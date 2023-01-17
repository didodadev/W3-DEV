<!-- Description : Notlar Tablosunda Konu alanının uzunluğu arttırıldı.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'NOTES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'NOTE_HEAD')
    BEGIN
        ALTER TABLE NOTES 
        ALTER COLUMN NOTE_HEAD nvarchar(250);
    END;
</querytag>