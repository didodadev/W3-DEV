<!-- Description : INVENTORY ve INVENTORY_HISTORY Tablolarına Yeni Alanları Eklendi.
Developer: Tufan Çakıroğlu
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INVENTORY' AND COLUMN_NAME = 'IFRS_INVENTORY_DURATION')
    BEGIN
        ALTER TABLE INVENTORY ADD
        IFRS_INVENTORY_DURATION float NULL
    END;
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INVENTORY' AND COLUMN_NAME = 'ACTIVITY_TYPE_ID')
    BEGIN
        ALTER TABLE INVENTORY ADD
        ACTIVITY_TYPE_ID int NULL
    END;
	
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INVENTORY_HISTORY' AND COLUMN_NAME = 'ACTIVITY_ID')
    BEGIN
        ALTER TABLE INVENTORY_HISTORY ADD
        ACTIVITY_ID int NULL
    END;

	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INVENTORY_HISTORY' AND COLUMN_NAME = 'IFRS_INVENTORY_DURATION')
    BEGIN
        ALTER TABLE INVENTORY_HISTORY ADD
        IFRS_INVENTORY_DURATION float NULL
    END;
</querytag>