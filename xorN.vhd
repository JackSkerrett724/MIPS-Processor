---------------------------------------
-- Company: RIT
-- Engineer: Jack Skerrett (jps8836@rit.edu)
--
-- Create Date: 1-28-2025
-- Design Name: xorN
-- Module Name: xorN - df
-- Project Name: Lab 1
-- Target Devices: Basys3
--
-- N-bit logical xor

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity xorN is
    generic(N: integer := 32);
    port(
        a,b: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(N-1 downto 0));
end xorN;

architecture df of xorN is
begin
    process(a,b) 
    begin
        for i in 0 to N-1 loop
            y(i) <= a(i) xor b(i);
        end loop;
    end process;
end architecture;