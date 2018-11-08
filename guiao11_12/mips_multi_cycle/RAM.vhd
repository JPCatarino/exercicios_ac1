library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;

library work;
use work.DisplayUnit_pkg.all;

entity RAM is
	generic( ADDR_BUS_SIZE : positive := 6;
				DATA_BUS_SIZE : positive := 32);
				
	port(clk					  : in  std_logic;
		  readEn				  : in  std_logic;
		  writeEn			  : in  std_logic;
		  address			  : in  std_logic_vector(ADDR_BUS_SIZE-1 downto 0);
		  writeData			  : in  std_logic_vector(DATA_BUS_SIZE-1 downto 0);
		  readData			  : out std_logic_vector(DATA_BUS_SIZE-1 downto 0));
end RAM;

architecture Behavioral of RAM is
	constant NUM_WORDS : positive := (2 ** ADDR_BUS_SIZE);
	subtype  TData is std_logic_vector(DATA_BUS_SIZE-1 downto 0);
	type TMemory is array(0 to NUM_WORDS - 1) of TData;
	signal s_memory : TMemory := ( X"20050000", -- main: addi $5,$0,0
											X"20040005", -- addi $4,$0,5
											X"20020001", -- do: addi $2,$0,1 
											X"20030000", -- addi $3,$0,0 
											X"0064082A", -- for: slt $1,$3,$4 
											X"1020000C", -- beq $1,$0,endfor 
											X"00633020", -- add $6,$3,$3
											X"00C63020", -- add $6,$6,$6 
											X"00C53020", -- add $6,$6,$5 
											X"8CC70080", -- lw $7,80($6) 
											X"8CC80084", -- lw $8,84($6) 
											X"0107082A", -- slt $1,$8,$7 
											X"10200003", -- beq $1,$0,endif 
											X"ACC70084", -- sw $7,84($6) 
											X"ACC80080", -- sw $8,80($6) 
											X"20020000", -- addi $2,$0,0 
											X"20630001", -- endif: addi $3,$3,1 
											X"08000004", -- j for 
											X"2084FFFF", -- endfor:addi $4,$4,-1 
											X"1040FFEE", -- beq $2,$0,do 
											X"00000000", -- nop
											X"1000FFFF", -- w1: beq $0,$0,w1
											X"00000000", -- nop
											X"00000000", -- ...
											X"00000000", 
											X"00000000", 
											X"00000000", 
											X"00000000", 
											X"00000000", 
											X"00000000", 
											X"00000000", 
											X"00000000", 
											X"00000014", -- .word 20
											X"00000011", -- .word 17
											X"FFFFFFFE", -- .word -2
											X"00000019", -- .word 25
											X"00000005", -- .word 5
											X"FFFFFFFF", -- .word -1
											others => X"00000000");
begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(writeEn = '1') then
				s_memory(to_integer(unsigned(address))) <= writeData;
			end if;
		end if;
	end process;
	
	readData <= s_memory(to_integer(unsigned(address))) when 
						readEn = '1' else (others => '-');
						
	DU_DMdata <= s_memory(to_integer(unsigned(DU_DMaddr)));
					
end Behavioral;