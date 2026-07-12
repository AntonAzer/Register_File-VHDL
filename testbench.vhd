library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RegisterFile is
end tb_RegisterFile;

architecture Test of tb_RegisterFile is
    -- Component Declaration
    component RegisterFile
        port (
            clk, rst, we : in std_logic;
            read_addr1, read_addr2, write_addr : in std_logic_vector(2 downto 0);
            write_data : in std_logic_vector(7 downto 0);
            read_data1, read_data2 : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk, rst, we : std_logic := '0';
    signal read_addr1, read_addr2, write_addr : std_logic_vector(2 downto 0) := "000";
    signal write_data : std_logic_vector(7 downto 0) := x"00";
    signal read_data1, read_data2 : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin
    uut: RegisterFile port map (
        clk => clk, rst => rst, we => we,
        read_addr1 => read_addr1, read_addr2 => read_addr2,
        write_addr => write_addr, write_data => write_data,
        read_data1 => read_data1, read_data2 => read_data2
    );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin		
        rst <= '1'; we <= '0';
        read_addr1 <= "000"; read_addr2 <= "000";
        wait for clk_period;

        rst <= '0'; we <= '1';
        write_addr <= "000"; write_data <= x"FF";
        wait for clk_period;

        we <= '1'; write_addr <= "001"; write_data <= x"11";
        wait for clk_period;

        we <= '1'; write_addr <= "111"; write_data <= x"90";
        wait for clk_period;

        we <= '1'; write_addr <= "011"; write_data <= x"08";
        wait for clk_period;

        we <= '1'; write_addr <= "100"; write_data <= x"03";
        read_addr1 <= "001"; read_addr2 <= "111";
        wait for clk_period;

        we <= '0'; 
        read_addr1 <= "010"; read_addr2 <= "011";
        wait for clk_period;

        we <= '0';
        read_addr1 <= "100"; read_addr2 <= "101";
        wait for clk_period;

        we <= '1'; write_addr <= "000"; write_data <= x"01";
        read_addr1 <= "110"; read_addr2 <= "000";
        wait for clk_period;

        wait;
    end process;
end Test;