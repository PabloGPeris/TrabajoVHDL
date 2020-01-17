library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Paco is

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
    
    --las constantes dx representan los segmentos que se iluminarían para
    --formar la letra o número deseado. Los números son solo 7 bits porque
    --incluyen la posibilidad de poner un punto
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
    

    component generic_cntr is 
    --contador genérico para los temporizadores, que puede contar hasta 10
    --o menos
    Generic (
        state_num : positive:= 10
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
    
    component Decoder_7s is
    --decodificador integer10 a 7 segmentos (marcar 2 para el punto)
    Port (
        num_in: in integer10;
        dot: in std_logic;
        
        led_out : out std_logic_vector(7 downto 0)
     );
    end component;
    
    component Decoder_7s_reg is
    --decodificador de tiempo_t a registro de display (disp_reg), que se
    --empleará para 4 siete segmentos
    Port (
        time_in: in tiempo_t;
  
        reg_out: out disp_reg_t 
    );
    end component;
    
    component adder_integer10 is
    --sumador de integer10 con acarreo de entrada y salida
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
    --sumador de tiempo_t. No indica desbordamiento
    Port ( 
        din1: in tiempo_t;
        din2: in tiempo_t;
        
        dout: out tiempo_t;
        complement: in std_logic:= '0' --poner a 1 para indicar que el
        --primer carry out es 1, necesario si el sin2 es complemento (a 9)
        --para poder hacer la resta
    );
    end component;
    
    component substracter_time is
    --restador de tiempo_t, pasando a complemento a 9 y luego 10. No indica
    --desbordamiento
    Port ( 
        din1: in tiempo_t;
        din2: in tiempo_t;
        
        dout: out tiempo_t 
        );
    end component;
    
    component Adder_Subs_Sync is
    --sumador y restador síncrono de din1 y din2. Evita el desbordamiento
    --haciendo una comparación
    port(
           reset: in std_logic;
           ce: in std_logic; --clock enable (poner a 1 para sumar y restar)
           suma: in std_logic; -- = '1', suma; = '0', resta
           din1: in tiempo_t;
           din2: in tiempo_t;
           clk : in std_logic;
           
           dout: out tiempo_t
      );
    end component;
    
    ----------------------------
    --máquinas de estado (FSM)--
    ----------------------------
    
    component FSM_Set is
    port(
           start : in std_logic;--señal de inicio
           
           reset : in STD_LOGIC;--botón de reset
           ok : in std_logic;--botón de ok
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk : in std_logic;--reloj (1 kHz)
           
           disp_reg_1: out disp_reg_t;--lo que muestra el primer cuarteto
           --de 7 segmentos
           disp_reg_2: out disp_reg_t;--lo que muestra el 2º cuarteto
           --de 7 segmentos
           gamemode : out gamemode_t;--modo de juego
           
           fin : out std_logic--señal de fin
      );   
    end component;
    
    component FSM_AddSub is
    --máquina de estados de suma y resta de tiempos
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
    
    component FSM_Main is
    Port ( 
           start : in STD_LOGIC;--señal de inicio
           
           reset : in STD_LOGIC; --botón reset
           button1 : in STD_LOGIC;--botón 1
           button2 : in STD_LOGIC;--botón 2
           ok : in std_logic;
           clk1k : in STD_LOGIC;--reloj de 1kHz (para la FSM)
           clk10 : in STD_LOGIC;--reloj de 10 Hz (para la temporización)
           initial_v : in tiempo_t; --tiempo inicial
           increment: in tiempo_t;
           gamemode : in gamemode_t;
                   
           time_out1 : out tiempo_t;--tiempo del jugador 1
           time_out2 : out tiempo_t;--tiempo del jugador 2
           
           fin : out std_logic--señal de fin
           );
    end component;
end Paco;



package body Paco is
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