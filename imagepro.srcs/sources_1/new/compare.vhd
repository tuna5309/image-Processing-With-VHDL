
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compare is
 Port ( 
  i_clk   : in std_logic;
  i_reset : in std_logic;
  i_val   : in std_logic;
  a       : in std_logic_vector (7 downto 0); 
  b       : in std_logic_vector (7 downto 0);
  o_data1 : out std_logic_vector(7 downto 0);
  o_data2 : out std_logic_vector(7 downto 0)
    
);
end compare;

architecture Behavioral of compare is
begin

process (i_clk, i_reset)
begin 
   if ( rising_edge (i_reset)) then 
      o_data1 <= (others => '0') ;
      o_data2 <= (others => '0') ;
   else 
     if (rising_edge (i_clk)) then    
        if(i_val ='1') then 
          if ( a >b ) then 
           o_data1 <= a;
           o_data2 <= b;
          else 
           o_data1 <= b;
           o_data2 <= a;
          end if;
         end if;
      end if;
     end if;
end process;

end Behavioral;
