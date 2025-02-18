----------------------------------------------------------------------------------
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.globals.all;

entity alu32TB is
end alu32TB;

architecture tb of alu32TB is

constant N : integer := 32;
constant M : integer := 5;

type testRecord is record
    a , b , y : std_logic_vector (N -1 downto 0) ;
    op : std_logic_vector (3 downto 0) ;
end record ;
-- Array of all tests .
-- Format : ( A , B , Y , OP )
constant num_tests: integer := 43 ;
type testArr is array (0 to num_tests-1) of testRecord;

constant testVectorArray : testArr := (
--OR
    (a=> x"000000F0", b=> x"0000000F", y=> x"000000FF", op=> x"8"),
    (a=> x"0000000F", b=> x"00000001", y=> x"0000000F", op=> x"8"),
    (a=> x"0000000A", b=> x"00000003", y=> x"0000000B", op=> x"8"),
    (a=> x"FFFFFFFF", b=> x"A00B00C0", y=> x"FFFFFFFF", op=> x"8"),
--AND
    (a=> x"000000F0", b=> x"0000000F", y=> x"00000000", op=> x"A"),
    (a=> x"000000FF", b=> x"0000000F", y=> x"0000000F", op=> x"A"),
    (a=> x"A00000F0", b=> x"A000000F", y=> x"A0000000", op=> x"A"),
    (a=> x"0000000A", b=> x"00000003", y=> x"00000002", op=> x"A"),
--XOR
    (a=> x"000000F0", b=> x"0000000F", y=> x"000000FF", op=> x"B"),
    (a=> x"000000FF", b=> x"0000000F", y=> x"000000F0", op=> x"B"),
    (a=> x"0000000A", b=> x"00000005", y=> x"0000000F", op=> x"B"),
    (a=> x"0000000A", b=> x"00000003", y=> x"00000009", op=> x"B"),
--SLL
    (a=> x"0000000F", b=> x"00000004", y=> x"000000F0", op=> x"C"),
    (a=> x"000000FF", b=> x"0000000F", y=> x"007F8000", op=> x"C"),
    (a=> x"00000002", b=> x"00000001", y=> x"00000004", op=> x"C"),
    (a=> x"0000000A", b=> x"00000003", y=> x"00000050", op=> x"C"),
--SRL
    (a=> x"0000000F", b=> x"00000002", y=> x"00000003", op=> x"D"),
    (a=> x"F0000000", b=> x"0000001C", y=> x"0000000F", op=> x"D"),
    (a=> x"0000000A", b=> x"00000001", y=> x"00000005", op=> x"D"),
    (a=> x"0000000C", b=> x"00000002", y=> x"00000003", op=> x"D"),
--SRA
    (a=> x"0000000F", b=> x"00000002", y=> x"00000003", op=> x"E"),
    (a=> x"F0000000", b=> x"0000001C", y=> x"FFFFFFFF", op=> x"E"),
    (a=> x"0000000A", b=> x"00000001", y=> x"00000005", op=> x"E"),
    (a=> x"C000000C", b=> x"00000002", y=> x"F0000003", op=> x"E"),
--Edge Cases
    (a=> x"00000006", b=> x"00000002", y=> x"00000001", op=> x"D"),
    (a=> x"00000006", b=> x"00000001", y=> x"00000003", op=> x"E"),
    (a=> x"00000006", b=> x"00000002", y=> x"00000001", op=> x"E"),
    (a=> x"F0000000", b=> x"00000001", y=> x"F8000000", op=> x"E"),
    (a=> x"00000000", b=> x"00000000", y=> x"00000000", op=> x"8"),
    (a=> x"00000000", b=> x"0000000F", y=> x"0000000F", op=> x"8"),
    (a=> x"0000000F", b=> x"0000000F", y=> x"0000000F", op=> x"8"),
    (a=> x"00000005", b=> x"0000000A", y=> x"0000000F", op=> x"8"),
    (a=> x"0000000A", b=> x"00000005", y=> x"0000000F", op=> x"8"),
    (a=> x"00000000", b=> x"00000000", y=> x"00000000", op=> x"B"),
    (a=> x"00000000", b=> x"0000000F", y=> x"0000000F", op=> x"B"),
    (a=> x"0000000F", b=> x"00000000", y=> x"0000000F", op=> x"B"),
    (a=> x"0000000F", b=> x"0000000F", y=> x"00000000", op=> x"B"),
    (a=> x"00000005", b=> x"0000000A", y=> x"0000000F", op=> x"B"),
    (a=> x"0000000A", b=> x"00000005", y=> x"0000000F", op=> x"B"),
    (a=> x"00000000", b=> x"00000000", y=> x"00000000", op=> x"A"),
    (a=> x"00000000", b=> x"0000000F", y=> x"00000000", op=> x"A"),
    (a=> x"0000000F", b=> x"00000000", y=> x"00000000", op=> x"A"),
    (a=> x"0000000F", b=> x"0000000F", y=> x"0000000F", op=> x"A")
) ;

    component alu32 is
        generic (N: integer := 32;
                 M: integer := 5);
        port(
            A: in std_logic_vector(N-1 downto 0);
            B: in std_logic_vector(N-1 downto 0);
            OP: in std_logic_vector(3 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
            );
    end component;

constant delay : time := 20 ns ;
signal A, B, Y: std_logic_vector(N-1 downto 0) := (others => '0');
signal OP     : std_logic_vector(3 downto 0) := (others => '0');
begin

UUT: alu32
    generic map (N => N, M => M)
    port map(A => A,
            B => B,
            OP => OP,
            Y => Y);


stim_proc:process
begin
    for i in 0 to num_tests-1 loop

        A <= testVectorArray(i).a;
        B <= testVectorArray(i).b;
        OP <= testVectorArray(i).op;
        wait for delay;
        
        assert testVectorArray(i).y = y
            report "Test failed"
        severity failure;
    end loop;

	assert false
		report "Testbench Concluded"
		severity failure;
    
    end process;
end tb;
