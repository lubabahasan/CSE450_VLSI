library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_alu is
    Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
           B      : in  STD_LOGIC_VECTOR (7 downto 0);
           SEL    : in  STD_LOGIC_VECTOR (1 downto 0);
           RESULT : out STD_LOGIC_VECTOR (7 downto 0);
           ZERO   : out STD_LOGIC);
end cpu_alu;

architecture Structural of cpu_alu is

    component adder_8bit is
        Port ( A    : in  STD_LOGIC_VECTOR (7 downto 0);
               B    : in  STD_LOGIC_VECTOR (7 downto 0);
               CIN  : in  STD_LOGIC;
               SUM  : out STD_LOGIC_VECTOR (7 downto 0);
               COUT : out STD_LOGIC);
    end component;

    component and_gate is
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component or_gate is
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component not_gate is
        Port ( A : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component mux4 is
        Port ( D0  : in  STD_LOGIC;
               D1  : in  STD_LOGIC;
               D2  : in  STD_LOGIC;
               D3  : in  STD_LOGIC;
               SEL : in  STD_LOGIC_VECTOR (1 downto 0);
               Y   : out STD_LOGIC);
    end component;

    signal SUM_RES  : STD_LOGIC_VECTOR (7 downto 0);
    signal AND_RES  : STD_LOGIC_VECTOR (7 downto 0);
    signal RES_INT  : STD_LOGIC_VECTOR (7 downto 0);
    signal ADD_COUT : STD_LOGIC;
    signal OR_L1    : STD_LOGIC_VECTOR (3 downto 0);
    signal OR_L2    : STD_LOGIC_VECTOR (1 downto 0);
    signal OR_ALL   : STD_LOGIC;

begin

    -- A + B (carry out unused)
    ADD8 : adder_8bit
        port map ( A    => A,
                   B    => B,
                   CIN  => '0',
                   SUM  => SUM_RES,
                   COUT => ADD_COUT );

    -- bitwise A AND B
    GEN_AND : for i in 0 to 7 generate
        AG : and_gate port map ( A => A(i), B => B(i), Y => AND_RES(i) );
    end generate;

    -- result select: "00" B, "01" sum, "10" AND, "11" A
    GEN_MUX : for i in 0 to 7 generate
        MX : mux4 port map ( D0  => B(i),
                             D1  => SUM_RES(i),
                             D2  => AND_RES(i),
                             D3  => A(i),
                             SEL => SEL,
                             Y   => RES_INT(i) );
    end generate;

    -- zero detect: OR all result bits, then invert
    O0 : or_gate port map ( A => RES_INT(0), B => RES_INT(1), Y => OR_L1(0) );
    O1 : or_gate port map ( A => RES_INT(2), B => RES_INT(3), Y => OR_L1(1) );
    O2 : or_gate port map ( A => RES_INT(4), B => RES_INT(5), Y => OR_L1(2) );
    O3 : or_gate port map ( A => RES_INT(6), B => RES_INT(7), Y => OR_L1(3) );

    O4 : or_gate port map ( A => OR_L1(0), B => OR_L1(1), Y => OR_L2(0) );
    O5 : or_gate port map ( A => OR_L1(2), B => OR_L1(3), Y => OR_L2(1) );

    O6 : or_gate port map ( A => OR_L2(0), B => OR_L2(1), Y => OR_ALL );

    NZ : not_gate port map ( A => OR_ALL, Y => ZERO );

    RESULT <= RES_INT;

end Structural;
