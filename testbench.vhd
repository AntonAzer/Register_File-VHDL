library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture Test of testbench is
    -- Component 1: DFFsModel
    component DFFsModel
        port (
            clk, rst, we : in std_logic;
            read_addr1, read_addr2, write_addr : in std_logic_vector(2 downto 0);
            write_data : in std_logic_vector(7 downto 0);
            read_data1, read_data2 : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Component 2: MemoryArray
    component MemoryArray
        port (
            clk, rst, we : in std_logic;
            read_addr1, read_addr2, write_addr : in std_logic_vector(2 downto 0);
            write_data : in std_logic_vector(7 downto 0);
            read_data1, read_data2 : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Shared Inputs
    signal clk, rst, we : std_logic := '0';
    signal read_addr1, read_addr2, write_addr : std_logic_vector(2 downto 0) := "000";
    signal write_data : std_logic_vector(7 downto 0) := x"00";

    -- DFF Model Outputs
    signal read_data1_dff, read_data2_dff : std_logic_vector(7 downto 0);
    
    -- Memory Array Model Outputs
    signal read_data1_arr, read_data2_arr : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instantiating DFFsModel
    uut_dff: DFFsModel port map (
        clk => clk, rst => rst, we => we,
        read_addr1 => read_addr1, read_addr2 => read_addr2,
        write_addr => write_addr, write_data => write_data,
        read_data1 => read_data1_dff, read_data2 => read_data2_dff
    );

    -- Instantiating MemoryArray
    uut_arr: MemoryArray port map (
        clk => clk, rst => rst, we => we,
        read_addr1 => read_addr1, read_addr2 => read_addr2,
        write_addr => write_addr, write_data => write_data,
        read_data1 => read_data1_arr, read_data2 => read_data2_arr
    );

    -- Clock Generator
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Self-Checking Stimulus Process
    stim_proc: process
    begin		
        -- CYCLE 1: Reset all registers, set read addresses to 0
        rst <= '1'; we <= '0';
        read_addr1 <= "000"; read_addr2 <= "000";
        wait for clk_period;
        assert (read_data1_dff = x"00" and read_data2_dff = x"00") 
            report "Cycle 1 Error [DFF]: Expected (00, 00)" severity error;
        assert (read_data1_arr = x"00" and read_data2_arr = x"00") 
            report "Cycle 1 Error [Array]: Expected (00, 00)" severity error;

        -- CYCLE 2: Write 0xFF in Reg(0)
        rst <= '0'; we <= '1';
        write_addr <= "000"; write_data <= x"FF";
        wait for clk_period;
        assert (read_data1_dff = x"FF" and read_data2_dff = x"FF") 
            report "Cycle 2 Error [DFF]: Expected (FF, FF)" severity error;
        assert (read_data1_arr = x"FF" and read_data2_arr = x"FF") 
            report "Cycle 2 Error [Array]: Expected (FF, FF)" severity error;

        -- CYCLE 3: Write 0x11 in Reg(1)
        we <= '1'; write_addr <= "001"; write_data <= x"11";
        wait for clk_period;
        assert (read_data1_dff = x"FF" and read_data2_dff = x"FF") 
            report "Cycle 3 Error [DFF]: Expected (FF, FF)" severity error;
        assert (read_data1_arr = x"FF" and read_data2_arr = x"FF") 
            report "Cycle 3 Error [Array]: Expected (FF, FF)" severity error;

        -- CYCLE 4: Write 0x90 in Reg(7)
        we <= '1'; write_addr <= "111"; write_data <= x"90";
        wait for clk_period;
        assert (read_data1_dff = x"FF" and read_data2_dff = x"FF") 
            report "Cycle 4 Error [DFF]: Expected (FF, FF)" severity error;
        assert (read_data1_arr = x"FF" and read_data2_arr = x"FF") 
            report "Cycle 4 Error [Array]: Expected (FF, FF)" severity error;

        -- CYCLE 5: Write 0x08 in Reg(3)
        we <= '1'; write_addr <= "011"; write_data <= x"08";
        wait for clk_period;
        assert (read_data1_dff = x"FF" and read_data2_dff = x"FF") 
            report "Cycle 5 Error [DFF]: Expected (FF, FF)" severity error;
        assert (read_data1_arr = x"FF" and read_data2_arr = x"FF") 
            report "Cycle 5 Error [Array]: Expected (FF, FF)" severity error;

        -- CYCLE 6: Read Reg(1) on Port 0, Reg(7) on Port 1, Write 0x03 in Reg(4)
        we <= '1'; write_addr <= "100"; write_data <= x"03";
        read_addr1 <= "001"; read_addr2 <= "111";
        wait for clk_period;
        assert (read_data1_dff = x"11" and read_data2_dff = x"90") 
            report "Cycle 6 Error [DFF]: Expected (11, 90)" severity error;
        assert (read_data1_arr = x"11" and read_data2_arr = x"90") 
            report "Cycle 6 Error [Array]: Expected (11, 90)" severity error;

        -- CYCLE 7: Read Reg(2) on Port 0, Reg(3) on Port 1
        we <= '0'; 
        read_addr1 <= "010"; read_addr2 <= "011";
        wait for clk_period;
        assert (read_data1_dff = x"00" and read_data2_dff = x"08") 
            report "Cycle 7 Error [DFF]: Expected (00, 08)" severity error;
        assert (read_data1_arr = x"00" and read_data2_arr = x"08") 
            report "Cycle 7 Error [Array]: Expected (00, 08)" severity error;

        -- CYCLE 8: Read Reg(4) on Port 0, Reg(5) on Port 1
        we <= '0';
        read_addr1 <= "100"; read_addr2 <= "101";
        wait for clk_period;
        assert (read_data1_dff = x"03" and read_data2_dff = x"00") 
            report "Cycle 8 Error [DFF]: Expected (03, 00)" severity error;
        assert (read_data1_arr = x"03" and read_data2_arr = x"00") 
            report "Cycle 8 Error [Array]: Expected (03, 00)" severity error;

        -- CYCLE 9: Read Reg(6) on Port 0, Reg(0) on Port 1, Write 0x01 in Reg(0)
        we <= '1'; write_addr <= "000"; write_data <= x"01";
        read_addr1 <= "110"; read_addr2 <= "000";
        wait for clk_period;
        assert (read_data1_dff = x"00" and read_data2_dff = x"01") 
            report "Cycle 9 Error [DFF]: Expected (00, 01)" severity error;
        assert (read_data1_arr = x"00" and read_data2_arr = x"01") 
            report "Cycle 9 Error [Array]: Expected (00, 01)" severity error;

        -- Final Success Message
        report "SUCCESS: All test cases passed successfully for both DFF and Memory Array designs!" severity note;

        wait;
    end process;

end Test;