<!-- Description : WRK_WIDGET Tablosuna yeni alan eklendi.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>   

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='MAIN_VERSION')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD MAIN_VERSION nvarchar(250) NULL;
   END;

</querytag>