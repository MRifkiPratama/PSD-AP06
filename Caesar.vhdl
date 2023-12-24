library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Caesar is
    port (
        enable : in std_logic; -- Enable signal
        input_string : in string(1 to 4); -- Input string dengan 4 huruf
        shift_amount : in integer; -- Jumlah Shift
        shift_direction : in character; -- Perubahan penulisan dari shift_direction
        output_string : out string(1 to 4) -- Output string dengan 4 huruf
    );
end entity Caesar;

architecture rtl of Caesar is
begin
    process(input_string, shift_amount, shift_direction, enable)
        variable output_chars : string(1 to 4); -- Ubah variabel menjadi string
        variable temp : integer;
    begin
        if enable = '1' then
            for i in 1 to 4 loop
                -- Convert karakter ke nilai ASCII
                temp := character'pos(input_string(i));

                -- Lakukan pergeseran sesuai arah
                case shift_direction is
                    when 'l' =>
                        for j in 0 to shift_amount - 1 loop
                            temp := temp - 1;
                        end loop;
                    when 'r' =>
                        for j in 0 to shift_amount - 1 loop
                            temp := temp + 1;
                        end loop;
                    when others =>
                        null;
                end case;

                -- Pastikan nilai ASCII berada dalam rentang huruf kecil
                if temp < 97 then
                    temp := 123 - (97 - temp);
                elsif temp > 122 then
                    temp := 96 + (temp - 122);
                end if;

                -- Konversi kembali dari nilai ASCII ke karakter
                output_chars(i) := character'val(temp);
            end loop;

            -- Keluarkan string hasil perubahan
            output_string <= output_chars;
        else
            -- If not enabled, output the input string unchanged
            output_string <= input_string;
        end if;
    end process;
end architecture rtl;
