<!-- Description : Sevk i̇şlemleri̇ taşıyıcı bölümüne bireysel hesap alanı eklendi. 
Developer: İlker Altındal
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP_RESULT' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'SERVICE_CONSUMER_ID')
    BEGIN
        ALTER TABLE
        SHIP_RESULT
        ADD SERVICE_CONSUMER_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP_RESULT' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'SERVICE_CONSUMER_MEMBER_ID')
    BEGIN
        ALTER TABLE
        SHIP_RESULT
        ADD SERVICE_CONSUMER_MEMBER_ID int NULL
    END;
</querytag>