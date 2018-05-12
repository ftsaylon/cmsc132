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
    variable registers : std_logic_vector(33 downto 0);
    variable instr : std_logic_vector(3 downto 0);
    variable op1 : std_logic_vector(4 downto 0);
    variable op2 : std_logic_vector(4 downto 0);
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
		if(cnt < 16) then
			if(cnt2 = 14) then
				readline(fp, line_buf);
				cnt2 := 0;
				cnt := cnt + 1;
			else
				read(line_buf, char);

				if(cnt2 < 4) then
					case char is
						when '0' =>
							instr(cnt2) := '0';
						when others =>
							instr(cnt2) := '1';
					end case;
				elsif(cnt2 = 4) then
					read(line_buf, space);
					case instr is
						when "0000" =>
							report "LOAD";
						when "0001" =>
							report "ADD_R";
						when "0010" =>
							report "ADD_I";
						when "0011" =>
							report "SUB_R";
						when "0100" =>
							report "SUB_I";
						when "0101" =>
							report "MUL_R";
						when "0110" =>
							report "MUL_I";
						when "0111" =>
							report "DIV_R";
						when "1000" =>
							report "DIV_I";
						when "1001" =>
							report "MOD_R";
						when "1010" =>
							report "MOD_I";	
						when others =>
							report "No instruction";
					end case;
				elsif(cnt2 = 10) then
					case char is
						when '0' =>
							op1(cnt2) := '0';
						when others =>
							op1(cnt2) := '1';
					end case;
					read(line_buf, space);
					if(instr(0) = 0) then
						--I

					else 
						--R
					end if;
				elsif(cnt2 = 16) then
					case char is
						when '0' =>
							op2(cnt2) := '0';
						when others =>
							op2(cnt2) := '1';
					end case;
					if(instr(0) = 0) then
						--I

					else 
						--R
					end if;
				end if;

				cnt2 := cnt2 + 1;
		
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
