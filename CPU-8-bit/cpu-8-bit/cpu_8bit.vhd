library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_8bit is
    Port ( CLK   : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q     : out STD_LOGIC_VECTOR (7 downto 0);   -- accumulator
           Z     : out STD_LOGIC;                       -- zero flag
           PC    : out STD_LOGIC_VECTOR (3 downto 0);   -- program counter
           R_OUT : out STD_LOGIC_VECTOR (7 downto 0));  -- data register
end cpu_8bit;

architecture Structural of cpu_8bit is

    component pc_4bit is
        Port ( CLK     : in  STD_LOGIC;
               RESET   : in  STD_LOGIC;
               LOAD    : in  STD_LOGIC;
               ADDR_IN : in  STD_LOGIC_VECTOR (3 downto 0);
               PC_OUT  : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component program_rom is
        Port ( ADDR  : in  STD_LOGIC_VECTOR (3 downto 0);
               INSTR : out STD_LOGIC_VECTOR (11 downto 0));
    end component;

    component control_unit is
        Port ( OPCODE   : in  STD_LOGIC_VECTOR (3 downto 0);
               ALU_SEL  : out STD_LOGIC_VECTOR (1 downto 0);
               B_SEL    : out STD_LOGIC;
               ACC_LOAD : out STD_LOGIC;
               R_LOAD   : out STD_LOGIC;
               Z_LOAD   : out STD_LOGIC;
               PC_LOAD  : out STD_LOGIC);
    end component;

    component cpu_alu is
        Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
               B      : in  STD_LOGIC_VECTOR (7 downto 0);
               SEL    : in  STD_LOGIC_VECTOR (1 downto 0);
               RESULT : out STD_LOGIC_VECTOR (7 downto 0);
               ZERO   : out STD_LOGIC);
    end component;

    component register_8bit is
        Port ( CLK   : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               LOAD  : in  STD_LOGIC;
               D     : in  STD_LOGIC_VECTOR (7 downto 0);
               Q     : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component z_flag is
        Port ( CLK     : in  STD_LOGIC;
               RESET   : in  STD_LOGIC;
               LOAD    : in  STD_LOGIC;
               ZERO_IN : in  STD_LOGIC;
               Z       : out STD_LOGIC);
    end component;

    component mux2 is
        Port ( D0  : in  STD_LOGIC;
               D1  : in  STD_LOGIC;
               SEL : in  STD_LOGIC;
               Y   : out STD_LOGIC);
    end component;

    -- fetch / decode
    signal PC_ADDR  : STD_LOGIC_VECTOR (3 downto 0);
    signal INSTR    : STD_LOGIC_VECTOR (11 downto 0);
    signal OPCODE   : STD_LOGIC_VECTOR (3 downto 0);
    signal OPERAND  : STD_LOGIC_VECTOR (7 downto 0);

    -- control lines
    signal ALU_SEL  : STD_LOGIC_VECTOR (1 downto 0);
    signal B_SEL    : STD_LOGIC;
    signal ACC_LOAD : STD_LOGIC;
    signal R_LOAD   : STD_LOGIC;
    signal Z_LOAD   : STD_LOGIC;
    signal PC_LOAD  : STD_LOGIC;

    -- datapath
    signal ALU_B    : STD_LOGIC_VECTOR (7 downto 0);
    signal ALU_RES  : STD_LOGIC_VECTOR (7 downto 0);
    signal ALU_ZERO : STD_LOGIC;
    signal ACC_VAL  : STD_LOGIC_VECTOR (7 downto 0);
    signal R_VAL    : STD_LOGIC_VECTOR (7 downto 0);

begin

    -- fetch
    U_PC : pc_4bit
        port map ( CLK     => CLK,
                   RESET   => RESET,
                   LOAD    => PC_LOAD,
                   ADDR_IN => OPERAND(3 downto 0),
                   PC_OUT  => PC_ADDR );

    U_ROM : program_rom
        port map ( ADDR  => PC_ADDR,
                   INSTR => INSTR );

    OPCODE  <= INSTR(11 downto 8);
    OPERAND <= INSTR(7 downto 0);

    -- decode
    U_CTRL : control_unit
        port map ( OPCODE   => OPCODE,
                   ALU_SEL  => ALU_SEL,
                   B_SEL    => B_SEL,
                   ACC_LOAD => ACC_LOAD,
                   R_LOAD   => R_LOAD,
                   Z_LOAD   => Z_LOAD,
                   PC_LOAD  => PC_LOAD );

    -- operand mux: immediate, or R for LDR
    GEN_BMUX : for i in 0 to 7 generate
        BM : mux2 port map ( D0  => OPERAND(i),
                             D1  => R_VAL(i),
                             SEL => B_SEL,
                             Y   => ALU_B(i) );
    end generate;

    -- execute
    U_ALU : cpu_alu
        port map ( A      => ACC_VAL,
                   B      => ALU_B,
                   SEL    => ALU_SEL,
                   RESULT => ALU_RES,
                   ZERO   => ALU_ZERO );

    -- write back
    U_ACC : register_8bit
        port map ( CLK   => CLK,
                   RESET => RESET,
                   LOAD  => ACC_LOAD,
                   D     => ALU_RES,
                   Q     => ACC_VAL );

    U_R : register_8bit
        port map ( CLK   => CLK,
                   RESET => RESET,
                   LOAD  => R_LOAD,
                   D     => ACC_VAL,
                   Q     => R_VAL );

    U_Z : z_flag
        port map ( CLK     => CLK,
                   RESET   => RESET,
                   LOAD    => Z_LOAD,
                   ZERO_IN => ALU_ZERO,
                   Z       => Z );

    -- outputs
    Q     <= ACC_VAL;
    PC    <= PC_ADDR;
    R_OUT <= R_VAL;

end Structural;
