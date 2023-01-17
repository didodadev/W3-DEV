<!-- Description :  Sözlük İnput alanı genişletme
Developer: Fatih Kara
Company : Workcube
Destination: Main-->
<querytag>
    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_LANGUAGE_INFO' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='ITEM')
    BEGIN
        ALTER TABLE SETUP_LANGUAGE_INFO 
        ALTER COLUMN ITEM nvarchar(MAX) NULL;
    END;
</querytag>
