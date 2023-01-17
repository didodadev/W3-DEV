<!-- Description : Ziyaret Defteri Print
Developer: Melisa Bayramlı
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 27 AND PRINT_MODULE_NAME = 'Call Center' AND PRINT_TYPE=123)
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
            27,
            'Ziyaret Defteri',
            123,
            'Call Center',
            61443
        )
    END
</querytag>
