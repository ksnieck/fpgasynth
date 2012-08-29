--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:18:41 08/15/2012
-- Design Name:   
-- Module Name:   /home/ksnieck/Dropbox/Projects/fpgasynth/nexys2/i2s_cntrl_tb.vhd
-- Project Name:  nexys2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: I2S_cntrl
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
 
ENTITY i2s_cntrl_tb IS
END i2s_cntrl_tb;
 
ARCHITECTURE behavior OF i2s_cntrl_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT I2S_cntrl
    PORT(
         ldin : IN  std_logic_vector(15 downto 0);
         rdin : IN  std_logic_vector(15 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic;
         sdout : OUT  std_logic;
         sclk : OUT  std_logic;
         lrck : OUT  std_logic;
         mclk : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ldin : std_logic_vector(15 downto 0) := "1010101010101010";
   signal rdin : std_logic_vector(15 downto 0) := "0101010101010101";
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal sdout : std_logic;
   signal sclk : std_logic;
   signal lrck : std_logic;
   signal mclk : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: I2S_cntrl PORT MAP (
          ldin => ldin,
          rdin => rdin,
          clk => clk,
          reset => reset,
          sdout => sdout,
          sclk => sclk,
          lrck => lrck,
          mclk => mclk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		reset <= '1';
      wait for clk_period*10;
      reset <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
