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

entity uart is
	generic (
		tx_fifo_depth	: integer := 1024;
		rx_fifo_depth	: integer := 1024
	);
	Port ( clk 			: in  STD_LOGIC;
			reset			: in  STD_LOGIC;
			ce 			: in  STD_LOGIC;		-- clock enable
			accum_inc	: in unsigned(15 downto 0);
			din			: in std_logic_vector(7 downto 0);
			wr				: in std_logic;
			ff				: out std_logic;		-- fifo full
			dout			: out std_logic_vector(7 downto 0);
			rd				: in std_logic;		-- read
			ef				: out std_logic;		-- fifo empty
			tx 			: out  STD_LOGIC;
			rx 			: in  STD_LOGIC);
end uart;

architecture RTL of uart is
	
	-- Type definitions
	type tx_state_type is (tx_idle, tx_start, tx_send, tx_end);
	type rx_state_type is (rx_idle, rx_recv, rx_end);
	
	-- State type declarations
	signal tx_state : tx_state_type;
	signal rx_state : rx_state_type;
	
	-- Baudrate generation process register
	-- rx_sampling_rate = 16
	-- accum_inc = (baudrate * 2^rx_accum_width * rx_sampling_rate) / clock_frequency
	-- Ex: (115200 * 2^16 * 16) / 50e6 = 2416
	-- Set teh accum_inc value to 1208 to get 115200 baud
	
	signal rx_accum 	: unsigned (15 downto 0); -- recieve accumulator
	signal rx_accum_d : unsigned (15 downto 0); -- recieve accumulator wrap
	signal tx_accum	: integer range 0 to 15;	-- transmit accumulator (1/16 slower than rx)
	signal tx_ce		: std_logic;	-- clock enable for tx process (when tx accum wraps)
	signal rx_ce		: std_logic;	-- clocke enable for rx		(when rx accum wraps)
	
	-- Tx process registers
	signal tx_data		: std_logic_vector (7 downto 0);
	signal tx_bit		: integer range 0 to 7;	-- bit counter
	
	-- Tx process signals
	signal tx_dout		: std_logic_vector (7 downto 0);
	signal tx_rd		: std_logic;	-- Read	
	signal tx_ef		: std_logic;	-- Empty Flag

	-- Rx process registers
	signal rx_data 	: std_logic_vector (7 downto 0);
	signal rx_bit		: integer range 0 to 7;
	signal rx_cntr		: integer range 0 to 15;
	signal rx_sum		: integer range 0 to 4;
	
	-- Rx process signals
	signal rx_wr		: std_logic;
	signal rx_ff		: std_logic;
	
begin

	-- Baudrate generation process
	process(clk)
	begin
		if rising_edge(clk) then 
			if reset = '1' then 
				rx_accum		<= (others => '0');
				rx_accum_d	<= (others => '0');
				tx_accum		<= 0;
				tx_ce			<= '0';
				rx_ce			<= '0';
			elsif ce = '1' then
				tx_ce			<= '0';
				rx_ce			<= '0';
				rx_accum_d 	<= rx_accum;
				rx_accum		<= rx_accum + accum_inc;
				
				-- increment rx_accum with wrapping
				if rx_accum_d > rx_accum then
					rx_ce <= '1';
					
					if tx_accum = 15 then 
						tx_accum <= 0;
						tx_ce 	<= '1';
					else
						tx_accum <= tx_accum + 1;
					end if;
						
				end if;
			end if;
		end if;
	end process;
	
	-- Tx process
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then -- syncronous resets are cool
				tx_data	<= (others => '0');
				tx_rd		<= '0';
				tx_bit	<= 0;
				tx_state <= tx_idle;
			elsif ce = '1' then
				tx_rd <= '0';
				
				case tx_state is
					when tx_idle =>
						if tx_ef = '0' then -- Fifo not empty
							tx_data	<= tx_dout;
							tx_rd 	<= '1';
							tx_state <= tx_start;
						end if;
					when tx_start =>
						if tx_ce = '1' then 
							tx <= '0';	-- start bit
							tx_state <= tx_send;
						end if;
					when tx_send =>
						if tx_ce = '1' then
							tx <= tx_data(tx_bit);
							if tx_bit = 7 then
								tx_bit <= 0;
								tx_state <= tx_end;
							else
								tx_bit <= tx_bit + 1;
							end if;
						end if;
					when tx_end => 
						if tx_ce = '1' then
							tx <= '1'; -- stop bit
							tx_state <= tx_idle;
							if tx_ef = '0' then
								tx_data <= tx_dout;
								tx_rd <= '1';
								tx_state <= tx_start;
							end if;
						end if;
				end case;
			end if;
		end if;
	end process;
	
	-- Rx process
	process(clk)
	begin
		if rising_edge(clk) then 
			if reset = '1' then
				rx_data	<= (others => '0');
				rx_wr		<= '0';
				rx_bit	<= 0;
				rx_cntr	<= 0;
				rx_sum	<= 0;
				rx_state <= rx_idle;
			elsif ce = '1' then
				rx_wr <= '0';
				
				case rx_state is
					when rx_idle =>
						if rx_ce = '1' then
							if rx = '0' then
								rx_cntr <= rx_cntr + 1;
								if rx_cntr = 10 then
									rx_state <= rx_recv;
								end if;
							else
								rx_cntr <= 0;
							end if;
						end if;
						
					when rx_recv => 
						if rx_ce = '1' then
							if rx_cntr = 15 then
								rx_cntr <= 0;
							else
								rx_cntr <= rx_cntr + 1;
							end if;
							
							-- Sum the four middle samples
							if (rx_cntr > 5) and (rx_cntr < 10) then
								if rx = '1' then
									rx_sum <= rx_sum + 1;
								end if;
							end if;
							
							-- Evaluate the sum
							if rx_cntr = 10 then
								rx_sum <= 0;
								if rx_sum >= 3 then 
									rx_data(rx_bit) <= '1';
								else
									rx_data(rx_bit) <= '0';
								end if;
								if rx_bit = 7 then 
									rx_bit <= 0;
									rx_state <= rx_end;
								else
									rx_bit <= rx_bit + 1;
								end if;
							end if;
						end if;
					
					when rx_end =>
						if rx_ce = '1' then
							if rx_cntr = 15 then
								rx_cntr <= 0;
							elsif rx_cntr = 7 then
								rx_cntr <= 0;
								rx_state <= rx_idle;
								if rx_ff = '0' then
									rx_wr <= '1';
								end if;
							else
								rx_cntr <= rx_cntr + 1;
							end if;
						end if;
				end case;
			end if;
		end if;
	end process;
						
					
	
	-- FIFO instantiations
	txfifo : entity work.sync_fifo
		generic map (
			data_width => 8,
			data_depth => tx_fifo_depth
		)
		port map (
			clk	=> clk,
			reset => reset,
			ce		=>	ce,
			din	=> din,
			wr		=> wr,
			ff		=> ff,
			dout	=> tx_dout,
			rd		=> tx_rd,
			ef		=> tx_ef
		);

	rxfifo : entity work.sync_fifo
		generic map (
			data_width => 8,
			data_depth => rx_fifo_depth
		)
		port map (
			clk	=> clk,
			reset => reset,
			ce		=>	ce,
			din	=> rx_data,
			wr		=> rx_wr,
			ff		=> rx_ff,
			dout	=> dout,
			rd		=> rd,
			ef		=> ef
		);

		

end RTL;

