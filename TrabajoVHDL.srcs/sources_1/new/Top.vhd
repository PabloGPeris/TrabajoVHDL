library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.paco.all;


entity Top is
    Port ( 
        clk1M: in std_logic;
        reset : in STD_LOGIC;
        ok : in std_logic;
        button1 : in STD_LOGIC;
        button2 : in STD_LOGIC;
        
        
        led: out std_logic_vector(7 downto 0); --leds que se encienden del display 7 segmentos
        digctrl: out std_logic_vector(7 downto 0)--7 segmentos que se enciende
    );
end Top;

architecture Behavioral of Top is
    
    component DCM is
    Port ( clk1M : in STD_LOGIC;
           reset: in std_logic;
           clk1k : out STD_LOGIC;
           clk10 : out STD_LOGIC);
    end component;
    
    component input_interface is
    Port (
        button1_in: in std_logic;
        button2_in: in std_logic;
        ok_in: in std_logic;
        reset: in std_logic;
        clk1k: in std_logic;
        
        button1_out: out std_logic;
        button2_out: out std_logic;
        ok_out: out std_logic

    );
    end component;
    
    
    component FSM_Big is
    Port (
           reset : in STD_LOGIC;
           ok : in std_logic;
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk10 : in std_logic;
           clk1k: in std_logic;
           
           disp_reg1: out disp_reg_t;
           disp_reg2: out disp_reg_t;
           state_out: out state_t
    );
    end component;
    
    component Mux_7s is
    Port (
        clk: in std_logic; --reloj
        reg1: in disp_reg_t; --registro de 4 std_logic_vector(7 downto 0) de muestra
        reg2: in disp_reg_t;
    
        led: out std_logic_vector(7 downto 0); --leds que se encienden del display 7 segmentos
        digctrl: out std_logic_vector(7 downto 0) --7 segmentos que se enciende
    );
    end component;
    
    signal clk10, clk1k: std_logic;
    signal button1_sync, button2_sync, ok_sync: std_logic;
    signal disp_reg1, disp_reg2: disp_reg_t;
    signal state: state_t;
begin

    dcmtop: DCM
    Port map ( 
        clk1M => clk1M,
        reset => reset,
        clk1k => clk1k,
        clk10 => clk10
    );

    iitop: input_interface
    Port map(
        button1_in => button1,
        button2_in => button2,
        ok_in => ok,
        reset => reset,
        clk1k =>clk1k,
        
        button1_out => button1_sync,
        button2_out => button2_sync,
        ok_out => ok_sync

    );

    fsmtop: FSM_Big
    Port map(
           reset => reset,
           ok => ok_sync,
           button1 => button1_sync,
           button2 => button2_sync,
           clk10 => clk10,
           clk1k => clk1k,
           
           disp_reg1 => disp_reg1,
           disp_reg2 => disp_reg2,
           state_out => state
    );

    muxtop: Mux_7s
    Port map(
        clk => clk1k,
        reg1 => disp_reg1,
        reg2 => disp_reg2,
    
        led => led,
        digctrl => digctrl
    );


end Behavioral;
