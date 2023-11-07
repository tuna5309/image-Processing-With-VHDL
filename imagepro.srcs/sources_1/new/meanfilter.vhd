library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith;

entity meanfilter is
  port (
    i_clk        : in std_logic;
    i_reset      : in std_logic;
    i_data_valid : in std_logic;
    i_start      : in std_logic;
   -- i_data_valid_hr : in std_logic;
   -- i_data_valid_vr : in std_logic;
    i_data_in    : in std_logic_vector (7 downto 0);  
    o_data_ready : out std_logic;
    o_mean_out   : out std_logic_vector(7 downto 0)
  );
end entity meanfilter;

architecture Behavioral of meanfilter is

type t_mean is (S_IDLE,S_SUM,S_AVERAGE);
signal mean_state    : t_mean := S_IDLE;

signal cnt_2  : integer:=0;
signal cnt_1  : integer:=0;
signal ready  : std_logic; 

 
signal reg_data_valid1 : std_logic;
signal reg_data_valid2 : std_logic;
signal reg_data_valid3 : std_logic;
signal reg_data_valid4 : std_logic;
signal reg_data_valid5 : std_logic;

signal reg_data_hr1 : std_logic;   
signal reg_data_hr2 : std_logic;   
signal reg_data_hr3 : std_logic;   
signal reg_data_hr4 : std_logic;   
signal reg_data_hr5 : std_logic;   

signal reg_data_vr1 : std_logic;   
signal reg_data_vr2 : std_logic;   
signal reg_data_vr3 : std_logic;   
signal reg_data_vr4 : std_logic;   
signal reg_data_vr5 : std_logic;   

signal average        : integer;
signal sum            : integer;
signal sum_cnt_1      : integer:=0;
signal sum_cnt_2      : integer:=0;
signal truefalse      : std_logic:='0';
signal done           : std_logic;

signal line0_data : std_logic_vector ( 7 downto 0);
signal line1_data : std_logic_vector ( 7 downto 0);
signal line2_data : std_logic_vector ( 7 downto 0);
signal line3_data : std_logic_vector ( 7 downto 0);
signal line4_data : std_logic_vector ( 7 downto 0);

signal none  : std_logic_vector ( 7 downto 0);

signal data00,data01,data02,data03,data04 :std_logic_vector ( 7 downto 0);
signal data10,data11,data12,data13,data14 :std_logic_vector ( 7 downto 0);
signal data20,data21,data22,data23,data24 :std_logic_vector ( 7 downto 0);
signal data30,data31,data32,data33,data34 :std_logic_vector ( 7 downto 0);
signal data40,data41,data42,data43,data44 :std_logic_vector ( 7 downto 0);

signal input_data :  std_logic_vector(7 downto 0 );



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
 
 
  line4_data <= i_data_in;
  process (i_clk, i_reset)
  begin
 
 

     reg_data_valid1 <= i_data_valid;
     reg_data_valid2 <= reg_data_valid1;
     reg_data_valid3 <= reg_data_valid2;
     reg_data_valid4 <= reg_data_valid3;
     reg_data_valid5 <= reg_data_valid4;
   
  -- reg_data_hr1 <= i_data_valid_hr;     
  -- reg_data_hr2 <= reg_data_hr1;  
  -- reg_data_hr3 <= reg_data_hr2;  
  -- reg_data_hr4 <= reg_data_hr3;  
  -- reg_data_hr5 <= reg_data_hr4;  
  -- 
  -- reg_data_vr1 <= i_data_valid_vr;  
  -- reg_data_vr2 <= reg_data_vr1;     
  -- reg_data_vr3 <= reg_data_vr2;     
  -- reg_data_vr4 <= reg_data_vr3;     
  -- reg_data_vr5 <= reg_data_vr4;     
   
   
 if (rising_edge (i_clk)) then 
   if ( rising_edge (i_reset)) then 
    data00 <= (others => '0');data01 <= (others => '0');data02 <= (others => '0');data03 <= (others => '0');data04 <= (others => '0');
    data10 <= (others => '0');data11 <= (others => '0');data12 <= (others => '0');data13 <= (others => '0');data14 <= (others => '0');
    data20 <= (others => '0');data21 <= (others => '0');data22 <= (others => '0');data23 <= (others => '0');data24 <= (others => '0');
    data30 <= (others => '0');data31 <= (others => '0');data32 <= (others => '0');data33 <= (others => '0');data34 <= (others => '0');
    data40 <= (others => '0');data41 <= (others => '0');data42 <= (others => '0');data43 <= (others => '0');data44 <= (others => '0');  
  else 
