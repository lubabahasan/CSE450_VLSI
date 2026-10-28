library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_4bit is
    Port ( CLK   : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           LOAD  : in  STD_LOGIC;
           D     : in  STD_LOGIC_VECTOR (3 downto 0);
           Q     : out STD_LOGIC_VECTOR (3 downto 0));
end register_4bit;

architecture Structural of register_4bit is

    component register_1bit is
        Port ( CLK   : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               LOAD  : in  STD_LOGIC;
               D     : in  STD_LOGIC;
               Q     : out STD_LOGIC);
    end component;

begin

    -- four 1-bit registers side by side
    REG0 : register_1bit port map (CLK => CLK, RESET => RESET, LOAD => LOAD, D => D(0), Q => Q(0));
    REG1 : register_1bit port map (CLK => CLK, RESET => RESET, LOAD => LOAD, D => D(1), Q => Q(1));
    REG2 : register_1bit port map (CLK => CLK, RESET => RESET, LOAD => LOAD, D => D(2), Q => Q(2));
    REG3 : register_1bit port map (CLK => CLK, RESET => RESET, LOAD => LOAD, D => D(3), Q => Q(3));

end Structural;
