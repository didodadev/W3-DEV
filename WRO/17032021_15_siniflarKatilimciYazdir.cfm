<!-- Description : Sınıflar sayfasında, sınıfın katılımcılarının yazdırılması için eklendi.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main -->
<querytag>
     IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 34 AND PRINT_MODULE_NAME = 'Eğitim Yönetimi Sınıf Katılımcıları' AND PRINT_TYPE=128)
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
            34,
            'Eğitim Yönetimi Sınıf Katılımcıları',
            128,
            'Eğitim Yönetimi',
            62388
        )
    END
</querytag>