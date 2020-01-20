library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.mipack.all;


entity Mux_7s is
Port (
    clk: in std_logic; --reloj
    reg1: in disp_reg_t; --registro de 4 std_logic_vector(7 downto 0) de muestra
    reg2: in disp_reg_t;
    
    led: out std_logic_vector(7 downto 0); --leds que se encienden del display 7 segmentos
    digctrl: out std_logic_vector(7 downto 0) --7 segmentos que se enciende
);
end Mux_7s;

architecture Behavioral of Mux_7s is
    subtype mux_t is integer range 0 to 7;
    
    signal mux_signal: mux_t := 0;
begin
        
    
    mux_signaled : process(clk)
    begin
        if rising_edge(clk) then
            mux_signal <= (mux_signal + 1) mod 8;  
        end if;
    end process;
    
    --multiplexación digctrl
    with mux_signal select
    digctrl <=  "11111110" when 0,
                "11111101" when 1,
                "11111011" when 2,
                "11110111" when 3,
                "11101111" when 4,
                "11011111" when 5,
                "10111111" when 6,
                "01111111" when others;
    
    --multiplexación led
    with mux_signal select
    led <=      reg2(0) when 0,
                reg2(1) when 1,
                reg2(2) when 2,
                reg2(3) when 3,
                reg1(0) when 4,
                reg1(1) when 5,
                reg1(2) when 6,
                reg1(3) when others;

    --digctrl <= reg(mux_signal);

end Behavioral;
