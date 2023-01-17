<!-- Description : Bütçe Aktarım Talebi Print 
Developer: Melek KOCABEY
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 46 AND PRINT_MODULE_NAME = 'Bütçe' AND PRINT_TYPE=332)
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
            46,
            'Bütçe Aktarım Talebi',
            332,
            'Bütçe',
            61325
        )
    END
</querytag>
