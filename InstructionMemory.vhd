----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Jack Skerrett
-- 
-- Create Date: 02/20/2025 11:04:28 AM
-- Module Name: InstructionMemory - Behavioral
-- Project Name: Lab3_Fetch
-- Target Devices: Basys3
-- Description:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionMemory is
    port(addr: in std_logic_vector(27 downto 0);
         d_out: out std_logic_vector(31 downto 0));
end InstructionMemory;

architecture Behavioral of InstructionMemory is
-- MEMORY STRUCTURE
type memArray is array(0 to 1023) of std_logic_vector(31 downto 0);
signal memory: memArray := (others => (others => '0'));

begin
--FOR TESTING
memory(4) <= x"11111111";
memory(8) <= x"22222222";
memory(12) <= x"1f2e3d4c";
memory(16) <= x"43252515";
memory(20) <= x"FFFFFFFF";
memory(24) <= x"ABCDEF12";
memory(28) <= x"98765432";
memory(32) <= x"ABABABAB";
memory(36) <= x"CA123445";





process(addr)
begin

if to_integer(unsigned(addr)) > 1023 then -- outside of range
    d_out <= (others => '0');
else
    d_out <= memory(to_integer(unsigned(addr)));
end if;
end process;
end Behavioral;
