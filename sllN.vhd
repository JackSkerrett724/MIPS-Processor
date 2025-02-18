---------------------------------------
-- Company: RIT
-- Engineer: Jack Skerrett (jps8836@rit.edu)
--
-- Create Date: 1-16-2025
-- Design Name: sllN
-- Module Name: sllN - behaviroal 
-- Project Name: Lab 1
-- Target Devices: Basys3
--
-- N-bit Logical Left Shift

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity sllN is
    generic (N: integer := 32;
             M: integer := 5);
    port (
            A: in std_logic_vector(N-1 downto 0);
            SHIFT_AMT: in std_logic_vector(M-1 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
          );
end sllN;

architecture behavioral of sllN is
    type shifty_array is array(N-1 downto 0) of std_logic_vector(N-1 downto 0);
    signal aSLL : shifty_array;

begin
    generateSLL: for i in 0 to N-1 generate
        aSLL(i)(N-1 downto i) <= A(N-1-i downto 0);
        left_fill: if i > 0 generate
            aSLL(i)(i-1 downto 0) <= (others => '0');
        end generate left_fill;
    end generate generateSLL;
    
  Y <= aSLL(to_integer(unsigned(SHIFT_AMT)));
end behavioral;

