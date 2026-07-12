library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        we         : in  std_logic; -- Write Enable
        read_addr1 : in  std_logic_vector(2 downto 0);
        read_addr2 : in  std_logic_vector(2 downto 0);
        write_addr : in  std_logic_vector(2 downto 0);
        write_data : in  std_logic_vector(7 downto 0);
        read_data1 : out std_logic_vector(7 downto 0);
        read_data2 : out std_logic_vector(7 downto 0)
    );
end RegisterFile;



architecture Behavioral of RegisterFile is
    type reg_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal regs : reg_array;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            for i in 0 to 7 loop
                regs(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            if we = '1' then
                regs(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;

    read_data1 <= regs(to_integer(unsigned(read_addr1)));
    read_data2 <= regs(to_integer(unsigned(read_addr2)));
end Behavioral;