library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;

entity cosas_7s_tb is
--  Port ( );
end cosas_7s_tb;

architecture Behavioral of cosas_7s_tb is
    signal clk, clk10: std_logic:= '1';
    signal reset, start, button1, button2: std_logic:= '0';
    
    signal disp_state1, disp_state2: cntr_state_t;
    signal fin : std_logic;
    
    signal reg_out1, reg_out2: disp_reg_t;
    
begin
    fsmmain: FSM_Main
    Port map(
           reset => reset,
           start => start,
           button1 => button1,
           button2 => button2,
           clk1k => clk,
           clk10 => clk10,
           initial_v => (0, 1, 0, 0 ,0),
           
           disp_state1 => disp_state1,
           disp_state2 => disp_state2,
           fin => fin
           );
    
    uut1: decoder_7s_reg
    Port map(
        state => disp_state1,
  
        reg_out => reg_out1
    );
    
    uut2: decoder_7s_reg
    Port map(
        state => disp_state2,
  
        reg_out => reg_out2
    );
           
    
    clk <= not clk after 500 us;
    clk10 <= not clk10 after 50 ms;
    
    reset <= '1' after 20 ms, '0' after 80 ms;
    start <= '1' after 3 sec, '0' after 4 sec;

    button1 <= '1' after 35 sec, '0' after 36 sec;
    button2 <= '1' after 5 sec, '0' after 6 sec, '1' after 50 sec, '0' after 51 sec, '1' after 60 sec, '0' after 61 sec;
    
end Behavioral;
