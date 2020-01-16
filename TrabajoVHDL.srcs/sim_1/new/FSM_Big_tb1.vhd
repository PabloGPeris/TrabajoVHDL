library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Paco.all;

entity FSM_Big_tb1 is
--  Port ( );
end FSM_Big_tb1;

architecture Behavioral of FSM_Big_tb1 is
  component FSM_Big is
  Port (
           reset : in STD_LOGIC;
           ok : in std_logic;
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk10 : in std_logic;
           clk1k: in std_logic;
           
           disp_reg1: out disp_reg_t;
           disp_reg2: out disp_reg_t
    );
    end component;
    
    signal clk1k, clk10: std_logic:= '1';
    signal reset, start, button1, button2, ok: std_logic:= '0';
    
    signal disp1, disp2: disp_reg_t;
    
begin

uut: FSM_Big 
  Port map (
           reset => reset,
           ok => ok,
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
    button1 <= '1' after 1 sec, '0' after 2 sec, '1' after 12 sec, '0' after 13 sec, '1' after 20 sec, '0' after 21 sec;
    button2 <= '1' after 3 sec, '0' after 4 sec, '1' after 5 sec, '0' after 6 sec, '1' after 15 sec, '0' after 16 sec;
    ok <= '1' after 4 sec, '0' after 4500 ms, '1' after  8 sec, '0' after 9 sec, '1' after 10 sec, '0' after 11 sec;
    
    


end Behavioral;
