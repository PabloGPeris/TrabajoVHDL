library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mipack.all;

entity FSM_Big_tb1 is
--  Port ( );
end FSM_Big_tb1;

architecture Behavioral of FSM_Big_tb1 is

    signal clk1k, clk10: std_logic:= '1';
    signal reset, start, button1, button2, ok: std_logic:= '0';
    signal button1_pre, button2_pre, ok_pre: std_logic:= '0';
    
    signal disp1, disp2: disp_reg_t;
    
    
begin


    process(clk1k)
    begin
        if rising_edge(clk1k) then
            button1_pre<=button1;
            button2_pre<=button2;
            ok_pre<=ok;
        end if;
    end process;

uut: FSM_Big 
  Port map (
           reset => reset,
           ok_re => ok and not ok_pre,
           button1_re => button1 and not button1_pre,
           button2_re => button2 and not button2_pre,
           button1 => button1,
           button2 => button2,         
           clk10 => clk10,
           clk1k => clk1k,
           
           disp_reg1 => disp1,
           disp_reg2 => disp2
    );
    
    clk1k <= not clk1k after 500 us;
    clk10 <= not clk10 after 50 ms;
    
    reset <= '1' after 10 ms, '0' after 20 ms;
    button1 <= '1' after 1 sec + 10 us, '0' after 2 sec + 100 us, '1' after 12 sec + 100 us, '0' after 13 sec + 100 us, '1' after 20 sec + 100 us, '0' after 21 sec + 100 us;
    button2 <= '1' after 3 sec + 10 us, '0' after 4 sec + 100 us, '1' after 5 sec + 100 us, '0' after 6 sec + 100 us, '1' after 15 sec + 100 us, '0' after 16 sec + 100 us;
    ok <= '1' after 4 sec + 10 us, '0' after 4500 ms + 100 us, '1' after  8 sec + 100 us, '0' after 9 sec + 100 us, '1' after 10 sec + 100 us, '0' after 11 sec + 100 us;
    
    


end Behavioral;
