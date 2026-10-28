library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
    Port ( D0  : in  STD_LOGIC;
           D1  : in  STD_LOGIC;
           SEL : in  STD_LOGIC;
           Y   : out STD_LOGIC);
end mux2;

architecture Behavioral of mux2 is
begin
    Y <= D1 when SEL = '1' else D0;
end Behavioral;