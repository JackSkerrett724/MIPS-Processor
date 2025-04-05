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
-- 32-bit ALU
library ieee;
use ieee.std_logic_1164.all;
use work.globals.all;

entity ALU is
    port(
        A: in std_logic_vector(N-1 downto 0);
        B: in std_logic_vector(N-1 downto 0);
        OP: in std_logic_vector(3 downto 0);
        Y: out std_logic_vector(N-1 downto 0)
        );
end ALU;

architecture struct of ALU is

    component orN is
    port(
        a,b: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(N-1 downto 0));
    end component;
    
    component andN is
    port(
        a,b: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(N-1 downto 0));
    end component;
    
    component xorN is
    port(
        a,b: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(N-1 downto 0));
    end component;
    
    component sllN is
    port (
            A: in std_logic_vector(N-1 downto 0);
            SHIFT_AMT: in std_logic_vector(M-1 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
          );
    end component;
    
    component srlN is
    port (
            A: in std_logic_vector(N-1 downto 0);
            SHIFT_AMT: in std_logic_vector(M-1 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
          );
    end component;
    
    component sraN is
    port (
            A: in std_logic_vector(N-1 downto 0);
            SHIFT_AMT: in std_logic_vector(M-1 downto 0);
            Y: out std_logic_vector(N-1 downto 0)
          );
    end component;
    
    component RippleAdder is
    port(A, B: in std_logic_vector(N-1 downto 0);
        OP: in std_logic;
        Sum: out std_logic_vector(n-1 downto 0));
    end component;
    
    component Multiplier is
    port (
        Am, Bm : in std_logic_vector((N/2)-1 downto 0);  
        P : out std_logic_vector(N-1 downto 0)
    );
    end component;
    
    signal or_result:  std_logic_vector(3 downto 0);
    signal and_result: std_logic_vector(3 downto 0);
    signal xor_result: std_logic_vector(3 downto 0);
    signal sll_result: std_logic_vector(3 downto 0);
    signal srl_result: std_logic_vector(3 downto 0);
    signal sra_result: std_logic_vector(3 downto 0);
    signal add_result: std_logic_vector(3 downto 0);
    signal sub_result: std_logic_vector(3 downto 0);
    signal mul_result: std_logic_vector(3 downto 0);

begin
       or_comp: orN
            port map(a => A, b=>B,y=>or_result);
       and_comp: andN
            port map(a => A, b=>B,y=>and_result);
       xor_comp: xorN
            port map(a => A, b=>B,y=>xor_result);
       sll_comp: sllN
            port map (a => A, shift_amt => B(M-1 downto 0), y => sll_result);
       srl_comp: srlN
            port map (a => A, shift_amt => B(M-1 downto 0), y => srl_result);
       sra_comp: sraN
            port map (a => A, shift_amt => B(M-1 downto 0), y => sra_result);
       add_comp: RippleAdder
            port map (A => A, B => B, OP => '0', Sum => add_result);
       sub_comp: RippleAdder
            port map (A => A, B => B, OP => '1', Sum => sub_result);
       mul_comp: Multiplier
            port map (Am => A((N/2)- 1 downto 0), Bm => B((N/2)- 1 downto 0), P => mul_result);
       
       with op select Y <=
       or_result  when "1000",
       and_result when "1010",
       xor_result when "1011",
       sll_result when "1100",
       srl_result when "1101",
       sra_result when "1110",
       add_result when "0100",
       sub_result when "0101",
       mul_result when "0110",
       (others => '0') when others;
        
end architecture;