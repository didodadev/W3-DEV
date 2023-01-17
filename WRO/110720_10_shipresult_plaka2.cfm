<!-- Description : Sevk i̇şlemleri̇ sevkiyat bölümüne 2. plaka alanı eklendi
Developer: İlker Altındal
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP_RESULT' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PLATE2')
    BEGIN
        ALTER TABLE
        SHIP_RESULT
        ADD PLATE2 NVARCHAR(25) NULL
    END;
</querytag>