----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kurt Snieckus
-- 
-- Create Date:    05:21:13 08/05/2012 
-- Design Name: 
-- Module Name:    midi_decoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--					Decodes midi data to control the synth
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity midi_decoder is
	Port ( din : in  STD_LOGIC_VECTOR (7 downto 0);
		wr : out  STD_LOGIC;
		nrdy : in  STD_LOGIC;
		clk : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		midi_chan : in std_logic_vector (3 downto 0);
		midiclk : out std_logic;

		param_cmd : out  STD_LOGIC_VECTOR (7 downto 0);
		param_val : out  STD_LOGIC_VECTOR (15 downto 0));
end midi_decoder;

architecture RTL of midi_decoder is
	-- Type definitions
	type recv_state_type is (idle, data, done);

	-- State type declarations
	signal recv_state : recv_state_type;

	-- Packet Decode Registers
	signal byte_cnt : integer range 0 to 65535; -- Counter to count the midi data bytes
	
	-- Temporary holders for output values while waiting for the entire message
	signal param_cmd_d :  STD_LOGIC_VECTOR (7 downto 0);
	signal param_val_d : STD_LOGIC_VECTOR (15 downto 0);

	signal wr_d : std_logic := '0';
	signal midiclk_d : std_logic := '0';

begin
	-- Because this process is run on every clock edge, and will always read out the next byte from the
	-- serial fifo, we try just leaving the wr flag high all the time
	wr_d <= '1';
	wr <= '1';

	midiclk <= midiclk_d;

	-- Midi byte collection process
	process(clk)
	begin
		if rising_edge(clk) then
			
			if (reset = '1') then -- If reset line is held, put into the idle state.
				recv_state <= idle;
			end if;
			
			case recv_state is
				when idle =>		-- Read incomming byte, and determine if it's a status byte
					-- First of all, everything can be reset 
					param_cmd <= (others => '1');		-- address is NOP when all high
					param_val <= (others => '0');
					
					-- Output signal prelatch hold things
					param_cmd_d <= (others => '1');		-- address is NOP when all high
					param_val_d <= (others => '0');

					midiclk_d <= '0';
			
					-- reset internal signals
					byte_cnt <= 0;
			
					-- If we have an incoming byte, check if it's a status byte and on our channel
					if (nrdy = '0') and (din(7) = '1') and (midi_chan = din(3 downto 0)) then 
						-- It is indeed a status byte and it's on our channel
						
						-- Set command storage buffer based on midi status message
						param_cmd_d <= (others => '0'); -- Set all zeros to start
						param_cmd_d(2 downto 0) <= din(6 downto 4); -- lowest three equal address

						-- Change the state to data because that's what comes after a status byte
						recv_state <= data;
						
						-- Set byte_cnt based on how many midi data bytes we should expect
						case din(6 downto 4) is -- figure out what to do with this
							when "000" => -- Note off
								byte_cnt <= 2; -- 2 Bytes for a note off
							when "001" => -- Note on
								byte_cnt <= 2; -- 2 bytes for a note on
							when "111" => -- Midi Time clock (output for testing and shits)
								if din(3 downto 0) = "1000" then
									midiclk_d <= not midiclk_d;
								end if;
							when others => -- Midi message we are not dealing with
								recv_state <= idle; -- Reset midi controller and wait for the next status byte
						end case;

					else
						recv_state <= idle; -- no status byte and we are not expecting data so continue idle
					end if;
					
				when data =>		-- use midi data messages as required by midi spec
					if (nrdy = '0') and (din(7) = '0') then  -- a data byte is less than 128
						case param_cmd_d is
							when "00000000"|"00000001" => -- Note off or on
								if byte_cnt = 2 then -- first byte is note number
									param_val_d(6 downto 0) <= din(6 downto 0);
									byte_cnt <= 1;
								elsif byte_cnt = 1 then -- second byte is velocity
									param_val_d(13 downto 7) <= din(6 downto 0);
									byte_cnt <= 0;
									recv_state <= done; -- Last byte, latch data and look for next status byte
								end if;
							when others => -- catch things that we havn't written yet
								recv_state <= idle; -- and then don't do something stupid
						end case;
					end if;
				when done =>		-- Last midi data message recieved, latch data onto param bus
					-- Latch _d's to outputs so that the connected devices respond to midi message
					param_cmd <= param_cmd_d;
					param_val <= param_val_d;
					recv_state <= idle; -- Go to idle on next clock

			end case;
		end if;
	end process;
end RTL;

