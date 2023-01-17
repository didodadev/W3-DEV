<!-- Description : WoDiBa Kural Seti Tabloları
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WODIBA_BANK_TRANSACTION_TYPES' )
    BEGIN
    CREATE TABLE [WODIBA_BANK_TRANSACTION_TYPES](
        [TRANSACTION_UID] [int] NOT NULL,
        [BANK_ID] [int] NULL,
        [TRANSACTION_CODE] [nvarchar](100) NULL,
        [TRANSACTION_CODE2] [nvarchar](100) NULL,
        [PROCESS_TYPE] [int] NULL,
        [DESCRIPTION_1] [nvarchar](500) NULL,
        [DESCRIPTION_2] [nvarchar](500) NULL,
        [IN_OUT] [nvarchar](3) NULL,
        [REC_USER] [int] NULL,
        [REC_DATE] [datetime] NULL,
        [REC_IP] [nvarchar](50) NULL,
        [UPD_USER] [int] NULL,
        [UPD_DATE] [datetime] NULL,
        [UPD_IP] [nvarchar](50) NULL
    ) ON [PRIMARY]
    END;

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WODIBA_RULE_SETS' )
    BEGIN
    CREATE TABLE [WODIBA_RULE_SETS](
        [RULE_ID] [int] IDENTITY(1,1) NOT NULL,
        [COMPANY_ID] [int] NULL,
        [PROCESS_TYPE] [int] NULL,
        [PROCESS_CAT_ID] [int] NULL,
        [REC_USER] [int] NULL,
        [REC_DATE] [datetime] NULL,
        [REC_IP] [nvarchar](50) NULL,
        [UPD_USER] [int] NULL,
        [UPD_DATE] [datetime] NULL,
        [UPD_IP] [nvarchar](50) NULL,
    CONSTRAINT [PK_WODIBA_RULE_SETS] PRIMARY KEY CLUSTERED
    (
        [RULE_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WODIBA_RULE_SET_ROWS' )
    BEGIN
    CREATE TABLE [WODIBA_RULE_SET_ROWS](
        [RULE_SET_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
        [RULE_ID] [int] NULL,
        [RULE_SET_ROW_NAME] [nvarchar](100) NULL,
        [ACCOUNT_ID] [int] NULL,
        [TRANSACTION_CODE] [nvarchar](100) NULL,
        [IBAN] [nvarchar](50) NULL,
        [VKN] [nvarchar](50) NULL,
        [DESCRIPTION] [nvarchar](250) NULL,
        [PROCESS_CAT_ID] [int] NULL,
        [EXPENSE_CENTER_ID] [int] NULL,
        [EXPENSE_ITEM_ID] [int] NULL,
        [PROJECT_ID] [int] NULL,
        [COMPANY_ID] [int] NULL,
        [CONSUMER_ID] [int] NULL,
        [EMPLOYEE_ID] [int] NULL,
        [PAYMENT_TYPE_ID] [int] NULL,
        [SPECIAL_DEFINITION_ID] [int] NULL,
        [ASSET_ID] [int] NULL,
        [BRANCH_ID] [int] NULL,
        [DEPARTMENT_ID] [int] NULL,
        [REC_USER] [int] NULL,
        [REC_DATE] [datetime] NULL,
        [REC_IP] [nvarchar](50) NULL,
        [UPD_USER] [int] NULL,
        [UPD_DATE] [datetime] NULL,
        [UPD_IP] [nvarchar](50) NULL,
    CONSTRAINT [PK_WODIBA_RULE_SET_ROWS] PRIMARY KEY CLUSTERED 
    (
        [RULE_SET_ROW_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;
</querytag>