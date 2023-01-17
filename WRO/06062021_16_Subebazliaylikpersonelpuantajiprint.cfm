<!-- Description : Aylık Personel Puantajı 
Developer: Gülbahar İnan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 69 AND PRINT_MODULE_NAME = 'Devam Ve Kontrol' AND PRINT_TYPE=532)
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
            69,
            'Şube Bazlı Aylık Personel Puantajı',
            532,
            'Devam ve Kontrol',
            62979
        )
    END

    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 69 AND PRINT_MODULE_NAME = 'Devam Ve Kontrol' AND PRINT_TYPE=533)
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
            69,
            'Aylık Ücretsiz İzin Kağıdı',
            533,
            'Devam ve Kontrol',
            35914
        )
    END
</querytag>
