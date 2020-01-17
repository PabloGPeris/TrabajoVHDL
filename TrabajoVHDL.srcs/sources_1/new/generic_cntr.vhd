library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Paco.all;



entity generic_cntr is
    Generic (
        state_num : positive:= 10 --
    );
    Port ( clk : in STD_LOGIC;
           ce_n : in STD_LOGIC;--clk enable
           load : in STD_LOGIC;--preset
           load_v : in integer10; --valores que se cargan al hacer el load
           rdy_nxt_cntr : in std_logic;
           state_out : out integer10;--estado interno, pero de salida (para que se pueda
           rdy : out STD_LOGIC);
end generic_cntr;

architecture Behavioral of generic_cntr is

    signal state: integer10:= 0;
    signal next_state: integer10;
    
begin
    state_reg: process(clk, load)
    begin
        if load = '1' then
                state <= load_v;
        elsif rising_edge(clk) and ce_n = '0' then
            state <= next_state;
        end if;
    end process;

    nxt_state: process(state, rdy_nxt_cntr)
    begin
        next_state <= state;
        if rdy_nxt_cntr = '1' then
            if state = 0 then
                next_state <= state_num - 1;
            else
                next_state <= state - 1;
            end if;
        end if;
    end process;

    --output
    state_out <= state;
    rdy <= '1' when state = 0 and rdy_nxt_cntr = '1' else
            '0';
end Behavioral;
