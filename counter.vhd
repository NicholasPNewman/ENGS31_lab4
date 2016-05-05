----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:58:33 05/01/2016 
-- Design Name: 
-- Module Name:    counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned valuea
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
	port ( clk, EN_IN, reset : in std_logic;
		   EN_OUT            : out std_logic;
		   Q                 : out std_logic_vector(3 downto 0)
	);
end counter;

architecture Behavioral of counter is
signal reg_val: unsigned(3 downto 0) := "0000";

begin

process(clk)
begin
	if rising_edge(clk) then
		
		if reset = '1'then
			reg_val <= "0000";
		else
			if EN_IN = '0' then
				reg_val <= reg_val;
			elsif EN_IN = '1' then
				reg_val <= reg_val + 1;
			end if;
		end if;
		
		if reg_val = "1001" then
			EN_OUT <= '1';
			reg_val <= "0000";
		else
			EN_OUT <= '0';
		end if;
	
		Q <= std_logic_vector(reg_val);
	
	end if;
end process;

end Behavioral;