library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;

entity FSM_Main_tb_v2 is
--  Port ( );
end FSM_Main_tb_v2;

architecture Behavioral of FSM_Main_tb_v2 is
    signal clk1k, clk10: std_logic:= '1';
    signal reset, start, button1, button2, ok: std_logic:= '0';
    
    signal disp_state1, disp_state2: tiempo_t;
    signal fin : std_logic;
begin
    fsmmain: FSM_Main
    Port map(
           start => start,    
           reset => reset,

           button1 => button1,
           button2 => button2,
           ok => ok,
           clk1k => clk1k,
           clk10 => clk10,
           initial_v => (0, 1, 0, 0 ,0),
           increment => (0,0,0,3,0),
           gamemode => Inc,
           time_out1 => disp_state1,
           time_out2 => disp_state2,
           fin => fin
    );
 
           
    
    clk1k <= not clk1k after 500 us;
    clk10 <= not clk10 after 50 ms;
    
    reset <= '1' after 20 ms, '0' after 80 ms;
    start <= '1' after 3 sec, '0' after 4 sec;

    button1 <= '1' after 35 sec, '0' after 36 sec;
    button2 <= '1' after 5 sec, '0' after 6 sec, '1' after 50 sec, '0' after 51 sec;--, '1' after 60 sec, '0' after 61 sec;
    ok <= '1' after 85 sec + 100 us, '0' after 86 sec;
    
end Behavioral;
