----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Jack Skerrett
-- 
-- Create Date: 03/21/2025 05:01:01 PM
-- Design Name: ExecuteStage
-- Module Name: ExecuteStage - Behavioral
-- Project Name: Lab4
-- Target Devices: Basys3
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;

entity ExecuteStage is
    port(
         RegWrite,MemtoReg,MemWrite,ALUSrc,RegDst: in std_logic;
         ALUControl: in std_logic_vector(3 downto 0);
         RtDest,RdDest: in std_logic_vector(4 downto 0);
         RegSrcA, RegSrcB, SignImm: in std_logic_vector(31 downto 0);
         RegWriteOut, MemtoRegOut, MemWriteOut: out std_logic;
         WriteReg: out std_logic_vector(4 downto 0);
         ALUResult, WriteData: out std_logic_vector(31 downto 0));
end ExecuteStage;

architecture Behavioural of ExecuteStage is

signal ALUBInput: std_logic_vector(31 downto 0);

component ALU is
    port(
        A: in std_logic_vector(N-1 downto 0);
        B: in std_logic_vector(N-1 downto 0);
        OP: in std_logic_vector(3 downto 0);
        Y: out std_logic_vector(N-1 downto 0)
        );
end component ALU;

begin
--Write Reg
with RegDst select WriteReg <=
    RtDest when '0',
    RdDest when others;
---------------

process(ALUSrc, SignImm, RegSrcB)
begin
if ALUSrc = '1' then
    ALUBInput <= SignImm;
else
    ALUBInput <= RegSrcB;
end if;
end process;

RegWriteOut <= RegWrite;
MemtoRegOut <= MemtoReg;
MemWriteOut <= MemWrite;

WriteData <= RegSrcB;

ALUComp: ALU port map(RegSrcA, ALUBInput, ALUControl, ALUResult);

end Behavioural;