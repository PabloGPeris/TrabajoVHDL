library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mipack.all;


entity FSM_Set is
    port(
           reset : in STD_LOGIC;
           start : in std_logic;
           ok : in std_logic;
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk10 : in std_logic;
           

           disp_reg_1: out disp_reg_t;
           sidp_reg_2: out disp_reg_t;
           initial_v : out cntr_state_t;
           increment : out cntr_state_t;
           gamemode : out gamemode_t;
           fin : out std_logic
      );
      
      
end FSM_Set;

architecture Behavioral of FSM_Set is
    type Set_state_t is (S0, S1, S2, S11, S12, S2_End); --s1 sin, s2 inc, s11 set time, s12 set increment


    signal state: Set_state_t;
    signal nxt_state: Set_state_t;
    signal button1_pressed : std_logic;
    signal button2_pressed : std_logic;
    signal ok_pressed : std_logic;
begin
    state_reg: process (reset, clk10)
    begin
    	if reset = '1'
 then 
        	state <= S0;
        	button1_pressed <= '0';
        	button2_pressed <= '0';
        	increment <= (0, 0, 0, 3, 0);
        	initial_v <= (0, 5, 0, 0, 0);
        elsif rising_edge(clk10) then
        	state <= nxt_state;
        	button1_pressed <= button1;--para hacer flancos
        	button2_pressed <= button2;
        	ok_pressed <= ok;
        end if;
    end process;
    

    
    nxt_dec: process (state, start, ok, button1, button2)
    begin
    	nxt_state <= state; --evitar latch
        case state is
        	when S0 =>
        	   if start = '1' then
        	       nxt_state <= S1;
        	   end if;
        	when S1 =>
        	   if button1 = '1' and button1_pressed = '0' then--flanco de subida con nuestro reloj
        	       nxt_state <= S2;
        	   elsif button2 = '1' and button2_pressed = '0' then--flanco de subida con nuestro reloj
        	       nxt_state <= S2;
        	   elsif ok = '1' and ok_pressed = '0' then
        	       nxt_state <= S11;
        	   end if;
        	
        	when S2 =>
        	   if button1 = '1' and button1_pressed = '0' then--flanco de subida con nuestro reloj
        	       nxt_state <= S1;
        	   elsif button2 = '1' and button2_pressed = '0' then--flanco de subida con nuestro reloj
        	       nxt_state <= S1;
        	   elsif ok = '1' and ok_pressed = '0' then
        	       nxt_state <= S11;
        	   end if;
        	when S11 => 
        	   if button1 = '1' and button1_pressed = '0' then--flanco de subida con nuestro reloj
        	       nxt_state <= S1;
        	   end if;
        	when others =>
        	       nxt_state <= S0;
        end case;
    end process;
    

end Behavioral;
