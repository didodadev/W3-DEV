 <!-- Description : Müşteri-Tedarikçi Print
Developer: Dilek Özdemir 
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 4 AND PRINT_MODULE_NAME = 'Müşteri-Tedarikçi' AND PRINT_TYPE=126)
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
            4,
            'Bireysel Hesaplar',
            126,
            'Müşteri-Tedarikçi',
            47168
        )
    END
</querytag>

<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 4 AND PRINT_MODULE_NAME = 'Müşteri-Tedarikçi' AND PRINT_TYPE=127)
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
            4,
            'Kurumsal Hesaplar',
            127,
            'Müşteri-Tedarikçi',
            47168
        )
    END
</querytag>