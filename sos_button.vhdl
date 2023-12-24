library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sos_button is
    port (
        enable : in std_logic;
        msg1, msg2, msg3 : out std_logic_vector(7 downto 0)
    );
end entity sos_button;

architecture rtl of sos_button is
begin
    process(enable)
    begin
        if enable = '1' then
            msg1 <= "01010011"; -- ASCII for 'S'
            msg2 <= "01001111"; -- ASCII for 'O'
            msg3 <= "01010011"; -- ASCII for 'S'
        else
            msg1 <= (others => '0');
            msg2 <= (others => '0');
            msg3 <= (others => '0');
        end if;
    end process;
end architecture rtl;
