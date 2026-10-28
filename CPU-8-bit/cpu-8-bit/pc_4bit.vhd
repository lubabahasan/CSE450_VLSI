library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_4bit is
    Port ( CLK     : in  STD_LOGIC;
           RESET   : in  STD_LOGIC;
           LOAD    : in  STD_LOGIC;
           ADDR_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           PC_OUT  : out STD_LOGIC_VECTOR (3 downto 0));
end pc_4bit;

architecture Structural of pc_4bit is

    component register_4bit is
        Port ( CLK   : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               LOAD  : in  STD_LOGIC;
               D     : in  STD_LOGIC_VECTOR (3 downto 0);
               Q     : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component adder_4bit is
        Port ( A    : in  STD_LOGIC_VECTOR (3 downto 0);
               B    : in  STD_LOGIC_VECTOR (3 downto 0);
               CIN  : in  STD_LOGIC;
               SUM  : out STD_LOGIC_VECTOR (3 downto 0);
               COUT : out STD_LOGIC);
    end component;

    component mux2 is
        Port ( D0  : in  STD_LOGIC;
               D1  : in  STD_LOGIC;
               SEL : in  STD_LOGIC;
               Y   : out STD_LOGIC);
    end component;

    signal PC_CURRENT : STD_LOGIC_VECTOR (3 downto 0);
    signal PC_PLUS1   : STD_LOGIC_VECTOR (3 downto 0);
    signal PC_NEXT    : STD_LOGIC_VECTOR (3 downto 0);
    signal INC_COUT   : STD_LOGIC;

begin

    -- PC + 1 (carry out unused, so the count wraps from 15 to 0)
    INC : adder_4bit
        port map ( A    => PC_CURRENT,
                   B    => "0001",
                   CIN  => '0',
                   SUM  => PC_PLUS1,
                   COUT => INC_COUT );

    -- choose PC + 1 or the branch address
    GEN_SEL : for i in 0 to 3 generate
        MX : mux2 port map ( D0  => PC_PLUS1(i),
                             D1  => ADDR_IN(i),
                             SEL => LOAD,
                             Y   => PC_NEXT(i) );
    end generate;

    -- PC register, loads its next value on every clock edge
    PCREG : register_4bit
        port map ( CLK   => CLK,
                   RESET => RESET,
                   LOAD  => '1',
                   D     => PC_NEXT,
                   Q     => PC_CURRENT );

    PC_OUT <= PC_CURRENT;

end Structural;
