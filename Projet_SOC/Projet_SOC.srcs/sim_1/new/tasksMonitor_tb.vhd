-----------------------------------------------------------------
-- Engineer: Timothé LANNUZEL & William PENSEC
-- Create Date: 19.01.2021 12:09:40
-- Module Name: taskMonitor_tb - Behavioral
-- Project Name: Détection de dépassement de temps d'exécution
-- Revision: 1.2
-----------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity taskMonitor_tb is
--  Port ( );
end taskMonitor_tb;

architecture Behavioral of taskMonitor_tb is
    component taskMonitor is
        Port (
            clk_in : in std_logic;
            reset_in : in  std_logic;
            
            id_task : in std_logic_vector(3 downto 0);
            wcet_task : in std_logic_vector(15 downto 0);
            mess_task : in std_logic_vector(3 downto 0);
            
            counter_interupt : out std_logic;
            counter_interupt_test: out std_logic_vector(15 downto 0)
            
        ); 
    end component taskMonitor;
    
    signal clk : std_logic := '0';
    signal reset : std_logic;
    signal id : std_logic_vector(3 downto 0);
    signal wcet : std_logic_vector(15 downto 0);
    signal message : std_logic_vector(3 downto 0);
    signal compteur : std_logic;
    signal compteur_test: std_logic_vector(15 downto 0);
    
begin
    clk <= not clk after 1 ns;
    reset <= '0', '1' after 29 ns;
    id <=   std_logic_vector(to_unsigned(0,4)),                 --tache 0
            std_logic_vector(to_unsigned(1,4)) after 6 ns ,     --tache 1
            std_logic_vector(to_unsigned(0,4)) after 11 ns;     --tache 0
            
    wcet <= std_logic_vector(to_unsigned(3, 16)),               --tache 0: 3
            std_logic_vector(to_unsigned(5, 16)) after 7 ns;   --tache 1: 5
            
    message <=  std_logic_vector(to_unsigned(0,4)),             --stop
                std_logic_vector(to_unsigned(2,4)) after 2 ns,  --load
                std_logic_vector(to_unsigned(1,4)) after 3 ns,  --start 
                std_logic_vector(to_unsigned(3,4)) after 5 ns,  --suspend 
                std_logic_vector(to_unsigned(0,4)) after 7 ns,  --stop
                std_logic_vector(to_unsigned(2,4)) after 8 ns,  --load
                std_logic_vector(to_unsigned(1,4)) after 9 ns,  --start
                std_logic_vector(to_unsigned(3,4)) after 11 ns, --suspend 
                std_logic_vector(to_unsigned(4,4)) after 13 ns; --resume 
                
    iut : entity work.taskMonitor(Behavioral)
    Port map(
        clk_in => clk,
        reset_in => reset,
        id_task => id,
        wcet_task => wcet,
        mess_task => message,
        counter_interupt => compteur,
        counter_interupt_test =>compteur_test
    );

end Behavioral;
