----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2025 09:34:54 PM
-- Design Name: 
-- Module Name: WritebackStageTB - Behavioral
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
use work.globals.all;

entity WritebackStageTB is
end entity;

architecture tb of WritebackStageTB is
    signal regwrite       : std_logic;
    signal memtoreg       : std_logic;
    signal aluresult      : std_logic_vector(31 downto 0);
    signal readdata       : std_logic_vector(31 downto 0);
    signal writereg       : std_logic_vector(4 downto 0);
    signal regwriteout    : std_logic;
    signal writeregout    : std_logic_vector(4 downto 0);
    signal result         : std_logic_vector(31 downto 0);

    component WritebackStage
        port (
            regwrite     : in std_logic;
            memtoreg     : in std_logic;
            aluresult    : in std_logic_vector(31 downto 0);
            readdata     : in std_logic_vector(31 downto 0);
            writereg     : in std_logic_vector(4 downto 0);
            regwriteout  : out std_logic;
            writeregout  : out std_logic_vector(4 downto 0);
            result       : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: WritebackStage port map (
        regwrite     => regwrite,
        memtoreg     => memtoreg,
        aluresult    => aluresult,
        readdata     => readdata,
        writereg     => writereg,
        regwriteout  => regwriteout,
        writeregout  => writeregout,
        result       => result
    );

    process
    begin
        writereg <= "00000";
        wait for 20 ns;
        assert writeregout = "00000" report "writeregout FAILED" severity error;
        
        writereg <= "11111";
        wait for 20 ns;
        assert writeregout = "11111" report "writeregout FAILED" severity error;
        
        regwrite <= '0';
        wait for 20 ns;
        assert regwriteout = '0' report "regwriteout FAILED" severity error;
        
        regwrite <= '1';
        wait for 20 ns;
        assert regwriteout = '1' report "regwriteout FAILED" severity error;
        
        memtoreg  <= '0';
        aluresult  <= x"00000000";
        readdata   <= x"FFFFFFFF";
        wait for 20 ns;
        assert result = x"00000000" report "result FAILED with reg = 0" severity error;
        
        memtoreg <= '1';
        wait for 20 ns;
        assert result = x"FFFFFFFF" report "result FAILED with mem = FFFFFFFF" severity error;
        
        memtoreg  <= '0';
        aluresult  <= x"55555555";
        readdata   <= x"AAAAAAAA";
        wait for 20 ns;
        assert result = x"55555555" report "result FAILED with reg = 55555555" severity error;
        
        memtoreg <= '1';
        wait for 20 ns;
        assert result = x"AAAAAAAA" report "result FAILED with mem = AAAAAAAA" severity error;
        
        report "Testbench Success" severity note;
        wait;
    end process;
end architecture;

