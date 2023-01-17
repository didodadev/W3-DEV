<!-- Description : OFFER_ROW ve INTERNALDEMAND_ROW tablolarına EXPENSE_CENTER_ID,EXPENSE_ITEM_ID,ACTIVITY_TYPE_ID ve ACTIVITY_TYPE_ID alanları açıldı
Developer: Uğur Hamurpet
Company : Workcube
Destination: Company -->
<querytag>
    
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER_ROW' AND COLUMN_NAME = 'EXPENSE_CENTER_ID' )
    BEGIN
    ALTER TABLE OFFER_ROW ADD EXPENSE_CENTER_ID int NULL
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER_ROW' AND COLUMN_NAME = 'EXPENSE_ITEM_ID' )
    BEGIN
    ALTER TABLE OFFER_ROW ADD EXPENSE_ITEM_ID int NULL
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER_ROW' AND COLUMN_NAME = 'ACTIVITY_TYPE_ID' )
    BEGIN
    ALTER TABLE OFFER_ROW ADD ACTIVITY_TYPE_ID int NULL
	END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER_ROW' AND COLUMN_NAME = 'ACC_CODE' )
    BEGIN
    ALTER TABLE OFFER_ROW ADD ACC_CODE nvarchar(100) NULL
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INTERNALDEMAND_ROW' AND COLUMN_NAME = 'EXPENSE_CENTER_ID' )
    BEGIN
    ALTER TABLE INTERNALDEMAND_ROW ADD EXPENSE_CENTER_ID int NULL
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INTERNALDEMAND_ROW' AND COLUMN_NAME = 'EXPENSE_ITEM_ID' )
    BEGIN
    ALTER TABLE INTERNALDEMAND_ROW ADD EXPENSE_ITEM_ID int NULL
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INTERNALDEMAND_ROW' AND COLUMN_NAME = 'ACTIVITY_TYPE_ID' )
    BEGIN
    ALTER TABLE INTERNALDEMAND_ROW ADD ACTIVITY_TYPE_ID int NULL
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INTERNALDEMAND_ROW' AND COLUMN_NAME = 'ACC_CODE' )
    BEGIN
	ALTER TABLE INTERNALDEMAND_ROW ADD ACC_CODE nvarchar(100) NULL
    END;

</querytag>
