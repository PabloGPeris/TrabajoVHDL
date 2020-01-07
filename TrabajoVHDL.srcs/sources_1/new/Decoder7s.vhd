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
    led_interno <= "0000001" when 0,
                   "1001111" when 1,
                   "0010010" when 2,
                   "0000110" when 3,
                   "1001100" when 4,
                   "0100100" when 5,
                   "0100000" when 6,
                   "0001111" when 7,
                   "0000000" when 8,
                   "0001100" when 9,
                   "1111110" when others;
    
    led_out <= led_interno & dot;

    
end dataflow;
