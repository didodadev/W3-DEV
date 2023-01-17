<!-- Description : Sevk i̇şlemleri̇ sevkiyat bölümüne taşiyici elle gi̇ri̇ldi̇ği̇nde tc alani eklendi̇ 
Developer: Halit Yurttaş
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP_RESULT' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'DELIVER_EMP_TC')
    BEGIN
        ALTER TABLE
        SHIP_RESULT
        ADD DELIVER_EMP_TC NVARCHAR(11) NULL
    END;
</querytag>