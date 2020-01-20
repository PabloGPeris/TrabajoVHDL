library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mipack.all;

entity Input_edge_generator is
    Port ( ok : in STD_LOGIC;
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk : in STD_LOGIC;
           
           ok_re : out STD_LOGIC;
           button1_re : out STD_LOGIC;
           button2_re : out STD_LOGIC);
end Input_edge_generator;

architecture Behavioral of Input_edge_generator is

begin
    okreg: Edge_generator 
    Port map( 
            input => ok,
            clk => clk,
            output => ok_re
    );

    okb1: Edge_generator 
    Port map( 
            input => button1,
            clk => clk,
            output => button1_re
    );

    okb2: Edge_generator 
    Port map( 
            input => button2,
            clk => clk,
            output => button2_re
    );
    
end Behavioral;
