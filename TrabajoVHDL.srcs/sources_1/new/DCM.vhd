library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DCM is
    Port ( clk100M : in STD_LOGIC;
           reset: in std_logic;
           clk1k : out STD_LOGIC;
           clk10 : out STD_LOGIC);
end DCM;

architecture Structural of DCM is

    component clk_divider is
    generic(
        smodule : positive
    );
    Port ( 
        clk_in : in std_logic;
        reset : in std_logic;
        clk_out : out std_logic
    );
    end component;
    
    signal clk1k_interno : std_logic;
begin
    cl1k: clk_divider 
    generic map(
        smodule => 50000
    )
    Port map ( 
        clk_in => clk100M,
        reset => reset,
        clk_out => clk1k_interno
    );
    
    cl10: clk_divider 
    generic map(
        smodule => 50
    )
    Port map ( 
        clk_in => clk1k_interno,
        reset => reset,
        clk_out => clk10
    );

    clk1k <= clk1k_interno;
end Structural;
