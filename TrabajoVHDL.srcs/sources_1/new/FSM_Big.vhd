library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;

entity FSM_Big is
  Port (
           reset : in STD_LOGIC;
           ok_re : in std_logic;--por flanco
           button1_re : in STD_LOGIC;--por flanco
           button2_re : in STD_LOGIC;--por flanco
           button1 : in STD_LOGIC;--no flanco
           button2 : in STD_LOGIC;--no flanco
           clk10 : in std_logic;
           clk1k: in std_logic;
           
           disp_reg1: out disp_reg_t;
           disp_reg2: out disp_reg_t
   );
end FSM_Big;

architecture Behavioral of FSM_Big is
    type state_t is (S0, S1, S2, S3, S4, S5);
    
    signal state, nxt_state: state_t;
    
    ---FSM_Set
    signal start_set, reset_set, fin_set: std_logic;
    signal disp_reg_set1, disp_reg_set2: disp_reg_t;
    
    --FSM_AddSub
    signal start_addsub, reset_addsub, fin_addsub: std_logic;
    signal disp_reg_addsub1: disp_reg_t;
    signal time_out_addsub2: tiempo_t;
    
    --FSM_Main
    signal start_main, reset_main, fin_main: std_logic;
    signal time_out_main1, time_out_main2: tiempo_t;
    
    --decoder 7 segmentos
    signal din_dec1, din_dec2: tiempo_t;
    signal dout_dec1, dout_dec2: disp_reg_t;
    
    
    --señales comunes
    signal gamemode: gamemode_t;
    signal initial_v, increment: tiempo_t;
    
begin

    gamemode <= Sin;
--      SI ESTO ESTÁ COMENTADO ES PORQUE NO FUNCIONA LO PREVISTO AL PRINCIPIO 
--    setfsm: FSM_Set
--    port map(
--           start => start_set,
           
--           reset => reset or reset_set,
--           ok_re => ok_re,
--           button1_re => button1_re,
--           button2_re => button2_re,
--           clk => clk1k,
           
--           disp_reg_1 => disp_reg_set1,
--           disp_reg_2 => disp_reg_set2,
--           gamemode => gamemode,
           
--           fin => fin_set
--      );   
      
      addsubfsm: FSM_AddSub
      port map(
           start => start_addsub,
           
           reset => reset or reset_addsub,
           ok_re => ok_re,
           button1 => button1,
           button2 => button2,
           gamemode => gamemode,
           clk10 => clk10,
           clk1k => clk1k,
           
           disp_reg => disp_reg_addsub1, 
           time_out => time_out_addsub2,--tiempo que se va a mostrar en pantalla
           initial_v => initial_v,
           increment => increment,

           fin => fin_addsub
      );

    mainfsm: FSM_Main
    Port map( 
        start => start_main,
        
        reset => reset or reset_main,
        button1 => button1_re,
        button2 => button2_re,
        ok => ok_re,
        clk1k => clk1k,
        clk10 => clk10,
        initial_v => initial_v,
        increment => increment,
        gamemode => gamemode,
           
        time_out1 => time_out_main1,
        time_out2 => time_out_main2,
           
        fin => fin_main
        );   
        
        
    dec1: Decoder_7s_reg
    port map(
        time_in => din_dec1,
  
        reg_out => dout_dec1
    );
    
    dec2: Decoder_7s_reg
    port map(
        time_in => din_dec2,
  
        reg_out => dout_dec2
    );

    state_reg: process (all)
    begin
    	if reset = '1' then 
            state <= S0;
	
        elsif rising_edge(clk1k) then
            state <= nxt_state;
        end if;
    end process;

    nxt_dec: process (state, fin_addsub, fin_set, fin_main)
    begin
    	nxt_state <= state; 
        case state is
        
            when S0 =>
--              cosas que solo ocurren si no funciona
--        	    nxt_state <= S1;
        	    nxt_state <= S3;        	    

        	    
--        	when S1 =>
--                if fin_set = '1' then
--                    nxt_state <= S2;
--                end if;
                
--        	when S2 =>
--        	    nxt_state <= S3;
        	    
        	when S3 =>
        	    if fin_addsub = '1' then
                    nxt_state <= S4;
                end if;
                
            when S4 => 
        	    nxt_state <= S5;
        	    
        	when S5 =>
        	    if fin_main = '1' then
                    nxt_state <= S0;
                end if;
             
        	when others =>
        	    nxt_state <= S0;
        	    
        end case;
    end process;

    out_dec: process (state, clk1k) 
    begin
    case state is
    
        	when S0 =>

                reset_set <= '1';
                reset_addsub <= '1';
                reset_main <= '1';
                
                start_set <= '0';
                start_addsub <= '0';
                start_main <= '0';
                
                din_dec2 <= time_out_addsub2; 
                disp_reg1 <= (dL, dO, dA, dD);
                disp_reg2 <= (dguion, dguion, dguion, dguion);
                
                
            when S1 =>
                reset_set <= '0';
                reset_addsub <= '0';
                reset_main <= '0';
                
                start_set <= '1';
                start_addsub <= '0';
                start_main <= '0';
                
                din_dec2 <= time_out_addsub2; 
                disp_reg1 <= disp_reg_set1;
                disp_reg2 <= disp_reg_set2;
                
                
            when S2 =>
                reset_set <= '0';
                reset_addsub <= '0';
                reset_main <= '0';
                
                start_set <= '0';
                start_addsub <= '0';
                start_main <= '0';
                
                din_dec2 <= time_out_addsub2; 
                disp_reg1 <= disp_reg_addsub1;
                disp_reg2 <= dout_dec2;
            
            when S3 =>
                reset_set <= '0';
                reset_addsub <= '0';
                reset_main <= '0';
                
                start_set <= '0';
                start_addsub <= '1';
                start_main <= '0';
                
                din_dec2 <= time_out_addsub2; 
                disp_reg1 <= disp_reg_addsub1;
                disp_reg2 <= dout_dec2;
            when S4 =>
                reset_set <= '0';
                reset_addsub <= '0';
                reset_main <= '0';
                
                start_set <= '0';
                start_addsub <= '0';
                start_main <= '0';
                
                din_dec2 <= time_out_main2; 
                disp_reg1 <= dout_dec1;
                disp_reg2 <= dout_dec2;
            when S5 =>
                reset_set <= '0';
                reset_addsub <= '0';
                reset_main <= '0';
                
                start_set <= '0';
                start_addsub <= '0';
                start_main <= '1';
                
                din_dec2 <= time_out_main2; 
                disp_reg1 <= dout_dec1;
                disp_reg2 <= dout_dec2;
                
            when others =>
                reset_set <= '0';
                reset_addsub <= '0';
                reset_main <= '0';
                
                start_set <= '0';
                start_addsub <= '0';
                start_main <= '0';
                
                din_dec2 <= time_out_addsub2; 
                disp_reg1 <= (dE, dR, dR, dGuion);
                disp_reg2 <= (dE, dR, dR, dGuion);
        end case;
    end process;
    
    din_dec1 <= time_out_main1;
    
end Behavioral;
