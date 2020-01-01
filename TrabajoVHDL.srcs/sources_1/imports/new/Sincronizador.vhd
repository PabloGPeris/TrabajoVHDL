library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
 
entity sincronizador is   
Port (  
    sync_in: IN STD_LOGIC;     
    clk: IN STD_LOGIC;     
    sync_out: OUT STD_LOGIC 
  ); 
end sincronizador; 
 
architecture Behavioral of sincronizador is 
 
    constant SYNC_STAGES : integer := 3; 
    constant PIPELINE_STAGES : integer := 1; 
    constant INIT : std_logic := '0'; 
 
    signal sreg : std_logic_vector(SYNC_STAGES-1 downto 0) := (others => INIT); 
    attribute async_reg : string; 
    attribute async_reg of sreg : signal is "true"; 
 
    signal sreg_pipe : std_logic_vector(PIPELINE_STAGES-1 downto 0) := (others => INIT); 
    attribute shreg_extract : string; 
    attribute shreg_extract of sreg_pipe : signal is "false"; 
    
begin 
 
   process(clk)    
   begin 
        if(clk'event and clk='1')then 
            sreg <= sreg(SYNC_STAGES-2 downto 0) & sync_in;       
        end if;    
   end process; 
 
   no_pipeline : if PIPELINE_STAGES = 0 generate    
   begin       
        sync_out <= sreg(SYNC_STAGES-1);    
   end generate; 
 
   one_pipeline : if PIPELINE_STAGES = 1 generate    
   begin     
        process(clk)     
        begin 
            if(clk'event and clk='1') then         
                sync_out <= sreg(SYNC_STAGES-1);       
            end if;     
        end process;    
   end generate; 
 
   multiple_pipeline : if PIPELINE_STAGES > 1 generate    
   begin     
        process(clk)     
        begin 
            if(clk'event and clk='1') then 
                sreg_pipe <= sreg_pipe(PIPELINE_STAGES-2 downto 0) & sreg(SYNC_STAGES-1);       
            end if;     
        end process;
        
        sync_out <= sreg_pipe(PIPELINE_STAGES-1);    
   end generate; 
end Behavioral;