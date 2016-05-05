----------------------------------------------------------------------------------
-- Company: 			Engs 31 16S
-- Engineer: 			E.W. Hansen
-- 
-- Create Date:    	17:56:35 07/25/2008 / revised 07/17/2015
-- Design Name: 	
-- Module Name:    	mux7seg - Behavioral 
-- Project Name: 		
-- Target Devices: 	Digilent Nexys 3 board
-- Tool versions: 	ISE 14.7
-- Description: 		Multiplexed seven-segment decoder for the display on the
--							Nexys 2 board
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 1.00 (07/17/2015) --- drop the clock divider, run on a 1000 Hz clock
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mux7seg is
    Port ( clk : in  STD_LOGIC;											-- runs on a slow (100 Hz or so) clock
           y0, y1, y2, y3 : in  STD_LOGIC_VECTOR (3 downto 0);	-- digits
           seg : out  STD_LOGIC_VECTOR(0 to 6);						-- segments (a...g)
           an : out  STD_LOGIC_VECTOR (3 downto 0) );				-- anodes
end mux7seg;

architecture Behavioral of mux7seg is
	signal adcount : unsigned(1 downto 0) := "00";		-- anode / mux selector count
	signal muxy : std_logic_vector(3 downto 0);			-- mux output
	signal segh : std_logic_vector(0 to 6);				-- segments (high true)
begin			

AnodeDriver:
process(clk, adcount)
begin	
	if rising_edge(clk) then
		adcount <= adcount + 1;
	end if;
	
	case adcount is
		when "00" => an <= "1110";
		when "01" => an <= "1101";
		when "10" => an <= "1011";
		when "11" => an <= "0111";
		when others => an <= "1111";
	end case;
end process AnodeDriver;
	
Multiplexer:
process(adcount, y0, y1, y2, y3)
begin
	case adcount is
		when "00" => muxy <= y0;
		when "01" => muxy <= y1;
		when "10" => muxy <= y2;
		when "11" => muxy <= y3;
		when others => muxy <= x"0";
	end case;
end process Multiplexer;

-- Seven segment decoder
with muxy select segh <=
	"1111110" when x"0",		-- active-high definitions
	"0110000" when x"1",
	"1101101" when x"2",
	"1111001" when x"3",
	"0110011" when x"4",
	"1011011" when x"5",
	"1011111" when x"6",
	"1110000" when x"7",
	"1111111" when x"8",
	"1111011" when x"9",
	"1110111" when x"a",	
	"0011111" when x"b",	
	"1001110" when x"c",	
	"0111101" when x"d",	
	"1001111" when x"e",	
	"1000111" when x"f",	
	"0000000" when others;	
seg <= not(segh);				-- Convert to active-low

end Behavioral;

