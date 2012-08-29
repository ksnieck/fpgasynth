--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:31:59 08/04/2012
-- Design Name:   
-- Module Name:   /home/ksnieck/Projects/fpgasynth/nexys2/sync_fifo_sim.vhd
-- Project Name:  nexys2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sync_fifo
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
 
ENTITY sync_fifo_sim IS
END sync_fifo_sim;
 
ARCHITECTURE behavior OF sync_fifo_sim IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sync_fifo
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ce : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         wr : IN  std_logic;
         ff : OUT  std_logic;
         dout : OUT  std_logic_vector(7 downto 0);
         rd : IN  std_logic;
         ef : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ce : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal wr : std_logic := '0';
   signal rd : std_logic := '0';

 	--Outputs
   signal ff : std_logic;
   signal dout : std_logic_vector(7 downto 0);
   signal ef : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sync_fifo PORT MAP (
          clk => clk,
          reset => reset,
          ce => ce,
          din => din,
          wr => wr,
          ff => ff,
          dout => dout,
          rd => rd,
          ef => ef
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

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
