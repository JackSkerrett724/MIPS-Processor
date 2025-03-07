-------------------------------------------------
--  File:          InstructionDecodeTB.vhd
--
--  Entity:        InstructionDecodeTB
--  Architecture:  testbench
--  Author:        Jason Blocklove
--  Created:       09/04/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 testbench for InstructionDecode
--                 stage
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionDecodeTB is
end InstructionDecodeTB;

architecture testbench of InstructionDecodeTB is

type test_vector is record
	Instruction	 : std_logic_vector(31 downto 0);
	RegWriteAddr : std_logic_vector(4 downto 0);
	RegWriteData : std_logic_vector(31 downto 0);
	RegWriteEn	 : std_logic;
	RegWrite	 : std_logic;
	MemtoReg	 : std_logic;
	MemWrite	 : std_logic;
	ALUControl	 : std_logic_vector(3 downto 0);
	ALUSrc		 : std_logic;
	RegDst		 : std_logic;
	RD1, RD2	 : std_logic_vector(31 downto 0);
	RtDest		 : std_logic_vector(4 downto 0);
	RdDest		 : std_logic_vector(4 downto 0);
	ImmOut		 : std_logic_vector(31 downto 0);
end record;

type test_array is array (natural range <>) of test_vector;
constant test_vector_array : test_array := (
--NOOP
	(Instruction => x"00000000",
	RegWriteAddr => "00000",
	RegWriteData => x"00000000",
	RegWriteEn => '0',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "1100",
	ALUSrc => '0',
	RegDst => '1',
	RD1 => x"00000000",
	RD2 => x"00000000",
	RtDest => "00000",
	RdDest => "00000",
	ImmOut => x"00000000"),
--ADD R1, R1, R2 - 00000000001000010001000000100000
	(Instruction => x"00211020",
	RegWriteAddr => "00001",
	RegWriteData => x"12121212",
	RegWriteEn => '1',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "0100",
	ALUSrc => '0',
	RegDst => '1',
	RD1 => x"00000000",
	RD2 => x"00000000",
	RtDest => "00001",
	RdDest => "00010",
	ImmOut => x"00001020"),
--ADDI R1, R1, 13 - 001000 00001 00001 0000000000001101
	(Instruction => x"2021000d",
	RegWriteAddr => "00010",
	RegWriteData => x"00000001",
	RegWriteEn => '1',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "0100",
	ALUSrc => '1',
	RegDst => '0',
	RD1 => x"12121212",
	RD2 => x"12121212",
	RtDest => "00001",
	RdDest => "00000",
	ImmOut => x"0000000d"),
	--XOR R2, R1, R2 000000 00001 00010 00010 00000 100110
	(Instruction => x"00221026",
	RegWriteAddr => "00010",
	RegWriteData => x"00000001",
	RegWriteEn => '1',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "1011",
	ALUSrc => '0',
	RegDst => '1',
	RD1 => x"12121212",
	RD2 => x"00000001",
	RtDest => "00010",
	RdDest => "00010",
	ImmOut => x"00001026"),
	--LW, R2, 16(R1) 100011 00001 00010 0000000000010110
	(Instruction => x"8C220016",
	RegWriteAddr => "00010",
	RegWriteData => x"00000001",
	RegWriteEn => '1',
	RegWrite => '1',
	MemtoReg => '1',
	MemWrite => '0',
	ALUControl => "0100",
	ALUSrc => '1',
	RegDst => '0',
	RD1 => x"12121212",
	RD2 => x"00000001",
	RtDest => "00010",
	RdDest => "00000",
	ImmOut => x"00000016")

);

