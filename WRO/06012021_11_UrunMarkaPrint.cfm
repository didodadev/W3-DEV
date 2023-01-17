<!-- Description : Marka Print
Developer: Melisa Bayramlı
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 5 AND PRINT_MODULE_NAME = 'Ürün ve Stoklar' AND PRINT_TYPE=218)
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
            5,
            'Marka',
            218,
            'Ürün ve Stoklar',
            58847
        )
    END
</querytag>
