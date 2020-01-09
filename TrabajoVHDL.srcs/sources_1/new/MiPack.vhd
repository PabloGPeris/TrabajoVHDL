library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package MiPack is

    --------------------
    --tipos y subtipos--
    --------------------
    type disp_reg_t is array(3 downto 0) of std_logic_vector(7 downto 0); --array de registros de contador 7 segmentos
    subtype integer10 is natural range 0 to 9; -- enteros del 0 al 9
    type tiempo_t is array(4 downto 0) of integer10; --tiempo formado por 5 números del 1 al 10
    --(decenas de minutos, minutos, decenas de segundos [del 0 al 5], segundos y décima de segundo.
    type gamemode_t is (Normal, Inc); --modo de juego
    
    
    -------------
    --funciones--
    -------------
    
    function isgreater(din1, din2: tiempo_t) return std_logic;
    function isgreatereq(din1, din2: tiempo_t) return std_logic;
    
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
           load_v : in tiempo_t;

           time_out : out tiempo_t;--estados de salida
           rdy_out : out STD_LOGIC);
    end component;
    
    
    component FSM_Main is
    Port ( reset : in STD_LOGIC;
           start : in STD_LOGIC;
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk1k : in STD_LOGIC;
           clk10 : in STD_LOGIC;
           initial_v : in tiempo_t;
           
           disp_state1 : out tiempo_t;
           disp_state2 : out tiempo_t;
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
        state: in tiempo_t;
  
        reg_out: out disp_reg_t 
    );
    end component;
    
    component adder_integer10 is
    Generic(
        module: natural:= 10
    );
    Port ( 
        din1 : in integer10; --sumando1
        din2 : in integer10; --sumando2
        cin : in std_logic; --acarreo de entrada
    
        dout : out integer10; --resultado
        cout : out std_logic --acarreo de salida
    );
    end component;
    
    component adder_time is
    Port ( 
        din1: in tiempo_t;
        din2: in tiempo_t;
        
        dout: out tiempo_t;
        complement: in std_logic
    );
    end component;
    
    component substracter_time is
    Port ( 
        din1: in tiempo_t;
        din2: in tiempo_t;
        
        dout: out tiempo_t 
        );
    end component;
end MiPack;



package body mipack is
    function isgreater(din1, din2: tiempo_t) return std_logic is
    begin
    ff: for i in 4 downto 0 loop
        if din1(i) > din2(i) then
            return '1';
        elsif din1(i) < din2(i) then
            return '0';
        end if;
    end loop;
    
    return '0';
    end;
    
    function isgreatereq(din1, din2: tiempo_t) return std_logic is
    begin
    ff: for i in 4 downto 0 loop
        if din1(i) > din2(i) then
            return '1';
        elsif din1(i) < din2(i) then
            return '0';
        end if;
    end loop;
    
    return '1';
    end;
end package body;
