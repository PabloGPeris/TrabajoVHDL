library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MiPack.all;


entity FSM_Main is
    Port ( 
        start : in STD_LOGIC;
        
        reset : in STD_LOGIC; --Por flanco, aunque no obligatorio
        button1 : in STD_LOGIC; --Por flanco, aunque no obligatorio 
        button2 : in STD_LOGIC; -- Por flanco, aunque no obligatorio
        ok : in std_logic;
        clk1k : in STD_LOGIC;
        clk10 : in std_logic;
        initial_v : in tiempo_t;
        increment: in tiempo_t;
        gamemode : in gamemode_t;
           
        time_out1: out tiempo_t;
        time_out2: out tiempo_t;
           
        fin : out std_logic
        );   
end FSM_Main;

architecture Behavioral of FSM_Main is
    
    type state_t is (S0, S1, S10, S20, S11, S21, S12, S22, S13, S23, S3, S4); -- FSM

    
    signal state: state_t;
    signal nxt_state: state_t;
    signal time_interno1, time_interno2: tiempo_t;
    
    --cosas de los temporizadores principales
    signal ce_n1, ce_n2: std_logic;
    signal load1, load2: std_logic;
    signal nxt_load1, nxt_load2: std_logic;
    signal load_v1, load_v2: tiempo_t;
    signal nxt_load_v1, nxt_load_v2: tiempo_t;
    signal rdy1, rdy2: std_logic;
    
    --cosas de incrementos
    --signal din_adder1: tiempo_t;
    signal dout_adder1, dout_adder2: tiempo_t;
    signal ov_adder1, ov_adder2, ov_adder1_n, ov_adder2_n: std_logic;
    
    
