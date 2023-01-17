<!-- Description : Etkinlik ek tablo ve alanları.
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ORGANIZATION' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'ORG_STAGE')
    BEGIN
        ALTER TABLE ORGANIZATION ADD ORG_STAGE INT
    END;
        
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_P_RESERVE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'ORGANIZATION_ID')
    BEGIN
        ALTER TABLE ASSET_P_RESERVE ADD ORGANIZATION_ID INT
    END;

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='ORGANIZATION_ATTENDER')
    BEGIN
        CREATE TABLE [ORGANIZATION_ATTENDER](
            [ORGANIZATION_ATTENDER_ID] [int] IDENTITY(1,1) NOT NULL,
            [ORGANIZATION_ID] [int] NOT NULL,
            [EMP_ID] [int] NULL,
            [COMP_ID] [int] NULL,
            [PAR_ID] [int] NULL,
            [CON_ID] [int] NULL,
            [GRP_ID] [int] NULL,
            [STATUS] [int] NULL,
            [IS_SELFSERVICE] [int] NULL,
            [DETAIL] [nvarchar](500) NULL,
            [PARTICIPATION_RATE] [float] NULL,
            [COMMENT] [nvarchar](500) NULL,
        CONSTRAINT [PK_ORGANIZATION_ATTENDER] PRIMARY KEY CLUSTERED 
        (
            [ORGANIZATION_ATTENDER_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='ORGANIZATION_PLUS')
    BEGIN
        CREATE TABLE [ORGANIZATION_PLUS](
            [ORGANIZATION_ID] [int] NULL,
            [ORGANIZATION_PLUS_ID] [int] IDENTITY(1,1) NOT NULL,
            [PLUS_DATE] [datetime] NULL,
            [COMMETHOD_ID] [int] NULL,
            [PARTNER_ID] [int] NULL,
            [EMPLOYEE_ID] [int] NULL,
            [PLUS_CONTENT] [nvarchar](max) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [SERVICE_ZONE] [int] NULL,
            [MAIL_SENDER] [nvarchar](250) NULL,
            [SUBJECT] [nvarchar](200) NULL,
            [CONSUMER_ID] [int] NULL,
            [MAIL_CC] [nvarchar](250) NULL,
            [IS_MAIL] [bit] NULL,
            [RECORD_PAR] [int] NULL,
        CONSTRAINT [PK_ORGANIZATION_PLUS_ORGANIZATION_PLUS_ID] PRIMARY KEY CLUSTERED 
        (
            [ORGANIZATION_PLUS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='ORGANIZATION_RESULT_REPORT')
    BEGIN
        CREATE TABLE [ORGANIZATION_RESULT_REPORT](
            [RESULT_REPORT_ID] [int] IDENTITY(1,1) NOT NULL,
            [ORGANIZATION_ID] [int] NOT NULL,
            [RESULT_HEAD] [nvarchar](200) NULL,
            [RESULT_DETAIL] [nvarchar](max) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [RECORD_PAR] [int] NULL,
            [UPDATE_PAR] [int] NULL,
        CONSTRAINT [PK_ORGANIZATION_RESULT_REPORT] PRIMARY KEY CLUSTERED 
        (
            [RESULT_REPORT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
</querytag>
