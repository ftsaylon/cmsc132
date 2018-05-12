library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
  constant INTERVAL : time := 5 ns;
end entity test_tb;

architecture test_tb_arch of test_tb is
  signal clk : std_logic := '1';
  signal F, D, E, M, W, SF, UF, OvF : std_logic;
  signal pc0, pc1, pc2, pc3 : std_logic := '0';
  
  component readfile is
  	port(
      clk : in std_logic;
      F, D, E, W, M, SF, UF, OvF : out std_logic;
      pc0, pc1, pc2, pc3 : out std_logic
  	);
  end component readfile;
  
  
begin
  test1 : component readfile port map(clk, F, D, E, W, M, SF, UF, OvF, pc0, pc1, pc2, pc3);
  clk <= not clk after INTERVAL;

  process (clk)
    variable error_count : integer := 0;
  begin
  end process;                    
end architecture test_tb_arch;
