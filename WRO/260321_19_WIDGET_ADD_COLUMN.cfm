
<!-- Description : WRK_WIDGET Tablosuna yeni alan eklendi.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='WIDGET_TYPE')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD WIDGET_TYPE int NULL;
   END;
</querytag>