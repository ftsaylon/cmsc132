library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
	constant INTERVAL : time := 5 ns;
end entity test_tb;

architecture test_tb_arch of test_tb is
  signal clk : std_logic := '0';
  signal o : std_logic;
  
  signal pc0, pc1, pc2, pc3 : std_logic := '0';
  
  component readfile is
  	port(clk : in std_logic;
  			   o : out std_logic
  	);
  end component readfile;
  
  
begin
  test1 : component readfile port map(clk, o);
  clk <= not clk after INTERVAL;
  
  main : process is
    variable error_count : integer := 0;
  begin
  
    --for count in 0 to 3 loop
    --  i0 <= test_input(0);
    --  i1 <= test_input(1);
    --  
    --  wait for 10 ns;
    --  
    --  output := i0 or i1;

    --  assert o0=output report std_logic'image(i0) & " OR " & 
    --                          std_logic'image(i1) &
    --                          "| EXPECTED: " & std_logic'image(output) &
    --                          "| ACTUAL: " & std_logic'image(o0)
    --                    severity ERROR;
    --  if o0/=output then error_count := error_count + 1; end if;
    --  test_input := test_input + 1;
    --end loop;

    --report "Done with the test. There were " & integer'image(error_count) &
    --       " errors found.";
    wait;
  end process main;                    
end architecture test_tb_arch;
