<!-- Description : e-makbuz ilişki tanım tablosu
Developer: Fatih Kara
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='ERECEIPT_RELATION' )
    BEGIN
        CREATE TABLE [ERECEIPT_RELATION](
            [RELATION_ID] [int] IDENTITY(1,1) NOT NULL,
            [ACTION_ID] [int] NULL,
            [ACTION_TYPE] [nvarchar](50) NULL,
            [ERECEIPT_ID] [nvarchar](50) NULL,
            [UUID] [nvarchar](50) NULL,
            [PATH] [nvarchar](250) NULL,
            [PROFILE_ID] [nvarchar](50) NULL,
            [INTEGRATION_ID] [nvarchar](50) NULL,
            [IS_PAPER_UPDATE] [bit] NULL,
            [STATUS_CODE] [int] NULL,
            [STATUS_DESCRIPTION] [nvarchar](250) NULL,
            [STATUS_DATE] [datetime] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECEIPT_UUID] [nvarchar](250) NULL,
            [RECEIPT_ID] [nvarchar](250) NULL,
        CONSTRAINT [PK_ERECEIPT_RELATION] PRIMARY KEY CLUSTERED 
        (
            [RELATION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='ERECEIPT_SENDING_DETAIL')
    BEGIN
        CREATE TABLE [ERECEIPT_SENDING_DETAIL](
            [SENDING_DETAIL_ID] [int] IDENTITY(1,1) NOT NULL,
            [SERVICE_RESULT] [nvarchar](50) NULL,
            [UUID] [nvarchar](50) NULL,
            [ERECEIPT_ID] [nvarchar](50) NULL,
            [STATUS_DESCRIPTION] [nvarchar](50) NULL,
            [STATUS_CODE] [nvarchar](50) NULL,
            [ERROR_CODE] [nvarchar](50) NULL,
            [ACTION_ID] [int] NULL,
            [ACTION_TYPE] [nvarchar](50) NULL,
            [SERVICE_RESULT_DESCRIPTION] [nvarchar](250) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_ERECEIPT_SENDING_DETAIL] PRIMARY KEY CLUSTERED 
        (
            [SENDING_DETAIL_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

</querytag>