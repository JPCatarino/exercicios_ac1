library IEEE; 
library work;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use work.DisplayUnit_pkg.all;


entity instructionMemory is
	generic(ADDR_BUS_SIZE : positive := 6);
	port( address	: in  std_logic_vector(ADDR_BUS_SIZE-1 downto 0);
			readData : out std_logic_vector(31 downto 0));
end instructionMemory;

architecture Behavioral of instructionMemory is
	constant NUM_WORDS : positive := (2 ** ADDR_BUS_SIZE);
	subtype TData is std_logic_vector(31 downto 0);
	type TMemory is array(0 to NUM_WORDS - 1) of TData;
	constant s_memory : TMemory := (--X"2002001A", -- addi $2 ,$0,0x1A
											  --X"2003FFF9", -- addi $3 ,$0,-7
											  --X"00432020", -- add  $4 ,$2,$3
											  --X"00432822",	-- sub  $5 ,$2,$3
											  --X"00433024", -- and  $6 ,$2,$3
											  --X"00433825", -- or   $7 ,$2,$3
											  --X"00434027", -- nor  $8 ,$2,$3
											  --X"00434826", -- xor  $9 ,$2,$3
											  --X"0043502A", -- slt  $10,$2,$3
											  --X"28EBFFFE", -- slti $11,$7,-2
											  --X"292CFFE7", -- slti $12,$9,-25
											  --X"20030055",
											  --X"AC030000",
											  --X"8C040000",
											  X"20050000", -- addi $5 $0 0
											  X"20040005", -- addi $4 $0 5  
											  X"20020001", --[addi $2 $0 1  
                                   X"20030000", --[addi $3 $0 0 
                                   X"0064082a", --[for: slt $1 $3 $4  
                                   X"1020000c", --[beq $1 $0 endfor  
                                   X"00633020", --[add $6 $3 $3  
                                   X"00c63020", --[add $6 $6 $6  
                                   X"00c53020", --[add $6 $6 $5  
                                   X"8cc70000", --[lw $7 0($6)  
                                   X"8cc80004", --[lw $8 4($6)  
                                   X"0107082a", --[slt $1 $8 $7  
                                   X"10200003", --[beq $1 $0 endif 
                                   X"acc70004", --[sw $7 4($6)  
                                   X"acc80000", --[sw $8 0($6)  
                                   X"20020000", --[addi $2 $0 0 
                                   X"20630001", --[addi $3 $3 1 
                                   X"08000004", --[j for 
                                   X"2084ffff", --[endfor:addi $4 $4 -1  
                                   X"1040ffee", --[beq $2 $0 do  
                                   X"00000000", --[nop  
                                   X"1000ffff", --[w1: beq $0 $0 w1  
											  others => X"00000000");
begin
	readData  <= s_memory(to_integer(unsigned(address)));
	DU_IMdata <= s_memory(to_integer(unsigned(DU_IMaddr)));
end Behavioral;