--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:34:16 08/05/2012
-- Design Name:   
-- Module Name:   /home/ksnieck/Projects/fpgasynth/nexys2/uart_tb.vhd
-- Project Name:  nexys2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart
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
use IEEE.NUMERIC_STD.all;

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY uart_tb IS
END uart_tb;
 
ARCHITECTURE behavior OF uart_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ce : IN  std_logic;
         accum_inc : IN  unsigned(15 downto 0);
         din : IN  std_logic_vector(7 downto 0);
         wr : IN  std_logic;
         ff : OUT  std_logic;
         dout : OUT  std_logic_vector(7 downto 0);
         rd : IN  std_logic;
         ef : OUT  std_logic;
         tx : OUT  std_logic;
         rx : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ce : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal wr : std_logic := '0';
   signal rd : std_logic := '0';
   signal rx : std_logic := '0';

 	--Outputs
   signal ff : std_logic;
   signal dout : std_logic_vector(7 downto 0);
   signal ef : std_logic;
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
	
	signal bit_send_pos : integer range 0 to 9 := 9;
	signal bit_send : std_logic_vector(9 downto 0) := "0101010101";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart PORT MAP (
          clk => clk,
          reset => reset,
          ce => ce,
          accum_inc	=> to_unsigned(2416, 16),
          din => din,
          wr => wr,
          ff => ff,
          dout => dout,
          rd => rd,
          ef => ef,
          tx => tx,
          rx => rx
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
		reset <= '1';
		wait for clk_period*2;
		reset <= '0';
		
		wait for clk_period*2;
		ce <= '1';
		wait for clk_period;
		
		while (bit_send_pos >= 0) loop
			bit_send_pos <= bit_send_pos - 1;
			rx <= bit_send(bit_send_pos);
			wait for 8.68us;
		end loop;
		bit_send_pos <= 9;
		
		
		wait for clk_period;
		
		din <= "00111100";
		wr <= '1';
		
		wait for clk_period;
		
		wr <= '0';
		
		wait for 100us;


      -- wait;
   end process;

END;
