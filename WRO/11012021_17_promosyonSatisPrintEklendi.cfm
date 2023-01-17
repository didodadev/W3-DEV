<!-- Description : Promosyonlar satış printi oluşturuldu.
Developer :Zehra Dere
Company : Workcube
Destination : Main -->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 11 AND PRINT_MODULE_NAME = 'Satış' AND PRINT_TYPE=160)
        BEGIN
            INSERT INTO
        SETUP_PRINT_FILES_CATS
            (
                PRINT_MODULE_ID,
                PRINT_NAME,
                PRINT_TYPE,
                PRINT_MODULE_NAME,
                PRINT_DICTIONARY_ID
            )
            VALUES
            (
                11,
                'Promosyonlar Satış',
                160,
                'Satış',
                61563
            )
        END
</querytag>