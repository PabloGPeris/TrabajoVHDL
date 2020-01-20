library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Edge_generator is
    Port ( input : in STD_LOGIC;
           clk : in STD_LOGIC;
           output : out STD_LOGIC);
end Edge_generator;

architecture Behavioral of Edge_generator is
    signal previous_input: std_logic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            previous_input <= input;
        end if;
    end process;
    
    output <= input and not previous_input;

end Behavioral;
