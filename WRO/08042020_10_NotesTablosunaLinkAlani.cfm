<!-- Description : NOTES TABLOSUNA LINK ALANI EKLENDI
Developer: Botan Kaygan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'NOTES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'IS_LINK')
    BEGIN
        ALTER TABLE NOTES ADD
        IS_LINK bit NULL;
    END;
</querytag>