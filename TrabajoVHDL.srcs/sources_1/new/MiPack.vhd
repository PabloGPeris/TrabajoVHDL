library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package MiPack is

    --------------------
    --tipos y subtipos--
    --------------------
    type disp_reg is array(7 downto 0) of std_logic_vector(7 downto 0);
    subtype integer10 is natural range 0 to 9;
    subtype integer6 is natural range 0 to 5;
    type cntr_state is array(4 downto 0) of integer10;
    
    ---------------
    --componentes--
    ---------------
    
    component Dec_cntr is --contador-temporizador de décimas de segundo
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ce_n : in STD_LOGIC; --clk enable
           rdy : out STD_LOGIC); --ready
    end component;
    
    
    component generic_cntr is
    Generic (
        state_num : positive
    );
    Port ( clk : in STD_LOGIC;
           ce_n : in STD_LOGIC;--clk enable
           load : in STD_LOGIC;--preset
           load_v : in integer10; --valores que se cargan al hacer el load
           rdy_nxt_cntr : in std_logic;
           state_out : out integer10;--estado interno, pero de salida (para que se pueda
           rdy : out STD_LOGIC);
    end component;
    
    component big_cntr is
    Port ( clk : in STD_LOGIC;
           ce_n : in STD_LOGIC;--clk enable
           load: in STD_LOGIC;
           load_v : in cntr_state;

           state_out : out cntr_state;--estados de salida
           rdy_out : out STD_LOGIC);
    end component;
    
end MiPack;


