--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:03:35 08/15/2012
-- Design Name:   
-- Module Name:   /home/ksnieck/Dropbox/Projects/fpgasynth/nexys2/top_level_test_osc_tb.vhd
-- Project Name:  nexys2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_level_test_osc
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
 
ENTITY top_level_test_osc_tb IS
END top_level_test_osc_tb;
 
ARCHITECTURE behavior OF top_level_test_osc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_level_test_osc
    PORT(
         sw : IN  std_logic_vector(7 downto 0);
         led : OUT  std_logic_vector(7 downto 0);
         btn : IN  std_logic_vector(3 downto 0);
         disp : OUT  std_logic_vector(12 downto 0);
         vga : OUT  std_logic_vector(10 downto 0);
         tx : OUT  std_logic;
         rx : IN  std_logic;
         clk : IN  std_logic;
         ja1 : OUT  std_logic;
         ja2 : OUT  std_logic;
         ja3 : OUT  std_logic;
         ja4 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal sw : std_logic_vector(7 downto 0) := (others => '0');
   signal btn : std_logic_vector(3 downto 0) := (others => '0');
   signal rx : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal led : std_logic_vector(7 downto 0);
   signal disp : std_logic_vector(12 downto 0);
   signal vga : std_logic_vector(10 downto 0);
   signal tx : std_logic;
   signal ja1 : std_logic;
   signal ja2 : std_logic;
   signal ja3 : std_logic;
   signal ja4 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_level_test_osc PORT MAP (
          sw => sw,
          led => led,
          btn => btn,
          disp => disp,
          vga => vga,
          tx => tx,
          rx => rx,
          clk => clk,
          ja1 => ja1,
          ja2 => ja2,
          ja3 => ja3,
          ja4 => ja4
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
		btn(0) <= '1';
      wait for clk_period*10;
		btn(0) <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
