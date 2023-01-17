<!-- Description : Holistic.22.1 main objects
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>  
    IF EXISTS(SELECT 'Y' FROM sys.indexes WHERE name='NCL_TRAINING_CAT_1' AND object_id = OBJECT_ID('@_dsn_main_@.TRAINING_CAT'))
    BEGIN
        DROP INDEX [NCL_TRAINING_CAT_1] ON [TRAINING_CAT];
    END;
    
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'TRAINING_CAT' AND COLUMN_NAME = 'UPDATE_DATE')
    BEGIN
        ALTER TABLE TRAINING_CAT ALTER COLUMN UPDATE_DATE date NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'TRAINING_CAT' AND COLUMN_NAME = 'RECORD_DATE')
    BEGIN
        ALTER TABLE TRAINING_CAT ALTER COLUMN RECORD_DATE date NULL;
    END;

    CREATE NONCLUSTERED INDEX [NCL_TRAINING_CAT_1] ON [TRAINING_CAT] ([TRAINING_LANGUAGE] ASC,[TRAINING_CAT_ID] ASC)

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SETUP_ALTERNATIVE_QUESTIONS' AND COLUMN_NAME = 'PROPERTY_ID')
    BEGIN
        ALTER TABLE SETUP_ALTERNATIVE_QUESTIONS ADD PROPERTY_ID int;
    END;

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME = 'DATA_DESIGN')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ALTER COLUMN DATA_DESIGN varchar(max) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'ACTION_PROCESS_CAT_ID')
    BEGIN
        ALTER TABLE PAGE_WARNINGS ADD ACTION_PROCESS_CAT_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'VIDEO')
    BEGIN
        ALTER TABLE WRK_FAMILY ADD VIDEO nvarchar(50) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'WIKI')
    BEGIN
        ALTER TABLE WRK_FAMILY ADD WIKI int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'COMMANDMENT' AND COLUMN_NAME = 'PAY_COMMANDMENT_VALUE')
    BEGIN
        ALTER TABLE COMMANDMENT ADD PAY_COMMANDMENT_VALUE float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_SPACE' AND COLUMN_NAME = 'ASSETP_CATID')
    BEGIN
        ALTER TABLE ASSET_P_SPACE ADD ASSETP_CATID int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_SPACE' AND COLUMN_NAME = 'EMPLOYEE_ID')
    BEGIN
        ALTER TABLE ASSET_P_SPACE ADD EMPLOYEE_ID int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_SPACE' AND COLUMN_NAME = 'DEPARTMENT_ID')
    BEGIN
        ALTER TABLE ASSET_P_SPACE ADD DEPARTMENT_ID int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_SPACE' AND COLUMN_NAME = 'POSITION_CODE')
    BEGIN
        ALTER TABLE ASSET_P_SPACE ADD POSITION_CODE int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_SPACE' AND COLUMN_NAME = 'RELATION_DESKS_ASSETP_ID')
    BEGIN
        ALTER TABLE ASSET_P_SPACE ADD RELATION_DESKS_ASSETP_ID int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_SPACE' AND COLUMN_NAME = 'IS_HORECA')
    BEGIN
        ALTER TABLE ASSET_P_SPACE ADD IS_HORECA int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_9_AMOUNT')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_9_AMOUNT float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_8_AMOUNT')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_8_AMOUNT float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_9')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_9 float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_11_AMOUNT')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_11_AMOUNT float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_12')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_12 float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_8')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_8 float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_10')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_10 float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_12_AMOUNT')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_12_AMOUNT float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_10_AMOUNT')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_10_AMOUNT float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'EXT_TOTAL_HOURS_11')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD EXT_TOTAL_HOURS_11 float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'AKDI_DAY')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD AKDI_DAY float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'AKDI_HOUR')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD AKDI_HOUR float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'AKDI_AMOUNT')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD AKDI_AMOUNT float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'COMPANY_LAW_REQUEST' AND COLUMN_NAME = 'ACCOUNT_CODE')
    BEGIN
        ALTER TABLE COMPANY_LAW_REQUEST ADD ACCOUNT_CODE nvarchar(100) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_SOLUTION' AND COLUMN_NAME = 'VIDEO')
    BEGIN
        ALTER TABLE WRK_SOLUTION ADD VIDEO nvarchar(50) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_SOLUTION' AND COLUMN_NAME = 'WIKI')
    BEGIN
        ALTER TABLE WRK_SOLUTION ADD WIKI int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SUBSCRIPTION_COUNTER_ROWS' AND COLUMN_NAME = 'COUNTER_OUTGOING')
    BEGIN
        ALTER TABLE SUBSCRIPTION_COUNTER_ROWS ADD COUNTER_OUTGOING int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SUBSCRIPTION_COUNTER_ROWS' AND COLUMN_NAME = 'COUNTER_INCOMING')
    BEGIN
        ALTER TABLE SUBSCRIPTION_COUNTER_ROWS ADD COUNTER_INCOMING int NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SUBSCRIPTION_COUNTER_ROWS' AND COLUMN_NAME = 'SUBSCRIPTION_NO')
    BEGIN
        ALTER TABLE SUBSCRIPTION_COUNTER_ROWS ALTER COLUMN SUBSCRIPTION_NO nvarchar(100) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_MODULE' AND COLUMN_NAME = 'VIDEO')
    BEGIN
        ALTER TABLE WRK_MODULE ADD VIDEO nvarchar(50) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_MODULE' AND COLUMN_NAME = 'WIKI')
    BEGIN
        ALTER TABLE WRK_MODULE ADD WIKI int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'RECYCLE_SUB_GROUP' AND COLUMN_NAME = 'RECYCLE_SUB_GROUP_CODE')
    BEGIN
        ALTER TABLE RECYCLE_SUB_GROUP ADD RECYCLE_SUB_GROUP_CODE int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'RECYCLE_SUB_GROUP' AND COLUMN_NAME = 'NUMBER_PRICE')
    BEGIN
        ALTER TABLE RECYCLE_SUB_GROUP ADD NUMBER_PRICE float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'RECYCLE_SUB_GROUP' AND COLUMN_NAME = 'KG_PRICE')
    BEGIN
        ALTER TABLE RECYCLE_SUB_GROUP ADD KG_PRICE float NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SPEC_PLP' AND COLUMN_NAME = 'COLOUR_M')
    BEGIN
        ALTER TABLE SPEC_PLP ALTER COLUMN COLOUR_M varchar(10) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SPEC_PLP' AND COLUMN_NAME = 'COLOUR_Y')
    BEGIN
        ALTER TABLE SPEC_PLP ALTER COLUMN COLOUR_Y varchar(10) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SPEC_PLP' AND COLUMN_NAME = 'ORDER_NO')
    BEGIN
        ALTER TABLE SPEC_PLP ALTER COLUMN ORDER_NO varchar(100) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SPEC_PLP' AND COLUMN_NAME = 'COLOUR_C')
    BEGIN
        ALTER TABLE SPEC_PLP ALTER COLUMN COLOUR_C varchar(10) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LOGIN' AND COLUMN_NAME = 'COORDINATE2')
    BEGIN
        ALTER TABLE WRK_LOGIN ADD COORDINATE2 nvarchar(50) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LOGIN' AND COLUMN_NAME = 'COORDINATE1')
    BEGIN
        ALTER TABLE WRK_LOGIN ADD COORDINATE1 nvarchar(50) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'BRANCH' AND COLUMN_NAME = 'ACC_UNIT_CODE')
    BEGIN
        ALTER TABLE BRANCH ADD ACC_UNIT_CODE nvarchar(43) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_DEMAND' AND COLUMN_NAME = 'ASSET_P_STATUS')
    BEGIN
        ALTER TABLE ASSET_P_DEMAND ADD ASSET_P_STATUS bit NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_DEMAND' AND COLUMN_NAME = 'ASSET_P_DEMAND')
    BEGIN
        ALTER TABLE ASSET_P_DEMAND ADD ASSET_P_DEMAND bit NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P' AND COLUMN_NAME = 'RELATION_DESKS_ASSETP_ID')
    BEGIN
        ALTER TABLE ASSET_P ADD RELATION_DESKS_ASSETP_ID int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P' AND COLUMN_NAME = 'DESK_CHAIR')
    BEGIN
        ALTER TABLE ASSET_P ADD DESK_CHAIR int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P' AND COLUMN_NAME = 'DESK_NO')
    BEGIN
        ALTER TABLE ASSET_P ADD DESK_NO nvarchar(100) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET' AND COLUMN_NAME = 'CONTENT_AUTHOR')
    BEGIN
        ALTER TABLE ASSET ADD CONTENT_AUTHOR int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'RECYCLE_GROUP' AND COLUMN_NAME = 'RECYCLE_MAIN_GROUP_CODE')
    BEGIN
        ALTER TABLE RECYCLE_GROUP ADD RECYCLE_MAIN_GROUP_CODE int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEE_DAILY_IN_OUT' AND COLUMN_NAME = 'IS_AKDI_DAY')
    BEGIN
        ALTER TABLE EMPLOYEE_DAILY_IN_OUT ADD IS_AKDI_DAY int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'INSURANCE_RATIO' AND COLUMN_NAME = 'AKDI_DAY_MULTIPLIER')
    BEGIN
        ALTER TABLE INSURANCE_RATIO ADD AKDI_DAY_MULTIPLIER float NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_MUHTASAR_EXPORTS' AND COLUMN_NAME = 'FILE_NAME_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_MUHTASAR_EXPORTS ADD FILE_NAME_5746 nvarchar(200) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WORKNET_RELATION_COMPANY' AND COLUMN_NAME = 'WATALOGY_CODE')
    BEGIN
        ALTER TABLE WORKNET_RELATION_COMPANY ALTER COLUMN WATALOGY_CODE varchar(250) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WORKNET_RELATION_COMPANY' AND COLUMN_NAME = 'WORKNET_DOMAIN')
    BEGIN
        ALTER TABLE WORKNET_RELATION_COMPANY ALTER COLUMN WORKNET_DOMAIN varchar(250) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WORKNET_RELATION_COMPANY' AND COLUMN_NAME = 'SELLER')
    BEGIN
        ALTER TABLE WORKNET_RELATION_COMPANY ALTER COLUMN SELLER varchar(250) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER' AND COLUMN_NAME = 'OUR_COMPANY_ID')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER ALTER COLUMN OUR_COMPANY_ID nvarchar(1000) NULL;
    END;

    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='MARKETPLACE_CATEGORIES')
    BEGIN
        CREATE TABLE [MARKETPLACE_CATEGORIES](	  [MARKETPLACE_CATEGORY_ID] int NULL	, [MARKETPLACE_CATEGORY_NAME] varchar(500) NULL	, [WORKCUBE_CATEGORY_ID] int NULL	, [WATALOGY_CATEGORY_ID] int NULL	, [HIERARCHY] varchar(250) NULL	, [MARKETPLACE] int NULL	, [ID] int NOT NULL IDENTITY(1,1)	, [DEPARTMENT_ID] int NULL	, [LOCATION_ID] int NULL	, [BRANCH_ID] int NULL	, [PRICE_ID] int NULL	, CONSTRAINT [PK_MARKETPLACE_CATEGORIES] PRIMARY KEY ([ID] ASC));
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='PROTEIN_DESIGN_BLOCKS')
    BEGIN
        CREATE TABLE [PROTEIN_DESIGN_BLOCKS](	  [DESIGN_BLOCK_ID] int NOT NULL IDENTITY(1,1)	, [BLOCK_CONTENT_TITLE] nvarchar(150) NULL	, [BLOCK_CONTENT] nvarchar(16) NULL	, [THUMBNAIL] nvarchar(150) NULL	, [AUTHOR] varchar(50) NULL	, [PROTEIN_WIDGET_ID] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, CONSTRAINT [PK_PROTEIN_DESIGN_BLOCKS] PRIMARY KEY ([DESIGN_BLOCK_ID] ASC));
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='ASSET_P_DESKS_GROUP')
    BEGIN
        CREATE TABLE [ASSET_P_DESKS_GROUP](	  [ASSET_P_DESKS_GROUP_ID] int NOT NULL IDENTITY(1,1)	, [DEPARTMENT_ID] int NULL	, [EMPLOYEE_ID] int NULL	, [ASSETP_CATID] int NULL	, [POSITION_CODE] int NULL	, [ASSET_P_SPACE_ID] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL);
    END;
</querytag>