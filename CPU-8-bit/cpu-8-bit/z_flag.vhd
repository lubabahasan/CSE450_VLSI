library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity z_flag is
    Port ( CLK     : in  STD_LOGIC;
           RESET   : in  STD_LOGIC;
           LOAD    : in  STD_LOGIC;
           ZERO_IN : in  STD_LOGIC;
           Z       : out STD_LOGIC);
end z_flag;

architecture Structural of z_flag is

    component register_1bit is
        Port ( CLK   : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               LOAD  : in  STD_LOGIC;
               D     : in  STD_LOGIC;
               Q     : out STD_LOGIC);
    end component;

    component not_gate is
        Port ( A : in  STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    signal NZ_IN  : STD_LOGIC;
    signal NZ_OUT : STD_LOGIC;

begin

    -- the register stores the inverse of Z (NZ), because register_1bit
    -- resets to '0' and Z must be 1 after reset
    N_IN  : not_gate port map ( A => ZERO_IN, Y => NZ_IN );

    FLAG  : register_1bit
        port map ( CLK   => CLK,
                   RESET => RESET,
                   LOAD  => LOAD,
                   D     => NZ_IN,
                   Q     => NZ_OUT );

    N_OUT : not_gate port map ( A => NZ_OUT, Y => Z );

end Structural;
