----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2020 16:22:12
-- Design Name: 
-- Module Name: taskMonitor - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity taskMonitor is
    Port (
        clk_in : in std_logic;
        reset_in : in  std_logic;
        
        id_task : in std_logic_vector(3 downto 0);
        wcet_task : in std_logic_vector(15 downto 0);
        mess_task : in std_logic_vector(3 downto 0);
        
        counter_interupt : out std_logic;
------------------RAJOUTER----------------------
        counter_interupt_test: out std_logic_vector(16 - 1 downto 0)
        
------------------RAJOUTER----------------------
        
    );
end taskMonitor;



architecture Behavioral of taskMonitor is 

--------------------------------------------------
----------------------Signal----------------------
--------------------------------------------------
    --signal pour les chronos
    signal sigstartStop :  std_logic_vector(3 downto 0);
    signal sigsuspendResume :  std_logic_vector(3 downto 0);
    signal sigload :  std_logic_vector(3 downto 0);
    type register_array is array ( 3 downto 0 ) of std_logic_vector( 15 downto 0 );
    signal sigtaskwcet : register_array;

    signal curChrono: std_logic_vector(3 downto 0) := (others => '0');  -- pour connaitre sur quelle chrono on est
    signal interrupt_timer : std_logic_vector(3 downto 0);
    
------------------RAJOUTER----------------------
    signal curcounter_interupt_test : register_array;
    signal currTaskId : integer :=0;
    signal sigReset  :  std_logic_vector(3 downto 0);
------------------RAJOUTER----------------------
    
    
--------------------------------------------------
--------------------Components--------------------
--------------------------------------------------
    component chronometer 
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
    end component;
    
begin
    --------------------------------------------------
    ---------------------Port map---------------------
    --------------------------------------------------  
    generate_chrono : for i in 0 to 3 generate
        instChrono : entity work.chronometer(Behavioral)
            port map(
                clk => clk_in,
                startStop => sigstartStop(i),
                suspendResume => sigsuspendResume(i),
                load => sigload(i),
                reset => sigReset(i),
                wcet => sigtaskwcet(i),
                cout => interrupt_timer(i),
                cout_test => curcounter_interupt_test(i)
                
            );
    end generate;
    
------------------RAJOUTER----------------------
    
    
------------------RAJOUTER----------------------
    tache : process(clk_in)
    begin
------------------RAJOUTER----------------------
              --Changement du WCET
        if reset_in = '1' then
            loop1 : for i in 0 to 3 LOOP
                    sigstartStop(i) <= '0';    --STOP
                    sigload(i) <= '0';
                    sigsuspendResume(i) <= '0';
                    sigReset(i) <= '1';
            END LOOP loop1;
        else 
            case conv_integer ( mess_task ) is          --Changement de message
                when 0 =>
                    sigstartStop(currTaskId) <= '0';    --STOP
                    sigload(currTaskId) <= '0';
                    sigsuspendResume(currTaskId) <= '0';
                    sigReset(currTaskId) <= '0';
                when 1 =>
                    sigstartStop(currTaskId) <= '1';    --START
                    sigload(currTaskId) <= '0';
                when 2 =>
                    sigtaskwcet(currTaskId) <= wcet_task; 
                    sigload(currTaskId) <= '1';         --LOAD
                when 3 =>
                    sigsuspendResume(currTaskId) <= '1';--SUSPEND
                when 4 =>
                    sigsuspendResume(currTaskId) <= '0';--RESUME
                when 5 =>
                    sigReset(currTaskId) <= '1';        --RESET
                    sigstartStop(currTaskId) <= '0';    
                    sigload(currTaskId) <= '0';
                    sigsuspendResume(currTaskId) <= '0';
                when others =>
                    --ne rien faire
            end case;
        end if;
        if reset_in = '1' then 
             counter_interupt <= '0';
        elsif interrupt_timer(currTaskId) = '1' then
            counter_interupt <= '1';
        else
            counter_interupt <= '0';
        end if;
        counter_interupt_test <= curcounter_interupt_test(currTaskId);
    end process;
    
    tache2 : process(id_task)
    begin
        currTaskId <= to_integer (unsigned(id_task));
        
    end process;

    
end Behavioral;