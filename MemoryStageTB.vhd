----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2025 09:04:04 PM
-- Design Name: 
-- Module Name: MemoryStageTB - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemoryStageTB is
end entity;

architecture testbench of MemoryStageTB is

    component MemoryStage
        port(
            clk, rst, regwrite, memtoreg, memwrite: in std_logic;
            writereg: in std_logic_vector(4 downto 0);
            aluresult, writedata: in std_logic_vector(31 downto 0);
            switches: in std_logic_vector(15 downto 0);

            regwriteout, memtoregout: out std_logic;
            writeregout: out std_logic_vector(4 downto 0);
            memout, aluresultout: out std_logic_vector(31 downto 0);
            active_digit: out std_logic_vector(3 downto 0);
            seven_seg_digit: out std_logic_vector(6 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk, rst, regwrite, memtoreg, memwrite: std_logic := '0';
    signal writereg: std_logic_vector(4 downto 0) := (others => '0');
    signal aluresult, writedata: std_logic_vector(31 downto 0) := (others => '0');
    signal switches: std_logic_vector(15 downto 0) := (others => '0');

    signal regwriteout, memtoregout: std_logic;
    signal writeregout: std_logic_vector(4 downto 0);
    signal memout, aluresultout: std_logic_vector(31 downto 0);
    signal active_digit: std_logic_vector(3 downto 0);
    signal seven_seg_digit: std_logic_vector(6 downto 0);

    -- Clock generation
    constant clk_period : time := 10 ns;

begin
    UUT: MemoryStage
        port map (
            clk => clk,
            rst => rst,
            regwrite => regwrite,
            memtoreg => memtoreg,
            memwrite => memwrite,
            writereg => writereg,
            aluresult => aluresult,
            writedata => writedata,
            switches => switches,

            regwriteout => regwriteout,
            memtoregout => memtoregout,
            writeregout => writeregout,
            memout => memout,
            aluresultout => aluresultout,
            active_digit => active_digit,
            seven_seg_digit => seven_seg_digit
        );

      -- Clock process
    clk_process: process
    begin
        while now < 1000 ns loop  -- Run simulation for 1000 ns
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_process: process
    begin
        -- Reset sequence
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- Apply test values
        regwrite <= '1';
        memtoreg <= '0';
        memwrite <= '1';
        writereg <= "00010";
        aluresult <= x"00000010";
        writedata <= x"AAAAAAAA";
        switches <= x"1234";

        wait for 50 ns;

        -- Assertions
        assert regwriteout = '1' report "Test failed: regwriteout mismatch" severity error;
        assert memtoregout = '0' report "Test failed: memtoregout mismatch" severity error;
        assert writeregout = "00010" report "Test failed: writeregout mismatch" severity error;
        assert aluresultout = x"00000010" report "Test failed: aluresultout mismatch" severity error;

        -- Change values
        memwrite <= '0';
        writedata <= x"55555555";
        switches <= x"5678";

        wait for 50 ns;

        -- Assertions after change
        assert memwrite = '0' report "Test failed: memwrite mismatch" severity error;
        assert writedata = x"55555555" report "Test failed: writedata mismatch" severity error;
        assert switches = x"5678" report "Test failed: switches mismatch" severity error;

        -- End simulation
        assert false report "Testbench completed successfully" severity note;
        wait;
    end process;

end architecture;


