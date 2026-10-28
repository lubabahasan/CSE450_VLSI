library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity program_rom is
    Port ( ADDR  : in  STD_LOGIC_VECTOR (3 downto 0);
           INSTR : out STD_LOGIC_VECTOR (11 downto 0));
end program_rom;

architecture Behavioral of program_rom is
begin

    with ADDR select
        INSTR <= x"11E" when "0000",   -- LDI 0x1E
                 x"A00" when "0001",   -- STA
                 x"222" when "0010",   -- ADD 0x22
                 x"460" when "0011",   -- AND 0x60
                 x"B00" when "0100",   -- LDR
                 x"201" when "0101",   -- ADD 0x01
                 x"40F" when "0110",   -- AND 0x0F
                 x"A00" when "0111",   -- STA
                 x"100" when "1000",   -- LDI 0x00
                 x"B00" when "1001",   -- LDR
                 x"000" when others;   -- NOP

end Behavioral;
