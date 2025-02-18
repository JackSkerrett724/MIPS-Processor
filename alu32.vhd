---------------------------------------
-- Company: RIT
-- Engineer: Jack Skerrett (jps8836@rit.edu)
--
-- Create Date: 1-28-2025
-- Design Name: alu32
-- Module Name: alu32 - structural
-- Project Name: Lab 1
-- Target Devices: Basys3
--
-- Partial 32-bit ALU
library ieee;
use ieee.std_logic_1164.all;
use work.globals.all;

entity alu32 is
    port(
        A: in std_logic_vector(N-1 downto 0);
        B: in std_logic_vector(N-1 downto 0);
        OP: in std_logic_vector(3 downto 0);
        Y: out std_logic_vector(N-1 downto 0)
        );
end alu32;

architecture struct of alu32 is

    component orN is
    generic(N: integer := 32);
    port(
        a,b: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(N-1 downto 0));
    end component;
    
    component andN is
    generic(N: integer := 32);
    port(
        a,b: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(N-1 downto 0));
    end component;
    
    component xorN is
    generic(N: integer := 32);
    port(
        a,b: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(N-1 downto 0));
    end component;
    
    component sllN is
    generic (N: integer := 32;
             M: integer := 5);
    port (
            A: in std_logic_vector(N-1 downto 0);
            SHIFT_AMT: in std_logic_vector(M-1 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
          );
    end component;
    
    component srlN is
    generic (N: integer := 32;
             M: integer := 5);
    port (
            A: in std_logic_vector(N-1 downto 0);
            SHIFT_AMT: in std_logic_vector(M-1 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
          );
    end component;
    
    component sraN is
    generic (N: integer := 32;
             M: integer := 5);
    port (
            A: in std_logic_vector(N-1 downto 0);
            SHIFT_AMT: in std_logic_vector(M-1 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
          );
    end component;
    
    signal or_result:  std_logic_vector(31 downto 0);
    signal and_result: std_logic_vector(31 downto 0);
    signal xor_result: std_logic_vector(31 downto 0);
    signal sll_result: std_logic_vector(31 downto 0);
    signal srl_result: std_logic_vector(31 downto 0);
    signal sra_result: std_logic_vector(31 downto 0);

begin
       or_comp: orN
            generic map (N => N)
            port map(a => A, b=>B,y=>or_result);
       and_comp: andN
            generic map (N => N)
            port map(a => A, b=>B,y=>and_result);
       xor_comp: xorN
            generic map (N => N)
            port map(a => A, b=>B,y=>xor_result);
       sll_comp: sllN
            generic map (N => N, M => M)
            port map (a => A, shift_amt => B(M-1 downto 0), y => sll_result);
       srl_comp: srlN
            generic map (N => N, M => M)
            port map (a => A, shift_amt => B(M-1 downto 0), y => srl_result);
       sra_comp: sraN
            generic map (N => N, M => M)
            port map (a => A, shift_amt => B(M-1 downto 0), y => sra_result);
       
       with op select Y <=
       or_result  when "1000",
       and_result when "1010",
       xor_result when "1011",
       sll_result when "1100",
       srl_result when "1101",
       sra_result when "1110",
       (others => '0') when others;
        
end architecture;