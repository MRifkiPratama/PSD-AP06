library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity help_button is
    port (
        enable : in std_logic;
        msg1, msg2, msg3, msg4 : out std_logic_vector(7 downto 0)  
    );
end entity help_button;

architecture rtl of help_button is
begin
    process(enable)
    begin
        if enable = '1' then
            msg1 <= "01001000"; -- ASCII for 'H'
            msg2 <= "01000101"; -- ASCII for 'E'
            msg3 <= "01001100"; -- ASCII for 'L'
            msg4 <= "01010000"; -- ASCII for 'P'
        else
            msg1 <= (others => '0');
            msg2 <= (others => '0');
            msg3 <= (others => '0');
            msg4 <= (others => '0');
        end if;
    end process;
end architecture rtl;
