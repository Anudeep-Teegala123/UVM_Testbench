
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_4bit_tb is
end alu_4bit_tb;

architecture testbench of alu_4bit_tb is

    -- Component declaration
    component alu_4bit
        port (
            A        : in  signed(3 downto 0);
            B        : in  signed(3 downto 0);
            ALU_Sel  : in  std_logic_vector(2 downto 0);
            Result   : out signed(3 downto 0);
            Overflow : out std_logic;
            Zero     : out std_logic
        );
    end component;

    -- Signals to connect to ALU
    signal A        : signed(3 downto 0) := (others => '0');
    signal B        : signed(3 downto 0) := (others => '0');
    signal ALU_Sel  : std_logic_vector(2 downto 0) := "000";
    signal Result   : signed(3 downto 0);
    signal Overflow : std_logic;
    signal Zero     : std_logic;

begin

    -- Instantiate ALU
    uut: alu_4bit
        port map (
            A        => A,
            B        => B,
            ALU_Sel  => ALU_Sel,
            Result   => Result,
            Overflow => Overflow,
            Zero     => Zero
        );

    -- Test process
    stimulus_proc: process
    begin
        -- Test Addition: 3 + 4
        A <= to_signed(3, 4);
        B <= to_signed(4, 4);
        ALU_Sel <= "000";  -- ADD
        wait for 10 ns;

        -- Test Addition with Overflow: 7 + 3
        A <= to_signed(7, 4);
        B <= to_signed(3, 4);
        ALU_Sel <= "000";  -- ADD
        wait for 10 ns;

        -- Test Subtraction: 5 - 2
        A <= to_signed(5, 4);
        B <= to_signed(2, 4);
        ALU_Sel <= "001";  -- SUB
        wait for 10 ns;

        -- Test Subtraction with Overflow: -8 - 3
        A <= to_signed(-8, 4);
        B <= to_signed(3, 4);
        ALU_Sel <= "001";  -- SUB
        wait for 10 ns;

        -- Test AND
        A <= to_signed(6, 4); -- 0110
        B <= to_signed(3, 4); -- 0011
        ALU_Sel <= "010";
        wait for 10 ns;

        -- Test OR
        ALU_Sel <= "011";
        wait for 10 ns;

        -- Test XOR
        ALU_Sel <= "100";
        wait for 10 ns;

        -- Test Shift Left (Logical)
        A <= to_signed(2, 4); -- 0010
        ALU_Sel <= "101";
        wait for 10 ns;

        -- Test Shift Right (Arithmetic)
        A <= to_signed(-4, 4); -- 1100
        ALU_Sel <= "110";
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end testbench;