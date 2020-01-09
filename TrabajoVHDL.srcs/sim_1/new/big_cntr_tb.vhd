library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MiPack.all;



entity big_cntr_tb is
end big_cntr_tb;

architecture Behavioral of big_cntr_tb is
    signal clk: std_logic:= '1';
    signal ce_n: std_logic:= '0';
    signal load: std_logic:= '0';
    signal load_v: tiempo_t;
    
    signal state: tiempo_t;
    signal rdy: std_logic;

begin
    uut:
    big_cntr
    Port map ( 
           clk => clk,
           ce_n => ce_n,
           load => load,
           load_v => load_v,
           time_out => state,
           rdy_out => rdy
           );


    clk <= not clk after 50 ms;
    
    load_v <= (0, 1, 1, 1, 0);
    
    load <= '1' after 60 ms, '0' after 80 ms;
    
    ce_n <= '1' after 51020 ms, '0' after 55 sec;
end Behavioral;