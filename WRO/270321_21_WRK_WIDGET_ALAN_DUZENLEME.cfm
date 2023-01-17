<!-- Description : WRK_WIDGET Tablosunda widget_type boş olan alanlar dolduruldu.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>   

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='WIDGET_TYPE')
    BEGIN
        
    UPDATE WRK_WIDGET SET  WIDGET_TYPE='4' WHERE WIDGET_TYPE is null
   END;

</querytag>