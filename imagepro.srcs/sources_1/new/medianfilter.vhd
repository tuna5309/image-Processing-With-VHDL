library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity medianfilter is
Port ( 
  i_clk        : in std_logic;
  i_reset      : in std_logic; 
  i_data_valid : in std_logic;
  i_data_in    : in std_logic_vector( 7 downto 0 );
  o_median_out : out std_logic_vector ( 7 downto 0 )
);
end medianfilter;

architecture Behavioral of medianfilter is

signal median : std_logic_vector( 7 downto 0 );
signal sum_cnt_1 : integer:=0;
signal sum_cnt_2 : integer:=0;
signal val       : std_logic;
signal tmp       : std_logic;
signal o_data_ready : std_logic;

signal none : std_logic_vector ( 7 downto 0);
signal none1 : std_logic_vector ( 7 downto 0);
signal none2 : std_logic_vector ( 7 downto 0);
signal none3 : std_logic_vector ( 7 downto 0);
signal none4 : std_logic_vector ( 7 downto 0);

signal data00,data01,data02,data03,data04 :std_logic_vector ( 7 downto 0); 
signal data10,data11,data12,data13,data14 :std_logic_vector ( 7 downto 0); 
signal data20,data21,data22,data23,data24 :std_logic_vector ( 7 downto 0); 
signal data30,data31,data32,data33,data34 :std_logic_vector ( 7 downto 0); 
signal data40,data41,data42,data43,data44 :std_logic_vector ( 7 downto 0); 

signal line0_data : std_logic_vector ( 7 downto 0);             
signal line1_data : std_logic_vector ( 7 downto 0);             
signal line2_data : std_logic_vector ( 7 downto 0);             
signal line3_data : std_logic_vector ( 7 downto 0);             
signal line4_data : std_logic_vector ( 7 downto 0);      

signal line0_o_min        :std_logic_vector(7 downto 0 );      
signal line0_o_min_medium :std_logic_vector(7 downto 0 );
signal line0_median       :std_logic_vector(7 downto 0 );     
signal line0_max_medium   :std_logic_vector(7 downto 0 ); 
signal line0_max           :std_logic_vector(7 downto 0 );         

signal line1_o_min        :std_logic_vector(7 downto 0 );      
signal line1_o_min_medium :std_logic_vector(7 downto 0 );
signal line1_median       :std_logic_vector(7 downto 0 );     
signal line1_max_medium   :std_logic_vector(7 downto 0 ); 
signal line1_max           :std_logic_vector(7 downto 0 ); 

signal line2_o_min        :std_logic_vector(7 downto 0 );      
signal line2_o_min_medium :std_logic_vector(7 downto 0 );
signal line2_median       :std_logic_vector(7 downto 0 );     
signal line2_max_medium   :std_logic_vector(7 downto 0 ); 
signal line2_max           :std_logic_vector(7 downto 0 ); 

signal line3_o_min        :std_logic_vector(7 downto 0 );      
signal line3_o_min_medium :std_logic_vector(7 downto 0 );
signal line3_median       :std_logic_vector(7 downto 0 );     
signal line3_max_medium   :std_logic_vector(7 downto 0 ); 
signal line3_max           :std_logic_vector(7 downto 0 ); 

signal line4_o_min        :std_logic_vector(7 downto 0 );  
signal line4_o_min_medium :std_logic_vector(7 downto 0 );  
signal line4_median       :std_logic_vector(7 downto 0 );  
signal line4_max_medium   :std_logic_vector(7 downto 0 );  
signal line4_max           :std_logic_vector(7 downto 0 ); 

signal colm_0_o_min        :std_logic_vector(7 downto 0 ); 
signal colm_0_o_min_medium :std_logic_vector(7 downto 0 ); 
signal colm_0_median       :std_logic_vector(7 downto 0 ); 
signal colm_0_max_medium   :std_logic_vector(7 downto 0 ); 
signal colm_0_max           :std_logic_vector(7 downto 0 );

signal colm_1_o_min        :std_logic_vector(7 downto 0 );   
signal colm_1_o_min_medium :std_logic_vector(7 downto 0 );   
signal colm_1_median       :std_logic_vector(7 downto 0 );   
signal colm_1_max_medium   :std_logic_vector(7 downto 0 );   
signal colm_1_max           :std_logic_vector(7 downto 0 );  

