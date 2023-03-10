<!-- Description : company_info ve session tablolarına eshipment ve date alanları, eshipment tanım tablosu eklendi.
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OUR_COMPANY_INFO' AND COLUMN_NAME = 'IS_ESHIPMENT')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO ADD 
		IS_ESHIPMENT bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OUR_COMPANY_INFO' AND COLUMN_NAME = 'ESHIPMENT_DATE')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO ADD 
		ESHIPMENT_DATE datetime NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SESSION' AND COLUMN_NAME = 'IS_ESHIPMENT')
    BEGIN
        ALTER TABLE WRK_SESSION ADD 
		IS_ESHIPMENT bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SESSION' AND COLUMN_NAME = 'ESHIPMENT_DATE')
    BEGIN
        ALTER TABLE WRK_SESSION ADD 
		ESHIPMENT_DATE datetime NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ESHIPMENT_INTEGRATION_INFO' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
    CREATE TABLE [ESHIPMENT_INTEGRATION_INFO](
        [ID] [int] IDENTITY(1,1) NOT NULL,
        [COMP_ID] [int] NULL,
        [UBLVERSIONID] [nvarchar](50) NULL,
        [CUSTOMIZATIONID] [nvarchar](50) NULL,
        [RECEIVED_LAST_DATE] [datetime] NULL,
        [TEMPLATE_FILENAME] [nvarchar](200) NULL,
        [TEMPLATE_FILENAME_BASE64] [nvarchar](250) NULL,
        [ESHIPMENT_NUMBER] [nvarchar](50) NULL,
        [ESHIPMENT_PREFIX] [nvarchar](50) NULL,
        [IS_TEMPLATE_CODE] [bit] NULL,
        [IS_RECEIVING_PROCESS] [bit] NULL,
        [SPECIAL_PERIOD] [bit] NULL,
        [IS_MULTIPLE_PREFIX] [bit] NULL,
        [ESHIPMENT_TYPE] [int] NULL,
        [ESHIPMENT_TEST_SYSTEM] [bit] NULL,
        [ESHIPMENT_SIGNATURE_URL] [nvarchar](250) NULL,
        [ESHIPMENT_COMPANY_CODE] [nvarchar](50) NULL,
        [ESHIPMENT_USER_NAME] [nvarchar](50) NULL,
        [ESHIPMENT_PASSWORD] [nvarchar](50) NULL,
        [ESHIPMENT_SENDER_ALIAS] [nvarchar](50) NULL,
        [ESHIPMENT_RECEIVER_ALIAS] [nvarchar](50) NULL,
    CONSTRAINT [PK_ESHIPMENT_INTEGRATION_INFO] PRIMARY KEY CLUSTERED 
    (
        [ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END

</querytag>
