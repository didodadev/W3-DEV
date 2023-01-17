<!-- Description : Şube Finansal Günlük Durum Raporu Print
Developer: Gülbahar Erol
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 16 AND PRINT_MODULE_NAME = 'Finans' AND PRINT_TYPE=125)
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
            16,
            'Şube Finansal Günlük Durum Raporu',
            125,
            'Finans',
            54611
        )
    END
</querytag>
