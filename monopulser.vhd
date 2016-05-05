----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:15:22 05/02/2016 
-- Design Name: 
-- Module Name:    monopulser - Behavioral 
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
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity monopulser is
    Port ( clk : in  STD_LOGIC;
           pulse : in  STD_LOGIC;
           enable : out  STD_LOGIC;
           clear : out  STD_LOGIC);
end monopulser;

architecture Behavioral of monopulser is

type state_type is (hold, count, disp, clr);
signal current_on, next_on: state_type := hold;
signal i_out: std_logic_vector(1 downto 0) := "00";

begin
process(PULSE)
begin
	if PULSE = '1' then
		case current_on is
			when hold =>
				next_on <= count;
			when count =>
				next_on <= disp;
			when disp =>
				next_on <= clr;
			when clr =>
				next_on <= hold;
		end case;
	end if;
	
	current_on <= next_on;
	case current_on is
		when hold =>
			i_out <= "00";
		when count =>
			i_out <= "01";
		when clr =>
			i_out <= "10";
		when disp =>
			i_out <= "00";
	end case;

end process;

end Behavioral;

