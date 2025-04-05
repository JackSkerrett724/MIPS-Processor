----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 11:20:43 PM
-- Design Name: 
-- Module Name: MultiplierTB - Behavioral
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
use work.globals.all;

entity MultiplierTB is
end MultiplierTB;

architecture Behavioral of MultiplierTB is
    component Multiplier
        port(
            Am, Bm: in std_logic_vector((N/2)-1 downto 0);
            P: out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal A_tb, B_tb: std_logic_vector((N/2)-1 downto 0);
    signal Product_tb: std_logic_vector(N-1 downto 0);
    signal Expected_Product: std_logic_vector(N-1 downto 0);
    
begin
    UUT: Multiplier port map(Am => A_tb, Bm => B_tb, P => Product_tb);

    process
    begin
        -- Test Case 1: 2 * 3
        A_tb <= x"0002"; B_tb <= x"0003";  
        Expected_Product <= std_logic_vector(to_unsigned(2*3, N));
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 1 Failed" severity failure;

        -- Test Case 2: 5 * 7
        A_tb <= x"0005"; B_tb <= x"0007";  
        Expected_Product <= std_logic_vector(to_unsigned(5*7, N));
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 2 Failed" severity failure;

        -- Test Case 3: 15 * 15
        A_tb <= x"000F"; B_tb <= x"000F"; 
        Expected_Product <= std_logic_vector(to_unsigned(15*15, N));
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 3 Failed" severity failure;

        -- Test Case 4: 0 * Any number
        A_tb <= x"0000"; B_tb <= x"0009";  
        Expected_Product <= std_logic_vector(to_unsigned(0*9, N));
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 4 Failed" severity failure;

        -- Test Case 5: 1 * Any number
        A_tb <= x"0001"; B_tb <= x"000D"; 
        Expected_Product <= std_logic_vector(to_unsigned(1*13, N));
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 5 Failed" severity failure;

        -- Test Case 6: Medium-sized multiplication (100 * 50)
        A_tb <= x"0064"; B_tb <= x"0032";
        Expected_Product <= std_logic_vector(to_unsigned(100*50, N));
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 6 Failed" severity failure;

        -- Test Case 7: Large multiplication (255 * 255)
        A_tb <= x"00FF"; B_tb <= x"00FF";
        Expected_Product <= std_logic_vector(to_unsigned(255*255, N));
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 7 Failed" severity failure;

        --(0xAAAA * 0x5555)
        A_tb <= x"AAAA"; B_tb <= x"5555";
        Expected_Product <= std_logic_vector(to_unsigned(43690*21845, N));  -- Pre-calculated pattern result  
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 8 Failed" severity failure;

        -- (0xFFFF * 0xFFFF)
        A_tb <= x"FFFF"; B_tb <= x"FFFF";
        Expected_Product <= x"FFFE0001";  -- (2^16-1)^2 result
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 9 Failed" severity failure;

        -- Test Case 10: Large non-max values (0xFFFE * 0xFFFE)
        A_tb <= x"FFFE"; B_tb <= x"FFFE";
        Expected_Product <= x"FFFC0004";  -- (2^16-2)^2 result
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 10 Failed" severity failure;

        -- Test Case 11: Complex multiplication (1234 * 5678)
        A_tb <= x"04D2"; B_tb <= x"162E";
        Expected_Product <= x"006AE9BC";  -- 1234*5678 = 7,006,652
        wait for 10 ns;
        assert Product_tb = Expected_Product report "Test Case 11 Failed" severity failure;

        report "All test cases passed successfully!" severity failure;
        wait;
    end process;
    
end Behavioral;
