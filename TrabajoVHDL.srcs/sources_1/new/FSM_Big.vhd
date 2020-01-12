library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mipack.all;


entity FSM_Big is
  Port (
           reset : in STD_LOGIC;
           ok : in std_logic;
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           clk10 : in std_logic;
           clk1k: in std_logic;
           
           disp_reg_1: out disp_reg_t;
           disp_reg_2: out disp_reg_t
   );
end FSM_Big;

architecture Behavioral of FSM_Big is
    type state_t is (S0, S1, S2, S3);
begin


end Behavioral;
