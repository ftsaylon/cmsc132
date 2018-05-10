library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.numeric_std.all;

entity readfile is
  port(clk : in std_logic;
		 o : out std_logic);
end readfile;

architecture testarch of readfile is
begin
  process (clk)
    file fp : text;
    variable line_buf : line := null;
    variable i : integer;
    variable char : character := '0';
    variable space : character;
    variable init : integer := 0;
    variable cnt : integer := 0;
    variable cnt2 : integer := 14;
  begin
  	if(init = 0) then
  		init := 1;
		file_open(fp, "test.txt", READ_MODE);
	end if;
	if rising_edge(clk) then
		if(cnt < 15) then
			if(cnt2 = 14) then
				readline(fp, line_buf);
				cnt2 := 0;
				cnt := cnt + 1;
			else
				read(line_buf, char);
				read(line_buf, space);
				cnt2 := cnt2 + 1;
				report character'image(char);
		
				if(char = '0') then
					o <= '0';
				elsif(char = '1') then
					o <= '1';
				end if;
			end if;
		else
			file_close(fp);
		end if;
	end if;
  end process;
end testarch;
