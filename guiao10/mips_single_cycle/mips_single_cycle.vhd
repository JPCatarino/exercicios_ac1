library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_pkg.all;
use work.DisplayUnit_pkg.all;

entity mips_single_cycle is
	port( CLOCK_50 : in	std_logic;
			SW			: in  std_logic_vector(7 downto 0);
			KEY		: in	std_logic_vector(3 downto 0);
			LEDR		: out	std_logic_vector(9 downto 0);
			HEX0		: out std_logic_vector(6 downto 0);
			HEX1		: out std_logic_vector(6 downto 0);
			HEX2		: out std_logic_vector(6 downto 0);
			HEX3		: out std_logic_vector(6 downto 0);
			HEX4		: out std_logic_vector(6 downto 0);
			HEX5		: out std_logic_vector(6 downto 0);
			HEX6		: out std_logic_vector(6 downto 0);
			HEX7		: out std_logic_vector(6 downto 0));
end mips_single_cycle;

architecture Structural of mips_single_cycle is
	signal	s_clk 				  : std_logic;
	signal	s_Jump				  : std_logic;  -- Control Unit
	signal	s_Branch				  : std_logic;  -- ""
	signal	s_MemToReg			  : std_logic;  -- ""
	signal	s_MemWrite			  : std_logic;  -- ""
	signal	s_MemRead			  : std_logic;  -- ""
	signal	s_ALUsrc				  : std_logic;  -- ""
	signal	s_RegWrite			  : std_logic;  -- ""
	signal	s_RegDst				  : std_logic;  -- ""
	signal	s_ALUop				  : std_logic_vector(1  downto 0);
	signal	s_ext, s_pc, s_data : std_logic_vector(31 downto 0);
	signal	s_jAddr 				  : std_logic_vector(25 downto 0);
	signal	s_imm					  : std_logic_vector(15 downto 0);
	signal   s_opcode				  : std_logic_vector(5  downto 0);
	signal   s_rs				     : std_logic_vector(4  downto 0);
	signal	s_rt				     : std_logic_vector(4  downto 0);
	signal	s_rd				     : std_logic_vector(4  downto 0);
	signal   s_shamt			     : std_logic_vector(4  downto 0);
	signal	s_funct			     : std_logic_vector(5  downto 0);
	signal	s_mux5_out			  : std_logic_vector(4  downto 0);
	signal	s_readData1			  : std_logic_vector(31 downto 0);
	signal	s_readData2			  : std_logic_vector(31 downto 0);
	signal	s_mux32_1_out		  : std_logic_vector(31 downto 0);
	signal	s_mux32_2_out		  : std_logic_vector(31 downto 0);
	signal	s_aluRes				  : std_logic_vector(31 downto 0);
	signal	s_ALUcontrol		  : std_logic_vector(2  downto 0);
	signal	s_DMReadData		  : std_logic_vector(31 downto 0);
	signal	s_zero				  : std_logic;
			
	

begin
	--debouncer
debnc:	entity work.DebounceUnit(Behavioral)
				generic map(mSecMinInWidth	=> 200,
								inPolarity		=> '0',
								outPolarity		=> '1')
				
				port	  map(refClk			=> CLOCK_50,
								dirtyIn			=> KEY(0),
								pulsedOut		=> open);
								
-- Freq Divider
freqDiv: entity work.divFreq(Behavioral)
				generic map(KDIV => 6250000)
				port map(clkIn => CLOCK_50,
							clkOut => s_clk);
	--Display module
displ:	entity work.DisplayUnit(Behavioral)
				generic map(dataPathType => SINGLE_CYCLE_DP,
								IM_ADDR_SIZE => ROM_ADDR_SIZE,
								DM_ADDR_SIZE => RAM_ADDR_SIZE)
				
				port	  map(RefClk		 => CLOCK_50,
								InputSel		 => SW(1 downto 0),
								DispMode		 => SW(2),
								NextAddr	    => KEY(3),
								Dir			 => KEY(2),
								disp0			 => HEX0,
								disp1			 => HEX1,
								disp2        => HEX2,
								disp3			 => HEX3,
								disp4			 => HEX4,
								disp5			 => HEX5,
								disp6			 => HEX6,
								disp7			 => HEX7);
								
    -- PCUpdate

