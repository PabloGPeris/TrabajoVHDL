library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;

entity FAS_tb is
--  Port ( );
end FAS_tb;

architecture Behavioral of FAS_tb is
    signal reset, start, ok, b1, b2, clk10, clk1k: std_logic := '0';
 
    signal initial_v, increment: tiempo_t;
    signal t_o: tiempo_t;
    signal dr: disp_reg_t;
    signal fin: std_logic;
    --signal state: Set_state_t;
begin
    uut: FSM_AddSub
    port map(
           start => START,

           reset => RESET,
           ok => OK,
           button1 => B1,
           button2 => B2,
           gamemode => INC,
           clk10 => CLK10,
           clk1k => CLK1K,
           
           disp_reg => DR,
           time_out => T_o,
           initial_v => INITIAL_V,
           increment => INCREMENT,

           fin => FIN
      );
      
      clk10 <= not clk10 after 50 ms;
      clk1k <= not clk1k after 500 us;
      reset <= '1' after 100 ms, '0' after 200 ms, '1' after 80 sec, '0' after 81 sec;
      start <= '1' after 1 sec, '0' after 2 sec;
      b1 <= '1' after 3 sec, '0' after 4 sec, '1' after 5 sec, '0' after 6 sec, '1' after 11 sec, '0' after 15 sec;
      b2 <= '1' after 7 sec, '0' after 8 sec, '1' after 16 sec, '0' after 47 sec, '1' after 70 sec, '0' after 75 sec;
      ok <= '1' after 48 sec, '0' after 49 sec, '1' after 80 sec, '0' after 81 sec;

end Behavioral;

