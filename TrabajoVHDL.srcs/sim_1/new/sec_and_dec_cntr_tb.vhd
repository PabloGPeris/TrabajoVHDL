library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MiPack.all;

entity sec_and_dec_cntr_tb is
--  Port ( );
end sec_and_dec_cntr_tb;

architecture Behavioral of sec_and_dec_cntr_tb is
    signal clk: std_logic:= '0';
    signal preset: std_logic:= '0';
    signal ce_n: std_logic:= '0';
    
    signal state: integer10;
    
    signal rdy_dec_cntr: std_logic;
    signal rdy_sec_cntr: std_logic;
begin

    dec_uut: Dec_cntr
    Port map( clk => clk,
           reset => preset,
           ce_n => ce_n, --clk enable
           rdy => rdy_dec_cntr
           ); --ready
    
    sec_u: Sec_cntr
    Port map( clk => clk,
           ce_n => ce_n,
           preset => preset,
           load_v => 5, 
           rdy_dec_cntr => rdy_dec_cntr,
           state_out => state,
           rdy => rdy_sec_cntr
           );


    clk <= not clk after 50 ms;
    preset <= '1' after 60 ms, '0' after 70 ms;
    ce_n <= '1' after 10 sec, '0' after 13 sec;
end Behavioral;
