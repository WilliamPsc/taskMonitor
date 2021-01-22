-----------------------------------------------------------------
-- Engineer: Timothé LANNUZEL & William PENSEC
-- Create Date: 05.01.2020 17:21:00
-- Module Name: chronometer_tb - Behavioral
-- Project Name: Détection de dépassement de temps d'exécution
-- Revision: 1.0
-----------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chronometer_tb is
--  Port ( );
end chronometer_tb;

architecture Behavioral of chronometer_tb is
    component chronometer is
        generic(
            WIDTH : integer := 16
        );
        Port(
            clk : in std_logic;
            startStop : in std_logic;
            suspendResume : in std_logic;
            load : in std_logic;
            reset : in std_logic;
            wcet : in std_logic_vector(WIDTH - 1 downto 0);
            cout : out std_logic;
            cout_test : out std_logic_vector(WIDTH - 1 downto 0)
        );
    end component chronometer;
    
    constant WIDTH : integer := 16;
    signal clk_ch : std_logic := '0';
    signal startStop_ch : std_logic;
    signal suspendResume_ch : std_logic;
    signal load_ch : std_logic;
    signal reset_ch : std_logic;
    signal wcet_ch : std_logic_vector(WIDTH - 1 downto 0);
    signal cout_ch : std_logic;
    signal cout_test_ch : std_logic_vector(WIDTH - 1 downto 0);
    
begin
    clk_ch <= not clk_ch after 1 ns;
    startStop_ch <= '0', '1' after 5 ns;
    suspendResume_ch <= '0'; -- always active
    load_ch <= '1', '0' after 4 ns; -- data are loaded after 4 ns
    reset_ch <= '0'; -- never reseted
    wcet_ch <= std_logic_vector(to_unsigned(15, 16));
    
    iut : entity work.chronometer(Behavioral)
    Port map(
        clk => clk_ch,
        startStop => startStop_ch,
        suspendResume => suspendResume_ch,
        load => load_ch,
        reset => reset_ch,
        wcet => wcet_ch,
        cout => cout_ch,
        cout_test => cout_test_ch
    );
end Behavioral;
