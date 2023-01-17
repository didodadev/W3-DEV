<!-- Description : Holistic.21.6 period wro
Developer: Uğur Hamurpet
Company : Workcube
Destination: Product -->
<querytag> 
IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME='WATALOGY_GOOGLE_PRODUCT_CAT')
BEGIN
    CREATE TABLE [WATALOGY_GOOGLE_PRODUCT_CAT](	  [GOOGLE_PRODUCT_CAT_ID] float NULL	, [CATEGORY1] nvarchar(255) NULL	, [CATEGORY2] nvarchar(255) NULL	, [CATEGORY3] nvarchar(255) NULL	, [CATEGORY4] nvarchar(255) NULL	, [CATEGORY5] nvarchar(255) NULL	, [CATEGORY6] nvarchar(255) NULL	, [CATEGORY7] nvarchar(255) NULL	, [WATALOGY_PRODUCT_CAT_ID] int NOT NULL IDENTITY(1,1)	, [HIERARCHY] nvarchar(255) NULL	, [CATEGORY_NAME] nvarchar(255) NULL	, CONSTRAINT [PK_WATALOGY_GOOGLE_PRODUCT_CAT] PRIMARY KEY ([WATALOGY_PRODUCT_CAT_ID] ASC));
END;
IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME='PROCUCT_CAT_MARKETPLACE_INTEGRATION')
BEGIN
    CREATE TABLE [PROCUCT_CAT_MARKETPLACE_INTEGRATION](	  [PROCUCT_CAT_MARKETPLACE_INTEGRATION_ID] int NOT NULL	, [PROCUCT_CAT_ID] int NULL	, [WORKNET_ID] int NULL	, [PROCUCT_CAT_MARKETPLACE_ID] int NULL	, [OUR_COMPANY_ID] int NULL	, [WATALOGY_PRODUCT_CAT_ID] int NULL	, [GOOGLE_PRODUCT_CAT_ID] int NULL	, [RECORD_IP] nvarchar(40) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(40) NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, CONSTRAINT [PK__PROCUCT___F94A139F6D7BA4B6] PRIMARY KEY ([PROCUCT_CAT_MARKETPLACE_INTEGRATION_ID] ASC));
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_PROPERTY' AND COLUMN_NAME = 'PROPERTY_COLLAR')
BEGIN
    
    IF EXISTS(SELECT 'Y' FROM sys.indexes WHERE name='NCL_PRODUCT_PROPERTY_1' AND object_id = OBJECT_ID('@_dsn_product_@.PRODUCT_PROPERTY'))
    BEGIN
        DROP INDEX [NCL_PRODUCT_PROPERTY_1] ON [PRODUCT_PROPERTY];
    END;
    IF EXISTS(SELECT 'Y' FROM sys.indexes WHERE name='NCL_PRODUCT_PROPERTY_2' AND object_id = OBJECT_ID('@_dsn_product_@.PRODUCT_PROPERTY'))
    BEGIN
        DROP INDEX [NCL_PRODUCT_PROPERTY_2] ON [PRODUCT_PROPERTY];
    END;
    ALTER TABLE PRODUCT_PROPERTY ADD PROPERTY_COLLAR bit;
    CREATE NONCLUSTERED INDEX [NCL_PRODUCT_PROPERTY_1] ON [PRODUCT_PROPERTY] ([PROPERTY_CODE] ASC) 
    CREATE NONCLUSTERED INDEX [NCL_PRODUCT_PROPERTY_2] ON [PRODUCT_PROPERTY] ([PROPERTY] ASC)
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_PROPERTY' AND COLUMN_NAME = 'PROPERTY_BODY_SIZE')
BEGIN
    ALTER TABLE PRODUCT_PROPERTY ADD PROPERTY_BODY_SIZE bit;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_MEMBER_ID')
BEGIN
    ALTER TABLE PRODUCT ADD PRODUCT_MEMBER_ID nvarchar(500);
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'WATALOGY_CODE')
BEGIN
    ALTER TABLE PRODUCT ADD WATALOGY_CODE nvarchar(500);
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'RECOVERY_AMOUNT')
BEGIN
    ALTER TABLE PRODUCT ADD RECOVERY_AMOUNT float;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_CAT' AND COLUMN_NAME = 'WATALOGY_CAT_ID')
BEGIN
    ALTER TABLE PRODUCT_CAT ADD WATALOGY_CAT_ID nvarchar(250);
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_CAT' AND COLUMN_NAME = 'IS_CASH_REGISTER')
BEGIN
    ALTER TABLE PRODUCT_CAT ADD IS_CASH_REGISTER bit;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_CAT' AND COLUMN_NAME = 'IS_WHOPS')
BEGIN
    ALTER TABLE PRODUCT_CAT ADD IS_WHOPS bit;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'SETUP_COMPANY_STOCK_CODE' AND COLUMN_NAME = 'UNIT_ID')
BEGIN
    ALTER TABLE SETUP_COMPANY_STOCK_CODE ADD UNIT_ID int;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRICE_STANDART' AND COLUMN_NAME = 'PROCESS_STAGE')
BEGIN
    ALTER TABLE PRICE_STANDART ADD PROCESS_STAGE int;
END;
</querytag>