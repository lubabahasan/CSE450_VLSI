library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
    Port ( D0  : in  STD_LOGIC;
           D1  : in  STD_LOGIC;
           D2  : in  STD_LOGIC;
           D3  : in  STD_LOGIC;
           SEL : in  STD_LOGIC_VECTOR (1 downto 0);
           Y   : out STD_LOGIC);
end mux4;

architecture Behavioral of mux4 is
begin
    process (D0, D1, D2, D3, SEL)
    begin
        case SEL is
            when "00"   => Y <= D0;
            when "01"   => Y <= D1;
            when "10"   => Y <= D2;
            when "11"   => Y <= D3;
            when others => Y <= '0';
        end case;
    end process;
end Behavioral;