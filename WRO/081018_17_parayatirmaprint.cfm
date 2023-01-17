<!-- Description : Banka para yatırma çekme işlemi için print tipi kayıdı oluşturur.
Developer: Pınar Yıldız
Company : Workcube
Destination: Main-->
<querytag>
IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 19 AND PRINT_MODULE_NAME = 'Banka' AND PRINT_TYPE=531)
BEGIN
   INSERT INTO
   SETUP_PRINT_FILES_CATS
   (
   PRINT_MODULE_ID,
   PRINT_NAME,
   PRINT_TYPE,
   PRINT_MODULE_NAME
   )
   VALUES
   (
   19,
   'Banka Para Çekme/Yatırma İşlemi',
   531,
   'Banka'
   )
END
    </querytag>
