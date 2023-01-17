<!-- Description : Tahakkuk Planlama ile ilgil tablolar açıldı.
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'TAHAKKUK_PLAN_NO')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD 
		TAHAKKUK_PLAN_NO nvarchar(40) NULL DEFAULT 'THK'
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'TAHAKKUK_PLAN_NUMBER')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD 
		TAHAKKUK_PLAN_NUMBER int NULL DEFAULT 0
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAHAKKUK_PLAN' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [TAHAKKUK_PLAN](
            [TAHAKKUK_PLAN_ID] [int] IDENTITY(1,1) NOT NULL,
            [PROCESS_TYPE] [int] NULL,
            [PROCESS_CAT] [int] NULL,
            [PAPER_NO] [nvarchar](40) NULL,
            [START_DATE] [datetime] NULL,
            [FINISH_DATE] [datetime] NULL,
            [DUE_DATE] [datetime] NULL,
            [NET_TOTAL] [float] NULL,
            [NET_TOTAL_SYSTEM] [float] NULL,
            [MEMBER_TYPE] [nvarchar](50) NULL,
            [COMPANY_ID] [int] NULL,
            [CONSUMER_ID] [int] NULL,
            [PARTNER_ID] [int] NULL,
            [EMPLOYEE_ID] [int] NULL,
            [PROJECT_ID] [int] NULL,
            [ASSETP_ID] [int] NULL,
            [EXPENSE_CENTER_ID] [int] NULL,
            [ACCOUNT_CODE] [nvarchar](150) NULL,
            [MONTH_EXPENSE_ITEM_ID] [int] NULL,
            [MONTH_ACCOUNT_CODE] [nvarchar](150) NULL,
            [YEAR_EXPENSE_ITEM_ID] [int] NULL,
            [YEAR_ACCOUNT_CODE] [nvarchar](150) NULL,
            [IS_PROJECT_ACCOUNT] [bit] NULL,
            [DETAIL] [nvarchar](1000) NULL,
            [EXPENSE_TOTAL] [float] NULL,
            [OTHER_EXPENSE_TOTAL] [float] NULL,
            [OTHER_MONEY] [nvarchar](43) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [DEPARTMENT_ID] [int] NULL,
            [BRANCH_ID] [int] NULL,
            [PERIOD_ID] [int] NULL,
            [WRK_ID] [nvarchar](75) NULL,
            [TAX_TOTAL] [float] NULL,
            [OTHER_TAX_TOTAL] [float] NULL,
            [OTHER_NET_TOTAL] [float] NULL,
            [TAX] [float] NULL,
            [PAYMETHOD_ID] [int] NULL,
            [CARD_PAYMETHOD_ID] [int] NULL,
            [CARI_ACTION_TYPE] [int] NULL,
        CONSTRAINT [PK_TAHAKKUK_PLAN] PRIMARY KEY CLUSTERED 
        (
            [TAHAKKUK_PLAN_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAHAKKUK_PLAN_ROW' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [TAHAKKUK_PLAN_ROW](
            [TAHAKKUK_PLAN_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
            [TAHAKKUK_PLAN_ID] [int] NULL,
            [ROW_PLAN_DATE] [datetime] NULL,
            [ROW_DETAIL] [nvarchar](500) NULL,
            [ROW_EXPENSE_CENTER_ID] [int] NULL,
            [ROW_EXPENSE_ITEM_ID] [int] NULL,
            [ROW_ACCOUNT_CODE] [nvarchar](50) NULL,
            [ROW_TOTAL_EXPENSE] [float] NULL,
            [ROW_OTHER_TOTAL_EXPENSE] [float] NULL,
            [ROW_OTHER_MONEY] [nvarchar](43) NULL,
            [IS_PROCESS] [bit] NULL,
            [PROCESS_ACTION_ID] [int] NULL,
            [PROCESS_ACTION_TYPE] [int] NULL,
            [WRK_ROW_ID] [nvarchar](75) NULL,
            [PROCESS_PERIOD_ID] [int] NULL,
            [WRK_ROW_RELATION_ID] [nvarchar](75) NULL,
            [ROW_TOTAL_EXPENSE_TAX] [float] NULL,
            [ROW_OTHER_TOTAL_EXPENSE_TAX] [float] NULL,
            [ROW_TOTAL_EXPENSE_NET] [float] NULL,
            [ROW_OTHER_TOTAL_EXPENSE_NET] [float] NULL,
            [ROW_DUE_VALUE] [int] NULL,
            [ROW_DUE_DATE] [datetime] NULL,
        CONSTRAINT [PK_TAHAKKUK_PLAN_ROW] PRIMARY KEY CLUSTERED 
        (
            [TAHAKKUK_PLAN_ROW_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAHAKKUK_PLAN_MONEY' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [TAHAKKUK_PLAN_MONEY](
            [ID] [int] IDENTITY(1,1) NOT NULL,
            [ACTION_ID] [int] NOT NULL,
            [MONEY_TYPE] [nvarchar](43) NULL,
            [RATE2] [float] NULL,
            [RATE1] [float] NULL,
            [IS_SELECTED] [bit] NULL,
        CONSTRAINT [PK_TAHAKKUK_PLAN_MONEY] PRIMARY KEY CLUSTERED 
        (
            [ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAHAKKUK_PLAN_ROW_RELATION' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [TAHAKKUK_PLAN_ROW_RELATION](
            [TAHAKKUK_PLAN_RELATION_ID] [int] IDENTITY(1,1) NOT NULL,
            [WRK_ROW_ID] [nvarchar](75) NULL,
            [PERIOD_ID] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
        CONSTRAINT [PK_TAHAKKUK_PLAN_ROW_RELATION] PRIMARY KEY CLUSTERED 
        (
            [TAHAKKUK_PLAN_RELATION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAHAKKUK_PAYMENT_PLAN' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [TAHAKKUK_PAYMENT_PLAN](
            [TAHAKKUK_PAYMENT_PLAN_ID] [int] IDENTITY(1,1) NOT NULL,
            [TAHAKKUK_ID] [int] NULL,
            [PERIOD_ID] [int] NULL,
            [COMPANY_ID] [int] NULL,
            [ACTION_DETAIL] [nvarchar](250) NULL,
            [INVOICE_NUMBER] [nvarchar](50) NULL,
            [INVOICE_DATE] [datetime] NULL,
            [DUE_DATE] [datetime] NULL,
            [ACTION_VALUE] [float] NULL,
            [OTHER_ACTION_VALUE] [float] NOT NULL,
            [PAYMENT_VALUE] [float] NULL,
            [OTHER_MONEY] [nvarchar](43) NULL,
            [PAYMENT_METHOD_ROW] [int] NULL,
            [IS_CASH_PAYMENT] [bit] NULL,
            [IS_ACTIVE] [bit] NULL,
            [IS_BANK] [bit] NULL,
            [IS_PAID] [bit] NULL,
            [IS_BANK_IPTAL] [bit] NULL,
            [FILE_ID] [int] NULL,
            [RESULT_CODE] [nvarchar](10) NULL,
            [RESULT_DETAIL] [nvarchar](25) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [BANK_ACTION_ID] [int] NULL,
            [BANK_PERIOD_ID] [int] NULL,
            [DISCOUNT_TOTAL] [float] NULL,
            [PAYMENT_DATE] [datetime] NULL,
            [CONSUMER_ID] [int] NULL,
            [EMPLOYEE_ID] [int] NULL,
        CONSTRAINT [PK_TAHAKKUK_PAYMENT_PLAN] PRIMARY KEY CLUSTERED 
        (
            [TAHAKKUK_PAYMENT_PLAN_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>
