library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ALU32 is
	port(a, b  : in std_logic_vector(31 downto 0);
		  op    : in std_logic_vector(2 downto 0);
		  r  	  : out std_logic_vector(31 downto 0);
		  zero  : out std_logic);
end ALU32;

architecture Behavioral of ALU32 is
	signal s_a, s_b, s_r			: unsigned(31 downto 0);
	signal s_slt					: unsigned(31 downto 0);
	signal s_zero					: unsigned(0 downto 0);

begin
	s_a <= unsigned(a);
	s_b <= unsigned(b);
	process(op,s_a,s_b)
	begin
		zero <= '0';
		s_slt	<= (others => '0');
		if(op = "111")then
			if(signed(s_a) < signed(s_b)) then
				s_slt <= (0 => '1',others => '0');
			end if;
		elsif(op = "110") then
			if(s_a - s_b = 0) then
				zero <= '1';
			end if;
		end if;
	end process;
		
			
	
	with op select
		s_r <= s_a and s_b 	  when "000",
				 s_a or  s_b  	  when "001",
				 s_a  +  s_b 	  when "010",
				 s_a xor s_b     when "011",
				 s_a nor s_b	  when "100",
				 s_a  -  s_b     when "110",
				 s_slt		     when "111",
				 s_a	+  s_b	  when others;
	
	r <= std_logic_vector(s_r);


end Behavioral;
		  