signal colm_2_o_min        :std_logic_vector(7 downto 0 );   
signal colm_2_o_min_medium :std_logic_vector(7 downto 0 );   
signal colm_2_median       :std_logic_vector(7 downto 0 );   
signal colm_2_max_medium   :std_logic_vector(7 downto 0 );   
signal colm_2_max           :std_logic_vector(7 downto 0 );  

signal colm_3_o_min        :std_logic_vector(7 downto 0 );   
signal colm_3_o_min_medium :std_logic_vector(7 downto 0 );   
signal colm_3_median       :std_logic_vector(7 downto 0 );   
signal colm_3_max_medium   :std_logic_vector(7 downto 0 );   
signal colm_3_max           :std_logic_vector(7 downto 0 );  

signal colm_4_o_min        :std_logic_vector(7 downto 0 );   
signal colm_4_o_min_medium :std_logic_vector(7 downto 0 );   
signal colm_4_median       :std_logic_vector(7 downto 0 );   
signal colm_4_max_medium   :std_logic_vector(7 downto 0 );   
signal colm_4_max           :std_logic_vector(7 downto 0 );  
     
signal reg_data_valid1 : std_logic; 
signal reg_data_valid2 : std_logic; 
signal reg_data_valid3 : std_logic; 
signal reg_data_valid4 : std_logic; 
signal reg_data_valid5 : std_logic; 



component matrix is 
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
end component;

component short is                                             
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
end component;                                                  


begin

matrix_inst : matrix
 port map (
 
 i_clk         => i_clk,
 i_shif_in     => i_data_in,
 i_shift_valid => i_data_valid,
 o_shift_out   => none,
 o_tp0         => line0_data,
 o_tp1         => line1_data,
 o_tp2         => line2_data,
 o_tp3         => line3_data);
 
 process (i_clk, i_reset,i_data_valid)
 begin
 
  line4_data <= i_data_in;
 
 reg_data_valid1 <= i_data_valid;     
 reg_data_valid2 <= reg_data_valid1;  
 reg_data_valid3 <= reg_data_valid2;  
 reg_data_valid4 <= reg_data_valid3;  
 reg_data_valid5 <= reg_data_valid4;  
if ( rising_edge (i_reset)) then                                                                                                                                            
   data00 <= (others => '0');data01 <= (others => '0');data02 <= (others => '0');data03 <= (others => '0');data04 <= (others => '0');                                         
   data10 <= (others => '0');data11 <= (others => '0');data12 <= (others => '0');data13 <= (others => '0');data14 <= (others => '0');                                         
   data20 <= (others => '0');data21 <= (others => '0');data22 <= (others => '0');data23 <= (others => '0');data24 <= (others => '0');                                         
   data30 <= (others => '0');data31 <= (others => '0');data32 <= (others => '0');data33 <= (others => '0');data34 <= (others => '0');                                         
   data40 <= (others => '0');data41 <= (others => '0');data42 <= (others => '0');data43 <= (others => '0');data44 <= (others => '0'); 
else 
 if (rising_edge (i_clk)) then                                                                                                                                                 
                                                                                                                                                                         
 -- if (i_data_valid = '1') then                                                                                                                                             
     data04 <= line0_data;data03 <= data04;data02 <= data03;data01 <= data02;data00 <= data01;                                                                                
     data14 <= line1_data;data13 <= data14;data12 <= data13;data11 <= data12;data10 <= data11;                                                                                
     data24 <= line2_data;data23 <= data24;data22 <= data23;data21 <= data22;data20 <= data21;                                                                                
     data34 <= line3_data;data33 <= data34;data32 <= data33;data31 <= data32;data30 <= data31;                                                                                
     data44 <= line4_data;data43 <= data44;data42 <= data43;data41 <= data42;data40 <= data41;                                                                                
 --  else                                                                                                                                                                     
 --    data00 <=  data00;data01 <= data01;data02 <= data02;data03 <= data03;data04 <= data04 ;                                                                                
 --    data10 <=  data10;data11 <= data11;data12 <= data12;data13 <= data13;data14 <= data14 ;                                                                                
 --    data20 <=  data20;data21 <= data21;data22 <= data22;data23 <= data23;data24 <= data24 ;                                                                                
 --    data30 <=  data30;data31 <= data31;data32 <= data32;data33 <= data33;data34 <= data34 ;                                                                                
 --    data40 <=  data40;data41 <= data41;data42 <= data42;data43 <= data43;data44 <= data44 ;                                                                                
 --  end if ;                                                                                                                                                                 
