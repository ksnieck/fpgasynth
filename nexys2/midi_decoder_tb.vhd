--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:08:59 09/06/2012
-- Design Name:   
-- Module Name:   /home/ksnieck/Projects/fpgasynth/nexys2/midi_decoder_tb.vhd
-- Project Name:  nexys2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: midi_decoder
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
 
ENTITY midi_decoder_tb IS
END midi_decoder_tb;
 
ARCHITECTURE behavior OF midi_decoder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT midi_decoder
    PORT(
         din : IN  std_logic_vector(7 downto 0);
         wr : OUT  std_logic;
         nrdy : IN  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic;
         midi_chan : IN  std_logic_vector(3 downto 0);
         param_cmd : OUT  std_logic_vector(7 downto 0);
         param_val : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal nrdy : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal midi_chan : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal wr : std_logic;
   signal param_cmd : std_logic_vector(7 downto 0);
   signal param_val : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: midi_decoder PORT MAP (
          din => din,
          wr => wr,
          nrdy => nrdy,
          clk => clk,
          reset => reset,
          midi_chan => midi_chan,
          param_cmd => param_cmd,
          param_val => param_val
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

		nrdy <= '1';
		din <= (others => '0');
		midi_chan <= (others => '0');
		reset <= '1';

		wait for clk_period*10;
		reset <= '0';

		-- insert stimulus here 
		din <= "10010000";
		nrdy <= '0'; 
		
		wait for clk_period;

		din <= "00000000";
		nrdy <= '1';


		
		



      wait;
   end process;

END;
