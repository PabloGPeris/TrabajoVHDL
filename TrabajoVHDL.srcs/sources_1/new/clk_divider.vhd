library IEEE;

use IEEE.STD_LOGIC_1164.ALL;


entity clk_divider is
    generic(
        smodule : positive := 2
    );
    Port ( 
        clk_in : in std_logic;
        reset : in std_logic;
        clk_out : out std_logic
    );
end clk_divider;

architecture Behavioral of clk_divider is
    subtype m is integer range 0 to smodule - 1;
    
    signal clk_out_sig : std_logic := '0';
begin
    process (clk_in) 
        variable cnt : m := 0;
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                cnt:= 0;
            else
                cnt := (cnt + 1) mod smodule;
                if cnt = smodule - 1 then
                    clk_out_sig <= not clk_out_sig;
                end if;
            end if;
        end if;
    end process;
    
    clk_out <= clk_out_sig;
    
end Behavioral;
