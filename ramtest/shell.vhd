----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:20:28 05/31/2016 
-- Design Name: 
-- Module Name:    shell - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity shell is
	Port (clk : in std_logic;
			segments : out std_logic_vector(0 to 6);
			anodes : out std_logic_vector(3 downto 0);
			
			MemOE : out std_logic;
			MemWR : out std_logic;
			RamADV : out std_logic;
			RamCS : out std_logic;
			RamCLK : out std_logic;
			RamCRE : out std_logic;
			RamLB : out std_logic;
			RamUB : out std_logic;

			
			MemAdr : out std_logic_vector(26 downto 1);
			MemDB : inout std_logic_vector(15 downto 0)
			
			
			
			);
			
end shell;

architecture Behavioral of shell is

component mux7seg is
    Port ( 	clk : in  STD_LOGIC;
           	y0, y1, y2, y3 : in  STD_LOGIC_VECTOR (3 downto 0);						
           	seg : out  STD_LOGIC_VECTOR (0 to 6);	
           	an : out  STD_LOGIC_VECTOR (3 downto 0) );			
end component;

constant CDV3: integer := 100E6/2000;
constant CLOCK_DIVIDER_VALUE: integer := CDV3;
signal clkdiv_tog: std_logic := '0';
signal clkdiv: integer := 0;
signal sclk : std_logic;


signal test_val : std_logic_vector(15 downto 0);
type state_type is (r, w);
signal state : state_type := w;
signal address : std_logic_vector(26 downto 1) := "00000000000000000000000000";
signal dat : std_logic_vector(15 downto 0) := "0000000000000000";



begin

Slow_clock: BUFG       
	port map (I => clkdiv_tog,
				 O => sclk );

Clock_divider: process(clk) begin
	if rising_edge(clk) then    
		if clkdiv = CLOCK_DIVIDER_VALUE-1 then    clkdiv_tog <= NOT(clkdiv_tog);
			clkdiv <= 0;
		else
			clkdiv <= clkdiv + 1;
		end if;
	end if;
end process Clock_divider;



display: mux7seg
    Port Map ( clk => sclk ,	-- runs off the 1000 Hz clock
           	y3 => test_val(15 downto 12), 		        -- most significant digit
           	y2 => test_val(11 downto 8),  	
           	y1 => test_val(7 downto 4), 		
           	y0 => test_val(3 downto 0),		-- least significant digit
          	seg => segments,
           	an => anodes );	

process(sclk)
begin
	if state = r then
		state <= w;
	elsif state = w then
		state <= r;
	else
		test_val <= x"DEAD";
	end if;
	test_val <= dat;
end process;


process(state, address)
begin
case state is
	when r =>
		RamCLK <= '0';
		RamADV <= '0';
		RamCS  <= '0';
		MemOE  <= '0';
		MemWR  <= '1';
		RamCRE <= '0';
		RamLB  <= '0';
		RamUB <= '0';
		dat <= MemDB;
		MemAdr <= address;
	when w =>	
		RamCLK <= '0';
		RamADV <= '0';
		RamCS  <= '0';
		MemOE  <= '0';
		MemWR  <= '0';
		RamCRE <= '0';
		RamLB  <= '0';
		RamUB  <= '0';	
		MemDB <= x"0101";
		MemAdr <= address;
	when others =>
		test_val <= x"DEAD";
end case;
end process;


end Behavioral;

