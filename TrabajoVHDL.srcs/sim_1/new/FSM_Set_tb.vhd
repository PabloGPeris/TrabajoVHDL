library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mipack.all;

entity fsm_set_tb is
--  Port ( );
end fsm_set_tb;

architecture Behavioral of fsm_set_tb is

    signal reset, start, ok, b1, b2, clk: std_logic := '0';
    
    signal gamemode: gamemode_t;
    signal initial_v, increment: tiempo_t;
    signal dr1, dr2: disp_reg_t;
    signal fin: std_logic;
    signal state: Set_state_t;
begin
    uut: FSM_Set
    port map(
           reset => reset,
           start => start,
           ok => ok,
           button1 => b1, 
           button2 => b2,
           clk10 => clk,
           
           disp_reg_1 => dr1,
           disp_reg_2 => dr2,
           initial_v => initial_v,
           increment => increment,
           gamemode => gamemode,
           fin => fin,
           state_o => state
      );
      
      clk <= not clk after 100 ms;
      reset <= '1' after 100 ms, '0' after 200 ms, '1' after 80 sec, '0' after 81 sec;
      start <= '1' after 1 sec, '0' after 2 sec;
      b1 <= '1' after 3 sec, '0' after 4 sec, '1' after 5 sec, '0' after 6 sec, '1' after 11 sec, '0' after 15 sec;
      b2 <= '1' after 7 sec, '0' after 8 sec, '1' after 16 sec, '0' after 18 sec, '1' after 24 sec, '0' after 50 sec;
      ok <= '1' after 10 sec, '0' after 11 sec, '1' after 20 sec, '0' after 21 sec, '1' after 60 sec, '0' after 61 sec;

end Behavioral;