--  end if;                                                                                                                                                                   
  end if;                                                                                                                                                                     
end if;                                                                                                                                                                       
 end process;                                                                                                                                                                 
   
 short1:short                                             
   Port map(                                                        
     i_clk         => i_clk,         
     i_reset       => i_reset,         
     i_valid       => i_data_valid, 
     i_data_0      => data00,        
     i_data_1      => data01,        
     i_data_2      => data02,        
     i_data_3      => data03,        
     i_data_4      => data04,        
     o_min         => line0_o_min,         
     o_min_medium  => line0_o_min_medium,         
     o_median      => line0_median,        
     o_max_medium  => line0_max_medium,        
     o_max         => line0_max );                                                              
                                             
  short2:short                                        
   Port map(                                         
     i_clk         => i_clk,                         
     i_reset       => i_reset,                       
     i_valid       => i_data_valid,                  
     i_data_0      => data10,                        
     i_data_1      => data11,                        
     i_data_2      => data12,                        
     i_data_3      => data13,                        
     i_data_4      => data14,                        
     o_min         => line1_o_min,                   
     o_min_medium  => line1_o_min_medium,            
     o_median      => line1_median,                  
     o_max_medium  => line1_max_medium,              
     o_max         => line1_max );                   
 
 
  short3:short                                        
   Port map(                                         
     i_clk         => i_clk,                         
     i_reset       => i_reset,                       
     i_valid       => i_data_valid,                  
     i_data_0      => data20,                        
     i_data_1      => data21,                        
     i_data_2      => data22,                        
     i_data_3      => data23,                        
     i_data_4      => data24,                        
     o_min         => line2_o_min,                   
     o_min_medium  => line2_o_min_medium,            
     o_median      => line2_median,                  
     o_max_medium  => line2_max_medium,              
     o_max         => line2_max );                   
 
 
  short4:short                                        
   Port map(                                         
     i_clk         => i_clk,                         
     i_reset       => i_reset,                       
     i_valid       => i_data_valid,                  
     i_data_0      => data30,                        
     i_data_1      => data31,                        
     i_data_2      => data32,                        
     i_data_3      => data33,                        
     i_data_4      => data34,                        
     o_min         => line3_o_min,                   
     o_min_medium  => line3_o_min_medium,            
     o_median      => line3_median,                  
     o_max_medium  => line3_max_medium,              
     o_max         => line3_max );                   
 
 
   short5:short                                                 
    Port map(                                                   
      i_clk         => i_clk,                                   
      i_reset       => i_reset,                                 
      i_valid       => i_data_valid,                            
      i_data_0      => data40,                                  
      i_data_1      => data41,                                  
      i_data_2      => data42,                                  
      i_data_3      => data43,                                  
      i_data_4      => data44,                                  
      o_min         => line4_o_min,                             
      o_min_medium  => line4_o_min_medium,                      
      o_median      => line4_median,                            
      o_max_medium  => line4_max_medium,                        
      o_max         => line4_max );                             
 
 
     colm:short                            
     Port map(                              
       i_clk         => i_clk,              
       i_reset       => i_reset,            
       i_valid       => reg_data_valid1,       
       i_data_0      => line0_o_min,             
       i_data_1      => line1_o_min,             
       i_data_2      => line2_o_min,             
       i_data_3      => line3_o_min,             
       i_data_4      => line4_o_min,             
       o_min         =>  colm_0_o_min       ,        
       o_min_medium  =>  colm_0_o_min_medium, 
       o_median      =>  colm_0_median      ,       
       o_max_medium  =>  colm_0_max_medium  ,   
       o_max         =>  colm_0_max          );        
 
 
     colm2:short                                 
     Port map(                                  
       i_clk         => i_clk,                  
       i_reset       => i_reset,                
       i_valid       => reg_data_valid1,         
       i_data_0      => line0_o_min_medium,            
       i_data_1      => line1_o_min_medium,            
       i_data_2      => line2_o_min_medium,            
       i_data_3      => line3_o_min_medium,            
       i_data_4      => line4_o_min_medium,            
       o_min         =>  colm_1_o_min       ,                       
       o_min_medium  =>  colm_1_o_min_medium,                       
       o_median      =>  colm_1_median      ,                       
       o_max_medium  =>  colm_1_max_medium  ,                       
       o_max         =>  colm_1_max          );                     
 
      
      colm3:short                                        
      Port map(                                         
        i_clk         => i_clk,                         
        i_reset       => i_reset,                       
        i_valid       => reg_data_valid1,                
        i_data_0      => line0_median,            
        i_data_1      => line1_median,            
        i_data_2      => line2_median,            
        i_data_3      => line3_median,            
        i_data_4      => line4_median,            
        o_min         =>  colm_2_o_min       ,                              
        o_min_medium  =>  colm_2_o_min_medium,                              
        o_median      =>  colm_2_median      ,                              
        o_max_medium  =>  colm_2_max_medium  ,                              
        o_max         =>  colm_2_max          );                            
      
      
       colm4:short                                               
       Port map(                                                 
         i_clk         => i_clk,                                 
         i_reset       => i_reset,                               
         i_valid       => reg_data_valid1,                        
         i_data_0      => line0_max_medium,                          
         i_data_1      => line1_max_medium,                          
         i_data_2      => line2_max_medium,                          
         i_data_3      => line3_max_medium,                          
         i_data_4      => line4_max_medium,                          
         o_min         =>  colm_3_o_min       ,                                      
         o_min_medium  =>  colm_3_o_min_medium,                                      
         o_median      =>  colm_3_median      ,                                      
         o_max_medium  =>  colm_3_max_medium  ,                                      
         o_max         =>  colm_3_max          );                                    
 
       colm5:short                                                
       Port map(                                                  
         i_clk         => i_clk,                                  
         i_reset       => i_reset,                                
         i_valid       => reg_data_valid1,                         
         i_data_0      => line0_max,                       
         i_data_1      => line1_max,                       
         i_data_2      => line2_max,                       
         i_data_3      => line3_max,                       
         i_data_4      => line4_max,                       
         o_min         =>  colm_4_o_min       ,                                       
         o_min_medium  =>  colm_4_o_min_medium,                                       
         o_median      =>  colm_4_median      ,                                       
         o_max_medium  =>  colm_4_max_medium  ,                                       
         o_max         =>  colm_4_max          );                                     
 
 
         colm6:short                                    
         Port map(                                      
           i_clk         => i_clk,                      
           i_reset       => i_reset,                    
           i_valid       => reg_data_valid2,            
           i_data_0      => colm_0_max,                  
           i_data_1      => colm_1_o_min_medium,                  
           i_data_2      => colm_2_median,                  
           i_data_3      => colm_2_max_medium,                  
           i_data_4      => colm_4_max,                  
           o_min         =>  none1       ,       
           o_min_medium  =>  none2,       
           o_median      =>  median      ,       
           o_max_medium  =>  none3  ,       
           o_max         =>  none4          );     
 

process (i_clk) begin 
   if ( rising_edge (i_reset) ) then  
   sum_cnt_1 <= 0;
   else  
     if ( rising_edge (i_clk) ) then  
       if ( sum_cnt_1 < 10243 ) then 
          sum_cnt_1 <= sum_cnt_1 + 1 ;        
       else
        -- done         <= '1'; 
        o_data_ready <= '1';                    
        end if; 
      end if;
    end if;
   end process; 


--process(i_clk,i_reset)                                                       
--begin                                                                    
--   if(i_reset='1') then                                                  
--     sum_cnt_2<=1;                                                       
--     tmp<='1';                                                           
--   elsif(i_clk'event and i_clk='1' and o_data_ready = '1') then          
--     sum_cnt_2 <=sum_cnt_2+1;                                            
--     if (sum_cnt_2 = 10) then                                             
--       tmp <= NOT tmp;                                                   
--       sum_cnt_2 <= 1;                                                   
--     end if;                                                             
--   end if;                                                               
-- val <= tmp;                                                             
--end process;                                                             

o_median_out <= median;

end Behavioral;
