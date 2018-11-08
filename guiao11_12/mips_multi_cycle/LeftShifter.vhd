library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity LeftShifter is 
	port(a : in  std_logic_vector(31 downto 0);
		  b : out std_logic_vector(31 downto 0));
end LeftShifter;

architecture Behavioral of LeftShifter is

	signal tbs    : unsigned(31 downto 0);
	signal shifted: unsigned(31 downto 0);
begin 
	tbs <= unsigned(a);
	
	shifted <= shift_left(unsigned(tbs),2);
	
	b <= std_logic_vector(shifted);
		
			
	
end Behavioral;
	