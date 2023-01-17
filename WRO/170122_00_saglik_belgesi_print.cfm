<!-- Description : Sağlık Belgesi Print Şablonu
Developer: Dilek Özdemir
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 70 AND PRINT_MODULE_NAME = 'Sağlık ve Güvenlik İşlemleri' AND PRINT_TYPE=388)
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
            70,
            'Sağlık Belgesi',
            388,
            'Sağlık ve Güvenlik İşlemleri',
            47197
        )
    END
</querytag>