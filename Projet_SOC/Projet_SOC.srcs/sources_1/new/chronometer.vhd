-----------------------------------------------------------------
-- Engineer: Timothé LANNUZEL & William PENSEC
-- Create Date: 03.01.2020 16:01:00
-- Module Name: chronometer - Behavioral
-- Project Name: Détection de dépassement de temps d'exécution
-- Revision: 1.0
-----------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chronometer is
    generic(
        WIDTH : integer := 16
    );
    
    Port (
        clk : in std_logic;
        startStop : in std_logic;
        suspendResume : in std_logic;
        load : in std_logic;
        reset : in std_logic;
        wcet : in std_logic_vector(WIDTH - 1 downto 0);
        cout : out std_logic;
        cout_test : out std_logic_vector(WIDTH - 1 downto 0)
    );
end chronometer;

architecture Behavioral of chronometer is
    signal curr_value : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
begin
    cout_test <= curr_value;

    compteur : process(clk)
    begin
        if rising_edge(clk) then
            if load = '1' then
                curr_value <= wcet;
            elsif reset = '1' then
                curr_value <= (others => '0');
            elsif startStop = '1' and suspendResume = '0' and unsigned(curr_value) /= 0 then  -- 1 start | 0 resume
                curr_value <= std_logic_vector(unsigned(curr_value) - 1);
            end if;
        end if;
        
    end process;
    
    test : process(curr_value) 
    begin
        if startStop = '1' and unsigned(curr_value) = 0 then
            cout <= '1';
        else 
            cout <= '0';
        end if;
        if reset = '1' then
            cout <= '0';
        elsif load = '1' then 
            cout <= '0';
        end if;
    end process;
    
end Behavioral;
