library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MUX4n is
	generic(N : positive := 32);
	port(sel 	: in  std_logic_vector(1 downto 0);
		  input0 : in  std_logic_vector(N-1 downto 0);
		  input1 : in  std_logic_vector(N-1 downto 0);
		  input2	: in 	std_logic_vector(N-1 downto 0);
		  input3 : in 	std_logic_vector(N-1 downto 0);
		  outx   : out std_logic_vector(N-1 downto 0));
end MUX4n;

architecture Behavioral of MUX4n is
begin
	process(sel,input0,input1,input2,input3)
	begin
		case sel is
			when "00" => outx <= input0;
			when "01" => outx <= input1;
			when "10" => outx <= input2;
			when "11" => outx <= input3;
			when others => outx <= (others => '0');
		end case;
	end process;
end Behavioral;