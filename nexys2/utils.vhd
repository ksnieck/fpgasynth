--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package utils is

	-- Function declarations
	function INC_PTR(ptr, data_depth : integer) return integer;
	function CHK_EF(rd_ptr, wr_ptr, data_depth : integer) return std_logic;
	function CHK_FF(rd_ptr, wr_ptr, data_depth : integer) return std_logic;

end package utils;

package body utils is


	-- Function Definitions
	function INC_PTR(ptr, data_depth : integer) return integer is
	begin
		if ptr = data_depth-1 then
			return 0;
		else 
			return (ptr + 1);
		end if;
	end function INC_PTR;
	
	function CHK_EF(rd_ptr, wr_ptr, data_depth : integer) return std_logic is
	begin
		if rd_ptr = (data_depth-1) and wr_ptr = 0 then
			return '1';
		elsif (rd_ptr + 1) = wr_ptr then
			return '1';
		else 
			return '0';
		end if;
	end function CHK_EF;
	
	function CHK_FF(rd_ptr, wr_ptr, data_depth : integer) return std_logic is
	begin
		if wr_ptr = (data_depth-1) and rd_ptr = 0 then
			return '1';
		elsif (wr_ptr + 1) = rd_ptr then
			return '1';
		else 
			return '0';
		end if;
	end function CHK_FF;
	
	
end package body utils;
