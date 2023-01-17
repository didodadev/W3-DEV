<!-- Description : Şube Detay ekranının yazdırılması için eklendi.
Developer: Fatih Kara
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 3 AND PRINT_MODULE_NAME = 'Şube Çıktı Ekranı' AND PRINT_TYPE=129)
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
           'Şube Çıktı Ekranı',
           129,
           'İnsan Kaynakları',
           62916
       )
   END
</querytag>