begin

    time_out1 <= time_interno1;
    time_out2 <= time_interno2;
    ov_adder1_n <= not ov_adder1;
    ov_adder2_n <= not ov_adder2;

    bc1: big_cntr
    Port Map(
        clk => clk10,
        ce_n => ce_n1,
        load => load1,
        load_v => load_v1,
        
        time_out => time_interno1,
        rdy_out => rdy1
    
    );
    
    bc2: big_cntr
    Port Map(
        clk => clk10,
        ce_n => ce_n2,
        load => load2,
        load_v => load_v2,
        
        time_out => time_interno2,
        rdy_out => rdy2
    
    );
    
    adder1: adder_time
    Port map( 
        din1 => time_interno1,
        din2 => increment,
        
        dout => dout_adder1,
        ov => ov_adder1,
        complement => '0'
    );
    
    adder2: adder_time
    Port map( 
        din1 => time_interno2,
        din2 => increment,
        
        dout => dout_adder2,
        ov => ov_adder2,
        complement => '0'
    );
    
	state_reg: process (reset, clk1k)
    begin
    	if reset = '1'
        	then state <= S0;
        elsif rising_edge(clk1k) then
        	state <= nxt_state;
        	load_v1 <= nxt_load_v1;
        	load_v2 <= nxt_load_v2;
        	load1 <= nxt_load1;
        	load2 <= nxt_load2;
        end if;
    end process;
    
    nxt_dec: process (state, start, button1, button2, rdy1, rdy2, ok)
    begin
    	nxt_state <= state; --evitar latch
        case state is
            --estados iniciales
        	when S0 =>
        	    if start = '1' then
        	       nxt_state <= S1;
        	    end if;

                
            when S1 =>
            	if button2 = '1' then
            	    if gamemode = Sin then
                        nxt_state <= S13;
                    else --inc
                        nxt_state <= S10;
                    end if;
                elsif button1 = '1' then
                    if gamemode = Sin then
                        nxt_state <= S23;
                    else --inc
                        nxt_state <= S20;
                    end if;
                end if;
                
            --estados cuando hay incremento (gamemode = Inc)
                
            when S10 =>
                nxt_state <= S11;
                
            when S20 =>
                nxt_state <= S21;            
                
            when S11 =>
                nxt_state <= S12;
                
            when S21 =>
                nxt_state <= S22;   
                
             when S12 =>
                nxt_state <= S13;
                
            when S22 =>
                nxt_state <= S23;       
            
            --estados generales comunes (cuenta atrás) 
            when S13 =>
            
                if rdy1 = '1' then
                    nxt_state <= S3;
            	elsif button1 = '1' then
                    if gamemode = Sin then
                        nxt_state <= S23;
                    else --inc
                        nxt_state <= S20;
                    end if;
                end if;
                
            when S23 => 
                if rdy2 = '1' then
                    nxt_state <= S3;
            	elsif button2 = '1' then
            	    if gamemode = Sin then
                        nxt_state <= S13;
                    else --inc
                        nxt_state <= S10;
                    end if;
                end if;
            
            --estados finales
            when S3 =>
            if OK = '1' then
                nxt_state <= S4;
            end if;
                
            when S4 =>
                nxt_state <= S4;   
                 
            when others =>
            	nxt_state <= S0;
        end case;
    end process;
    
    out_dec: process (state, load_v1, load_v2, clk1k, ok) 
    begin
    case state is
            --estados iniciales    
        	when S0 =>
                fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';
                
                nxt_load_v1 <= initial_v;
                nxt_load_v2 <= initial_v;
                
                --din_adder1 <= initial_v;
                
            when S1=>
            	fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '1';
                nxt_load2 <= '1';
                

                nxt_load_v1 <= initial_v;
                nxt_load_v2 <= initial_v;

                
                --din_adder1 <= initial_v;
                
            --estados cuando hay incremento (gamemode = Inc)            
            when S10 =>
            	fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= ov_adder1_n;
                nxt_load2 <= '0';
                

                nxt_load_v1 <= time_interno1;
                nxt_load_v2 <= time_interno2;

                
                --din_adder1 <= time_interno1;
                
            when S11 =>
            	fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';
                

                nxt_load_v1 <= dout_adder1;
                nxt_load_v2 <= time_interno2;

                
                --din_adder1 <= time_interno1;           
                
            when S12 =>
            	fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';
                

                nxt_load_v1 <= dout_adder1;
                nxt_load_v2 <= time_interno2;

                
                --din_adder1 <= time_interno1;
                
           when S20 =>
            	fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= ov_adder2_n;
                

                nxt_load_v1 <= time_interno1;
                nxt_load_v2 <= time_interno2;

                
                --din_adder1 <= time_interno2;
                
            when S21 =>
            	fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';

                

                nxt_load_v1 <= time_interno1;
                nxt_load_v2 <= dout_adder2;

                
                --din_adder1 <= time_interno2;          
                
            when S22 =>
            	fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';
                

                nxt_load_v1 <= time_interno1;
                nxt_load_v2 <= dout_adder2;

                
                --din_adder1 <= time_interno2;           
            
            --estados generales comunes (cuenta atrás)    
                             
            when S13 =>
            	fin <= '0';
                ce_n1 <= '0';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';
                
                nxt_load_v1 <= time_interno1;
                nxt_load_v2 <= time_interno2;   
                
                --din_adder1 <= time_interno2;
                          
            when S23 =>
                fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '0';
                nxt_load1 <= '0';
                nxt_load2 <= '0';
                
                nxt_load_v1 <= time_interno1;
                nxt_load_v2 <= time_interno2;
                  
                --din_adder1 <= time_interno1;   
                
            --estados finales                           
            when S3 =>
                fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';

                nxt_load_v1 <= load_v1;
                nxt_load_v2 <= load_v2;     
                
                --din_adder1 <= initial_v;
                
            when S4 =>
                fin <= '1';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';

                nxt_load_v1 <= load_v1;
                nxt_load_v2 <= load_v2;  
                
                --din_adder1 <= initial_v;    
                                      
            when others =>
                fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                nxt_load1 <= '0';
                nxt_load2 <= '0';

                nxt_load_v1 <= load_v1;
                nxt_load_v2 <= load_v2; 
                
                --din_adder1 <= initial_v;                               
        end case;
    end process;

    
end Behavioral;
