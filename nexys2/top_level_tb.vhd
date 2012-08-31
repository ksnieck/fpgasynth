--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:46:38 08/30/2012
-- Design Name:   
-- Module Name:   /home/ksnieck/Projects/fpgasynth/nexys2/top_level_tb.vhd
-- Project Name:  nexys2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_level
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
 
ENTITY top_level_tb IS
END top_level_tb;
 
ARCHITECTURE behavior OF top_level_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_level
    PORT(
         sw : IN  std_logic_vector(7 downto 0);
         led : OUT  std_logic_vector(7 downto 0);
         btn : IN  std_logic_vector(3 downto 0);
         disp : OUT  std_logic_vector(12 downto 0);
         vga : OUT  std_logic_vector(10 downto 0);
         tx : OUT  std_logic;
         rx : IN  std_logic;
         clk : IN  std_logic;
         dac_sdout : OUT  std_logic;
         dac_sclk : OUT  std_logic;
         dac_lrck : OUT  std_logic;
         dac_mclk : OUT  std_logic;
         midi_rx : IN  std_logic;
         midi_thru : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal sw : std_logic_vector(7 downto 0) := (others => '0');
   signal btn : std_logic_vector(3 downto 0) := (others => '0');
   signal rx : std_logic := '0';
   signal clk : std_logic := '0';
   signal midi_rx : std_logic := '0';

 	--Outputs
   signal led : std_logic_vector(7 downto 0);
   signal disp : std_logic_vector(12 downto 0);
   signal vga : std_logic_vector(10 downto 0);
   signal tx : std_logic;
   signal dac_sdout : std_logic;
   signal dac_sclk : std_logic;
   signal dac_lrck : std_logic;
   signal dac_mclk : std_logic;
   signal midi_thru : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_level PORT MAP (
          sw => sw,
          led => led,
          btn => btn,
          disp => disp,
          vga => vga,
          tx => tx,
          rx => rx,
          clk => clk,
          dac_sdout => dac_sdout,
          dac_sclk => dac_sclk,
          dac_lrck => dac_lrck,
          dac_mclk => dac_mclk,
          midi_rx => midi_rx,
          midi_thru => midi_thru
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

		btn(0) <= '1'; -- reset
      wait for clk_period*10;
      
      -- stop reset state
      btn(0) <= '0';
      
      
      
		-- Send a midi packet
		
		

      -- insert stimulus here 

      wait;
   end process;

END;
