<!-- Description : NOTES TABLOSUNA ALERT_DATE ALANI EKLENDI
Developer: Botan Kaygan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'NOTES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'ALERT_DATE')
    BEGIN
        ALTER TABLE NOTES ADD
        ALERT_DATE datetime NULL;
    END;
</querytag>