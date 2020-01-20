library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MiPack.all;

entity adder_time is
    Port ( 
        din1: in tiempo_t;
        din2: in tiempo_t;
        
        dout: out tiempo_t;
        ov: out std_logic;
        complement: in std_logic:= '0' --poner a 1 para que haga el complemento a 10 (¿?)
    );
end adder_time;

architecture structural of adder_time is
    signal cin: std_logic_vector(5 downto 0);
begin
    cin(0) <= complement;
    ov <= complement xor cin(5);
    
    add_generate: 
    for i in 0 to 4 generate
    ff2:
        if i = 2 generate
    addn: adder_integer10
        Generic map(
            module => 6
        )
        Port map( 
        din1 => din1(i),
        din2 => din2(i),
        cin => cin(i),
    
        dout => dout(i),
        cout => cin(i + 1)
        );
        end generate ff2;
    ffn:
    if i /= 2 generate 
        addn: adder_integer10
        Generic map(
            module => 10
        )
        Port map( 
        din1 => din1(i),
        din2 => din2(i),
        cin => cin(i),
    
        dout => dout(i),
        cout => cin(i + 1)
        );
    end generate ffn;
    end generate add_generate;

end structural;