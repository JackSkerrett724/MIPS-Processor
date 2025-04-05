----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Jack Skerrett
-- 
-- Create Date: 04/02/2025 06:08:51 PM
-- Design Name: DataMemory
-- Module Name: DataMemory - Behavioral
-- Project Name: Lab4MemoryStage
-- Target Devices: Basys3
-- Description: 
--  MIPS Data Memory 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;


entity DataMemory is
    port (clk,w_en: in std_logic;
          addr: in std_logic_vector(ADDR_SPACE-1 downto 0);
          d_in: in std_logic_vector(WIDTH-1 downto 0);
          switches: in std_logic_vector(15 downto 0); 
          
          d_out: out std_logic_vector(WIDTH-1 downto 0);
          seven_seg: out std_logic_vector(15 downto 0)
          );
end DataMemory;

architecture Behavioral of DataMemory is

    type memory_array is array (0 to (2**ADDR_SPACE)-1) of std_logic_vector(WIDTH-1 downto 0);
    signal mips_mem : memory_array := (others => (others => '0')); 
    
begin

process(clk)
begin
    if rising_edge(clk) then
        if w_en = '1' then
            mips_mem(to_integer(unsigned(addr))) <= d_in;
        end if;
    end if;
end process;


process(clk)
begin
    if rising_edge(clk) then
        if addr = "1111111111" then
            if w_en = '1' then
                seven_seg <= d_in(15 downto 0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if addr = "1111111110" then
            d_out <= (x"0000" & switches);
        else
            d_out <= mips_mem(to_integer(unsigned(addr)));
        end if;
    end if;
end process;

end Behavioral;
