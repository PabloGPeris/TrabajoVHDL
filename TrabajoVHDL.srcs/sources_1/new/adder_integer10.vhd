library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

 --sumador de integer 10;
use work.MiPack.all;

entity adder_integer10 is
  Generic(
    module: natural:= 10
  );
  
  Port ( 
    din1 : in integer10; --sumando1
    din2 : in integer10; --sumando2
    cin : in std_logic; --acarreo de entrada
    
    dout : out integer10; --resultado
    cout : out std_logic --acarreo de salida
   );
end adder_integer10;

architecture Behavioral of adder_integer10 is
    subtype integer20 is natural range 0 to 19;
    
    signal resultado_intermedio: integer20;
begin
    process(din1, din2, cin)
    begin
        if cin = '1' then
            resultado_intermedio <= din1 + din2 + 1 ;
        else
            resultado_intermedio <= din1 + din2;
        end if;
    end process;
    
    process(resultado_intermedio)
    begin
        if resultado_intermedio >= module then--10 o mayor, normalmente
            dout <= resultado_intermedio - module;
            cout <= '1';
        else
            dout <= resultado_intermedio;
            cout <= '0';
        end if;
    end process;

end Behavioral;
