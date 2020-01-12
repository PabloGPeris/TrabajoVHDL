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
    type gamemode_t is (Sin, Inc); --modo de juego
    
    
    
    --------------
    --constantes--
    --------------
    --las constantes dx representan los segmentos que se iluminarían para formar la letra o número
    constant d0: std_logic_vector(6 downto 0 ):= "0000001";
    constant d1: std_logic_vector(6 downto 0 ):= "1001111";
    constant d2: std_logic_vector(6 downto 0 ):= "0010010";
    constant d3: std_logic_vector(6 downto 0 ):= "0000110";
    constant d4: std_logic_vector(6 downto 0 ):= "1001100";
    constant d5: std_logic_vector(6 downto 0 ):= "0100100";
    constant d6: std_logic_vector(6 downto 0 ):= "0100000";
    constant d7: std_logic_vector(6 downto 0 ):= "0001111";
    constant d8: std_logic_vector(6 downto 0 ):= "0000000";
    constant d9: std_logic_vector(6 downto 0 ):= "0001100";
    constant dguion: std_logic_vector(7 downto 0):= "11111101";
    constant dA: std_logic_vector(7 downto 0):= "00010001";
    constant dC: std_logic_vector(7 downto 0):= "01100011";
    constant dD: std_logic_vector(7 downto 0):= "10000101";
    constant dE: std_logic_vector(7 downto 0):= "01100001";
    constant dI: std_logic_vector(7 downto 0):= "11110011";
    constant dL: std_logic_vector(7 downto 0):= "11100011";
    constant dN: std_logic_vector(7 downto 0):= "11010101";
    constant dO: std_logic_vector(7 downto 0):= "11000101";
    constant dP: std_logic_vector(7 downto 0):= "00110001";
    constant dR: std_logic_vector(7 downto 0):= "11110101";
    constant dS: std_logic_vector(7 downto 0):= d5 & "1";
    constant dT: std_logic_vector(7 downto 0):= "01110011";
    constant dY: std_logic_vector(7 downto 0):= "10110001";
    
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
    
--    component FSM_Set is
--    port(
--           reset : in STD_LOGIC;
--           start : in std_logic;
--           ok : in std_logic;
--           button1 : in STD_LOGIC;
--           button2 : in STD_LOGIC;
--           clk10 : in std_logic;
           
--           disp_reg_1: out disp_reg_t;
--           disp_reg_2: out disp_reg_t;
--           initial_v : out tiempo_t;
--           increment : out tiempo_t;
--           gamemode : out gamemode_t;
--           fin : out std_logic
--      );
--    end component;
    
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
        complement: in std_logic:= '0'
    );
    end component;
    
    component substracter_time is
    Port ( 
        din1: in tiempo_t;
        din2: in tiempo_t;
        
        dout: out tiempo_t 
        );
    end component;
    
    component Adder_Subs_Sync is
    port(
           reset: in std_logic;
           ce: in std_logic; --clock enable (poner a 1 para sumar y restar)
           suma: in std_logic;
           din1: in tiempo_t;
           din2: in tiempo_t;
           clk : in std_logic;
           
           dout: out tiempo_t
      );
    end component;
    
    component FSM_AddSub is
    port(
           start : in std_logic;--señal de inicio
           
           reset : in STD_LOGIC;--botón reset
           ok : in std_logic;--botón ok
           button1 : in STD_LOGIC;--botón 1 (decremento)
           button2 : in STD_LOGIC;--botón 2 (incremento)
           gamemode : in gamemode_t;
           clk10 : in std_logic;
           clk1k: in std_logic;
           
           disp_reg: out disp_reg_t;--letras que se van a mostrar en pantalla
           time_out: out tiempo_t;--tiempo que se va a mostrar en pantalla
           initial_v : out tiempo_t;
           increment : out tiempo_t;

           fin : out std_logic
      );
      
      
    end component;
    
end MiPack;



package body MiPack is
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