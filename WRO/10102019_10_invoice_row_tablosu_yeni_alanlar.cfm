<!-- Description : INVOICE_ROW tablosuna yeni kolonlar eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Period -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'ACTIVITY_TYPE_ID')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		ACTIVITY_TYPE_ID int NULL
    END;

	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'SUBSCRIPTION_ID')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		SUBSCRIPTION_ID int NULL
    END;

	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'ASSETP_ID')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		ASSETP_ID int NULL
    END;

	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'BSMV_RATE')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		BSMV_RATE float NULL
    END;

	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'BSMV_AMOUNT')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		BSMV_AMOUNT float NULL
    END;
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'BSMV_CURRENCY')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		BSMV_CURRENCY float NULL
    END;

	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'OIV_RATE')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		OIV_RATE float NULL
    END;
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'OIV_AMOUNT')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		OIV_AMOUNT float NULL
    END;
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'TEVKIFAT_RATE')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		TEVKIFAT_RATE float NULL
    END;
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'TEVKIFAT_AMOUNT')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD 
		TEVKIFAT_AMOUNT float NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'BSMV_TOTAL')
    BEGIN
        ALTER TABLE INVOICE ADD 
		BSMV_TOTAL float NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'OIV_TOTAL')
    BEGIN
        ALTER TABLE INVOICE ADD 
		OIV_TOTAL float NULL
    END;
</querytag>