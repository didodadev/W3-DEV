<!-- Description : Company WRO
Developer: Uğur Hamurpet
Company : Workcube
Destination: Company -->

<querytag>      
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='ORDER_PRE_ROWS' AND COLUMN_NAME='UNIQUE_ID' )
    BEGIN   
        ALTER TABLE ORDER_PRE_ROWS ADD UNIQUE_ID nvarchar(500) NULL 
    END;
    
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='PRICE_RIVAL' AND COLUMN_NAME='DATE_EDIT' )
    BEGIN   
        ALTER TABLE PRICE_RIVAL ADD DATE_EDIT bit NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='PRICE_RIVAL' AND COLUMN_NAME='PRICE_TYPE' )
    BEGIN   
        ALTER TABLE PRICE_RIVAL ADD PRICE_TYPE int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='PRICE_RIVAL' AND COLUMN_NAME='TABLE_CODE' )
    BEGIN   
        ALTER TABLE PRICE_RIVAL ADD TABLE_CODE nvarchar(50) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='PRICE_RIVAL' AND COLUMN_NAME='PRICE_2' )
    BEGIN   
        ALTER TABLE PRICE_RIVAL ADD PRICE_2 float NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='ACCOUNTS' AND COLUMN_NAME='ACCOUNT_KMH_LIMIT' )
    BEGIN   
        ALTER TABLE ACCOUNTS ADD ACCOUNT_KMH_LIMIT float NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='ORDERS' AND COLUMN_NAME='ORDER_CODE' )
    BEGIN   
        ALTER TABLE ORDERS ADD ORDER_CODE nvarchar(50) NULL 
    END;
    
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='POS_EQUIPMENT' AND COLUMN_NAME='PATH' )
    BEGIN   
        ALTER TABLE POS_EQUIPMENT ADD PATH nvarchar(200) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='POS_EQUIPMENT' AND COLUMN_NAME='SERIAL_NUMBER' )
    BEGIN   
        ALTER TABLE POS_EQUIPMENT ADD SERIAL_NUMBER nvarchar(200) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='POS_EQUIPMENT' AND COLUMN_NAME='MALI_NO' )
    BEGIN   
        ALTER TABLE POS_EQUIPMENT ADD MALI_NO nvarchar(200) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='POS_EQUIPMENT' AND COLUMN_NAME='OFFLINE_PATH' )
    BEGIN   
        ALTER TABLE POS_EQUIPMENT ADD OFFLINE_PATH nvarchar(200) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='POS_EQUIPMENT' AND COLUMN_NAME='FILENAME' )
    BEGIN   
        ALTER TABLE POS_EQUIPMENT ADD FILENAME nvarchar(200) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='POS_EQUIPMENT' AND COLUMN_NAME='TYPE' )
    BEGIN   
        ALTER TABLE POS_EQUIPMENT ADD TYPE nvarchar(200) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='POS_EQUIPMENT' AND COLUMN_NAME='EQUIPMENT_CODE' )
    BEGIN   
        ALTER TABLE POS_EQUIPMENT ADD EQUIPMENT_CODE nvarchar(100) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='CREDIT_CARD' AND COLUMN_NAME='CLOSE_DATE' )
    BEGIN   
        ALTER TABLE CREDIT_CARD ADD CLOSE_DATE datetime NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='CREDIT_CARD' AND COLUMN_NAME='NEXT_PAYMENT_DATE' )
    BEGIN   
        ALTER TABLE CREDIT_CARD ADD NEXT_PAYMENT_DATE datetime NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='CREDIT_CARD' AND COLUMN_NAME='NEXT_CLOSE_DATE' )
    BEGIN   
        ALTER TABLE CREDIT_CARD ADD NEXT_CLOSE_DATE datetime NULL 
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONTRACT_INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [CONTRACT_INFO_PLUS_HISTORY](	  [INFO_ID_HIST] int NOT NULL IDENTITY(1,1)	, [INFO_ID] int NOT NULL	, [CONTRACT_ID] int NULL	, [PROPERTY1] nvarchar(500) NULL	, [PROPERTY2] nvarchar(500) NULL	, [PROPERTY3] nvarchar(500) NULL	, [PROPERTY4] nvarchar(500) NULL	, [PROPERTY5] nvarchar(500) NULL	, [PROPERTY6] nvarchar(500) NULL	, [PROPERTY7] nvarchar(500) NULL	, [PROPERTY8] nvarchar(500) NULL	, [PROPERTY9] nvarchar(500) NULL	, [PROPERTY10] nvarchar(500) NULL	, [PROPERTY11] nvarchar(500) NULL	, [PROPERTY12] nvarchar(500) NULL	, [PROPERTY13] nvarchar(500) NULL	, [PROPERTY14] nvarchar(500) NULL	, [PROPERTY15] nvarchar(500) NULL	, [PROPERTY16] nvarchar(500) NULL	, [PROPERTY17] nvarchar(500) NULL	, [PROPERTY18] nvarchar(500) NULL	, [PROPERTY19] nvarchar(500) NULL	, [PROPERTY20] nvarchar(500) NULL	, [PROPERTY21] nvarchar(500) NULL	, [PROPERTY22] nvarchar(500) NULL	, [PROPERTY23] nvarchar(500) NULL	, [PROPERTY24] nvarchar(500) NULL	, [PROPERTY25] nvarchar(500) NULL	, [PROPERTY26] nvarchar(500) NULL	, [PROPERTY27] nvarchar(500) NULL	, [PROPERTY28] nvarchar(500) NULL	, [PROPERTY29] nvarchar(500) NULL	, [PROPERTY30] nvarchar(500) NULL	, [PROPERTY31] nvarchar(500) NULL	, [PROPERTY32] nvarchar(500) NULL	, [PROPERTY33] nvarchar(500) NULL	, [PROPERTY34] nvarchar(500) NULL	, [PROPERTY35] nvarchar(500) NULL	, [PROPERTY36] nvarchar(500) NULL	, [PROPERTY37] nvarchar(500) NULL	, [PROPERTY38] nvarchar(500) NULL	, [PROPERTY39] nvarchar(500) NULL	, [PROPERTY40] nvarchar(500) NULL	, [COOKIE_NAME] nvarchar(250) NULL	, [RECORD_GUEST] bit NULL	, [RECORD_IP] nvarchar(50) NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [UPDATE_EMP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, CONSTRAINT [PK_CONTRACT_INFO_PLUS_HISTORY_INFO_ID_HIST] PRIMARY KEY ([INFO_ID_HIST] ASC));
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONTRACT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [CONTRACT_INFO_PLUS](	  [INFO_ID] int NOT NULL IDENTITY(1,1)	, [CONTRACT_ID] int NULL	, [PROPERTY1] nvarchar(500) NULL	, [PROPERTY2] nvarchar(500) NULL	, [PROPERTY3] nvarchar(500) NULL	, [PROPERTY4] nvarchar(500) NULL	, [PROPERTY5] nvarchar(500) NULL	, [PROPERTY6] nvarchar(500) NULL	, [PROPERTY7] nvarchar(500) NULL	, [PROPERTY8] nvarchar(500) NULL	, [PROPERTY9] nvarchar(500) NULL	, [PROPERTY10] nvarchar(500) NULL	, [PROPERTY11] nvarchar(500) NULL	, [PROPERTY12] nvarchar(500) NULL	, [PROPERTY13] nvarchar(500) NULL	, [PROPERTY14] nvarchar(500) NULL	, [PROPERTY15] nvarchar(500) NULL	, [PROPERTY16] nvarchar(500) NULL	, [PROPERTY17] nvarchar(500) NULL	, [PROPERTY18] nvarchar(500) NULL	, [PROPERTY19] nvarchar(500) NULL	, [PROPERTY20] nvarchar(500) NULL	, [PROPERTY21] nvarchar(500) NULL	, [PROPERTY22] nvarchar(500) NULL	, [PROPERTY23] nvarchar(500) NULL	, [PROPERTY24] nvarchar(500) NULL	, [PROPERTY25] nvarchar(500) NULL	, [PROPERTY26] nvarchar(500) NULL	, [PROPERTY27] nvarchar(500) NULL	, [PROPERTY28] nvarchar(500) NULL	, [PROPERTY29] nvarchar(500) NULL	, [PROPERTY30] nvarchar(500) NULL	, [PROPERTY31] nvarchar(500) NULL	, [PROPERTY32] nvarchar(500) NULL	, [PROPERTY33] nvarchar(500) NULL	, [PROPERTY34] nvarchar(500) NULL	, [PROPERTY35] nvarchar(500) NULL	, [PROPERTY36] nvarchar(500) NULL	, [PROPERTY37] nvarchar(500) NULL	, [PROPERTY38] nvarchar(500) NULL	, [PROPERTY39] nvarchar(500) NULL	, [PROPERTY40] nvarchar(500) NULL	, [COOKIE_NAME] nvarchar(250) NULL	, [RECORD_GUEST] bit NULL	, [RECORD_IP] nvarchar(50) NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [UPDATE_EMP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, CONSTRAINT [PK_CONTRACT_INFO_PLUS_INFO_ID] PRIMARY KEY ([INFO_ID] ASC));
    END;
</querytag>