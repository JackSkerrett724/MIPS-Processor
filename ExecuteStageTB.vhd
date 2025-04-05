----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 10:35:41 PM
-- Design Name: 
-- Module Name: ExecuteStageTB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ExecuteStage_TB IS
END ExecuteStage_TB;

ARCHITECTURE behavior OF ExecuteStage_TB IS

    -- Component Declaration for the Execute Stage
    COMPONENT ExecuteStage
        PORT (
            RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst: IN std_logic;
            ALUControl: IN std_logic_vector(3 DOWNTO 0);
            RtDest, RdDest: IN std_logic_vector(4 DOWNTO 0);
            RegSrcA, RegSrcB, SignImm: IN std_logic_vector(31 DOWNTO 0);
            RegWriteOut, MemtoRegOut, MemWriteOut: OUT std_logic;
            WriteReg: OUT std_logic_vector(4 DOWNTO 0);
            ALUResult, WriteData: OUT std_logic_vector(31 DOWNTO 0)
        );
    END COMPONENT;

    -- Signal Declarations
    SIGNAL RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst: std_logic;
    SIGNAL ALUControl: std_logic_vector(3 DOWNTO 0);
    SIGNAL RtDest, RdDest: std_logic_vector(4 DOWNTO 0);
    SIGNAL RegSrcA, RegSrcB, SignImm: std_logic_vector(31 DOWNTO 0);
    SIGNAL RegWriteOut, MemtoRegOut, MemWriteOut: std_logic;
    SIGNAL WriteReg: std_logic_vector(4 DOWNTO 0);
    SIGNAL ALUResult, WriteData: std_logic_vector(31 DOWNTO 0);

    -- Clock process (not required in this testbench, but can be useful)
    SIGNAL clk: std_logic := '0';
    CONSTANT clk_period: time := 10 ns;
BEGIN
    -- Instantiate the ExecuteStage Unit Under Test (UUT)
    uut: ExecuteStage PORT MAP (
        RegWrite => RegWrite,
        MemtoReg => MemtoReg,
        MemWrite => MemWrite,
        ALUSrc => ALUSrc,
        RegDst => RegDst,
        ALUControl => ALUControl,
        RtDest => RtDest,
        RdDest => RdDest,
        RegSrcA => RegSrcA,
        RegSrcB => RegSrcB,
        SignImm => SignImm,
        RegWriteOut => RegWriteOut,
        MemtoRegOut => MemtoRegOut,
        MemWriteOut => MemWriteOut,
        WriteReg => WriteReg,
        ALUResult => ALUResult,
        WriteData => WriteData
    );

    -- Clock process
    clk_process: PROCESS
    BEGIN
        WAIT FOR clk_period / 2;
        clk <= NOT clk;
    END PROCESS;

    -- Stimulus Process
    stim_proc: PROCESS
    BEGIN
        -- Initialize control signals
        RegWrite <= '1';
        MemtoReg <= '0';
        MemWrite <= '0';
        ALUSrc <= '0';
        RegDst <= '1';
        SignImm <= (others => '0');
        RtDest <= "10101";
        RdDest <= "01010";

        -- Test case: OR operation
        ALUControl <= "1000";
        RegSrcA <= X"0000000F";
        RegSrcB <= X"000000F0";
        WAIT FOR 20 ns;
        ASSERT ALUResult = X"000000FF" REPORT "OR operation failed" SEVERITY ERROR;

        -- Test case: AND operation
        ALUControl <= "1010";
        RegSrcA <= X"0000000F";
        RegSrcB <= X"000000F0";
        WAIT FOR 20 ns;
        ASSERT ALUResult = X"00000000" REPORT "AND operation failed" SEVERITY ERROR;

        -- Test case: XOR operation
        ALUControl <= "1011";
        RegSrcA <= X"0000000F";
        RegSrcB <= X"000000F0";
        WAIT FOR 20 ns;
        ASSERT ALUResult = X"000000FF" REPORT "XOR operation failed" SEVERITY ERROR;

        RegDst <= '0';
        ALUSrc <= '1';

        -- Test case: SLL (Shift Left Logical)
        ALUControl <= "1100";
        RegSrcA <= X"00000001";
        SignImm <= X"00000002";
        WAIT FOR 20 ns;
        ASSERT ALUResult = X"00000004" REPORT "SLL operation failed" SEVERITY ERROR;

        -- Test case: SRL (Shift Right Logical)
        ALUControl <= "1101";
        RegSrcA <= X"00000010";
        SignImm <= X"00000002";
        WAIT FOR 20 ns;
        ASSERT ALUResult = X"00000004" REPORT "SRL operation failed" SEVERITY failure;

        -- Test case: SRA (Shift Right Arithmetic)
        ALUControl <= "1110";
        RegSrcA <= X"80000000";
        SignImm <= X"00000002";
        WAIT FOR 20 ns;
        ASSERT ALUResult = X"E0000000" REPORT "SRA operation failed" SEVERITY failure;

        ALUSrc <= '0';
        
        -- Test case: ADD operation
        ALUControl <= "0100";
        RegSrcA <= X"00000005";
        RegSrcB <= X"00000003";
        WAIT FOR 20 ns;
        ASSERT ALUResult = X"00000008" REPORT "ADD operation failed" SEVERITY failure;

        -- Test case: SUB operation
        ALUControl <= "0101";
        RegSrcA <= X"00000008";
        RegSrcB <= X"00000002";
        WAIT FOR 20 ns;
        ASSERT ALUResult = X"00000006" REPORT "SUB operation failed" SEVERITY failure;

        -- End simulation
        REPORT "All tests completed successfully." SEVERITY failure;
  
    END PROCESS;
END behavior;
