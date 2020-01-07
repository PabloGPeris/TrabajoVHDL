library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package MiPack is

    --------------------
    --tipos y subtipos--
    --------------------
    type disp_reg_t is array(3 downto 0) of std_logic_vector(7 downto 0);
    subtype integer10 is natural range 0 to 9;
    type cntr_state_t is array(4 downto 0) of integer10;
    
    
    ---------------
    --componentes--
    ---------------
    

    component generic_cntr is --contador genérico para los temporizadores
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
    --contador gigante formado por 5 contadores; de décimas de segundo (0), 
    --de segundos (1), de decenas de segundo (2), de minutos (3) y de 
    --decenas de minutos (4)
    Port ( clk : in STD_LOGIC;
           ce_n : in STD_LOGIC;--clk enable
           load: in STD_LOGIC;
           load_v : in cntr_state_t;

           state_out : out cntr_state_t;--estados de salida
           rdy_out : out STD_LOGIC);
    end component;
    
    
    component FSM_Main is
    Port ( reset : in STD_LOGIC;
           start : in STD_LOGIC;
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk : in STD_LOGIC;
           clk10 : in STD_LOGIC;
           initial_v : in cntr_state_t;
           
           disp_state1 : out cntr_state_t;
           disp_state2 : out cntr_state_t;
           fin : out std_logic
           );
    end component;
    
    
    component Decoder_7s is
    Port (
        num_in: in integer10;
        dot: in std_logic;
        
        led_out : out std_logic_vector(7 downto 0)
     );
    end component;
    
    component Decoder_7s_reg is
    Port (
        state: in cntr_state_t;
  
        reg_out: out disp_reg_t 
    );
    end component;
end MiPack;


