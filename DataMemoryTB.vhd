----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Jack Skerrett
-- 
-- Create Date: 04/02/2025 07:23:46 PM
-- Design Name: DataMemoryTB
-- Module Name: DataMemoryTB - Behavioral
-- Project Name: Lab4MemoryStage
-- Target Devices: Basys3
-- Description: 
-- Testbench for DataMemory Component
-----------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;

entity DataMemoryTB is
end DataMemoryTB;

architecture Behavioral of DataMemoryTB is
component DataMemory is
    port (clk,w_en: in std_logic;
          addr: in std_logic_vector(ADDR_SPACE-1 downto 0);
          d_in: in std_logic_vector(WIDTH-1 downto 0);
          switches: in std_logic_vector(15 downto 0); 
          
          d_out: out std_logic_vector(WIDTH-1 downto 0);
          seven_seg: out std_logic_vector(15 downto 0)
          );
end component;
signal clk: std_logic := '0';
signal w_en: std_logic;
signal addr: std_logic_vector(9 downto 0);
signal d_in, d_out: std_logic_vector(31 downto 0);
signal switches, seven_seg: std_logic_vector(15 downto 0);
begin

    uut: DataMemory
        port map (
            clk => clk,
            w_en => w_en,
            addr => addr,
            d_in => d_in,
            switches => switches,
            d_out => d_out,
            seven_seg => seven_seg
        );
    
    -- Clock process
    process
    begin
        wait for 20 ns;
        clk <= not clk;
    end process;
    
    -- Stimulus process
    process
    begin
        wait until falling_edge(clk);
        -- Write aaaa5555 to address 1b
        w_en <= '1';
        addr <= "0000011011"; -- 10'h1b
        d_in <= x"aaaa5555";
        
        wait until falling_edge(clk);
        -- Write 5555aaaa to address 1c
        addr <= "0000011100"; -- 10'h1c
        d_in <= x"5555aaaa";
        
        wait until falling_edge(clk);
        -- Read from 1b
        w_en <= '0';
        addr <= "0000011011";
        wait until falling_edge(clk);
        assert (d_out = x"aaaa5555") report "read error at addr 1b" severity warning;
        
        wait until falling_edge(clk);
        -- Read from 1c
        addr <= "0000011100";
        wait until falling_edge(clk);
        assert (d_out = x"5555aaaa") report "read error at addr 1c" severity warning;
        
        -- Test switches read when addr = 1022
        wait until falling_edge(clk);
        w_en <= '0';
        switches <= x"1111";
        addr <= "1111111110"; -- 10'd1022
        wait until falling_edge(clk);
        assert (d_out = x"00001111") report "switch read error at addr 1022" severity warning;
        
        -- Test seven-segment display write at addr = 1023
        wait until falling_edge(clk);
        w_en <= '1';
        addr <= "1111111111"; -- 10'd1023
        d_in <= x"00003333";
        wait until falling_edge(clk);
        assert (seven_seg = x"3333") report "seven-segment write error at addr 1023" severity warning;
        
        assert false report "Test Bench Concluded Successfully" severity note;
        wait;
    end process;


end Behavioral;
