----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:36:34 08/03/2012 
-- Design Name: 
-- Module Name:    uart - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Test oscilliator, basic sawtooth, with 8 bit input for selecting a freq
-- 				and a 16 bit sample output
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
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;

entity test_osc is
	Port (
	clk 		: in std_logic;
	param_cmd : in std_logic_vector(7 downto 0);
	param_val : in std_logic_vector(15 downto 0);
	
	outen		: out std_logic;
	
	samp_clk	: in std_logic;
	dout		: out std_logic_vector(15 downto 0)
	
	);
		
end test_osc;

architecture RTL of test_osc is
	
	
	type fcwlut_type is array ( 0 to 127 ) of unsigned (15 downto 0);
	signal fcwlut : fcwlut_type;

	signal note_val	: std_logic_vector(6 downto 0);
	signal note_vel	: std_logic_vector(6 downto 0);
	signal fcw 			: unsigned (15 downto 0);
	
	signal phase		: unsigned (15 downto 0);
	
begin

	-- Generate the LUT for the Freqeuncy Control Word
	-- FCW (Delta F) = Fout*2^N / Fclock
	-- midi note number to frequency conversion:
	-- f=(2^((m−69)/12))*(440 Hz).
	-- So to get the increment value from the midi note
	-- FCW = 2^((m-69)/12) * 440 Hz * 2^N / Fclock
	-- Using N = 16 gives us a frequency step size of 0.7324 hz which is nice
	
	gen_fcwlut:
	for mf in 0 to 126 generate
		fcwlut(mf) <= to_unsigned((2**(abs((mf-69)/12)) * 440 * 65536 / (48000)), 16);
	end generate gen_fcwlut;

	-- Data readin
	process(clk)
	begin 
		if rising_edge(clk) then
			if param_cmd = "00000000" and param_val(6 downto 0) = note_val then
				-- note off	
				note_vel <= (others => '0');
				outen <= '0';
			elsif param_cmd = "00000001" and note_vel = "0000000" then
				-- we are not playing a note and we got a note on
				note_val <= param_val(6 downto 0);
				note_vel <= param_val(13 downto 7);
				
				-- get the FCW from the LUT
 				fcw <= fcwlut(to_integer(unsigned(param_val(6 downto 0))));
				
				outen <= '1';
				
			end if;
			
		
		end if;
	end process;		


	-- Numerically Controlled Oscillator
	process(samp_clk)
	begin
		if rising_edge(samp_clk) then 
			-- increment accumulator
			phase <= phase + fcw;
			-- Output sawtooth, this has bad rounding but i don't care rn
			dout <= std_logic_vector(phase);
		end if;
	end process;
end RTL;

