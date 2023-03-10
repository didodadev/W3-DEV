<!-- Description : e-mustahsil makbuz tanım tablosu
Developer: İlker Altındal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EPRODUCER_RECEIPT_INTEGRATION_INFO' )
    BEGIN
        CREATE TABLE [EPRODUCER_RECEIPT_INTEGRATION_INFO](
            [ID] [int] IDENTITY(1,1) NOT NULL,
            [COMP_ID] [int] NULL,
            [TEMPLATE_FILENAME] [nvarchar](200) NULL,
            [TEMPLATE_FILENAME_BASE64] [nvarchar](250) NULL,
            [EPRODUCER_NUMBER] [nvarchar](50) NULL,
            [EPRODUCER_PREFIX] [nvarchar](50) NULL,
            [EPRODUCER_TEST_SYSTEM] [bit] NULL,
            [EPRODUCER_COMPANY_CODE] [nvarchar](50) NULL,
            [EPRODUCER_USER_NAME] [nvarchar](50) NULL,
            [EPRODUCER_PASSWORD] [nvarchar](50) NULL,
            [EPRODUCER_LIVE_URL] [nvarchar](500) NULL,
            [EPRODUCER_TEST_URL] [nvarchar](500) NULL,
        CONSTRAINT [PK_EPRODUCER_RECEIPT_INTEGRATION_INFO] PRIMARY KEY CLUSTERED 
        (
            [ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='OUR_COMPANY_INFO' AND COLUMN_NAME='IS_EPRODUCER_RECEIPT')
    BEGIN   
        ALTER TABLE OUR_COMPANY_INFO
        ADD IS_EPRODUCER_RECEIPT BIT NULL
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='OUR_COMPANY_INFO' AND COLUMN_NAME='EPRODUCER_RECEIPT_DATE')
    BEGIN   
        ALTER TABLE OUR_COMPANY_INFO
        ADD EPRODUCER_RECEIPT_DATE datetime NULL
    END;
</querytag>