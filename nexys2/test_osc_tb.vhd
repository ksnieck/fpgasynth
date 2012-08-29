--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:10:58 08/15/2012
-- Design Name:   
-- Module Name:   /home/ksnieck/Dropbox/Projects/fpgasynth/nexys2/test_osc_tb.vhd
-- Project Name:  nexys2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_osc
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
USE ieee.numeric_std.ALL;
 
ENTITY test_osc_tb IS
END test_osc_tb;
 
ARCHITECTURE behavior OF test_osc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT test_osc
    PORT(
         samp_clk : IN  std_logic;
         freq : IN  std_logic_vector(7 downto 0);
         dout : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal samp_clk : std_logic := '0';
   signal freq : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal dout : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant samp_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: test_osc PORT MAP (
          samp_clk => samp_clk,
          freq => freq,
          dout => dout
        );

   -- Clock process definitions
   samp_clk_process :process
   begin
		samp_clk <= '0';
		wait for samp_clk_period/2;
		samp_clk <= '1';
		wait for samp_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for samp_clk_period*10;
      
      freq <= "11111111";
      

      -- insert stimulus here 

      wait;
   end process;

END;
