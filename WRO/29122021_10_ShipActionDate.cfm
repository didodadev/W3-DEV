<!-- Description : ACTION_DATE tablosuna ACTION_DATE alanı eklendi.
Developer: Fatih Kara
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'ACTION_DATE')
    BEGIN
        ALTER TABLE SHIP ADD
        ACTION_DATE DATETIME NULL;
    END;
</querytag>