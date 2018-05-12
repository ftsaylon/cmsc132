library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.numeric_std.all;

entity readfile is
	port(clk : in std_logic;
		   F : out std_logic;
		   D : out std_logic;
		   E : out std_logic;
		   W : out std_logic;
		   M : out std_logic;
		   SF : out std_logic;
		   UF : out std_logic;
		   OvF : out std_logic);
end readfile;

architecture testarch of readfile is
begin
  process (clk)
  	--array definitions
  	type int_array is array(0 to 31) of integer;
  	type char4_array is array(0 to 3) of character;
  	type char5_array is array(0 to 4) of character;

  	--variable declarations
    file fp : text;
    variable line_buf : line := null;
    variable i : integer;
    variable registers : int_array;
    variable instr : char4_array;
    variable op1 :  char5_array;
    variable op2 :  char5_array;
    variable op1_val :  integer;
    variable op2_val :  integer;
    variable char : character := '0';
    variable space : character;
    variable init : integer := 0;
    variable count1 : integer := 0;
  begin
  	--Initilization
  	if(init = 0) then
  		init := 1;
		file_open(fp, "test.txt", READ_MODE);

	    for count in 0 to 31 loop
	    	registers(count) := 0;
	    end loop;
	end if;

	if rising_edge(clk) then
		--reads until 15 lines of input
		if(count1 < 15) then

			--reads 1 line of input per rising edge
			readline(fp, line_buf);
			for count2 in 0 to 13 loop
				--catches a character
				read(line_buf, char);

				--catches the 2 space characters, in between the codes
				if(count2 = 3 OR count2 = 8) then
					read(line_buf, space);
				end if;

				--checks the current iteration count and places the bit into the proper array
				if(count2 < 4) then
					instr(count2) := char;
				elsif(count2 < 9) then
					op1(count2 - 4) := char;
				else
					op2(count2 - 9) := char;
				end if;

				if(count2 = 13) then
					--converts binary to decimal
					--op1_val is decreased by 1 (-49 instead of -48) in order to be used as an array key
					op1_val :=
						16 * (character'pos(op1(0)) - 48) + 
						8 * (character'pos(op1(1)) - 48) + 
						4 * (character'pos(op1(2)) - 48) + 
						2 * (character'pos(op1(3)) - 48) + 
						character'pos(op1(4)) - 49;
					op2_val := 
						16 * (character'pos(op2(0)) - 48) + 
						8 * (character'pos(op2(1)) - 48) + 
						4 * (character'pos(op2(2)) - 48) + 
						2 * (character'pos(op2(3)) - 48) + 
						character'pos(op2(4)) - 48;

					--performs the operation and stores the value into the register array
					case instr is
						when "0000" =>
							--LOAD
							F <= '1';
							registers(op1_val) := op2_val;
						when "0001" =>
							--ADD_R
							registers(op1_val) := registers(op1_val) + registers(op2_val - 1);
						when "0010" =>
							--ADD_I
							registers(op1_val) := registers(op1_val) + op2_val;
						when "0011" =>
							--SUB_R
							registers(op1_val) := registers(op1_val) - registers(op2_val - 1);
						when "0100" =>
							--SUB_I
							registers(op1_val) := registers(op1_val) - op2_val;
						when "0101" =>
							--MUL_R
							registers(op1_val) := registers(op1_val) * registers(op2_val - 1);
						when "0110" =>
							--MUL_I
							registers(op1_val) := registers(op1_val) * op2_val;
						when "0111" =>
							--DIV_R
							registers(op1_val) := registers(op1_val) / registers(op2_val - 1);
						when "1000" =>
							--DIV_I
							registers(op1_val) := registers(op1_val) / op2_val;
						when "1001" =>
							--MOD_R
							registers(op1_val) := registers(op1_val) mod registers(op2_val - 1);
						when "1010" =>
							--MOD_I
							registers(op1_val) := registers(op1_val) mod op2_val;
						when others =>
							--NO INSTRUCTION
					end case;
				end if;
			end loop;

		count1 := count1 + 1;

		--closes file after reading 15 lines
		else
			file_close(fp);
		end if;
	end if;
  end process;
end testarch;

