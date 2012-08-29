----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:30:48 08/03/2012 
-- Design Name: 
-- Module Name:    sync_fifo - Behavioral 
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

library work;
use work.utils.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_fifo is
	generic ( 
		data_width : integer := 8;
		data_depth : integer := 1024
	);
	port (
		clk		: in std_logic;
		reset		: in std_logic;
		ce			: in std_logic;
		din 		: in std_logic_vector(data_width-1 downto 0);
		wr			: in std_logic;
		ff			: out std_logic;
		dout 		: out std_logic_vector(data_width-1 downto 0);
		rd			: in std_logic;
		ef			: out std_logic
	);
end sync_fifo;


architecture RTL of sync_fifo is
	
	-- Type definitions
	type ram_type is array (0 to data_depth-1) of std_logic_vector(data_width-1 downto 0);
	
	-- Mem type declaration
	signal ram : ram_type;

	-- Mem attributes
	attribute ram_style : string;
	--attribute ram_style of ram : signal is "distributed";
	attribute ram_style of ram : signal is "block";
	
	--  Registers
	signal rd_ptr : integer range 0 to data_depth-1;
	signal wr_ptr : integer range 0 to data_depth-1;
	
	-- Signals
	signal ff_d		: std_logic;
	signal ef_d		: std_logic;
	
begin

	dout	<= ram(rd_ptr);
	ff		<= ff_d;
	ef		<= ef_d;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				wr_ptr	<= 0;
				rd_ptr	<= 0;
				ff_d		<= '0';
				ef_d		<= '1';
			elsif ce = '1' then
				-- Read, full, Write is don't care
				if rd = '1' and ff_d = '1' and ef_d = '0' then
					ff_d <= '0';
					rd_ptr <= INC_PTR(rd_ptr, data_depth);
					ef_d <= CHK_EF(rd_ptr, wr_ptr, data_depth);
				
				-- Write, empty, Read is don't care
				elsif wr = '1' and ff_d = '0' and ef_d = '1' then
					ram(wr_ptr) <= din;
					ef_d 			<= '0';
					wr_ptr		<= INC_PTR(wr_ptr, data_depth);
					ff_d			<= CHK_FF(rd_ptr, wr_ptr, data_depth);
					
				-- Read, not full, not empty
				elsif rd = '1' and wr = '0' and ff_d = '0' and ef_d = '0' then
					rd_ptr <= INC_PTR(rd_ptr, data_depth);
					ef_d <= CHK_EF(rd_ptr, wr_ptr, data_depth);
				
				-- Write, not full, not empty
				elsif rd = '0' and wr = '1' and ff_d = '0' and ef_d = '0' then
					ram(wr_ptr) <= din;
					wr_ptr		<= INC_PTR(wr_ptr, data_depth);
					ff_d			<= CHK_FF(rd_ptr, wr_ptr, data_depth);
					
				-- Write and Read, not full, not empty
				elsif rd = '1' and wr = '1' and ff_d = '0' and ef_d = '0' then
					ram(wr_ptr) <= din;
					wr_ptr		<= INC_PTR(wr_ptr, data_depth);
					rd_ptr 		<= INC_PTR(rd_ptr, data_depth);
					
				-- Full and empty at the same time, Read and Write is don't care
				elsif ff_d = '1' and ef_d = '1'then
					-- error if we are here, reset the fifo
					wr_ptr <= 0;
					rd_ptr <= 0;
					ff_d <= '0';
					ef_d <= '1';
				end if;
			end if;
		end if;
	end process;

end RTL;

