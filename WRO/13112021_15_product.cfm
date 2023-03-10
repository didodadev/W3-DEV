<!-- Description : Holistic 21.1 tablo ve kolon farkları wrosu
Developer: Fatih Kara
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'WORKNET_PRODUCT' AND COLUMN_NAME = 'RELATED_PRODUCT_ID')
    BEGIN
      ALTER TABLE WORKNET_PRODUCT ADD RELATED_PRODUCT_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PACKETING_ROW')
    BEGIN
      CREATE TABLE [PACKETING_ROW](	  [PACKET_ROW_ID] int NOT NULL IDENTITY(1,1)	, [STOCK_ID] int NULL	, [PRODUCT_ID] int NULL	, [UPD_ID] int NULL	, [ROW_IN] float NULL DEFAULT((0))	, [ROW_OUT] float NULL DEFAULT((0))	, [STORE] int NULL	, [STORE_LOCATION] int NULL	, [AMOUNT2] float NULL	, [UNIT2] nvarchar(50) NULL	, [SPECIAL_CODE] nvarchar(50) NULL	, [ROW_ID] int NULL	, [WRK_ROW_ID] nvarchar(50) NULL	, [DEPTH_VALUE] float NULL	, [WIDTH_VALUE] float NULL	, [HEIGHT_VALUE] float NULL	, [UNIT] nvarchar(50) NULL	, [UNIT_ID] int NULL	, [ORDER_ID] int NULL	, [P_RESULT_ID] int NULL	, CONSTRAINT [PK_PACKETING_ROW] PRIMARY KEY ([PACKET_ROW_ID] ASC));
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PACKETING')
    BEGIN
      CREATE TABLE [PACKETING](	  [PACKET_ID] int NOT NULL IDENTITY(1,1)	, [PACKAGE_STAGE] int NULL	, [RELATED_TYPE] int NOT NULL	, [ORDER_ID] int NULL	, [SHIP_ID] int NULL	, [PROD_RESULT_ID] int NULL	, [PACKAGE_NO] nvarchar(50) NULL	, [BARCOD] nvarchar(50) NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [RECORD_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, [PACKAGE_TYPE_ID] int NULL	, [MAX_VOLUME] int NULL	, [MAX_WIDTH] int NULL	, [COMPANY_ID] int NULL	, [PARTNER_ID] int NULL	, [CONSUMER_ID] int NULL	, [PROJECT_ID] int NULL	, [DEPARTMENT_ID] int NULL	, [ACTION_DATE] datetime NULL	, [DESCRIPTION] nvarchar(300) NULL	, [RELATED_PAPER_NO] nvarchar(50) NULL	, CONSTRAINT [PK_PACKETING] PRIMARY KEY ([PACKET_ID] ASC));
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_DESCRIPTION')
    BEGIN
      ALTER TABLE PRODUCT ADD PRODUCT_DESCRIPTION nvarchar(500);
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'INSTRUCTION')
    BEGIN
      ALTER TABLE PRODUCT ADD INSTRUCTION nvarchar(1000);
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'WATALOGY_CAT_ID')
    BEGIN
      ALTER TABLE PRODUCT ALTER COLUMN WATALOGY_CAT_ID varchar(100) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_DETAIL_WATALOGY')
    BEGIN
      ALTER TABLE PRODUCT ADD PRODUCT_DETAIL_WATALOGY nvarchar(500);
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_KEYWORD')
    BEGIN
      ALTER TABLE PRODUCT ADD PRODUCT_KEYWORD nvarchar(500);
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'STOCKS' AND COLUMN_NAME = 'INSTRUCTION')
    BEGIN
      ALTER TABLE STOCKS ADD INSTRUCTION nvarchar(1000);
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'STOCKS' AND COLUMN_NAME = 'COUNTER_MULTIPLIER')
    BEGIN
      ALTER TABLE STOCKS ADD COUNTER_MULTIPLIER float;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'STOCKS' AND COLUMN_NAME = 'FRIENDLY_URL')
    BEGIN
      ALTER TABLE STOCKS ADD FRIENDLY_URL nvarchar(1000);
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'STOCKS' AND COLUMN_NAME = 'PACKAGE_TYPE_ID')
    BEGIN
      ALTER TABLE STOCKS ADD PACKAGE_TYPE_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'STOCKS' AND COLUMN_NAME = 'COUNTER_TYPE_ID')
    BEGIN
      ALTER TABLE STOCKS ADD COUNTER_TYPE_ID int;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_IMAGES' AND COLUMN_NAME = 'VIDEO_PATH')
    BEGIN
      ALTER TABLE PRODUCT_IMAGES ALTER COLUMN VIDEO_PATH nvarchar(200) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_IMAGES' AND COLUMN_NAME = 'PRD_IMG_NAME')
    BEGIN
      ALTER TABLE PRODUCT_IMAGES ALTER COLUMN PRD_IMG_NAME nvarchar(200) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRICE_STANDART' AND COLUMN_NAME = 'STOCK_ID')
    BEGIN
      ALTER TABLE PRICE_STANDART ADD STOCK_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'WORKNET_PRODUCT' AND COLUMN_NAME = 'WATALOGY_CON_ID')
    BEGIN
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_1' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_1] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_2' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_2] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_3' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_3] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_4' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_4] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_5' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_5] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_6' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_6] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_7' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_7] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_8' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_8] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_9' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_9] ON [PRODUCT] 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_TEST_' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_TEST_] ON [PRODUCT]
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_IMAGES_1' AND object_id = OBJECT_ID('[PRODUCT_IMAGES]'))
      BEGIN
      DROP INDEX [NCL_PRODUCT_IMAGES_1] ON [PRODUCT_IMAGES] 
      END;
      ALTER TABLE WORKNET_PRODUCT ADD WATALOGY_CON_ID int;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_1' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_1] ON [PRODUCT] ([PRODUCT_CATID] ASC,[PRODUCT_ID] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_2' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_2] ON [PRODUCT] ([UPDATE_DATE] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_3' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_3] ON [PRODUCT] ([RECORD_DATE] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_4' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_4] ON [PRODUCT] ([PRODUCT_CODE] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_5' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_5] ON [PRODUCT] ([PRODUCT_MANAGER] ASC,[PRODUCT_ID] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_6' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_6] ON [PRODUCT] ([COMPANY_ID] ASC,[PRODUCT_ID] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_7' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_7] ON [PRODUCT] ([BRAND_ID] ASC,[PRODUCT_ID] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_8' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_8] ON [PRODUCT] ([PRODUCT_STAGE] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_9' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_9] ON [PRODUCT] ([IS_INVENTORY] ASC,[PRODUCT_ID] ASC,[PRODUCT_NAME] ASC)
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_TEST_' AND object_id = OBJECT_ID('[PRODUCT]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_TEST_] ON [PRODUCT] ([IS_COST] ASC,[PRODUCT_ID] ASC) 
      END;
      IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_IMAGES_1' AND object_id = OBJECT_ID('[PRODUCT_IMAGES]'))
      BEGIN
      CREATE NONCLUSTERED INDEX [NCL_PRODUCT_IMAGES_1] ON [PRODUCT_IMAGES] ([PRODUCT_ID] ASC,[IMAGE_SIZE] ASC,[PRODUCT_IMAGEID] ASC,[PATH] ASC,[DETAIL] ASC,[PATH_SERVER_ID] ASC)
      END;
    END;
</querytag>