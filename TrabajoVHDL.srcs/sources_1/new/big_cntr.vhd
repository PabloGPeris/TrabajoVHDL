library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MiPack.all;

entity big_cntr is
    Port ( clk : in STD_LOGIC;
           ce_n : in STD_LOGIC;--clk enable
           load: in STD_LOGIC;
           load_v : in cntr_state_t;
           
           state_out : out cntr_state_t;--estados de salida
           rdy_out : out STD_LOGIC);
end big_cntr;

architecture Behavioral of big_cntr is
    signal rdy: std_logic_vector(4 downto 0);
begin
    cntr0: generic_cntr
    Generic map(state_num => 10)
    Port map( 
        clk => clk,
        ce_n => ce_n,
        load => load,
        load_v => load_v(0),
        rdy_nxt_cntr => '1',
        state_out => state_out(0),--estado interno, pero de salida (para que se pueda
        rdy => rdy(0)
    );
    
    cntr_generate: 
    for i in 1 to 4 generate
    cntr2_generate: 
        if i = 2 generate
        cntr2: generic_cntr
        Generic map(state_num => 6)
        Port map( 
            clk => clk,
            ce_n => ce_n,
            load => load,
            load_v => load_v(i), 
            rdy_nxt_cntr => rdy(i - 1),
            state_out => state_out(i),--estado interno, pero de salida (para que se pueda
            rdy => rdy(i)
        );
        end generate cntr2_generate; 
    cntrn_generate: 
        if i /= 2 generate
        cntrn: generic_cntr
            Generic map(state_num => 10)
            Port map( 
                clk => clk,
                ce_n => ce_n,
                load => load,
                load_v => load_v(i), 
                rdy_nxt_cntr => rdy(i - 1),
                state_out => state_out(i),--estado interno, pero de salida (para que se pueda
                rdy => rdy(i)
        );
        end generate cntrn_generate;
    end generate cntr_generate;
    
    
   
    rdy_out <= rdy(4);

end Behavioral;
