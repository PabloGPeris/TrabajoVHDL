library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MiPack.all;


entity FSM_Main is
    Port ( reset : in STD_LOGIC;
           start : in std_logic;
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk1k : in STD_LOGIC;
           clk10 : in std_logic;
           initial_v : in cntr_state_t;
           
           disp_state1 : out cntr_state_t;
           disp_state2 : out cntr_state_t;
           
           fin : out std_logic
           );---------
end FSM_Main;

architecture Behavioral of FSM_Main is
    
    type state_t is (S0, S1, S10, S20, S3); -- FSM

    
    signal state: state_t;
    signal nxt_state: state_t;
    
    signal ce_n1, ce_n2: std_logic;
    signal load1, load2: std_logic;
    signal load_v1, load_v2: cntr_state_t;
    signal state_out1, state_out2: cntr_state_t;
    signal rdy1, rdy2: std_logic;
begin
    bc1: big_cntr
    Port Map(
        clk => clk10,
        ce_n => ce_n1,
        load => load1,
        load_v => load_v1,
        
        state_out => state_out1,
        rdy_out => rdy1
    
    );
    
    bc2: big_cntr
    Port Map(
        clk => clk10,
        ce_n => ce_n2,
        load => load2,
        load_v => load_v2,
        
        state_out => state_out2,
        rdy_out => rdy2
    
    );
    
	state_reg: process (reset, clk1k)
    begin
    	if reset = '1'
        	then state <= S0;
        elsif rising_edge(clk1k) then
        	state <= nxt_state;
        end if;
    end process;
    
    nxt_dec: process (state, start, button1, button2, rdy1, rdy2)
    begin
    	nxt_state <= state; --evitar latch
        case state is
        	when S0 =>
        	    if start = '1' then
        	       nxt_state <= S1;
        	    end if;

                
            when S1 =>
            	if button2 = '1' then
                    nxt_state <= S10;
                elsif button1 = '1' then
                    nxt_state <= S20;
                end if;
                
            when S10 =>
                if rdy1 = '1' then
                    nxt_state <= S3;
            	elsif button1 = '1' then
                	nxt_state <= S20;
                end if;
                
            when S20 => 
                if rdy2 = '1' then
                    nxt_state <= S3;
            	elsif button2 = '1' then
                	nxt_state <= S10;
                	
                end if;

            
            when S3 =>
                nxt_state <= S3;
                
            when others =>
            	nxt_state <= S0;
        end case;
    end process;
    
    out_dec: process(state) --Cambiarlo por with-select si se cree conveniente
    begin
    case state is
        	when S0 =>
                fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                load1 <= '0';
                load2 <= '0';
                
            when S1=>
            	fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                load1 <= '1';
                load2 <= '1';
                
                load_v1 <= initial_v;
                load_v2 <= initial_v;
                
            when S10 =>
            	fin <= '0';
                ce_n1 <= '0';
                ce_n2 <= '1';
                load1 <= '0';
                load2 <= '0';
                
                
            when S20 =>
                fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '0';
                load1 <= '0';
                load2 <= '0';
            
            when S3 =>
                fin <= '1';
                ce_n1 <= '1';
                ce_n2 <= '1';
                load1 <= '0';
                load2 <= '0';
                
            when others =>
                fin <= '0';
                ce_n1 <= '1';
                ce_n2 <= '1';
                load1 <= '0';
                load2 <= '0';
        end case;
    end process;


    disp_state1 <= state_out1;
    disp_state2 <= state_out2;
    
end Behavioral;
