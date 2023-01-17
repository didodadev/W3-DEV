<!-- Description : Esnek Çalışma Print 
Developer: Esma R. Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 3 AND PRINT_MODULE_NAME = 'Esnek Çalışma' AND PRINT_TYPE=122)
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
            'Esnek Çalışma',
            122,
            'İnsan Kaynakları',
            41800
        )
    END
</querytag>
