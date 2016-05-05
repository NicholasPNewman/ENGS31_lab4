----------------------------------------------------------------------------------
-- Company: 			Engs 31 16S
-- Engineer: 			Nick Newman
-- 
-- Create Date:    	 
-- Design Name: 		
-- Module Name:    		lab4_shell 
-- Project Name: 		Lab4
-- Target Devices: 		Digilent NEXYS3 (Spartan 6)
-- Tool versions: 		ISE Design Suite 14.7
-- Description: 		Stopwatch lab
--				
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
-- Boilerplate: don't change this
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;			-- needed for arithmetic

library UNISIM;						-- needed for the BUFG component
use UNISIM.Vcomponents.ALL;

entity Stopwatch is
port (mclk		: in std_logic;	-- FPGA board master clock
	-- control inputs
		button 	: in std_logic;
	--	
	-- multiplexed seven segment display
      segments	: out std_logic_vector(0 to 6);
      anodes 	: out std_logic_vector(3 downto 0) );
end Stopwatch;

architecture Behavioral of Stopwatch is

-- COMPONENT DECLARATIONS
-- Multiplexed seven segment display
component mux7seg is
    Port ( 	clk : in  STD_LOGIC;
           	y0, y1, y2, y3 : in  STD_LOGIC_VECTOR (3 downto 0);						
           	seg : out  STD_LOGIC_VECTOR (0 to 6);	
           	an : out  STD_LOGIC_VECTOR (3 downto 0) );			
end component;

-- Debouncer
component debouncer is
    Port ( clk 	: in  STD_LOGIC;
           switch 	: in  STD_LOGIC;		-- switch input
           dbswitch : out STD_LOGIC );		-- debounced output
end component;

-- Your component declarations go here
COMPONENT counter
	PORT(
		clk : IN std_logic;
		en_in : IN std_logic;
		reset : IN std_logic;          
		Q : OUT std_logic_vector(3 downto 0);
		en_out : OUT std_logic );
END COMPONENT;

component monopulser
	port(
		clk : in std_logic;
		pulse : in std_logic;
		enable : out std_logic;
		clear : out std_logic
		);
end component;
-------------------------------------------------
-- SIGNAL DECLARATIONS 
-- Signals for the clock divider, which divides the master clock down to 1000 Hz
-- Master clock frequency / CLOCK_DIVIDER_VALUE = 2000 Hz
constant CDV3: integer := 100E6/2000;      		-- Nexys3 board has 100 MHz clock
constant CLOCK_DIVIDER_VALUE: integer := 10;  -- use CDV3; use 10 for simulation
signal clkdiv: integer := 0;					-- the clock divider counter
signal clkdiv_tog: std_logic := '0';				-- terminal count
signal clk: std_logic;			    					-- the slow clock
signal button_db : std_logic := '0';				-- debounced button

-- Signal declarations for your code go here
signal PULSE_DIVIDER_VALUE: integer := 10;
signal pulsediv: integer := 0;
signal pulsediv_tog: std_logic := '0';
signal pulse_t: std_logic;

signal tenths_place, hundredths_place : std_logic_vector(3 downto 0);
signal tenths_en : std_logic;

begin

-- pulse buffer for 100ns pulses with a period of 1us
Pulse_buffer: BUFG
      port map (I => pulsediv_tog,
                O => pulse_t );

-- Clock buffer for 100 Hz clock
-- The BUFG component puts the slow clock onto the FPGA clocking network
Slow_clock_buffer: BUFG
      port map (I => clkdiv_tog,
                O => clk );


-- Divide the master clock down to 2000 Hz, then toggling the
-- clkdiv_tog signal at 2000 Hz gives a 1000 Hz clock with 50% duty cycle.
Clock_divider: process(mclk)
begin
	if rising_edge(mclk) then
	   	if clkdiv = CLOCK_DIVIDER_VALUE-1 then 
	   		clkdiv_tog <= NOT(clkdiv_tog);		
			clkdiv <= 0;
		else
			clkdiv <= clkdiv + 1;
		end if;
	end if;
end process Clock_divider;



-- Divide the master clock down to 2000 Hz, then toggling the
-- clkdiv_tog signal at 2000 Hz gives a 1000 Hz clock with 50% duty cycle.
Pulse_divider: process(clk)
begin
		if (pulsediv_tog = '1') AND (pulsediv = 0) then
			pulsediv_tog <= NOT(pulsediv_tog);
			pulsediv <= pulsediv + 1;
		elsif (pulsediv = PULSE_DIVIDER_VALUE - 1) then 
			pulsediv_tog <= NOT(pulsediv_tog);
			pulsediv <= 0;
		else 
			pulsediv <= pulsediv + 1;
		end if;
end process Pulse_divider;



-- Instantiate the debouncer
debounce: debouncer
    Port map ( clk => clk,		-- runs off the 1000 Hz clock
           switch => button,
           dbswitch => button_db );	

-- Instantiate the multiplexed seven segment display
display: mux7seg
    Port Map ( clk => clk ,	-- runs off the 1000 Hz clock
           	y3 => "1000", 		        -- most significant digit
           	y2 => "0100",  	
           	y1 => tenths_place, 		
           	y0 => hundredths_place,		-- least significant digit
          	seg => segments,
           	an => anodes );	

--------------------------------------------
-- Your logic goes here
-- Clock your system with the 1000 Hz (clk) signal

pulser: monopulser port map(
		clk => clk,
		pulse => button,
		enable => open, -- will eventually go to en_in
		clear => open  -- will eventually go to reset
	);

ones_digit: counter port map(
		clk => clk,
		en_in => '1',
		reset => '0',          
		Q => hundredths_place,
		en_out => tenths_en );
		
tens_digit: counter port map(
		clk => clk,
		en_in => tenths_en,
		reset => '0',          
		Q => tenths_place,
		en_out => open );
		

		
end Behavioral; 