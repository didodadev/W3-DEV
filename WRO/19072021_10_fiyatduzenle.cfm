<!-- Description : Fiyat düzenleme ekranının yazdırılması için eklendi.
Developer: Fatih Kara
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 55 AND PRINT_MODULE_NAME = 'Fiyat Yönetimi' AND PRINT_TYPE=220)
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
           55,
           'Fiyat Düzenle',
           220,
           'Fiyat Yönetimi',
           37390
       )
   END
</querytag>