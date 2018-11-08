library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux2_1 is
	port(sel 	: in std_logic;
		  input0 : in std_logic;
		  input1 : in std_logic;
		  outx   : out std_logic);
end Mux2_1;

architecture Behavioral of Mux2_1 is
begin
	process(sel,input0,input1)
begin
	if(sel = '0') then
		outx <= input0;
	else
		outx <= input1;
end if;
end process;
end Behavioral;		
		  