pcUp:		entity work.PCUpdate(Behavioral)
				port	map(clk		 => s_clk,
							 reset	 => not KEY(1),
							 zero		 => s_zero,
							 branch   => s_Branch,
							 jump	    => s_Jump,
							 offset32 => s_ext(31 downto 0),
							 jAddr26  => s_jAddr(25 downto 0),
							 pc		 => s_pc(31  downto 0));
							 
	 -- Instruction Memory
	 
InsMem:	entity work.InstructionMemory(Behavioral)
				port	map( address  => s_pc(7 downto 2),
							  readData => s_data);
							  
						  
							  
	-- Splitter
	
Spli:	   entity work.InstrSplitter(Behavioral)
				port 	map( instruction	=> s_data(31 downto 0),
							  opcode			=>	s_opcode,
							  rs				=>	s_rs,			
							  rt				=> s_rt,
			              rd				=> s_rd,
			              shamt			=> s_shamt,
			              funct			=> s_funct,
			              imm				=>	s_imm(15 downto 0),
			              jAddr			=> s_jAddr(25 downto 0));
							  
	-- sign extend
	
SE:		entity work.SignExtend(Behavioral)
				port	map( dataIn		=> s_imm,
							  dataOut	=> s_ext);
							  
	-- MUX5

MUX5:		entity work.Mux2N(Behavioral)
				generic map( N			=> 5)
				
				port	  map( sel		=>	s_RegDst,
								 input0	=> s_rt,
								 input1	=> s_rd,
								 outx		=> s_mux5_out);
	
	-- Banco de Registos

BdR:		entity work.RegFile(Structural)
				port  map( clk				=>	s_clk,
							  writeEnable	=> s_RegWrite,
							  writeReg		=> s_mux5_out,
		                 writeData		=> s_mux32_2_out,				
		                 readReg1		=> s_rs,
		                 readReg2		=> s_rt,
		                 readData1    => s_readData1,
		                 readData2		=> s_readData2);
							  
	-- MUX32 - 1		  
							  
MUX32_1:	entity work.Mux2N(Behavioral)
				generic map(N		=> 32)
				
				port	  map( sel 		=> s_ALUsrc,
								 input0	=> s_readData2,
								 input1	=> s_ext,
								 outx		=> s_mux32_1_out);
								 
	--Mux32 -2 
	
MUX32_2:	entity work.Mux2N(Behavioral)
				generic map(N		=> 32)
				
				port	  map( sel 		=> s_MemToReg,
								 input0	=> s_aluRes,
								 input1	=> s_DMReadData,
								 outx		=> s_mux32_2_out);							 
	-- ALU Control
	
ALUC:		entity work.ALUControlUnit(Behavioral)
				port	  map( ALUop		=> s_ALUop,	
								 funct		=> s_funct,	 
		                   ALUcontrol => s_ALUcontrol);
				
								
							
	-- ALU

ALU:		entity work.ALU32(Behavioral)
				port	 map( a			=> s_readData1, 
							   b  		=> s_mux32_1_out,
							   op    	=> s_ALUcontrol,
		                  r  	 	=> s_aluRes,
		                  zero  	=> s_zero);
								
	-- Control Unit
CU:		entity work.ControlUnit(Behavioral)
				port	 map( OpCode	=> s_opcode,		
								RegDst	=>	s_RegDst,	
								Branch	=>	s_Branch,	
								MemRead	=> s_MemRead,
								MemWrite	=> s_MemWrite,
								MemToReg	=> s_MemToReg,
								ALUsrc	=> s_ALUsrc,	
								RegWrite	=> s_RegWrite,
								Jump		=> s_Jump,
								ALUop		=> s_ALUop);
			
			LEDR(0) <= s_Jump;
			LEDR(1) <= s_Branch;
			LEDR(2) <= s_MemToReg;
			LEDR(3) <= s_MemWrite;
			LEDR(4) <= s_MemRead;
			LEDR(5) <= s_ALUsrc;
			LEDR(7 downto 6) <= s_ALUop;
			LEDR(8) <= s_RegWrite;
			LEDR(9) <= s_RegDst;
			
								
	-- Data memory
DM:		entity work.RAM(Behavioral)
				generic map( ADDR_BUS_SIZE => RAM_ADDR_SIZE,
								 DATA_BUS_SIZE => 32)
				port	  map( clk		   =>	s_clk,		  
							    readEn		=> s_MemRead,		 
		                   writeEn		=> s_MemWrite,		  
		                   address		=> s_aluRes(7 downto 2),		  
		                   writeData 	=> s_readData2,			  
		                   readData	=>	s_DMReadData);
				
end Structural;

							 
								
								
								
								
								
								