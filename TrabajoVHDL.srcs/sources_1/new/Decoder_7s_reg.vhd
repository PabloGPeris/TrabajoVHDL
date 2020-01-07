library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;

entity Decoder_7s_reg is
  Port (
        state: in cntr_state_t;
  
        reg_out: out disp_reg_t 
    );
end Decoder_7s_reg;

architecture structural of Decoder_7s_reg is
    signal dot: std_logic_vector(3 downto 0) := "1011"; --recordar la lógica negada
begin
    generator:
    for i in 1 to 4 generate
        decn: Decoder_7s
        Port map(
            num_in => state(i),
            dot => dot(i - 1),
        
            led_out => reg_out(i - 1)
     );
        
    
    end generate;
    

end structural;
