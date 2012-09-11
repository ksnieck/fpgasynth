----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:41:04 08/03/2012 
-- Design Name: 
-- Module Name:    top_level - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port (
		sw : in  STD_LOGIC_VECTOR (7 downto 0);
		led : out  STD_LOGIC_VECTOR (7 downto 0);
		btn : in  STD_LOGIC_VECTOR (3 downto 0);
		disp : out  STD_LOGIC_VECTOR (12 downto 0);
		vga : out  STD_LOGIC_VECTOR (10 downto 0);
		tx : out  STD_LOGIC;
		rx : in  STD_LOGIC;
		clk : in STD_LOGIC;
		
		dac_sdout : out STD_LOGIC;
		dac_sclk : out std_logic;
		dac_lrck : out std_logic;
		dac_mclk : out std_logic;
		
		midi_rx : in std_logic;
		midi_thru : out std_logic
	);
end top_level;

architecture RTL of top_level is

	signal reset	: std_logic;

	-- UART signals
	signal uart_din	: std_logic_vector(7 downto 0);
	signal uart_wr	: std_logic;
	signal uart_ff	: std_logic;
	signal uart_dout : std_logic_vector(7 downto 0);
	signal uart_rd	: std_logic;
	signal uart_ef	: std_logic;
	signal uart_reset : std_logic;
	
	-- Sample clock;
	signal samp_clk : std_logic;
	
	-- Param bus
	signal param_cmd : std_logic_vector(7 downto 0);
	signal param_val : std_logic_vector(15 downto 0);
	
	-- Samples
	signal samp_data	: std_logic_vector(15 downto 0);

	signal midiclk	: std_logic;
	
begin

	reset <= btn(0);
	
	midi_thru <= midi_rx;
	
	
	led(0) <= not midi_rx;
	led(1) <= midiclk;
	
	led(2) <= uart_ef;
	
	led(7 downto 4) <= (others => '0');
	
	-- Core instatiations
uart1 : entity work.uart
	generic map (
		tx_fifo_depth => 32,
		rx_fifo_depth => 32
	)
	port map (
		clk			=> clk,
		reset 		=> reset,	-- Reset is connected to BTN0
		ce				=> '1',
		accum_inc	=> to_unsigned(655, 16), -- Baudrate: 31.25k (MIDI) (see uart.vhd)
		din			=> uart_din,
		wr				=> uart_wr,
		ff				=> uart_ff,
		dout			=> uart_dout,
		rd				=> uart_rd,
		ef				=> uart_ef,
		tx				=> tx,
		rx				=> midi_rx
	);
	
midi_decoder1 : entity work.midi_decoder
	port map (
		din 			=> uart_dout,
		wr 			=> uart_rd,
		nrdy 			=> uart_ef,
		clk 			=> clk,
		reset 		=> reset,
		midi_chan 	=> "0000",
		midiclk		=> midiclk,
		param_cmd 	=> param_cmd,
		param_val 	=> param_val
	);
	
test_osc1 : entity work.test_osc
	port map (
		clk			=> clk,
		param_cmd	=> param_cmd,
		param_val	=> param_val,
		samp_clk		=> samp_clk,
		dout 			=> samp_data,
		outen			=> led(3)
	);
	
i2s_cntrl1 : entity work.I2S_cntrl
	port map (
		ldin => samp_data,
		rdin => samp_data,
		clk => clk,
		reset	=> reset,
		sdout => dac_sdout,
		sclk => dac_sclk,
		lrck => samp_clk,
		mclk => dac_mclk
	);
			
	dac_lrck <= samp_clk;
	
end RTL;

