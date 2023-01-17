<!-- Description : Gdpr izinler listesinde çalışana ait açık rıza beyanının yazırılması için kullanıldı.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 85 AND PRINT_MODULE_NAME = 'GDPR' AND PRINT_TYPE=376)
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

    85,
    'Aydınlatma Metni',
    376,
    'GDPR',
    44348
    )
    END
</querytag>