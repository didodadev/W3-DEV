<!-- Description : İzin Mutabakatı Print Setup
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 3 AND PRINT_MODULE_NAME = 'İzin Mutabakatları' AND PRINT_TYPE=355)
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
            'İzin Mutabakatları',
            355,
            'İnsan Kaynakları',
            56647
        )
    END
</querytag>