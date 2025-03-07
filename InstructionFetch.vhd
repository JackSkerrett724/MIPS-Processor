----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Jack Skerrett
-- 
-- Create Date: 02/20/2025 11:04:28 AM
-- Module Name: InstructionFetch - Behavioral
-- Project Name: Lab3_Fetch
-- Target Devices: Basys3
-- Description:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity InstructionFetch is
    port(clk, rst: in std_logic;
         Instruction: out std_logic_vector(31 downto 0));
end InstructionFetch;


architecture Behavioral of InstructionFetch is

signal PC: std_logic_vector(27 downto 0) := (others => '0'); --ProgramCounter
    
    component InstructionMemory is
        port(addr: in std_logic_vector(27 downto 0);
             d_out: out std_logic_vector(31 downto 0));
    end component;   

begin
    mem: InstructionMemory
    port map(
        addr => PC,
        d_out => Instruction);

process(rst,clk)
begin
if rst = '1' then
    PC <= (others => '0');
elsif rising_edge(clk) then
    PC <= std_logic_vector(to_unsigned(to_integer(unsigned( PC )) + 4, 28));
end if;
end process;
end Behavioral;
