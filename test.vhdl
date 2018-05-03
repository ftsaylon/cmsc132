library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.numeric_std.all;

entity readfile is
  port(rst, clk : in std_logic;
  			o : out std_logic);
end readfile;

architecture testarch of readfile is
begin
  process (rst, clk)
    file fp : text;
    variable line_buf : line := null;
    variable i : integer;
    variable char : character := '0';
    variable space : character;
    variable cnt : integer := 0;
    variable cnt2 : integer := 14;
  begin
  	if rst = '1' then
			file_open(fp, "test.txt", READ_MODE);
		elsif rising_edge(clk) then
			while(cnt < 15) loop
				if(cnt2 = 14) then
					readline(fp, line_buf);
					cnt2 := 0;
				else
					read(line_buf, char);
					read(line_buf, space);
					cnt2 := cnt2 + 1;
			
					if(char = '0') then
						o <= '0';
					elsif(char = '1') then
						o <= '1';
					end if;
				end if;
				cnt := cnt + 1;
			end loop;
			file_close(fp);
		end if;
  end process;
end testarch;
