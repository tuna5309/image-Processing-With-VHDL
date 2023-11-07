library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith;

entity sobelfilter is
Port ( 
   i_clk         : in std_logic;                        
   i_reset       : in std_logic;                        
   i_data_valid  : in std_logic;
   i_threshold   : in std_logic_vector(11 downto 0 );                        
   i_start       : in std_logic;                        
   i_data_in     : in std_logic_vector (7 downto 0);    
   o_data_ready  : out std_logic;                       
   o_sobel_out   : out std_logic_vector(7 downto 0));
end sobelfilter;

architecture Behavioral of sobelfilter is

signal Gx_data   : integer;
signal Gy_data   : integer;   

signal o_read    : std_logic;
signal out_cnt   : integer:=0;
signal sum       : integer;
signal done      : std_logic;
signal ready     : std_logic;
signal cnt_1     : integer:=0;
signal cnt_2     : integer:=0;
signal sum_cnt_1 : integer:=0;
signal sum_cnt_2 : integer:=0;
signal count_3   : integer:=0;

signal o_data      : std_logic_vector( 7 downto 0);
signal divide      : integer;
signal g_square    : integer;

signal cordicinput1: std_logic_vector (31 downto 0 );
signal cordicout1 : std_logic_vector(15 downto 0 );


signal m_axis_dout_tvalid : std_logic;
                                                 
signal data00,data01,data02,data03,data04 :integer range 0 to 255;
signal data10,data11,data12,data13,data14 :integer range 0 to 255;
signal data20,data21,data22,data23,data24 :integer range 0 to 255;
signal data30,data31,data32,data33,data34 :integer range 0 to 255;
signal data40,data41,data42,data43,data44 :integer range 0 to 255;

signal line0_data : std_logic_vector ( 7 downto 0);
signal line1_data : std_logic_vector ( 7 downto 0);
signal line2_data : std_logic_vector ( 7 downto 0);
signal line3_data : std_logic_vector ( 7 downto 0);
signal line4_data : std_logic_vector ( 7 downto 0);

signal none  : std_logic_vector ( 7 downto 0);

COMPONENT cordic_0                                                           
  PORT (                                                                     
    aclk : IN STD_LOGIC;                                                     
    s_axis_cartesian_tvalid : IN STD_LOGIC;                                  
    s_axis_cartesian_tdata  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);               
    m_axis_dout_tvalid      : OUT STD_LOGIC;                                      
    m_axis_dout_tdata       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)                    
  );                                                                         
END COMPONENT;                                                               

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

begin

 line4_data <= i_data_in;

process (i_clk, i_reset)                                                                                                   
begin                                                                                                                                   
                                                                                                                                                                                                                                      
if ( rising_edge (i_reset)) then                                                                                                         
  data00 <= 0;data01 <= 0;data02 <= 0;data03 <= 0;data04 <=0;    
  data10 <= 0;data11 <= 0;data12 <= 0;data13 <= 0;data14 <=0;    
  data20 <= 0;data21 <= 0;data22 <= 0;data23 <= 0;data24 <=0;    
  data30 <= 0;data31 <= 0;data32 <= 0;data33 <= 0;data34 <=0;    
  data40 <= 0;data41 <= 0;data42 <= 0;data43 <= 0;data44 <=0;    
else                                                                                                                                     
  if (rising_edge (i_clk)) then                                                                                                                                                                                                                                                                                                                                                        
    data04 <= to_integer(unsigned(line0_data));data03 <= data04;data02 <= data03;data01 <= data02;data00 <= data01;                                           
    data14 <= to_integer(unsigned(line1_data));data13 <= data14;data12 <= data13;data11 <= data12;data10 <= data11;                                           
    data24 <= to_integer(unsigned(line2_data));data23 <= data24;data22 <= data23;data21 <= data22;data20 <= data21;                                           
    data34 <= to_integer(unsigned(line3_data));data33 <= data34;data32 <= data33;data31 <= data32;data30 <= data31;                                           
    data44 <= to_integer(unsigned(line4_data));data43 <= data44;data42 <= data43;data41 <= data42;data40 <= data41;                                                                                                                                                                       
  end if;                                                                                                                                
