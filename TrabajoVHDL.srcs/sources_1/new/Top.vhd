library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mipack.all;


entity Top is
    Port ( 
        clk100M: in std_logic;
        reset : in STD_LOGIC;
        ok : in std_logic;
        button1 : in STD_LOGIC;
        button2 : in STD_LOGIC;
        
        
        led: out std_logic_vector(7 downto 0); --leds que se encienden del display 7 segmentos
        digctrl: out std_logic_vector(7 downto 0)--7 segmentos que se enciende
    );
end Top;

architecture structural of Top is
    
    signal clk10, clk1k: std_logic;
    signal button1_re, button2_re, ok_re: std_logic; --re = rising_edge
    signal disp_reg1, disp_reg2: disp_reg_t;
    

begin

    dcmtop: DCM
    Port map ( 
        clk100M => clk100M,
        reset => reset,
        clk1k => clk1k,
        clk10 => clk10
    );


    ieg: Input_edge_generator
    Port map( 
            ok => ok,
            button1 => button1,
            button2 => button2,
            clk => clk1k,
           
            ok_re => ok_re,
            button1_re => button1_re,
            button2_re => button2_re
    );




    fsmtop: FSM_Big
    Port map(
           reset => reset,


           ok_re  => ok_re,
           button1_re  => button1_re,
           button2_re  => button2_re,
           button1  => button1,
           button2  => button2,
           clk10 => clk10,
           clk1k => clk1k,
           
           disp_reg1 => disp_reg1,
           disp_reg2 => disp_reg2
    );

    muxtop: Mux_7s
    Port map(
        clk => clk1k,
        reg1 => disp_reg1,
        reg2 => disp_reg2,
    
        led => led,
        digctrl => digctrl
    );


end structural;
