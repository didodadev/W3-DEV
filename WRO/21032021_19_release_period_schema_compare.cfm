<!-- Description : Release Period Schema Compare
Developer: Uğur Hamurpet
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ERECEIPT_SENDING_DETAIL' AND TABLE_SCHEMA = '@_dsn_period_@' )
    BEGIN
        CREATE TABLE [ERECEIPT_SENDING_DETAIL](	  [SENDING_DETAIL_ID] int NOT NULL IDENTITY(1,1)	, [SERVICE_RESULT] nvarchar(50) NULL	, [UUID] nvarchar(50) NULL	, [ERECEIPT_ID] nvarchar(50) NULL	, [STATUS_DESCRIPTION] nvarchar(50) NULL	, [STATUS_CODE] nvarchar(50) NULL	, [ERROR_CODE] nvarchar(50) NULL	, [ACTION_ID] int NULL	, [ACTION_TYPE] nvarchar(50) NULL	, [SERVICE_RESULT_DESCRIPTION] nvarchar(250) NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, CONSTRAINT [PK_ERECEIPT_SENDING_DETAIL] PRIMARY KEY ([SENDING_DETAIL_ID] ASC));
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ERECEIPT_RELATION' AND TABLE_SCHEMA = '@_dsn_period_@' )
    BEGIN
        CREATE TABLE [ERECEIPT_RELATION](	  [RELATION_ID] int NOT NULL IDENTITY(1,1)	, [ACTION_ID] int NULL	, [ACTION_TYPE] nvarchar(50) NULL	, [ERECEIPT_ID] nvarchar(50) NULL	, [UUID] nvarchar(50) NULL	, [PATH] nvarchar(250) NULL	, [PROFILE_ID] nvarchar(50) NULL	, [INTEGRATION_ID] nvarchar(50) NULL	, [IS_PAPER_UPDATE] bit NULL	, [STATUS_CODE] int NULL	, [STATUS_DESCRIPTION] nvarchar(250) NULL	, [STATUS_DATE] datetime NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [RECEIPT_UUID] nvarchar(250) NULL	, [RECEIPT_ID] nvarchar(250) NULL	, CONSTRAINT [PK_ERECEIPT_RELATION] PRIMARY KEY ([RELATION_ID] ASC));
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP_INTERNAL' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'CODE')
    BEGIN
        ALTER TABLE SHIP_INTERNAL ADD CODE nvarchar(50)
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP_INTERNAL' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PAPER_NO')
    BEGIN
        ALTER TABLE SHIP_INTERNAL ADD PAPER_NO nvarchar(50)
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BANK_ACTIONS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'BILL_ID')
    BEGIN
        ALTER TABLE BANK_ACTIONS ADD BILL_ID int
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'IS_BANK')
    BEGIN
        ALTER TABLE INVOICE ADD IS_BANK bit
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'IS_CREDITCARD')
    BEGIN
        ALTER TABLE INVOICE ADD IS_CREDITCARD bit
    END;
</querytag>