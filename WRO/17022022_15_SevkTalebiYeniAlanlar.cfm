<!-- Description : Sevk talebi yeni alanlar
Developer: Fatih Kara
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'SHIP_INTERNAL_ROW' AND COLUMN_NAME = 'AMOUNT2')
    BEGIN
        ALTER TABLE SHIP_INTERNAL_ROW ADD 
        AMOUNT2 FLOAT NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'SHIP_INTERNAL_ROW' AND COLUMN_NAME = 'UNIT2')
    BEGIN
        ALTER TABLE SHIP_INTERNAL_ROW ADD 
        UNIT2 nvarchar(50) NULL
    END;
</querytag>