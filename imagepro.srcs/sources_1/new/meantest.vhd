library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;


entity tb_meanfilter is

end tb_meanfilter;

architecture Behavioral of tb_meanfilter is

component meanfilter is

port (
i_clk : in std_logic;                                  
i_reset : in std_logic;                                
i_data_valid : in std_logic;
i_start      : in std_logic;
o_data_ready : out std_logic;                      
i_data_in : in std_logic_vector(7 downto 0);           
o_mean_out : out std_logic_vector(7 downto 0)       
   );
end component;

 signal i_clk : std_logic := '0'; 
 signal i_reset : std_logic := '1'; 
 signal i_confirm : std_logic := '0'; 
 signal o_data_ready :  std_logic :='0';                    
 signal i_data_valid : std_logic := '0'; 
 signal i_enable_filter : std_logic :='1';
 signal i_start         : std_logic :='1';
 signal i_data_in : std_logic_vector(7 downto 0);
 signal o_mean_out : std_logic_vector(7 downto 0); 

constant c_clkperiod					: time 		:= 10 ns;
constant C_FILE_NAME_WR :string  := "C:\Users\Neta\Desktop\pro\imagepro\imagepro.srcs\sim_1\new\auh.txt";
constant C_FILE_NAME_RD :string  := "C:\Users\Neta\Desktop\pro\imagepro\imagepro.srcs\sim_1\new\rawhex.txt";

begin

  DUT : meanfilter
  port map(
    i_clk         => i_clk,
    i_reset       => i_reset,
    i_start       => i_start,
    i_data_valid  => i_data_valid,
    i_data_in     => i_data_in,
    o_data_ready  => o_data_ready,
    o_mean_out     => o_mean_out
  );

P_CLKGEN : process begin
i_clk 	<= '0';
wait for c_clkperiod/2;
i_clk		<= '1';
wait for c_clkperiod/2;
end process P_CLKGEN;
P_STIMULI : process 



	variable VEC_LINE_WR : line;
    variable VEC_VAR_WR  : std_logic_vector (7 downto 0);
	file VEC_FILE_WR : text open write_mode is C_FILE_NAME_WR;
	
	variable VEC_LINE_RD 		: line;
    variable VEC_VAR_RD 		: std_logic_vector (7 downto 0);
	file VEC_FILE_RD 			: text open read_mode is C_FILE_NAME_RD;

begin

i_reset	<= '1';
wait for 5 ns;
i_reset	<= '0';
wait for 5 ns;


while not endfile(VEC_FILE_RD) loop
	readline (VEC_FILE_RD, VEC_LINE_RD);
	hread (VEC_LINE_RD, VEC_VAR_RD);		
	wait until falling_edge(i_clk);
	i_data_in <= VEC_VAR_RD;	
	i_data_valid	<= '1';
	wait for c_clkperiod/2;
	i_data_valid	<= '0';
	--if ( rising_edge(o_data_ready)) then 
	hwrite(VEC_LINE_WR, o_mean_out);
	writeline(VEC_FILE_WR,VEC_LINE_WR);
  --  end if;
	wait for c_clkperiod/2;	
end loop;


assert false
report "SIM DONE"
severity failure;

end process P_STIMULI;

end Behavioral;
