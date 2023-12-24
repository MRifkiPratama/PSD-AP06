LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SOS_Transmitter IS
    PORT (
        login_flag : OUT STD_LOGIC;
        wrong_flag : OUT STD_LOGIC;
        input_string : IN STRING(1 TO 4); -- Input string dengan 4 huruf
        shift_amount : IN INTEGER; -- Jumlah Shift
        shift_direction : IN CHARACTER; -- Perubahan penulisan dari shift_direction
        e_button_help, e_button_sos, e_button_msg, enable : IN STD_LOGIC;
        hmsg1, hmsg2, hmsg3, hmsg4 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        smsg1, smsg2, smsg3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        output_string : OUT STRING(1 TO 4); -- Output string dengan 4 huruf
        clk : IN STD_LOGIC
    );
END ENTITY SOS_Transmitter;

ARCHITECTURE rtl OF SOS_Transmitter IS
    TYPE state_type IS (AUTHORIZATION, IDLE, PROCESSING, COMPLETE, LOCKDOWN);
    SIGNAL state : state_type;
    SIGNAL password_input : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL wrong_password_count : INTEGER := 0;
    SIGNAL send : INTEGER := 0;

    COMPONENT sos_button IS
        PORT (
            enable : IN STD_LOGIC;
            msg1, msg2, msg3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT help_button IS
        PORT (
            enable : IN STD_LOGIC;
            msg1, msg2, msg3, msg4 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Caesar IS
        PORT (
            enable : IN STD_LOGIC; -- Enable signal
            input_string : IN STRING(1 TO 4); -- Input string dengan 4 huruf
            shift_amount : IN INTEGER; -- Jumlah Shift
            shift_direction : IN CHARACTER; -- Perubahan penulisan dari shift_direction
            output_string : OUT STRING(1 TO 4) -- Output string dengan 4 huruf
        );
    END COMPONENT;
BEGIN
    caesar_shift : Caesar PORT MAP(e_button_msg, input_string, shift_amount, shift_direction, output_string);
    help : help_button PORT MAP(e_button_help, hmsg1, hmsg2, hmsg3, hmsg4);
    sos : sos_button PORT MAP(e_button_sos, smsg1, smsg2, smsg3);
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            login_flag <= '0';
            wrong_flag <= '0';

            CASE state IS
                WHEN AUTHORIZATION =>
                    IF password_input = "11110000" THEN
                        login_flag <= '1';
                        state <= IDLE;
                    ELSE
                        wrong_flag <= '1';
                        wrong_password_count <= wrong_password_count + 1;
                        IF wrong_password_count = 3 THEN
                            state <= LOCKDOWN;
                        ELSE
                            state <= AUTHORIZATION;
                        END IF;
                    END IF;
                WHEN IDLE =>
                    IF e_button_help = '1' THEN
                        state <= COMPLETE;
                    ELSIF e_button_sos = '1' THEN
                        state <= COMPLETE;
                    ELSIF enable = '1' THEN
                        state <= PROCESSING;
                    ELSE
                        state <= IDLE;
                    END IF;

                WHEN PROCESSING =>
                    IF e_button_msg = '1' THEN
                        state <= COMPLETE;
                    ELSE
                        state <= PROCESSING;
                    END IF;
                WHEN COMPLETE =>
                    send <= send + 1;
                    state <= IDLE;

                WHEN LOCKDOWN =>
                    -- Reset signals in LOCKDOWN state
                    password_input <= (OTHERS => '0');
                    login_flag <= '0';
                    wrong_flag <= '0';
                    wrong_password_count <= 0;
                    state <= AUTHORIZATION;

                WHEN OTHERS =>
                    -- Default case, in case any unexpected state occurs
                    state <= AUTHORIZATION;
            END CASE;
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;