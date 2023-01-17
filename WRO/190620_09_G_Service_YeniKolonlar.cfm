<!-- Description : G_SERVICE Tablosuna FUSEACTION alanı eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'G_SERVICE' AND COLUMN_NAME = 'FUSEACTION')
    BEGIN
        ALTER TABLE G_SERVICE ADD 
        FUSEACTION  nvarchar(250) NULL
    END;
</querytag>