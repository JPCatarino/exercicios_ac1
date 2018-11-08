library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity Register32	is
	port(clk		 : in  std_logic;
		  writEn	 : in  std_logic;
		  dataIn  : in  std_logic_vector(31 downto 0);
		  dataOut : out std_logic_vector(31 downto 0));
end Register32;
		  
architecture Behavioral of Register32 is
	
begin
	process(clk) 
	begin
		if(rising_edge(clk)) then
			if(writEn = '1') then
				dataOut <= dataIn;
			end if;
		end if;
	end process;
end Behavioral;
			
			