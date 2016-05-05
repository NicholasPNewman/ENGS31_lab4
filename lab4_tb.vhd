--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:24:07 05/02/2016
-- Design Name:   
-- Module Name:   C:/Users/Nick/Documents/ENGS31/Lab4/ENGS31_lab4/lab4_tb.vhd
-- Project Name:  ENGS31_lab4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Stopwatch
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY lab4_tb IS
END lab4_tb;
 
ARCHITECTURE behavior OF lab4_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Stopwatch
    PORT(
         mclk : IN  std_logic;
         button : IN  std_logic;
         segments : OUT  std_logic_vector(0 to 6);
         anodes : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal mclk : std_logic := '0';
   signal button : std_logic := '0';

 	--Outputs
   signal segments : std_logic_vector(0 to 6);
   signal anodes : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant mclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Stopwatch PORT MAP (
          mclk => mclk,
          button => button,
          segments => segments,
          anodes => anodes
        );

   -- Clock process definitions
   mclk_process :process
   begin
		mclk <= '0';
		wait for mclk_period/2;
		mclk <= '1';
		wait for mclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      -- button <= '1';
      wait for mclk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
