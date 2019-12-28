library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package MiPack is

    type disp_reg is array(7 downto 0) of std_logic_vector(7 downto 0); 
    
    component Mux_7s is --CONTROL DE LOS LEDS 7 SEGMENTOS
    Port (
        clk: in std_logic; --reloj
        reg: in disp_reg; --registro de 8 std_logic_vector(7 downto 0) de muestra
    
        led: out std_logic_vector(7 downto 0); --leds que se encienden del display 7 segmentos
        digctrl: out std_logic_vector(7 downto 0) --7 segmentos que se enciende
    );
    end component;
    component clk_divider is--DIVISOR DE FRECUENCIAS DE RELOJ
    generic(
        smodule : positive
    );
    Port ( 
        clk_in : in std_logic;
        reset : in std_logic;
        clk_out : out std_logic
    );
    end component;

    
    
end package;