library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.MiPack.all;


entity Adder_Subs_Sync is
    port(
           reset: in std_logic;
           ce: in std_logic; --clock enable (poner a 1 para sumar y restar)
           suma: in std_logic;
           din1: in tiempo_t;
           din2: in tiempo_t;
           clk : in std_logic;
           
           dout: out tiempo_t
      );
end Adder_Subs_Sync;

architecture Behavioral of Adder_Subs_Sync is

    --cosas de sumadores y restadores
    signal dout_adder, dout_sub : tiempo_t;
    
    
    component adder_time is
    --sumador de tiempo_t. No indica desbordamiento
    Port ( 
        din1: in tiempo_t;
        din2: in tiempo_t;
        
        dout: out tiempo_t;
        complement: in std_logic:= '0' --poner a 1 para indicar que el
        --primer carry out es 1, necesario si el sin2 es complemento (a 9)
        --para poder hacer la resta
    );
    end component;
    
begin


    adder: adder_time
    port map(
        din1 => din1,
        din2 => din2,
        
        dout => dout_adder
    
    );
    
    subs: substracter_time
    port map(
        din1 => din1,
        din2 => din2,
        
        dout => dout_sub
    );




    resta_suma: process (clk, reset)
    begin
        if reset = '1' then
            dout <= din1;
        elsif rising_edge(clk) then
        	if ce = '1' then
        	   if suma = '1' and isgreater(dout_adder, din1) = '1' then --comprueba que no se sale de los márgenes
        	       dout <= dout_adder;
        	   elsif suma = '0' and isgreater(din1, dout_sub) = '1' then
        	       dout <= dout_sub;
        	   else 
        	       dout <= din1;
        	   end if;
        	end if;
        end if;
    end process;
    
    
end behavioral;
