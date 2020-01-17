library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;


entity FSM_Set is
    port(
           start : in std_logic;--señal de inicio
           
           reset : in STD_LOGIC;--botón de reset
           ok_re : in std_logic;--botón de ok POR FLANCO
           button1_re : in STD_LOGIC;--POR FLANCO
           button2_re : in STD_LOGIC;--POR FLANCO
           clk : in std_logic;--reloj (1 kHz)
           
           disp_reg_1: out disp_reg_t;--lo que muestra el primer cuarteto
           --de 7 segmentos
           disp_reg_2: out disp_reg_t;--lo que muestra el 2º cuarteto
           --de 7 segmentos
           gamemode : out gamemode_t;--modo de juego
           
           
           fin : out std_logic--señal de fin
      );
      
      
end FSM_Set;

architecture Behavioral of FSM_Set is
    type Set_state_t is (S0, S1, S2, S5); --s1 sin, s2 inc, S5 fin
    
    signal state: Set_state_t;
    signal nxt_state: Set_state_t;
    
    
    signal gamemode_interno, nxt_gamemode : gamemode_t;
begin

    gamemode <=  gamemode_interno;

    state_reg: process (reset, clk)
    begin
    	if reset = '1' then 
        	state <= S0;
        	

        	
        elsif rising_edge(clk) then
        	state <= nxt_state;
        	gamemode_interno <= nxt_gamemode;--HAY QUE HACER ESTO PARA EVITAR LATCH
        	
        end if;
    end process;
    

    
    nxt_dec: process (state, start, ok_re, button1_re, button2_re)
    begin
    	nxt_state <= state; 
        case state is
        	when S0 =>
        	   if start = '1' then
        	       nxt_state <= S1;
        	   end if;
        	   
        	when S1 =>
        	   if button1_re = '1' then--flanco de subida de button1
        	       nxt_state <= S2;
        	   elsif button2_re = '1' then--flanco de subida de button2
        	       nxt_state <= S2;
        	   elsif ok_re = '1' then--flanco de subida de ok
        	       nxt_state <= S5;
        	   end if;
        	
        	when S2 =>
        	   if button1_re = '1'  then--flanco de subida de button1
        	       nxt_state <= S1;
        	   elsif button2_re = '1' then--flanco de subida de button2
        	       nxt_state <= S1;
        	   elsif ok_re = '1' then--flanco de subida de ok
        	       nxt_state <= S5;
        	   end if;

        	when S5 =>
        	   nxt_state <= S5;
        	   
        	when others =>
        	   nxt_state <= S0;
        	   
        end case;
    end process;
    
    output_dec: process(state)
    begin
        case state is
        	when S0 =>
        	
        	   nxt_gamemode <= gamemode_interno;
               fin <= '0';
               
               disp_reg_1 <= (dguion, dguion, dguion, dguion); -- "----"
               disp_reg_2 <= (dguion, dguion, dguion, dguion); -- "----"
               
        	when S1 =>
        	
        	   nxt_gamemode <= Sin;
        	   fin <= '0';
        	   
        	   disp_reg_1 <= (d1 & "0", dS, di, dn); -- "1.Sin"
               disp_reg_2 <= (dguion, dguion, dguion, dguion); -- "----"
        	   
        	when S2 =>
        	
        	   nxt_gamemode <= Inc;

        	   disp_reg_1 <= (d2 & "0", di, dn, dc); -- "2.inC"
               disp_reg_2 <= (dguion, dguion, dguion, dguion); -- "----"
        	   
        	   fin <= '0';
        	   
        	when S5 => 
        	   
        	   nxt_gamemode <= gamemode_interno;
        	   
        	   disp_reg_1 <= (dguion, dguion, dguion, dguion); -- "----"
               disp_reg_2 <= (dguion, dguion, dguion, dguion); -- "----"
        	   
        	   fin <= '1';
        	   
        	when others =>
        	
               nxt_gamemode <= gamemode_interno;
               
               disp_reg_1 <= (dE, dR, dR, dguion); -- "Err-"
               disp_reg_2 <= (dE, dR, dR, dguion); -- "Err-"
               
               fin <= '0';

        end case;
    end process;
end behavioral;