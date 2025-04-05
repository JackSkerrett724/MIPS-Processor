----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2025 07:29:53 PM
-- Design Name: 
-- Module Name: FullAdder - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FullAdder is
    port(
        A,B,Cin: in std_logic;
        Y, Cout: out std_logic);
end FullAdder;

architecture Behavioral of FullAdder is

begin

Y <= A xor B xor Cin;
Cout <= (A and B) or ((A xor B) and Cin);

end Behavioral;
