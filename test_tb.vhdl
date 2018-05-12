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
        F : out std_logic;
        D : out std_logic;
        E : out std_logic;
        W : out std_logic;
        M : out std_logic;
       SF : out std_logic;
       UF : out std_logic;
      OvF : out std_logic
  	);
  end component readfile;
  
  
begin
  test1 : component readfile port map(clk, F, D, E, W, M, SF, UF, OvF);
  clk <= not clk after INTERVAL;

  process (clk)
    variable val : integer := 0;
    variable counter : integer := 1;
    variable error_count : integer := 0;
  begin
    if(rising_edge(clk)) then
      val := counter;
      case (val mod 2) is
        when 1 => pc0 <= '1';
        when 0 => pc0 <= '0';
      end case;
      if(val > 0) then
        val := val / 2;
        case (val mod 2) is
          when 1 => pc1 <= '1';
          when 0 => pc1 <= '0';
        end case;
        if(val > 0) then
          val := val / 2;
          case (val mod 2) is
            when 1 => pc2 <= '1';
            when 0 => pc2 <= '0';
          end case;
          if(val > 0) then
            val := val / 2;
            case (val mod 2) is
              when 1 => pc3 <= '1';
              when 0 => pc3 <= '0';
            end case;
          end if;
        end if;
      end if;
      counter := counter + 1;
    else
      if(pc0 = '1') then
        pc0 <= '0';
      end if;
      if(pc1 = '1') then
        pc1 <= '0';
      end if;
      if(pc2 = '1') then
        pc2 <= '0';
      end if;
      if(pc3 = '1') then
        pc3 <= '0';
      end if;
    end if;

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
  end process;                    
end architecture test_tb_arch;
