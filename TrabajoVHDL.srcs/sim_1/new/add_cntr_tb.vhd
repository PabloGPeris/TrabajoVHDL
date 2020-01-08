----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2020 23:55:18
-- Design Name: 
-- Module Name: add_cntr_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mipack.all;

entity add_cntr_tb is
--  Port ( );
end add_cntr_tb;

architecture Behavioral of add_cntr_tb is
    signal din1, din2: cntr_state_t;
    signal dout: cntr_state_t;
begin
    uut: adder_cntr
    Port map( 
        din1 => din1,
        din2 => din2,
        
        dout => dout
    );
    
    
    din1 <= (1, 2, 3, 4, 5), (0, 2, 4, 8, 8) after 30 sec;
    din2 <= (5, 9, 1, 7, 6), (1, 9, 1, 4, 0) after 60 sec;

end Behavioral;
