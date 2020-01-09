library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mipack.all;

entity substracter_time is
  Port ( 
        din1: in tiempo_t;
        din2: in tiempo_t;
        
        dout: out tiempo_t 
        );
end substracter_time;

architecture Behavioral of substracter_time is
    signal c9: tiempo_t; -- complemento a 9 (bueno, a 5 en el caso de las décimas de minuto) de din2
begin
    
    restador: adder_time
    Port map( 
        din1 => din1,
        din2 => c9,
        
        dout => dout,
        complement => '1'
    );

    c9(0) <= 9 - din2(0);
    c9(1) <= 9 - din2(1);
    c9(2) <= 5 - din2(2);
    c9(3) <= 9 - din2(3);
    c9(4) <= 9 - din2(4);

end Behavioral;
