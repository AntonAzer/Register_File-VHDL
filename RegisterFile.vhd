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

architecture Structural of RegisterFile is
    component Reg_8bit is
        port(
            clk : in std_logic;
            rst : in std_logic;
            en  : in std_logic;
            d   : in std_logic_vector(7 downto 0);
            q   : out std_logic_vector(7 downto 0)
        );
    end component;

    type wire_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal reg_outputs : wire_array;
    
    signal decode_we : std_logic_vector(7 downto 0);

begin
    process(write_addr, we)
    begin
        decode_we <= (others => '0');
        if we = '1' then
            decode_we(to_integer(unsigned(write_addr))) <= '1';
        end if;
    end process;

    GEN_REGS: for i in 0 to 7 generate
        RegX: Reg_8bit port map (
            clk => clk,
            rst => rst,
            en  => decode_we(i),
            d   => write_data,
            q   => reg_outputs(i)
        );
    end generate;

    read_data1 <= reg_outputs(to_integer(unsigned(read_addr1)));
    read_data2 <= reg_outputs(to_integer(unsigned(read_addr2)));

end Structural;


library ieee;
use ieee.std_logic_1164.all;

entity Reg_8bit is
    port(clk, rst, en : in std_logic;
         d : in std_logic_vector(7 downto 0);
         q : out std_logic_vector(7 downto 0));
end Reg_8bit;

architecture Behavioral of Reg_8bit is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;
            end if;
        end if;
    end process;
end Behavioral;