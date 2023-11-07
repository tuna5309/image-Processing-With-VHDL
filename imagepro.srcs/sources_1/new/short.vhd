library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity short is
  Port ( 
    i_clk         : in std_logic;
    i_reset       : in std_logic;
    i_valid       : in std_logic;
    i_data_0      : in std_logic_vector ( 7 downto 0 ); 
    i_data_1      : in std_logic_vector ( 7 downto 0 ); 
    i_data_2      : in std_logic_vector ( 7 downto 0 ); 
    i_data_3      : in std_logic_vector ( 7 downto 0 ); 
    i_data_4      : in std_logic_vector ( 7 downto 0 );
    o_min         : out std_logic_vector ( 7 downto 0 );
    o_min_medium  : out std_logic_vector ( 7 downto 0 );
    o_median      : out std_logic_vector ( 7 downto 0 );
    o_max_medium  : out std_logic_vector ( 7 downto 0 );
    o_max         : out std_logic_vector ( 7 downto 0 )
  );
end short;

architecture Behavioral of short is

signal i_valid_1 : std_logic;
signal i_valid_2 : std_logic;
signal i_valid_3 : std_logic;
signal i_valid_4 : std_logic;
signal i_valid_5 : std_logic;
signal i_valid_6 : std_logic;
signal i_valid_7 : std_logic;
signal i_valid_8 : std_logic;

signal comp1_data1 : std_logic_vector(7 downto 0 ) ;
signal comp1_data2 : std_logic_vector(7 downto 0 ) ;
signal comp2_data1 : std_logic_vector(7 downto 0 ) ;
signal comp2_data2 : std_logic_vector(7 downto 0 ) ;
signal comp3_data1 : std_logic_vector(7 downto 0 ) ;
signal comp3_data2 : std_logic_vector(7 downto 0 ) ;
signal comp4_data1 : std_logic_vector(7 downto 0 ) ;
signal comp4_data2 : std_logic_vector(7 downto 0 ) ;
signal comp5_data1 : std_logic_vector(7 downto 0 ) ;
signal comp5_data2 : std_logic_vector(7 downto 0 ) ;
signal comp6_data1 : std_logic_vector(7 downto 0 ) ;
signal comp6_data2 : std_logic_vector(7 downto 0 ) ;
signal comp7_data1 : std_logic_vector(7 downto 0 ) ;
signal comp7_data2 : std_logic_vector(7 downto 0 ) ;
signal comp8_data1 : std_logic_vector(7 downto 0 ) ;
signal comp8_data2 : std_logic_vector(7 downto 0 ) ;


 component compare is   
 port(                                             
  i_clk   : in std_logic;                            
  i_reset : in std_logic;                            
  i_val   : in std_logic;                            
  a       : in std_logic_vector (7 downto 0);        
  b       : in std_logic_vector (7 downto 0);        
  o_data1 : out std_logic_vector(7 downto 0);        
  o_data2 : out std_logic_vector(7 downto 0)         
                                                     
);                                                   
end component;                                         

begin

comp1: compare 
port map (  
   i_clk   =>i_clk, 
   i_reset =>i_reset,
   i_val   => i_valid,
   a       => i_data_0,
   b       => i_data_1,
   o_data1 => comp1_data1, 
   o_data2 => comp1_data2);
 

comp2: compare              
port map (                  
   i_clk   =>i_clk,         
   i_reset =>i_reset,       
   i_val   => i_valid,      
   a       => i_data_2,     
   b       => i_data_3,     
   o_data1 => comp2_data1,  
   o_data2 => comp2_data2); 


comp3: compare              
port map (                  
   i_clk   =>i_clk,         
   i_reset =>i_reset,       
   i_val   => i_valid_1,      
   a       => comp1_data2,     
   b       => comp2_data1,     
   o_data1 => comp3_data1,  
   o_data2 => comp3_data2); 


comp4: compare               
port map (                   
   i_clk   =>i_clk,          
   i_reset =>i_reset,        
   i_val   => i_valid_1,       
   a       => comp2_data2,      
   b       => i_data_4,      
   o_data1 => comp4_data1,   
   o_data2 => comp4_data2);  


comp5: compare             
port map (                 
   i_clk   =>i_clk,        
   i_reset =>i_reset,      
   i_val   => i_valid_2,   
   a       => comp1_data1, 
   b       => comp3_data1,    
   o_data1 => o_max, 
   o_data2 => comp5_data2);

comp6: compare               
port map (                   
   i_clk   =>i_clk,          
   i_reset =>i_reset,        
   i_val   => i_valid_2,     
   a       => comp3_data2,   
   b       => comp4_data1,   
   o_data1 => comp6_data1,   
   o_data2 => comp6_data2);  

comp7: compare             
port map (                 
   i_clk   => i_clk,        
   i_reset => i_reset,      
   i_val   => i_valid_3,   
   a       => comp5_data2, 
   b       => comp6_data1, 
   o_data1 => o_max_medium, 
   o_data2 => o_median);

comp8: compare             
port map (                 
   i_clk   => i_clk,        
   i_reset => i_reset,      
   i_val   => i_valid_3,   
   a       => comp6_data2, 
   b       => comp4_data2, 
   o_data1 => o_min_medium, 
   o_data2 => o_min);


process (i_clk, i_reset)
begin 
i_valid_1 <= i_valid;
i_valid_2 <= i_valid_1;
i_valid_3 <= i_valid_2;
i_valid_4 <= i_valid_3;
i_valid_5 <= i_valid_4;

if (rising_edge (i_clk)) then 
  if ( rising_edge (i_reset)) then
end if;
end if;
end process;



end Behavioral;
