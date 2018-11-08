library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_pkg.all;
use work.DisplayUnit_pkg.all;

entity mips_multi_cycle is
	port( CLOCK_50 : in	std_logic;
			SW			: in  std_logic_vector(7 downto 0);
			KEY		: in	std_logic_vector(3 downto 0);
			LEDR		: out	std_logic_vector(8 downto 0);
			LEDG		: out std_logic_vector(6 downto 0);
			HEX0		: out std_logic_vector(6 downto 0);
			HEX1		: out std_logic_vector(6 downto 0);
			HEX2		: out std_logic_vector(6 downto 0);
			HEX3		: out std_logic_vector(6 downto 0);
			HEX4		: out std_logic_vector(6 downto 0);
			HEX5		: out std_logic_vector(6 downto 0);
			HEX6		: out std_logic_vector(6 downto 0);
			HEX7		: out std_logic_vector(6 downto 0));
end mips_multi_cycle;

architecture Structural of mips_multi_cycle is 
	--clock
	signal s_clk : std_logic;
	-- Control Unit
	signal s_MemRead, s_MemWrite, s_ALUSelA, s_RegDst, s_RegWrite, s_MemToReg, s_IorD, s_IRWrite, s_PCWrite, s_PCWriteCond : std_logic;
	signal s_ALUSelB, s_ALUOp, s_PCSource : std_logic_vector(1 downto 0);
	
	-- PCUpdate
	signal s_pc	: std_logic_vector(31 downto 0);
	
	-- Memory
	signal s_ReadData : std_logic_vector(31 downto 0);
	
	--muxpc
	signal s_MUXPCout : std_logic_vector(5 downto 0);
	
	-- muxwreg
	signal s_MUXwregOut : std_logic_vector(4 downto 0);
	
	-- muxdreg
	signal s_MUXdregOut : std_logic_vector(31 downto 0);
	
	-- Instruction Register
	signal s_IRout		: std_logic_vector(31 downto 0);
	
	--Data Register
	signal s_DRout		: std_logic_vector(31 downto 0);
	
	-- Splitter
	signal s_opcode	: std_logic_vector(5  downto 0);
	signal s_rs			: std_logic_vector(4  downto 0);
	signal s_rt			: std_logic_vector(4  downto 0);
	signal s_rd			: std_logic_vector(4  downto 0);
	signal s_shamt		: std_logic_vector(4  downto 0);
	signal s_funct		: std_logic_vector(5  downto 0);
	signal s_imm		: std_logic_vector(15 downto 0);
	signal s_jAddr		: std_logic_vector(25 downto 0);
	
	-- RegFile
	signal s_readData1, s_readData2   : std_logic_vector(31 downto 0);
	
	-- ALU Mux
	signal s_ALUmuxA	: std_logic_vector(31 downto 0);
	signal s_ALUmuxB	: std_logic_vector(31 downto 0);
	
	-- ALU Registers
	signal s_ALUregA, s_ALUregB, s_ALUregOut		: std_logic_vector(31 downto 0);
	
	-- ALU Control Unit
	signal s_ALUcontrol 					 : std_logic_vector(2 downto 0);
	
	-- ALU
	signal s_ALUres  	  					 : std_logic_vector(31 downto 0);
	signal s_zero    						 : std_logic;
	
	-- sign extend
	signal s_seOut							 : std_logic_vector(31 downto 0);
	
	-- shifter
	signal s_shOut							 : std_logic_vector(31 downto 0);
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
				generic map(dataPathType => MULTI_CYCLE_DP,
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
								
	-- Control Unit 
	
ConUnit:	entity work.ControlUnit(Behavioral)
				port	 map(clk					=> s_clk,			
							  reset				=> not KEY(1),
		                 OpCode				=>	s_opcode, 
		                 PCWrite			=> s_PCWrite,
		                 IRWrite			=> s_IRWrite,
					        IorD				=> s_IorD,
					        PCSource			=> s_PCSource,
					        RegDest			=> s_RegDst,
					        PCWriteCond		=> s_PCWriteCond,
		                 MemRead			=> s_MemRead,
		                 MemWrite			=> s_MemWrite,
					        MemToReg			=> s_MemToReg,
					        ALUSelA			=> s_ALUSelA,
					        ALUSelB			=> s_ALUSelB,
		                 RegWrite			=> s_RegWrite,
		                 ALUop				=> s_ALUop);
			
			LEDG(0) <= s_PCWrite;
			LEDG(1) <= s_PCWriteCond;
			LEDG(2) <= s_IorD;
			LEDG(3) <= s_MemRead;
			LEDG(4) <= s_MemWrite;
			LEDG(5) <= s_IRWrite;
			LEDG(6) <= s_MemToReg;
			
			LEDR(1 downto 0) <= s_PCSource;
			LEDR(3 downto 2) <= s_ALUOp;
			LEDR(4) <= s_ALUSelA;
			LEDR(6 downto 5) <= s_ALUSelB;
			LEDR(7) <= s_RegWrite;
			LEDR(8) <= s_RegDst;
			
	
	-- PCUpdate

PCUp:		entity work.PCUpdate(Behavioral)
				port	map(clk				=> s_clk, 
							 reset			=> not KEY(1),
							 zero				=> s_zero,
							 PCSource		=> s_PCSource,
							 PCWrite			=> s_PCWrite,
							 PCWriteCond	=> s_PCWriteCond,
							 PC4				=> s_ALUres,
							 BTA				=> s_ALUregOut,
							 jAddr			=> s_jAddr,
							 pc				=> s_pc);
					  
	--MUXPC
muxpc:	entity work.MUX2N(Behavioral)
				generic map( N => 6 )
				
				port	  map(sel    => s_IorD,
								input0 => s_pc(7 downto 2),
								input1 => s_ALUregOut (7 downto 2),
								outx	 => s_MUXPCout);
					  
	-- Memory
mem:		entity work.RAM(Behavioral)
				port	map(clk				=> s_clk,		  
							 readEn			=> s_MemRead,	  
							 writeEn			=> s_MemWrite,	  
							 address			=> s_MUXPCout,	  
							 writeData		=> s_ALUregB,	 
						    readData		=> s_ReadData);

	-- Instruction Register 				  
ir:		entity work.Register32(Behavioral) 
				port	map(clk		 		=> s_clk,
							 writEn			=> s_IRWrite,
							 dataIn  		=> s_ReadData,
							 dataOut 		=> s_IRout);
					  
	-- Data Register
					  
dr:		entity work.Register32(Behavioral)
				port	map(clk				=> s_clk,
							 writEn			=> '1',
							 dataIn			=> s_ReadData,
							 dataOut			=> s_DRout);
					  
	-- Splitter 

spli:		entity work.InstrSplitter(Behavioral)
				port	map(instruction 	=>	s_IRout,
							 opcode			=>	s_opcode,
							 rs				=>	s_rs,
							 rt				=>	s_rt,
							 rd				=>	s_rd,
							 shamt			=>	s_shamt,
							 funct			=>	s_funct,
							 imm				=>	s_imm,
							 jAddr			=>	s_jAddr);
	-- RegFile
	
RegF:		entity work.RegFile(Structural)
				port map(clk				=> s_clk,	
						   writeEnable		=> s_RegWrite,	
							writeReg			=> s_MUXwregOut,
							writeData		=> s_MUXdregOut,
							readReg1			=> s_rs,
							readReg2			=> s_rt,
							readData1    	=> s_readData1,
							readData2		=> s_readData2);
							
	-- ALU Registers 

aluA:		entity work.Register32(Behavioral)
				port map(clk				=> s_clk,
							writEn			=> '1',
							dataIn			=> s_readData1,
							dataOut			=> s_ALUregA);
							
aluB:		entity work.Register32(Behavioral)
				port map(clk				=> s_clk,
							writEn			=> '1',
							dataIn			=> s_readData2,
							dataOut			=> s_ALUregB);

aluOut:	entity work.Register32(Behavioral)
				port map(clk				=> s_clk,
							writEn			=> '1',
							dataIn			=> s_ALUres,
							dataOut			=> s_ALUregOut);
							
	-- ALU Control

aluC:		entity work.ALUControlUnit(Behavioral)
				port map(ALUop		 		=> s_ALUop,
						   funct		 		=> s_funct,
		               ALUcontrol 		=> s_ALUcontrol);
							
	-- ALU

ALU:		entity work.ALU32(Behavioral)
				port map(a 					=> s_ALUmuxA,
							b 					=> s_ALUmuxB,
							op    			=> s_ALUcontrol,
							r  				=> s_ALUres,
							zero  			=> s_zero);
							
	-- WReg mux
	
muxwreg:	entity work.MUX2N(Behavioral)
				generic map( N => 5 )
				
				port	  map(sel    => s_RegDst,
								input0 => s_rt,
								input1 => s_rd,
								outx	 => s_MUXwregOut);
	-- WData mux
	
muxwdata:	entity work.MUX2N(Behavioral)
					generic map( N => 32 )
				
					port	  map(sel    => s_MemToReg,
									input0 => s_ALUregOut,
									input1 => s_DRout,
									outx	 => s_MUXdregOut);
									
	-- ALUmuxA
ALUxA:		entity work.MUX2N(Behavioral)
					generic map( N => 32 )
				
					port	  map(sel    => s_ALUSelA,
									input0 => s_pc,
									input1 => s_ALUregA,
									outx	 => s_ALUmuxA);
									
	-- ALUmuxB
ALUxB:		entity work.MUX4n(Behavioral)
					generic map( N => 32 )
				
					port	  map(sel    => s_ALUSelB,
									input0 => s_ALUregB,
									input1 => x"00000004",
									input2 => s_seOut,
									input3 => s_shOut,
									outx	 => s_ALUmuxB);
									
	-- sign extenders 
se1:			entity work.SignExtend(Behavioral) 
					port 	map( dataIn  => s_imm,
								  dataOut => s_seOut);
	-- shifter
	
sh:			entity work.LeftShifter(Behavioral)
					port  map(a 		=>	s_seOut,	
								 b 		=>	s_shOut);

end Structural;