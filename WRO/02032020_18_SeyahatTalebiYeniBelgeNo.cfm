<!-- Description : Seyahat talebi formu için belge no eklendi.
Developer: GULBAHAR INAN
Company : Workcube
Destination: Company -->
<querytag>
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'TRAVEL_DEMAND_NO')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD 
		TRAVEL_DEMAND_NO nvarchar(40) NULL DEFAULT 'STN'
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'TRAVEL_DEMAND_NUMBER')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD 
		TRAVEL_DEMAND_NUMBER int NULL DEFAULT 0
    END;
</querytag>