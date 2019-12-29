library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;

entity Dec_cntr is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ce_n : in STD_LOGIC; --clk enable
           rdy : out STD_LOGIC); --ready
end Dec_cntr;

architecture Behavioral of Dec_cntr is
    signal state: integer10:= 0;
    signal next_state: integer10;
begin
    state_reg: process(clk, reset)
    begin
        if reset = '1' then
            state <= 0;
        elsif rising_edge(clk) and ce_n = '0' then
            state <= next_state;
        end if;
    end process;

    nxt_state: process(state)
    begin
        next_state <= state;
        if state = 0 then
            next_state <= 9;
        else
            next_state <= state - 1;
        end if;
    end process;

    --output
    rdy <= '1' when state = 0 else
            '0';
    
end Behavioral;
