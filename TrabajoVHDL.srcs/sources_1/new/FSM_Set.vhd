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
           disp_reg_2: out disp_reg_t;
           initial_v : out tiempo_t;
           increment : out tiempo_t;
           gamemode : out gamemode_t;
           fin : out std_logic
      );
      
      
end FSM_Set;

architecture Behavioral of FSM_Set is
    type Set_state_t is (S0, S1, S2, S11, S12, S5_End); --s1 sin, s2 inc, s11 set time, s12 set increment
    
    signal state: Set_state_t;
    signal nxt_state: Set_state_t;
    
    --variables para poder hacer flancos
    signal button1_pressed : std_logic;
    signal button2_pressed : std_logic;
    signal ok_pressed : std_logic;
    
    --cosas de sumadores y restadores
    signal din1_adder, din2_adder, dout_adder : tiempo_t;
    signal din1_sub, din2_sub, dout_sub : tiempo_t;
    
    --decodificador 7s
    signal din_dec: tiempo_t;
    signal dout_dec: disp_reg_t;
    
    
    --variables internas
    signal initial_v_interno, increment_interno : tiempo_t;
    
    
begin


    adder: adder_time
    port map(
        din1 => din1_adder,
        din2 => din2_adder,
        
        dout => dout_adder,
        complement => '0'
    
    );
    
    subs: substracter_time
    port map(
        din1 => din1_sub,
        din2 => din2_sub,
        
        dout => dout_sub
    );

    dec7:  Decoder_7s_reg
    Port map (
        state => din_dec,
  
        reg_out => dout_dec
    );



    state_reg: process (reset, clk10)
    begin
    	if reset = '1' then 
        	state <= S0;
        	
        	button1_pressed <= '0';--separar esto
        	button2_pressed <= '0';
        	ok_pressed <= '0';
        	
        elsif rising_edge(clk10) then
        	state <= nxt_state;
        	
        	button1_pressed <= button1;--para hacer flancos
        	button2_pressed <= button2;
        	ok_pressed <= ok;
        end if;
    end process;
    

    
    nxt_dec: process (state, start, ok, button1, button2)
    begin
    	nxt_state <= state; 
        case state is
        	when S0 =>
        	   if start = '1' then
        	       nxt_state <= S1;
        	   end if;
        	   
        	when S1 =>
        	   if button1 = '1' and button1_pressed = '0' then--flanco de subida de button1
        	       nxt_state <= S2;
        	   elsif button2 = '1' and button2_pressed = '0' then--flanco de subida de button2
        	       nxt_state <= S2;
        	   elsif ok = '1' and ok_pressed = '0' then--flanco de subida de ok
        	       nxt_state <= S11;
        	   end if;
        	
        	when S2 =>
        	   if button1 = '1' and button1_pressed = '0' then--flanco de subida de button1
        	       nxt_state <= S1;
        	   elsif button2 = '1' and button2_pressed = '0' then--flanco de subida de button2
        	       nxt_state <= S1;
        	   elsif ok = '1' and ok_pressed = '0' then--flanco de subida de ok
        	       nxt_state <= S11;
        	   end if;
        	   
        	when S11 => 
        	    if ok = '1' and ok_pressed = '0' then--flanco de subida de ok
                    if gamemode = Inc then
                        nxt_state <= S12;
                    else
                        nxt_state <= S5_End;
                    end if;
        	    end if;
        	   
            when S12 => 
        	   if ok = '1' and ok_pressed = '0' then--flanco de subida de ok
        	       nxt_state <= S5_End;
        	   end if;  
        	   
        	when S5_End =>
        	   nxt_state <= S5_End;
        	   
        	when others =>
        	   nxt_state <= S0;
        end case;
    end process;
    
    output_dec: process(state, clk10)
    begin
        case state is
        	when S0 =>
        	
        	   gamemode <= Sin;
        	   
        	   din1_adder <= initial_v_interno;
               din2_adder <= (0, 0, 3, 0, 0); --30 segundos        	   
        	   din1_sub <= initial_v_interno;
               din2_sub <= (0, 0, 3, 0, 0); --30 segundos
               
               initial_v_interno <= (1, 0, 0, 0, 0); --10 min
               increment_interno <= (0, 0, 0, 5, 0); --5 segundos
               
               fin <= '0';
               
               disp_reg_1 <= (dguion, dguion, dguion, dguion); -- "----"
               disp_reg_2 <= (dguion, dguion, dguion, dguion); -- "----"
               
        	when S1 =>
        	
        	   gamemode <= Sin;

        	   fin <= '0';
        	   
        	   disp_reg_1 <= (d1 & "0", dS, di, dn); -- "1.Sin"
               disp_reg_2 <= (dguion, dguion, dguion, dguion); -- "----"
        	   
        	when S2 =>
        	
        	   gamemode <= Inc;

        	   disp_reg_1 <= (d2 & "0", di, dn, dc); -- "2.inC"
               disp_reg_2 <= (dguion, dguion, dguion, dguion); -- "----"
        	   
        	   fin <= '0';
        	   
        	when S11 => 
        	
                din1_adder <= initial_v_interno;
                din2_adder <= (0, 0, 3, 0, 0); --30 segundos
        	   
        	    din1_sub <= initial_v_interno;
                din2_sub <= (0, 0, 3, 0, 0); --30 segundos
               
                din_dec <= initial_v_interno;
                disp_reg_1 <= (dt, di, de, dguion); -- "TiE-"
                disp_reg_2 <= dout_dec;
                
                fin <= '0';
                
               --sima o resta al valor inicial
                if rising_edge(clk10) then
                    if button1 = '1' and isgreater(initial_v_interno, (0, 0, 3, 0, 0)) = '1' then
                        initial_v_interno <= dout_sub;
                    elsif button2 = '1' and isgreater((9, 0, 0, 0, 0), initial_v_interno) = '1' then
                        initial_v_interno <= dout_adder;
                    end if;
                end if;
               
            when S12 => 
            
                din1_adder <= increment_interno;
                din2_adder <= (0, 0, 0, 1, 0); --1 segundo
        	   
        	    din1_sub <= increment_interno;
                din2_sub <= (0, 0, 0, 1, 0); --1 segundo
        	   
        	    din_dec <= increment_interno;
        	    disp_reg_1 <= (di, dn, dc, dguion); -- "inC-"
                disp_reg_2 <= dout_dec;
        	   
        	    fin <= '0';
        	   
        	    if rising_edge(clk10) then
        	        if button1 = '1' and isgreater(increment_interno, (0, 0, 0, 1, 0)) = '1' then
                        increment_interno <= dout_sub;
                    elsif button2 = '1' and isgreater((0, 1, 0, 0, 0), increment_interno) = '1' then
                        increment_interno <= dout_adder;
                    end if;
                end if;
        	   
        	when S5_End =>
        	   
        	   disp_reg_1 <= (dguion, dguion, dguion, dguion); -- "----"
               disp_reg_2 <= (dguion, dguion, dguion, dguion); -- "----"
        	   
        	   fin <= '1';
        	   
        	when others =>
        	
               gamemode <= Sin;
        	   din1_adder <= initial_v;
               din2_adder <= (0, 0, 3, 0, 0); --30 segundos
        	   
        	   din1_sub <= initial_v;
               din2_sub <= (0, 0, 3, 0, 0); --30 segundos
               
               initial_v_interno <= (1, 0, 0, 0, 0); --10 min
               increment_interno <= (0, 0, 0, 5, 0); --5 segundos
               
               fin <= '0';
               
               disp_reg_1 <= (dE, dR, dR, dguion); -- "Err-"
               disp_reg_2 <= (dE, dR, dR, dguion); -- "Err-"
        end case;
    end process;

    increment <= increment_interno;
    initial_v <= initial_v_interno;
    

    
end behavioral;