----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Jack Skerrett
-- 
-- Create Date: 04/02/2025 06:08:51 PM
-- Design Name: MemoryStage
-- Module Name: MemoryStage - Behavioral
-- Project Name: Lab4MemoryStage
-- Target Devices: Basys3
-- Description: 
--  MIPS MemoryStage 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;

entity MemoryStage is
    port(clk, rst, RegWrite, MemtoReg, MemWrite: in std_logic; 
         WriteReg: in std_logic_vector(4 downto 0);
         
         ALUResult, WriteData: in std_logic_vector(31 downto 0);
         Switches: in std_logic_vector(15 downto 0);
         
         RegWriteOut, MemtoRegOut: out std_logic;
         WriteRegOut: out std_logic_vector(4 downto 0);
         MemOut, ALUResultOut: out std_logic_vector(31 downto 0);
         Active_Digit: out std_logic_vector(3 downto 0);
         Seven_Seg_Digit: out std_logic_vector(6 downto 0));
         
end MemoryStage;

architecture Behavioral of MemoryStage is

signal displayNum: std_logic_vector(15 downto 0);

component DataMemory is
    port (clk,w_en: in std_logic;
          addr: in std_logic_vector(ADDR_SPACE-1 downto 0);
          d_in: in std_logic_vector(WIDTH-1 downto 0);
          switches: in std_logic_vector(15 downto 0); 
          
          d_out: out std_logic_vector(WIDTH-1 downto 0);
          seven_seg: out std_logic_vector(15 downto 0)
          );
end component;


component SevenSegController is
	port(
	clk	: in std_logic;
	rst : in std_logic;
	display_number : in std_logic_vector(15 downto 0);
	active_segment : out std_logic_vector(3 downto 0);
	led_out : out std_logic_vector(6 downto 0)
	);
end component;

begin

--Pass Through
RegWriteOut <= RegWrite;
MemtoRegOut <= MemtoReg;
WriteRegOut <= WriteReg;
ALUResultOut <= ALUResult;


memComp: DataMemory
          port map(clk, MemWrite, ALUResult(9 downto 0), WriteData, Switches, MemOut, displayNum);

SevSegComp: SevenSegController
          port map(clk, rst, displayNum, Active_Digit, Seven_Seg_Digit);

end Behavioral;