<!-- Description : Kampanyalar Sms İçeriği Print ŞAblonu
Developer: Dilek Özdemir
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 15 AND PRINT_MODULE_NAME = 'Kampanyalar Sms İçeriği' AND PRINT_TYPE=354)
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
            15,
            'Kampanyalar Sms İçeriği',
            354,
            'Pazarlama',
            29405
        )
    END
</querytag>