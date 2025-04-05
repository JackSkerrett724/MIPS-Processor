----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 11:08:07 PM
-- Design Name: 
-- Module Name: Multiplier - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Ripple Carry Multiplier
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
use work.globals.all;

entity Multiplier is
    port (
        Am, Bm : in std_logic_vector((N/2)-1 downto 0);  
        P : out std_logic_vector(N-1 downto 0)
    );
end Multiplier;

architecture Behavioral of Multiplier is

component FullAdder is
    port(
        A,B,Cin: in std_logic;
        Y, Cout: out std_logic);
end component;
----------------------------------------------------
    constant K : integer := N/2;
    type partial_product_array is array (0 to K-1) of std_logic_vector(N-1 downto 0);
    signal partial_products : partial_product_array;
    
    type sum_array is array (0 to K-1) of std_logic_vector(N-1 downto 0);
    signal sum : sum_array;

begin
    -- Generate partial products
    gen_partial: for i in 0 to K-1 generate
        partial_products(i) <= 
            std_logic_vector(shift_left(resize(unsigned(Am), N), i)) 
            when Bm(i) = '1' else 
            (others => '0');
    end generate;

    -- Initialize first sum with first partial product
    sum(0) <= partial_products(0);

    -- Generate adder chains for partial product accumulation
    gen_adder_chains: for i in 1 to K-1 generate
        signal carry_chain : std_logic_vector(N downto 0);
    begin
        carry_chain(0) <= '0';  -- Start with no carry-in
        
        gen_bit_adders: for j in 0 to N-1 generate
        begin
            FA: FullAdder port map(
                a   => sum(i-1)(j),
                b   => partial_products(i)(j),
                cin => carry_chain(j),
                Y => sum(i)(j),
                cout => carry_chain(j+1)
            );
        end generate gen_bit_adders;
    end generate gen_adder_chains;

    -- Final product output
    P <= sum(K-1);
end Behavioral;



