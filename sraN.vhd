---------------------------------------
-- Company: RIT
-- Engineer: Jack Skerrett (jps8836@rit.edu)
--
-- Create Date: 1-16-2025
-- Design Name: sraN
-- Module Name: sraN - behaviroal 
-- Project Name: Lab 1
-- Target Devices: Basys3
--
-- N-bit Arithmatic Right Shift

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity sraN is
    generic (N: integer := 32;
             M: integer := 5);
    port (
            A: in std_logic_vector(N-1 downto 0);
            SHIFT_AMT: in std_logic_vector(M-1 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
          );
end sraN;

architecture behavioral of sraN is
    type shifty_array is array(N-1 downto 0) of std_logic_vector(N-1 downto 0);
    signal aSRA : shifty_array;

begin
    generateSRA: for i in 0 to N-1 generate
        aSRA(i)(N-1-i downto 0) <= A(N-1 downto i);
        right_fill: if i > 0 generate
            aSRA(i)(N-1 downto N-i) <= (others => A(N-1)); -- sign bit gets added on
        end generate right_fill;
    end generate generateSRA;
    
  Y <= aSRA(to_integer(unsigned(SHIFT_AMT)));
end behavioral;