end if;                                                                                                                                  
end process;

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
                                                           

Gx_data<= (-5*data00)+(-4*data01)+(4*data03)+(5*data04)+(-8*data10)+(-10*data11)+(10*data13)+(8*data14)+(-10*data20)+(-20*data21)+(20*data23)+(10*data24)+(-8*data30)+(-10*data31)+(10*data33)+(8*data34)+(-5*data40)+(-4*data41)+(4*data43)+(5*data44) when done='1';  
Gy_data<= (5*data00)+(8*data01)+(10*data02)+(8*data03)+(5*data04)+(4*data10)+(10*data11)+(20*data12)+(10*data13)+(4*data14)+(-4*data30)+(-10*data31)+(-20*data32)+(-10*data33)+(-4*data34)+(-5*data40)+(-8*data41)+(-10*data42)+(-8*data43)+(-5*data44) when done='1';


process (i_clk, i_reset)                    
begin                                       
 if ( rising_edge (i_reset)) then              
 else
   if (rising_edge (i_clk)) then 
     if ( done = '1') then                                
       g_square <= ( Gx_data * Gx_data) + (Gy_data * Gy_data);
       cordicinput1 <= std_logic_vector(to_unsigned(g_square,cordicinput1'length));   
     end if;
   end if;
 end if;                                
end process;

cordic1 : cordic_0                                         
  PORT MAP (                                                          
    aclk => i_clk,                                                     
    s_axis_cartesian_tvalid => i_data_valid,               
    s_axis_cartesian_tdata  => cordicinput1,                 
    m_axis_dout_tvalid      => m_axis_dout_tvalid,                         
    m_axis_dout_tdata       => cordicout1                            
  );                                                                                         

process (i_clk) begin 
 if ( rising_edge (i_reset) ) then      
   cnt_1 <= 0;
   ready <= '0';
   cnt_2 <= 0;
 else
   if (rising_edge ( i_clk)) then
     if ( o_read = '1') then
       ready <= '1';
       if ( cnt_1 < 1020 ) then 
         cnt_1 <= cnt_1 +1;       
       else 
         if ( cnt_2 < 4 ) then 
           cnt_2 <= cnt_2 +1;
           ready <= '0';
         else 
           cnt_2 <= 0;
           cnt_1 <= 0;
         end if;
       end if;
     end if;
   end if;
 end if;
   end process;
    
  
  
 process (i_clk) begin 
 if ( rising_edge (i_reset) ) then  
   done      <= '0';
   sum_cnt_1 <= 0;
   sum_cnt_2 <= 0;
 else  
   if(rising_edge (i_clk) ) then  
     if( sum_cnt_1 < 1026 ) then 
       sum_cnt_1   <= sum_cnt_1 + 1 ;         
     else
       done          <= '1'; 
       if(out_cnt  < 18) then 
         out_cnt      <= out_cnt + 1;
       else 
         o_data_ready <= '1'; 
         o_read       <= '1';
       end if; 
     end if;
   end if;
 end if;
 end process; 


process (i_clk) begin                                
 if ( rising_edge (i_reset)) then                                           
 else  
   if (rising_edge (i_clk)) then   
     if ( done = '1') then                                                                                        
       if (cordicout1 > to_integer(unsigned(i_threshold ))) then                      
         o_data <= std_logic_vector(to_unsigned(255,o_sobel_out'length));      
       else                                                                       
         o_data <= std_logic_vector(to_unsigned(0,o_sobel_out'length));    
       end if;                                                                        
     end if;
   end if;
 end if;
end process;

o_sobel_out <= o_data when o_read = '1' and ready= '1';

end Behavioral;
