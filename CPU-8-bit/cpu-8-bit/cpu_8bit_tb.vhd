library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_8bit_tb is
end cpu_8bit_tb;

architecture Behavioral of cpu_8bit_tb is

    component cpu_8bit is
        Port ( CLK   : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               Q     : out STD_LOGIC_VECTOR (7 downto 0);
               Z     : out STD_LOGIC;
               PC    : out STD_LOGIC_VECTOR (3 downto 0);
               R_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal CLK   : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '1';
    signal Q     : STD_LOGIC_VECTOR (7 downto 0);
    signal Z     : STD_LOGIC;
    signal PC    : STD_LOGIC_VECTOR (3 downto 0);
    signal R_OUT : STD_LOGIC_VECTOR (7 downto 0);

    signal RUNNING : BOOLEAN := TRUE;

begin

    UUT : cpu_8bit
        port map ( CLK   => CLK,
                   RESET => RESET,
                   Q     => Q,
                   Z     => Z,
                   PC    => PC,
                   R_OUT => R_OUT );

    -- clock, 20 ns period
    CLK_PROC : process
    begin
        while RUNNING loop
            CLK <= '0';
            wait for 10 ns;
            CLK <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    STIM : process
    begin

        -- reset
        RESET <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"00"  report "RESET: accumulator not cleared"    severity error;
        assert R_OUT = x"00" report "RESET: R not cleared"           severity error;
        assert Z = '1'    report "RESET: zero flag should be 1"      severity error;
        assert PC = "0000" report "RESET: PC not cleared"            severity error;
        RESET <= '0';

        -- cycle 1: LDI 0x1E  ->  ACC = 1E
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"1E"   report "LDI 0x1E failed"                  severity error;
        assert Z = '0'     report "LDI 0x1E: Z should be 0"          severity error;
        assert PC = "0001" report "PC did not advance to 1"          severity error;

        -- cycle 2: STA  ->  R = 1E
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert R_OUT = x"1E" report "STA failed, R should be 1E"     severity error;
        assert Q = x"1E"   report "STA must not change the ACC"      severity error;
        assert PC = "0010" report "PC did not advance to 2"          severity error;

        -- cycle 3: ADD 0x22  ->  ACC = 40
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"40"   report "ADD 0x22 failed, expected 40"     severity error;
        assert Z = '0'     report "ADD 0x22: Z should be 0"          severity error;

        -- cycle 4: AND 0x60  ->  ACC = 40
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"40"   report "AND 0x60 failed, expected 40"     severity error;

        -- cycle 5: LDR  ->  ACC = 1E
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"1E"   report "LDR failed, expected 1E"          severity error;

        -- cycle 6: ADD 0x01  ->  ACC = 1F
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"1F"   report "ADD 0x01 failed, expected 1F"     severity error;

        -- cycle 7: AND 0x0F  ->  ACC = 0F
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"0F"   report "AND 0x0F failed, expected 0F"     severity error;

        -- cycle 8: STA  ->  R = 0F
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert R_OUT = x"0F" report "STA failed, R should be 0F"     severity error;
        assert Q = x"0F"   report "STA must not change the ACC"      severity error;

        -- cycle 9: LDI 0x00  ->  ACC = 00, Z = 1
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"00"   report "LDI 0x00 failed"                  severity error;
        assert Z = '1'     report "zero flag did not set on ACC = 0" severity error;

        -- cycle 10: LDR  ->  ACC = 0F, Z = 0
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"0F"   report "LDR failed, expected 0F"          severity error;
        assert Z = '0'     report "zero flag did not clear"          severity error;
        assert PC = "1010" report "PC did not advance to 10"         severity error;

        report "All test cases passed successfully." severity note;

        RUNNING <= FALSE;
        wait;

    end process;

end Behavioral;
