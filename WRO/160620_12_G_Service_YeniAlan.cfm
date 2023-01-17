<!-- Description : G_SERVICE Tablosuna Full_url alanı eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'G_SERVICE' AND COLUMN_NAME = 'FULL_URL')
    BEGIN
        ALTER TABLE G_SERVICE ADD 
        FULL_URL  nvarchar(250) NULL
    END;
</querytag>