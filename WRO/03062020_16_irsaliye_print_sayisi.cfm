<!-- Description : SHIP tablosuna print edilme sayisi.
Developer: Yunus Özay
Company : Team Yazılım
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PRINT_COUNT')
    BEGIN
        ALTER TABLE SHIP ADD PRINT_COUNT int NULL
    END;
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PRINT_DATE')
    BEGIN
        ALTER TABLE SHIP ADD PRINT_DATE datetime NULL
    END;
</querytag>
