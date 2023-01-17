<!-- Description : Period şemasına yeni alanlar ve tablolar eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_LIMB' AND TABLE_SCHEMA = '@_dsn_period_@') 
    BEGIN
        CREATE TABLE [SETUP_HEALTH_ASSURANCE_TYPE_LIMB](	  [ASSURANCE_LIMB_ID] int NOT NULL IDENTITY(1,1)	, [LIMB_ID] int NULL	, [ASSURANCE_ID] int NULL	, [PERIOD] int NULL	, [MAX] int NULL	, [NOTE] nvarchar(100) NULL	, CONSTRAINT [PK__SETUP_HE__58137D7D6ABB8788] PRIMARY KEY ([ASSURANCE_LIMB_ID] ASC));
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'EMPLOYEE_HEALTH_AMOUNT')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD EMPLOYEE_HEALTH_AMOUNT float;
    END;


    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'EXPENSE_ITEM_PLANS_ID')
    BEGIN
       ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD EXPENSE_ITEM_PLANS_ID int;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'OUR_COMPANY_HEALTH_AMOUNT')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD OUR_COMPANY_HEALTH_AMOUNT float;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CASH_ACTIONS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'SUBSCRIPTION_ID')
    BEGIN
        ALTER TABLE CASH_ACTIONS ADD SUBSCRIPTION_ID int
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_NAME = 'SETUP_LIMB' AND TABLE_SCHEMA = '@_dsn_period_@') 
    BEGIN
        CREATE TABLE [SETUP_LIMB](	  [LIMB_ID] int NOT NULL IDENTITY(1,1)	, [LIMB_NAME] nvarchar(100) NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(43) NULL	, CONSTRAINT [PK__SETUP_LI__B7AD21AAE407E28F] PRIMARY KEY ([LIMB_ID] ASC));
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PRODUCT_MANUFACT_CODE')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD
        PRODUCT_MANUFACT_CODE nvarchar(50)  NULL;
    END
    ELSE
    BEGIN
        ALTER TABLE INVOICE_ROW ALTER COLUMN PRODUCT_MANUFACT_CODE nvarchar(50)  NULL;
    END;

</querytag>
