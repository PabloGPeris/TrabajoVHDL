library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mipack.all;

entity adder_time_tb is
--  Port ( );
end adder_time_tb;

architecture Behavioral of adder_time_tb is
    signal din1, din2: tiempo_t;
    signal dout_suma, dout_resta: tiempo_t;
    signal greater, smallereq: std_logic;
begin
    uut: adder_time
    Port map( 
        din1 => din1,
        din2 => din2,
        
        dout => dout_suma,
        complement => '0'
    );
    
    uut2: substracter_time
    Port map( 
        din1 => din1,
        din2 => din2,
        
        dout => dout_resta
    );
    
    
    din1 <= (5, 9, 1, 7, 6), (1, 9, 1, 4, 0) after 30 sec, (0, 2, 4, 8, 8) after 70 sec;
    din2 <= (1, 2, 3, 4, 5), (0, 2, 4, 8, 8) after 60 sec;
    

    
    greater <= isgreater(din1, din2);
    smallereq <= isgreatereq(din2, din1);
    
end Behavioral;
