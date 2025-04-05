----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Jack Skerrett
-- 
-- Create Date: 04/02/2025 09:15:23 PM
-- Design Name: WritebackStage
-- Module Name: WritebackStage - Behavioral
-- Project Name: Lab4MemoryStage
-- Target Devices: Basys3
-- Description: 
-- MIPS Writeback Stage
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;

entity WritebackStage is
    port(RegWrite, MemtoReg: in std_logic;
         ALUResult, ReadData: in std_logic_vector(31 downto 0);
         WriteReg: in std_logic_vector(4 downto 0);
         
         RegWriteOut: out std_logic;
         WriteRegOut: out std_logic_vector(4 downto 0);
         Result: out std_logic_vector(31 downto 0));
end WritebackStage;

architecture Behavioral of WritebackStage is

begin

process(ReadData, MemtoReg, ALUResult)
begin
    if MemtoReg = '1' then
        Result <= ReadData;
    else  
        Result <= ALUResult;
    end if;
end process;

WriteRegOut <= WriteReg;
RegWriteOut <= RegWrite;

end Behavioral;
