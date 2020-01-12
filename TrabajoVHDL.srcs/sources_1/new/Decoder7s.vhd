library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;

entity Decoder_7s is
    Port (
        num_in: in integer10;
        dot: in std_logic;
        
        led_out : out std_logic_vector(7 downto 0)
     );
end Decoder_7s;

architecture dataflow of Decoder_7s is
    signal led_interno: std_logic_vector(6 downto 0);
begin

    with num_in select
    led_interno <= d0 when 0,
                   d1 when 1,
                   d2 when 2,
                   d3 when 3,
                   d4 when 4,
                   d5 when 5,
                   d6 when 6,
                   d7 when 7,
                   d8 when 8,
                   d9 when 9,
                   d0 when others;
    
    led_out <= led_interno & dot;

    
end dataflow;
