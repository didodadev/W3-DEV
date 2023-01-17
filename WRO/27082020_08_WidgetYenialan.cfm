<!-- Description : Widget Tablosuna yeni alanlar eklendi.
Developer: Emine Yilmaz
Company : Workcube
Destination: Main-->
<querytag>  
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='XML_PATH')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD XML_PATH nvarchar(250);
    END;  
</querytag>