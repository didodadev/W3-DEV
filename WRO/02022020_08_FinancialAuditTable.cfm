<!-- Description : Mali tablolar tanımları ve finansal tablo kopyalam tablo tanımları
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FINANCIAL_AUDIT' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [FINANCIAL_AUDIT](
            [FINANCIAL_AUDIT_ID] [int] IDENTITY(1,1) NOT NULL,
            [TABLE_NAME] [nvarchar](250) NULL,
            [TABLE_TYPE] [int] NULL,
            [PROCESS_STAGE] [int] NULL,
            [DETAIL] [nvarchar](500) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_FINANCIAL_AUDIT] PRIMARY KEY CLUSTERED 
        (
            [FINANCIAL_AUDIT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FINANCIAL_AUDIT_ROW' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [FINANCIAL_AUDIT_ROW](
        [FINANCIAL_AUDIT_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
        [FINANCIAL_AUDIT_ID] [int] NOT NULL,
        [CODE] [nvarchar](43) NULL,
        [NAME] [nvarchar](150) NULL,
        [ACCOUNT_CODE] [nvarchar](50) NULL,
        [SIGN] [nvarchar](43) NULL,
        [BA] [bit] NULL,
        [VIEW_AMOUNT_TYPE] [int] NULL,
        [IFRS_CODE] [nvarchar](50) NULL,
        [NAME_LANG_NO] [int] NULL,
        [IS_SHOW] [bit] NULL,
        [IS_CUMULATIVE] [bit] NULL
        ) ON [PRIMARY]
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FINANCIAL_TABLES_COPIES' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
            CREATE TABLE [FINANCIAL_TABLES_COPIES](
            [FINANCIAL_TABLE_ID] [int] IDENTITY(1,1) NOT NULL,
            [TABLE_NAME] [nvarchar](250) NULL,
            [TABLE_PATH] [nvarchar](250) NULL,
            [IS_IFRS] [bit] NULL,
            [PROCESS_STAGE] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [ARRANGEMENT_DATE] [datetime] NULL,
            [ARRANGEMENT_EMP] [int] NULL
        ) ON [PRIMARY]
    END
</querytag>