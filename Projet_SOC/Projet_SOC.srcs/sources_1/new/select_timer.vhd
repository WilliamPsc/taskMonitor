----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2021 10:32:40
-- Design Name: 
-- Module Name: select_timer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity select_timer is
        Port(   
            task_id : in std_logic_vector (3 downto 0);
            dec_task_id : out  std_logic_vector (3 downto 0)
        );
end select_timer;

architecture Behavioral of select_timer is
    signal id : integer;
begin
    task : process(task_id)
    begin
        dec_task_id <= (others => '0');
        dec_task_id (conv_integer (task_id) ) <= '1';
    end process;

end Behavioral;
