
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_4bit is
    port (
        A        : in  signed(3 downto 0);
        B        : in  signed(3 downto 0);
        ALU_Sel  : in  std_logic_vector(2 downto 0);
        Result   : out signed(3 downto 0);
        Overflow : out std_logic;
        Zero     : out std_logic
    );
end alu_4bit;

architecture Behavioral of alu_4bit is
    signal res_ext   : signed(4 downto 0);  -- 1 bit extended result to check overflow
    signal temp_res  : signed(3 downto 0);
    signal oflow     : std_logic := '0';
begin
    process(A, B, ALU_Sel)
    begin
        oflow   <= '0';
        res_ext <= (others => '0');

        case ALU_Sel is
            when "000" => -- A + B
                res_ext <= resize(A, 5) + resize(B, 5);
                temp_res <= res_ext(3 downto 0);

                -- Overflow detection for signed add
                if (A(3) = B(3)) and (res_ext(3) /= A(3)) then
                    oflow <= '1';
                end if;

            when "001" => -- A - B
                res_ext <= resize(A, 5) - resize(B, 5);
                temp_res <= res_ext(3 downto 0);

                -- Overflow detection for signed sub
                if (A(3) /= B(3)) and (res_ext(3) /= A(3)) then
                    oflow <= '1';
                end if;

            when "010" => -- A AND B
                temp_res <= A and B;

            when "011" => -- A OR B
                temp_res <= A or B;

            when "100" => -- A XOR B
                temp_res <= A xor B;

            when "101" => -- Shift Left A (logical)
                temp_res <= shift_left(A, 1); -- shift left logical

            when "110" => -- Shift Right A (arithmetic)
                temp_res <= shift_right(A, 1); -- arithmetic shift right

            when others =>
                temp_res <= (others => '0');
        end case;
    end process;

    Result   <= temp_res;
    Overflow <= oflow;
    Zero     <= '1' when temp_res = "0000" else '0';

end Behavioral;