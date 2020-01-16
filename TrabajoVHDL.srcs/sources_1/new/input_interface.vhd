library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_interface is
    Port (
        button1_in: in std_logic;
        button2_in: in std_logic;
        ok_in: in std_logic;
        reset: in std_logic;
        clk1k: in std_logic;
        
        button1_out: out std_logic;
        button2_out: out std_logic;
        ok_out: out std_logic

    );
end input_interface;

architecture Behavioral of input_interface is

    component sincronizador is   
    Port (  
        sync_in: IN STD_LOGIC;     
        clk: IN STD_LOGIC;     
        sync_out: OUT STD_LOGIC 
    ); 
    end component; 
    
    component debouncer IS     
    port ( 
        clk  	: in std_logic;
        rst  	: in std_logic;
        btn_in 	: in std_logic; 
 	    btn_out 	: out std_logic); 
    END component; 
    
    signal button1_interno, button2_interno, ok_interno: std_logic;
begin

    s1: sincronizador 
    Port map(  
        sync_in => button1_in,  
        clk => clk1k,    
        sync_out => button1_interno
    ); 
    
    s2: sincronizador 
    Port map(  
        sync_in => button2_in,  
        clk => clk1k,    
        sync_out => button2_interno
    ); 
    
    sok: sincronizador 
    Port map(  
        sync_in => ok_in,  
        clk => clk1k,    
        sync_out => ok_interno
    ); 
    
    d1: debouncer    
    port map( 
        clk  	=> clk1k,
        rst  	=> reset,
        btn_in 	=> button1_interno,
 	    btn_out 	=> button1_out
 	);
 	    
    d2: debouncer    
    port map( 
        clk  	=> clk1k,
        rst  	=> reset,
        btn_in 	=> button2_interno,
 	    btn_out 	=> button2_out
 	);
    
    dok: debouncer    
    port map( 
        clk  	=> clk1k,
        rst  	=> reset,
        btn_in 	=> ok_interno,
 	    btn_out 	=> ok_out
 	);

end Behavioral;
