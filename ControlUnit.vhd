----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Jack Skerrett
-- 
-- Create Date: 02/21/2025 07:38:36 PM
-- Module Name: ControlUnit - Behavioral
-- Project Name: Lab3_Decode
-- Target Devices: Basys3
-- Tool Versions: 
-- Description: 
-- Sets the control signals to properly run the instruction based on the opcode of said instruction
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    port(opcode, funct: in std_logic_vector(5 downto 0);
         regWrite, memToReg, memWrite, ALUSrc, regDst: out std_logic;
         ALUControl: out std_logic_vector(3 downto 0));
end ControlUnit;

architecture Behavioral of ControlUnit is

begin

regW: process(opcode)
begin

case opcode is
    when "000000" => regWrite <= '1'; -- R-Type
    when "001000" => regWrite <= '1';
    when "001100" => regWrite <= '1';
    when "001101" => regWrite <= '1';
    when "001110" => regWrite <= '1';
    when "100011" => regWrite <= '1';
    when others => regWrite <= '0';
end case;
end process;

mem2Reg: process(opcode)
begin 
if opcode = "100011" then
    memToReg <= '1'; -- LW
else memToReg <= '0';
end if;
end process;

memW: process(opcode)
begin
if opcode = "101011" then
    memWrite <= '1';
else memWrite <= '0';
end if;
end process;

ALUSource: process(opcode)
begin

case opcode is
    when "001000" => ALUSrc <= '1';
    when "001100" => ALUSrc <= '1';
    when "001101" => ALUSrc <= '1';
    when "001110" => ALUSrc <= '1';
    when "101011" => ALUSrc <= '1';
    when "100011" => ALUSrc <= '1';
    when others => ALUSrc <= '0';
end case;
end process;

RegisterDst: process(opcode)
begin

case opcode is
    when "000000" => regDst <= '1';
    when others => regDst <= '0';
    
end case;
end process;

ALUCtrl: process(opcode,funct)
begin

if opcode = "000000" then
    case funct is
        when "100000" => ALUControl <= "0100"; --ADD
        when "101011" => ALUControl <= "0100"; --LW
        when "100100" => ALUControl <= "1010"; --AND
        when "011001" => ALUControl <= "0110"; --MULTIU
        when "100101" => ALUControl <= "1000"; --OR
        when "100110" => ALUControl <= "1011"; --XOR
        when "000000" => ALUControl <= "1100"; --SLL
        when "000011" => ALUControl <= "1110"; --SRA
        when "000010" => ALUControl <= "1101"; --SRL
        when "100010" => ALUControl <= "0101"; --SUB
        when others => ALUControl <= "0000";
    end case;
    
else
case opcode is
    when "001000" => ALUControl <= "0100"; --ADDI
    when "100011" => ALUControl <= "0100"; --SW
    when "001100" => ALUControl <= "1010"; --ANDI
    when "001101" => ALUControl <= "1000"; --ORI
    when "001110" => ALUControl <= "1011"; --XORI
    when others => ALUControl <= "0000";
end case;
end if;

end process;
end Behavioral;


