<!-- Description : eirsaliye ilişki tablosunda yanıt değerleri için alan eklendi
Developer: Fatih Kara
Company : Workcube
Destination: Period -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'ESHIPMENT_RELATION' AND COLUMN_NAME = 'RECEIPMENT_UUID')
    BEGIN
        ALTER TABLE ESHIPMENT_RELATION ADD
        RECEIPMENT_UUID nvarchar(250) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'ESHIPMENT_RELATION' AND COLUMN_NAME = 'RECEIPMENT_ID')
    BEGIN
        ALTER TABLE ESHIPMENT_RELATION ADD
        RECEIPMENT_ID nvarchar(250) NULL
    END;
</querytag>