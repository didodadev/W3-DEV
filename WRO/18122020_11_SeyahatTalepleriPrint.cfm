<!-- Description : Seyahat Talepleri Print
Developer: Melisa Bayramlı
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 3 AND PRINT_MODULE_NAME = 'İnsan Kaynakları' AND PRINT_TYPE=124)
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
            'Seyahat Talepleri',
            124,
            'İnsan Kaynakları',
            49729
        )
    END
</querytag>