-- if (i_data_valid = '1') then
      data04 <= line0_data;data03 <= data04;data02 <= data03;data01 <= data02;data00 <= data01;
      data14 <= line1_data;data13 <= data14;data12 <= data13;data11 <= data12;data10 <= data11;
      data24 <= line2_data;data23 <= data24;data22 <= data23;data21 <= data22;data20 <= data21;
      data34 <= line3_data;data33 <= data34;data32 <= data33;data31 <= data32;data30 <= data31;
      data44 <= line4_data;data43 <= data44;data42 <= data43;data41 <= data42;data40 <= data41;
   -- else 
   --   data00 <=  data00;data01 <= data01;data02 <= data02;data03 <= data03;data04 <= data04 ;  
   --   data10 <=  data10;data11 <= data11;data12 <= data12;data13 <= data13;data14 <= data14 ;
   --   data20 <=  data20;data21 <= data21;data22 <= data22;data23 <= data23;data24 <= data24 ;
   --   data30 <=  data30;data31 <= data31;data32 <= data32;data33 <= data33;data34 <= data34 ;
   --   data40 <=  data40;data41 <= data41;data42 <= data42;data43 <= data43;data44 <= data44 ;
   -- end if ;
  --end if;
  end if;
 end if;   
  end process;
  
 process (i_clk) begin 
   if ( rising_edge (i_reset) ) then    
   cnt_1 <= 0;
   ready <= '0';
   cnt_2 <= 0;
   else
     if ( done = '1') then
     ready <= '1';
       if ( cnt_1 < 1015 ) then 
         cnt_1 <= cnt_1 +1;
         
       else 
          if ( cnt_2 < 8 ) then 
            cnt_2 <= cnt_2 +1;
            ready <= '0';
          else 
            cnt_2 <= 0;
            cnt_1 <= 0;
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
     if ( rising_edge (i_clk) ) then  
       if ( sum_cnt_1 < 2053 ) then 
          sum_cnt_1 <= sum_cnt_1 + 1 ;        
       else
          done         <= '1'; 
          o_data_ready <= '1';  
        end if; 
      end if;
    end if;
   end process; 
    sum        <= to_integer(unsigned(data00)) + to_integer(unsigned(data10)) +  to_integer(unsigned(data20)) + to_integer(unsigned(data30)) + to_integer(unsigned(data40)) + to_integer(unsigned(data01)) + to_integer(unsigned(data11)) + to_integer(unsigned(data21)) + to_integer(unsigned(data31)) + to_integer(unsigned(data41)) + to_integer(unsigned(data02)) + to_integer(unsigned(data12)) + to_integer(unsigned(data22)) + to_integer(unsigned(data32)) + to_integer(unsigned(data42)) +to_integer(unsigned(data03)) + to_integer(unsigned(data13)) + to_integer(unsigned(data23)) + to_integer(unsigned(data33)) + to_integer(unsigned(data43)) +to_integer(unsigned(data04)) + to_integer(unsigned(data14)) + to_integer(unsigned(data24)) + to_integer(unsigned(data34))  + to_integer(unsigned(data44)) ;    
    average    <= sum/25;
    o_mean_out <= std_logic_vector(to_unsigned(average,o_mean_out'length)) when done = '1' and ready='1'  ;
end architecture Behavioral;

