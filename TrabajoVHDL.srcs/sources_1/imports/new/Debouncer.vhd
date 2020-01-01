library ieee; use ieee.std_logic_1164.all; use ieee.std_logic_unsigned.all; 
 
ENTITY debouncer IS     
port ( 
        clk  	: in std_logic;
        rst  	: in std_logic;
        btn_in 	: in std_logic; 
 	    btn_out 	: out std_logic); 
END debouncer; 
 
ARCHITECTURE behavioral OF debouncer IS     
signal Q1, Q2, Q3 : std_logic;  
BEGIN 
    process(clk)     
    begin 
        if (clk'event and clk = '1') then 
            if (rst = '0') then 
                Q1 <= '0'; 
                Q2 <= '0';                 
                Q3 <= '0';             
            else 
                Q1 <= btn_in; 
                Q2 <= Q1;                 
                Q3 <= Q2;             
            end if;         
        end if;    
    end process; 
 
    btn_out <= Q1 and Q2 and (not Q3); 
 
END behavioral; 

