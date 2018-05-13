library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.numeric_std.all;

entity readfile is
	port(
		clk : in std_logic;
		F, D, E, W, M, SF, UF, OvF, ZF : out std_logic;
		pc0, pc1, pc2, pc3 : out std_logic);
end readfile;

architecture testarch of readfile is
begin
	process (clk)
	  	--array definitions
	  	type int_array is array(0 to 31) of integer;
	  	type char4_array is array(0 to 3) of character;
	  	type char5_array is array(0 to 4) of character;
	  	type boolean_array is array(0 to 4) of boolean;

	  	--variable declarations
	    file fp : text;
	    variable line_buf : line := null;
	    variable i : integer;
	    variable stage_checker : boolean_array;
	    variable do_stage : boolean_array;
	    variable registers : int_array;
	    variable instr : char4_array;
	    variable op1 :  char5_array;
	    variable op2 :  char5_array;
	    variable operation : integer;
	    variable op1_val : integer;
	    variable op2_val :  integer;
	    variable target_register :  integer;
	    variable output_value :  integer;
	    variable char : character := '0';
	    variable space : character;
	    variable init : integer := 0;
	    variable count1 : integer := 0;
	    variable val : integer := 0;
	    variable counter : integer := 1;
	begin
	  	--Initilization
	  	if(init = 0) then
	  		init := 1;
			file_open(fp, "test.txt", READ_MODE);

		    for count in 0 to 31 loop
		    	registers(count) := 0;
		    end loop;
		    for count in 0 to 4 loop
		    	stage_checker(count) := false;
		    	do_stage(count) := false;
		    end loop;
		end if;

		if rising_edge(clk) then

			--MEMORY
			if(do_stage(4) = true) then
				M <= '1';
				stage_checker(4) := true;
				do_stage(4) := false;
			end if;

			--WRITEBACK
			if(do_stage(3) = true) then
				registers(target_register) := output_value;

				W <= '1';
				stage_checker(3) := true;
				do_stage(3) := false;
				do_stage(4) := true;
			end if;

			--EXECUTE
			--performs the operation and stores the value into the register array
			if(do_stage(2) = true) then
				target_register := op1_val;
				case operation is
					when 0 =>
						--LOAD
						output_value := op2_val;
					when 1 =>
						--ADD_R
						output_value := registers(target_register) + registers(op2_val - 1);
					when 2 =>
						--ADD_I
						output_value := registers(target_register) + op2_val;
					when 3 =>
						--SUB_R
						output_value := registers(target_register) - registers(op2_val - 1);
					when 4 =>
						--SUB_I
						output_value := registers(target_register) - op2_val;
					when 5 =>
						--MUL_R
						output_value := registers(target_register) * registers(op2_val - 1);
					when 6 =>
						--MUL_I
						output_value := registers(target_register) * op2_val;
					when 7 =>
						--DIV_R
						output_value := registers(target_register) / registers(op2_val - 1);
					when 8 =>
						--DIV_I
						output_value := registers(target_register) / op2_val;
					when 9 =>
						--MOD_R
						output_value := registers(target_register) mod registers(op2_val - 1);
					when 10 =>
						--MOD_I
						output_value := registers(target_register) mod op2_val;
					when others =>
						--NO INSTRUCTION
				end case;

				if(output_value > 4) then
					OvF <= '1';
				end if;
				if(output_value >= 0) then
					SF <= '1';
				end if;
				if(output_value = 0) then
					ZF <= '1';
				end if;
				if(output_value < 0) then
					UF <= '1';
				end if;

				E <= '1';
				stage_checker(2) := true;
				do_stage(2) := false;
				do_stage(3) := true;
			end if;

			--DECODE
			if(do_stage(1) = true) then
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

				case instr is
					when "0000" =>
						--LOAD
						operation := 0;
					when "0001" =>
						--ADD_R
						operation := 1;
					when "0010" =>
						--ADD_I
						operation := 2;
					when "0011" =>
						--SUB_R
						operation := 3;
					when "0100" =>
						--SUB_I
						operation := 4;
					when "0101" =>
						--MUL_R
						operation := 5;
					when "0110" =>
						--MUL_I
						operation := 6;
					when "0111" =>
						--DIV_R
						operation := 7;
					when "1000" =>
						--DIV_I
						operation := 8;
					when "1001" =>
						--MOD_R
						operation := 9;
					when "1010" =>
						--MOD_I
						operation := 10;
					when others =>
						--NO INSTRUCTION
						operation := -1;
				end case;
				
				D <= '1';
				stage_checker(1) := true;
				do_stage(1) := false;
				do_stage(2) := true;
			end if;

			--FETCH
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

				end loop;

				F <= '1';
				stage_checker(0) := true;
				do_stage(1) := true;
				count1 := count1 + 1;

			--closes file after reading 15 lines
			else
				file_close(fp);
			end if;

			--PC
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
			if(stage_checker(4) = true) then
				M <= '0';
				stage_checker(4) := false;
			end if;
			if(stage_checker(3) = true) then
				W <= '0';
				stage_checker(3) := false;
			end if;
			if(stage_checker(2) = true) then
				E <= '0';
				stage_checker(2) := false;
			end if;
			if(stage_checker(1) = true) then
				D <= '0';
				stage_checker(1) := false;
			end if;
			F <= '0';
			stage_checker(0) := false;
			SF <= '0';
			UF <= '0';
			OvF <= '0';
			ZF <= '0';
			pc0 <= '0';
			pc1 <= '0';
			pc2 <= '0';
			pc3 <= '0';
		end if;
	end process;
end testarch;