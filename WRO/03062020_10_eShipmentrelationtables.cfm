<!-- Description : e-irsaliye gönderim sırası ilişki tabloları içerir
Developer: İlker Altındal
Company : Workcube
Destination: Period -->
<querytag>
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ESHIPMENT_NUMBER' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [ESHIPMENT_NUMBER](
            [ID] [int] IDENTITY(1,1) NOT NULL,
            [ESHIPMENT_PREFIX] [varchar](50) NOT NULL,
            [ESHIPMENT_NUMBER] [varchar](50) NULL,
        CONSTRAINT [PK_ESHIPMENT_NUMBER] PRIMARY KEY CLUSTERED 
        (
            [ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ESHIPMENT_RELATION' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [ESHIPMENT_RELATION](
            [RELATION_ID] [int] IDENTITY(1,1) NOT NULL,
            [ACTION_ID] [int] NULL,
            [ACTION_TYPE] [nvarchar](50) NULL,
            [ESHIPMENT_ID] [nvarchar](50) NULL,
            [UUID] [nvarchar](50) NULL,
            [PATH] [nvarchar](250) NULL,
            [SENDER_TYPE] [int] NULL,
            [SERVICE_RESULT_DESCRIPTION] [nvarchar](500) NULL,
            [STATUS] [bit] NULL,
            [PROFILE_ID] [nvarchar](50) NULL,
            [ENVUUID] [nvarchar](50) NULL,
            [INTEGRATION_ID] [nvarchar](50) NULL,
            [IS_PAPER_UPDATE] [bit] NULL,
            [STATUS_CODE] [int] NULL,
            [STATUS_DESCRIPTION] [nvarchar](250) NULL,
            [STATUS_DATE] [datetime] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_ESHIPMENT_RELATION] PRIMARY KEY CLUSTERED 
        (
            [RELATION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ESHIPMENT_SENDING_DETAIL' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [ESHIPMENT_SENDING_DETAIL](
            [SENDING_DETAIL_ID] [int] IDENTITY(1,1) NOT NULL,
            [SERVICE_RESULT] [nvarchar](50) NULL,
            [UUID] [nvarchar](50) NULL,
            [ESHIPMENT_ID] [nvarchar](50) NULL,
            [STATUS_DESCRIPTION] [nvarchar](50) NULL,
            [STATUS_CODE] [nvarchar](50) NULL,
            [ERROR_CODE] [nvarchar](50) NULL,
            [ACTION_ID] [int] NULL,
            [ACTION_TYPE] [nvarchar](50) NULL,
            [IS_SUCCESFULL] [bit] NULL,
            [SERVICE_RESULT_DESCRIPTION] [nvarchar](250) NULL,
            [BELGE_OID] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [SHIPMENT_TYPE_CODE] [nvarchar](50) NULL,
        CONSTRAINT [PK_ESHIPMENT_SENDING_DETAIL] PRIMARY KEY CLUSTERED 
        (
            [SENDING_DETAIL_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

</querytag>
