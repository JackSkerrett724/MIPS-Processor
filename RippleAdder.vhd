----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Jack Skerrett
-- 
-- Create Date: 03/21/2025 05:01:01 PM
-- Design Name: RippleAdder
-- Module Name: RippleAdder - Structural
-- Project Name: Lab4
-- Target Devices: Basys3
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;

entity RippleAdder is
    port(A, B: in std_logic_vector(N-1 downto 0);
        OP: in std_logic;
        Sum: out std_logic_vector(N-1 downto 0));
end RippleAdder;

architecture structural of RippleAdder is

signal tempAddOut: std_logic_vector(N-1 downto 0);
signal tempSubOut: std_logic_vector(N-1 downto 0);
signal tempB: std_logic_vector(N-1 downto 0);
signal addSum: std_logic_vector(N-1 downto 0);
signal subSum: std_logic_vector(N-1 downto 0);
component FullAdder is
    port(
        A,B,Cin: in std_logic;
        Y, Cout: out std_logic);
end component;

begin

Add0: FullAdder port map(A(0), B(0), '0', addSum(0), tempAddOut(0));
addGen: for i in 1 to N-1 generate
        Addi: FullAdder port map(
        A(i) ,B(i) ,tempAddOut(i-1) , addSum(i), tempAddOut(i)
        );
end generate addGen;

tempB <= std_logic_vector(unsigned((not B)) + 1); -- 2s comp

Sub0: FullAdder port map(A(0), tempB(0), '0', subSum(0), tempSubOut(0));
subGen: for i in 1 to N-1 generate
        Subi: FullAdder port map(
        A(i), tempB(i), tempSubOut(i-1), subSum(i), tempSubOut(i));
end generate subGen;


with OP select Sum <=
    addSum when '0', --addition
    subSum when others; -- subtraction 


end structural;
