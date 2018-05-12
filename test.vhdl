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
  	type int_array is array(0 to 31) of integer;
  	type char4_array is array(0 to 3) of character;
  	type char5_array is array(0 to 4) of character;

    file fp : text;
    variable line_buf : line := null;
    variable i : integer;
    variable registers : int_array;
    variable instr : char4_array;
    variable op1 :  char5_array;
    variable op2 :  char5_array;
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

				if(cnt2 = 3 OR cnt2 = 8) then
					read(line_buf, space);
				end if;

				if(cnt2 < 4) then
					instr(cnt2) := char;
				elsif(cnt2 < 9) then
					op1(cnt2 - 4) := char;
				else
					op2(cnt2 - 9) := char;
				end if;

				if(cnt2 = 13) then
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

					if(instr(3) = '0') then
						--I
						report "Immediate";
					else 
						--R
						report "Register";
					end if;
				end if;

				cnt2 := cnt2 + 1;
		
				--if(char = '0') then
				--	o <= '0';
				--elsif(char = '1') then
				--	o <= '1';
				--end if;
			end if;
		else
			file_close(fp);
		end if;
	end if;
  end process;
end testarch;

