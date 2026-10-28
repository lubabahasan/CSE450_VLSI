library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port ( OPCODE   : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_SEL  : out STD_LOGIC_VECTOR (1 downto 0);
           B_SEL    : out STD_LOGIC;
           ACC_LOAD : out STD_LOGIC;
           R_LOAD   : out STD_LOGIC;
           Z_LOAD   : out STD_LOGIC;
           PC_LOAD  : out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is
begin

    process (OPCODE)
    begin
        -- default: hold every register
        ALU_SEL  <= "11";
        B_SEL    <= '0';
        ACC_LOAD <= '0';
        R_LOAD   <= '0';
        Z_LOAD   <= '0';
        PC_LOAD  <= '0';

        case OPCODE is

            when "0001" =>              -- LDI
                ALU_SEL  <= "00";
                B_SEL    <= '0';
                ACC_LOAD <= '1';
                Z_LOAD   <= '1';

            when "0010" =>              -- ADD
                ALU_SEL  <= "01";
                B_SEL    <= '0';
                ACC_LOAD <= '1';
                Z_LOAD   <= '1';

            when "0100" =>              -- AND
                ALU_SEL  <= "10";
                B_SEL    <= '0';
                ACC_LOAD <= '1';
                Z_LOAD   <= '1';

            when "1010" =>              -- STA
                R_LOAD   <= '1';

            when "1011" =>              -- LDR
                ALU_SEL  <= "00";
                B_SEL    <= '1';
                ACC_LOAD <= '1';
                Z_LOAD   <= '1';

            when others =>              -- NOP
                null;

        end case;
    end process;

end Behavioral;
