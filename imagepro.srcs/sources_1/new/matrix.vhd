library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity matrix is
 Port ( 
    i_clk           : in std_logic;
    i_shif_in       : in std_logic_vector(7 downto 0);
    i_shift_valid   : in std_logic;
    o_shift_out     : out std_logic_vector(7 downto 0);
    o_tp0           : out std_logic_vector(7 downto 0); 
    o_tp1           : out std_logic_vector(7 downto 0); 
    o_tp2           : out std_logic_vector(7 downto 0); 
    o_tp3           : out std_logic_vector(7 downto 0)
 );
end matrix;

architecture Behavioral of matrix is


signal line0 : std_logic_vector(7 downto 0);
signal line1 : std_logic_vector(7 downto 0);
signal line2 : std_logic_vector(7 downto 0);
signal line3 : std_logic_vector(7 downto 0);

COMPONENT c_shift_ram_0                          
  PORT (                                         
    D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);         
    CLK : IN STD_LOGIC;                          
    CE : IN STD_LOGIC;                           
    Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)         
  );                                             
END COMPONENT;                                   

begin

shift_ram_0 : c_shift_ram_0        
  PORT MAP (                              
    D => i_shif_in,                               
    CLK => i_clk,                           
    CE => i_shift_valid,                             
    Q => o_tp3                                
  );                                      

--shift_ram_1 : c_shift_ram_0        
--  PORT MAP (                              
--    D => line3,                               
--    CLK => i_clk,                           
--    CE => i_shift_valid,                             
--    Q => o_tp3                                
--  );                                      


shift_ram_2 : c_shift_ram_0        
  PORT MAP (                              
    D => o_tp3,                               
    CLK => i_clk,                           
    CE => i_shift_valid,                             
    Q => o_tp2                               
  );                                      


--shift_ram_3 : c_shift_ram_0        
--  PORT MAP (                              
--    D => line2,                               
--    CLK => i_clk,                           
--    CE => i_shift_valid,                             
--    Q => o_tp2                                
--  );                                      


shift_ram_4 : c_shift_ram_0        
  PORT MAP (                              
    D => o_tp2 ,                               
    CLK => i_clk,                           
    CE => i_shift_valid,                             
    Q => o_tp1                                
  );                                      



--shift_ram_5 : c_shift_ram_0        
--  PORT MAP (                              
--    D => line1,                               
--    CLK => i_clk,                           
--    CE => i_shift_valid,                             
--    Q => o_tp1                                
--  );                                      



shift_ram_6 : c_shift_ram_0        
  PORT MAP (                              
    D => o_tp1,                               
    CLK => i_clk,                           
    CE => i_shift_valid,                             
    Q => o_tp0                                
  );                                      


--shift_ram_7 : c_shift_ram_0        
--  PORT MAP (                              
--    D => line0,                               
--    CLK => i_clk,                           
--    CE => i_shift_valid,                             
--    Q => o_tp0                                
--  );                                      

o_shift_out <= o_tp0;

end Behavioral;