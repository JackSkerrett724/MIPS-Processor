----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Jack Skerrett
-- 
-- Create Date: 02/07/2025 11:41:55 AM
-- Design Name: RegisterFile
-- Module Name: RegisterFile - Behavioral
-- Project Name: Lab2
-- Target Devices: Basys3
-- Description: Register File component for a MIPS Processor
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.globals.all;

entity RegisterFile is
    port( 
        clk_n, we: in std_logic;
        Addr1, Addr2, Addr3: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
        wd: in std_logic_vector(BIT_WIDTH-1 downto 0);
        RD1,RD2: out std_logic_vector(BIT_WIDTH-1 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
type registerFile is array(0 to 2**LOG_PORT_DEPTH-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
signal registers: registerFile := (others => (others => '0'));
begin

    process(clk_n) is 
    begin
        if falling_edge(clk_n) then
            RD1 <= registers(to_integer(unsigned(Addr1)));
            RD2 <= registers(to_integer(unsigned(Addr2)));
         
            if we = '1' then
                if Addr3 /= "000" then
                    registers(to_integer(unsigned(Addr3))) <= wd;
                end if;
            end if;
        end if;
    
    end process;


end Behavioral;
