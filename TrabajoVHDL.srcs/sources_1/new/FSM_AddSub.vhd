library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;


entity FSM_AddSub is
    port(
           start : in std_logic;--señal de inicio
           
           reset : in STD_LOGIC;--botón reset
           ok_re : in std_logic;--botón ok Con flanco
           button1 : in STD_LOGIC;--botón 1 (decremento) SIN FLANCO
           button2 : in STD_LOGIC;--botón 2 (incremento) SIN FLANCO
           gamemode : in gamemode_t;
           clk10 : in std_logic;
           clk1k: in std_logic;
           
           disp_reg: out disp_reg_t;--letras que se van a mostrar en pantalla
           time_out: out tiempo_t;--tiempo que se va a mostrar en pantalla
           initial_v : out tiempo_t;
           increment : out tiempo_t;

           fin : out std_logic
      );
      
      
end FSM_AddSub;

architecture Behavioral of FSM_AddSub is
    type Set_state_t is (S0, S1, S2, S3, S4); --s1 set time, s2 set inc, s3 end;
    
    signal state: Set_state_t;
    signal nxt_state: Set_state_t;
    
    
    --cosas de sumadores y restadores
    signal din_addsub1, din_addsub2, dout_addsub : tiempo_t;
    signal ce_addsub: std_logic;
    signal reset_addsub: std_logic;

    --variables internas
    signal initial_v_interno, increment_interno : tiempo_t;
    signal nxt_initial_v, nxt_increment : tiempo_t;
    
begin

    addsub: Adder_Subs_Sync
    port map(
           reset => reset or reset_addsub,
           ce => ce_addsub,
           suma => button2, --truco, preguntar si no se entiende
           din1 => din_addsub1,
           din2 => din_addsub2,
           clk => clk10,
           
           dout => dout_addsub
      );

    state_reg: process (reset, clk1k)
    begin
    	if reset = '1' then 
        	state <= S0;

        elsif rising_edge(clk1k) then
        	state <= nxt_state;
        	initial_v_interno <= nxt_initial_v;
        	increment_interno <= nxt_increment;
        end if;
    end process;
    

    
    nxt_dec: process (state, start, ok_re)
    begin
    	nxt_state <= state; 
        case state is
        
        	when S0 =>
        	   if start = '1' then
        	       nxt_state <= S1;
        	   end if;
        	   
        	when S1 =>
        	   if ok_re = '1' then 
        	       if gamemode = Inc then
        	           nxt_state <= S2;
        	       else
        	           nxt_state <= S4;
        	       end if;
        	   end if;
        	   
        	when S2 => 
        	   nxt_state <= S3;
        	
        	when S3 =>
        	   if ok_re = '1' then
        	       nxt_state <= S4;
        	   end if;

        	when S4 =>
        	   nxt_state <= S4;
        	   
        	when others =>
        	   nxt_state <= S0;  
        	   
        end case;
    end process;
    
    output_dec: process (state, button1, button2, clk1k)
    begin
        case state is
        	when S0 =>
                
                din_addsub1 <= initial_v_interno;
                din_addsub2 <= (0, 0, 0, 0, 0);
                ce_addsub <= '0';
                reset_addsub <= '1';
                
                nxt_initial_v <= (1, 0, 0, 0, 0); --10 min
                nxt_increment <= (0, 0, 0, 3, 0); --3 segundos
               
                disp_reg <= (dguion, dguion, dguion, dguion); -- "----"
                time_out <= initial_v_interno;
                
                fin <= '0';
                
               
        	when S1 =>
                
                din_addsub1 <= initial_v_interno;
                din_addsub2 <= (0, 0, 3, 0, 0); --30 segundos
                ce_addsub <= button1 or button2;
                reset_addsub <= '0';
                
        	    disp_reg <= (dt, di, de, dguion); -- "TiE-"
        	    time_out <= initial_v_interno;
               
                nxt_initial_v <= dout_addsub;
                nxt_increment <= increment_interno;
        	    
        	    fin <= '0';
        	    
        	when S2 =>
                
                din_addsub1 <= increment_interno;
                din_addsub2 <= (0, 0, 0, 1, 0); --1 segundo
                ce_addsub <= button1 or button2;
                reset_addsub <= '1';
                
        	    disp_reg <= (di, dn, dc, dguion); -- "inC-"
        	    time_out <= increment_interno;
               
                nxt_initial_v <= initial_v_interno;
        	    nxt_increment <= dout_Addsub;
        	   
        	    fin <= '0';
        	   
        	when S3 =>
        	
                din_addsub1 <= increment_interno;
                din_addsub2 <= (0, 0, 0, 1, 0); --1 segundo
                ce_addsub <= button1 or button2;
                reset_addsub <= '0';
                
        	    disp_reg <= (di, dn, dc, dguion); -- "inC-"
        	    time_out <= increment_interno;
               
                nxt_initial_v <= initial_v_interno;
        	    nxt_increment <= dout_Addsub;
        	   
        	    fin <= '0';
        	   
        	when S4 =>
                   
                din_addsub1 <= initial_v_interno;
                din_addsub2 <= (0, 0, 0, 0, 0);
                ce_addsub <= '0';
                reset_addsub <= '1';
                
                nxt_initial_v <= initial_v_interno;
                nxt_increment <= increment_interno;
               
                disp_reg <= (dL, dO, dA, dD); -- "Load"
                time_out <= initial_v_interno;
                
                fin <= '1';
        	   
        	when others =>
        	
                din_addsub1 <= initial_v_interno;
                din_addsub2 <= (0, 0, 0, 0, 0);
                ce_addsub <= '0';
                reset_addsub <= '1';

                nxt_initial_v <= initial_v_interno;
                nxt_increment <= increment_interno;
               
                disp_reg <= (dE, dR, dR, dguion); -- "Err-"
                time_out <= initial_v_interno;
                
                fin <= '0';

        end case;
    end process;

    increment <= increment_interno;
    initial_v <= initial_v_interno;
    
    
end behavioral;