component InstructionDecode is
	port(
	--------- INPUTS ------------------
		--Main Input
		Instruction	: in std_logic_vector(31 downto 0);

		--CLK
		clk			: in std_logic;

		--WB Inputs
		RegWriteAddr : in std_logic_vector(4 downto 0);
		RegWriteData : in std_logic_vector(31 downto 0);
		RegWriteEn	: in std_logic;

	---------- OUTPUTS ----------------
		--Cotrol Unit Outputs
		RegWrite	: out std_logic;
		MemtoReg	: out std_logic;
		MemWrite	: out std_logic;
		ALUControl	: out std_logic_vector(3 downto 0);
		ALUSrc		: out std_logic;
		RegDst		: out std_logic;

		--Register File Outputs
		RD1, RD2	: out std_logic_vector(31 downto 0);

		--Other Outputs
		RtDest		: out std_logic_vector(4 downto 0);
		RdDest		: out std_logic_vector(4 downto 0);
		ImmOut		: out std_logic_vector(31 downto 0)
	);
end component;

signal Instruction	: std_logic_vector(31 downto 0);
signal clk			: std_logic;
signal RegWriteAddr : std_logic_vector(4 downto 0);
signal RegWriteData : std_logic_vector(31 downto 0);
signal RegWriteEn	: std_logic;
signal RegWrite		: std_logic;
signal MemtoReg		: std_logic;
signal MemWrite		: std_logic;
signal ALUControl	: std_logic_vector(3 downto 0);
signal ALUSrc		: std_logic;
signal RegDst		: std_logic;
signal RD1, RD2		: std_logic_vector(31 downto 0);
signal RtDest		: std_logic_vector(4 downto 0);
signal RdDest		: std_logic_vector(4 downto 0);
signal ImmOut		: std_logic_vector(31 downto 0);

begin


UUT : InstructionDecode
	port map (
	--------- INPUTS ------------------
		--Main Input
		Instruction	 => Instruction,
		--CLK
		clk			 => clk,
		--WB Inputs
		RegWriteAddr  => RegWriteAddr,
		RegWriteData  => RegWriteData,
		RegWriteEn	 => RegWriteEn,
	---------- OUTPUTS ----------------
		--Cotrol Unit Outputs
		RegWrite	 => RegWrite,
		MemtoReg	 => MemtoReg,
		MemWrite	 => MemWrite,
		ALUControl	 => ALUControl,
		ALUSrc		 => ALUSrc,
		RegDst		 => RegDst,
		--Register File Outputs
		RD1 => RD1,
		RD2 => RD2,
		--Other Outputs
		RtDest		 => RtDest,
		RdDest		 => RdDest,
		ImmOut		 => ImmOut
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
	wait until clk='0';
	for i in 0 to 4 loop --TODO: update to number of test vectors
		wait until clk='1';
		Instruction <= test_vector_array(i).Instruction;
		RegWriteAddr <= test_vector_array(i).RegWriteAddr;
		RegWriteData <= test_vector_array(i).RegWriteData;
		RegWriteEn <= test_vector_array(i).RegWriteEn;
		wait until clk='0';
    	wait for 5 ns;
--TODO:	assert statements
    assert RegWrite = test_vector_array(i).RegWrite
        report "RegWrite test failed" severity failure;
        
    assert MemtoReg = test_vector_array(i).MemtoReg
        report "MemToReg Test Failed" severity failure;
    
    assert MemWrite = test_vector_array(i).MemWrite
        report "MemWrite Test Failed" severity failure;
    
    assert ALUControl = test_vector_array(i).ALUControl
        report "ALUControl Test Failed" severity failure;
        
    assert ALUSrc = test_vector_array(i).ALUSrc
        report "ALUSrc Test Failed" severity failure;
    
    assert RegDst = test_vector_array(i).RegDst
        report "RegDst Test Failed" severity failure;
        
    assert RD1 = test_vector_array(i).RD1
        report "RD1 Test Failed" severity failure;
    
    assert RD2 = test_vector_array(i).RD2
        report "RD2 Test Failed" severity failure;
        
    assert RtDest = test_vector_array(i).RtDest
        report "RtDest Test Failed" severity failure;
        
    assert RdDest = test_vector_array(i).RdDest
        report "RdDest Test Failed" severity failure;
        
    assert ImmOut = test_vector_array(i).ImmOut
        report "ImmOut Test Failed" severity failure;
	end loop;
	wait until clk='0';

    assert false
        report "Testbench Concluded"
        severity failure;
end process;

end testbench;
