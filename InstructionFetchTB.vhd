-------------------------------------------------
--  File:          InstructionFetchTB.vhd
--
--  Entity:        InstructionFetchTB
--  Architecture:  BEHAVIORAL
--  Author:        Jason Blocklove
--  Created:       07/26/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 Testbench for Instruction Fetch
--                 Stage
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionFetchTB is
end InstructionFetchTB;

architecture Behavioral of InstructionFetchTB is

type test_vector is record
	rst : std_logic;
	Instruction	 : std_logic_vector(31 downto 0);
end record;

--TODO: Add additional 5 cases to test table
type test_array is array (natural range <>) of test_vector;
constant test_vector_array : test_array := (
	(rst => '1', Instruction => x"00000000"), -- address 0, reset value
	(rst => '0', Instruction => x"11111111"), -- address 1
	(rst => '0', Instruction => x"22222222"), -- address 2
	(rst => '0', Instruction => x"1f2e3d4c"),  -- address 3
	(rst => '0', Instruction => x"43252515"),  -- address 4
	(rst => '0', Instruction => x"FFFFFFFF"),  -- address 5
	(rst => '0', Instruction => x"ABCDEF12"),  -- address 6
	(rst => '0', Instruction => x"98765432"),  -- address 7
	(rst => '0', Instruction => x"ABABABAB"),  -- address 8
	(rst => '0', Instruction => x"CA123445")  -- address 9
);

component InstructionFetch
  port (
    clk : in std_logic;
    rst : in std_logic;
    Instruction : out std_logic_vector(31 DOWNTO 0)
  );
end component;

	signal rst : std_logic;
	signal clk : std_logic;
	signal instruction : std_logic_vector(31 downto 0);


begin

uut : InstructionFetch
  port map (
    clk => clk,
    rst => rst,
    Instruction => Instruction
  );

clk_proc:process
begin
	clk <= '0';
	wait for 50 ns;
	clk <= '1';
	wait for 50 ns;
end process;

stim_proc:process
begin
  --TODO:	time for everything to reset
 -- wait for 100 ns;
  rst <= '1';
  wait until clk='1';
  wait until clk='0';

	for i in test_vector_array'range loop
		rst <= test_vector_array(i).rst;
		wait until clk='0';
		assert instruction = test_vector_array(i).Instruction;
			report "Test Passed";
	end loop;
	wait until clk='0';

	assert false
		report "Testbench Concluded"
		severity failure;


end process;

end Behavioral;
