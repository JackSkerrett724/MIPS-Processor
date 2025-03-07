----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Jack Skerrett
-- 
-- Create Date: 03/02/2025 03:47:25 PM
-- Module Name: InstructionDecode - Behavioral
-- Project Name: Lab3_Decode
-- Target Devices: Basys3
-- Description: 
-- Breaks the given instruction down into its different components to send to the register file and control unit 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;

entity InstructionDecode is
    port(--INPUTS
         clk, RegWriteEn: in std_logic;
         Instruction, RegWriteData: in std_logic_vector(31 downto 0);
         RegWriteAddr: in std_logic_vector(4 downto 0);
         --OUTPUTS
         RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst: out std_logic;
         ALUControl: out std_logic_vector(3 downto 0);
         RtDest, RdDest: out std_logic_vector(4 downto 0);
         RD1, RD2, ImmOut: out std_logic_vector(31 downto 0));
end InstructionDecode;

architecture Behavioral of InstructionDecode is
signal op: std_logic_vector(5 downto 0) := Instruction(31 downto 26);
signal Regs: std_logic_vector(4 downto 0) := Instruction(25 downto 21);
signal Regt: std_logic_vector(4 downto 0) := Instruction(20 downto 16);
signal Regd: std_logic_vector(4 downto 0) := Instruction(15 downto 11);
signal funct: std_logic_vector(5 downto 0) := Instruction(5 downto 0);

component ControlUnit is
    port(opcode, funct: in std_logic_vector(5 downto 0);
         regWrite, memToReg, memWrite, ALUSrc, regDst: out std_logic;
         ALUControl: out std_logic_vector(3 downto 0));
end component;

component RegisterFile is
    port( 
        clk_n, we: in std_logic;
        Addr1, Addr2, Addr3: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
        wd: in std_logic_vector(BIT_WIDTH-1 downto 0);
        RD1,RD2: out std_logic_vector(BIT_WIDTH-1 downto 0));
end component;
begin

outputs: process(Instruction)
    begin
    -- SIGN-EXTENDED IMMEDIATE VALUE ---
    ImmOut(31 downto 14) <= (others => Instruction(15));
    ImmOut(15 downto 0) <= Instruction(15 downto 0);
    ------------------------------------
    
    op <= Instruction(31 downto 26);
    Regs <= Instruction(25 downto 21);
    Regt <= Instruction(20 downto 16);
    Regd <= Instruction(15 downto 11);
    funct <= Instruction(5 downto 0);
    -- Rt / Rd VALUES --
    RtDest(4 downto 0) <= Instruction(20 downto 16);
    RdDest(4 downto 0) <= Instruction(15 downto 11);
    --------------------
    
end process;
    
regFile: RegisterFile
    port map(
             clk_n => clk,
             we => RegWriteEn,
             Addr1 => Regs,
             Addr2 => Regt,
             Addr3 => RegWriteAddr,
             wd => RegWriteData,
             RD1 => RD1,
             RD2 => RD2
             );

control: ControlUnit
    port map(
             opcode => op,
             funct => funct,
             regWrite => RegWrite,
             memtoReg => MemtoReg,
             memWrite => MemWrite,
             ALUSrc => ALUSrc,
             regDst => RegDst,
             ALUControl => ALUControl
             );
             
             
            
            
             
   
end Behavioral;
