<!-- Description : Ödenek Hakediş Hesabı print
Developer: Esma R. Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 3 AND PRINT_MODULE_NAME = 'Ödenek Hakediş Hesabı' AND PRINT_TYPE=319)
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
            3,
            'Ödenek Hakediş Hesabı',
            319,
            'İnsan Kaynakları',
            63144
        )
    END
</querytag>
