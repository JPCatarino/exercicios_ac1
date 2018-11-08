library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux2N is
	generic(N : positive := 32);
	port(sel 	: in  std_logic;
		  input0 : in  std_logic_vector(N-1 downto 0);
		  input1 : in  std_logic_vector(N-1 downto 0);
		  outx   : out std_logic_vector(N-1 downto 0));
end Mux2N;

architecture Behavioral of Mux2N is
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
		  