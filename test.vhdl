library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.numeric_std.all;

entity readfile is
  port(rst, clk : in std_logic;
				  o : out std_logic
      );
end readfile;

architecture testarch of readfile is
begin
  process (rst, clk)
    file fp : text;
    variable line_buf : line;
    variable i : integer;
    variable char : character := '0';
    variable cnt : integer := 0;
  begin
  	if rst = '1' then
			file_open(fp, "test.txt", READ_MODE);
		elsif rising_edge(clk) then
			while(cnt = 0) loop
				readline(fp, line_buf);
				read(line_buf, char);
			
				if(char = '0') then
					o <= '0';
				else
					o <= '1';
				end if;
				cnt := 1;
			end loop;
			file_close(fp);
		end if;
  end process;
end testarch;
