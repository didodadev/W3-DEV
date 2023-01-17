<!-- Description : Satış Dışı Hedefler Print Şablonu
Developer: Doğukan Adıgüzel
Company : Workcube
Destination: Main-->

<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 41 AND PRINT_MODULE_NAME = 'Satış Dışı Hedefler' AND PRINT_TYPE=554)
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
            41,
            'Satış Dışı Hedefler',
            554,
            'Satış Gücü Planlama',
            47200
        )
    END
</querytag>
