<!-- Description :  Event Tablosuna online toplantılar için alan eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EVENT' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='ONLINE_MEET_LINK')
    BEGIN
        ALTER TABLE EVENT ADD 
        ONLINE_MEET_LINK nvarchar(500) NULL
    END;
</querytag>