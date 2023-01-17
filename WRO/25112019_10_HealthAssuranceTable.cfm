<!-- Description : Sağlık Teminat Tabloları
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE' ) )
    BEGIN
       CREATE TABLE [SETUP_HEALTH_ASSURANCE_TYPE](
            [ASSURANCE_ID] [int] IDENTITY(1,1) NOT NULL,
            [IS_ACTIVE] [bit] NULL,
            [ASSURANCE] [nvarchar](250) NULL,
            [DETAIL] [nvarchar](max) NULL,
            [WORKING_TYPE] [int] NULL,
            [PERIOD] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
        CONSTRAINT [PK_SETUP_HEALTH_ASSURANCE_TYPE] PRIMARY KEY CLUSTERED 
        (
            [ASSURANCE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
    IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT' ) )
    BEGIN
        CREATE TABLE [SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT](
            [SUPPORT_ID] [int] IDENTITY(1,1) NOT NULL,
            [ASSURANCE_ID] [int] NULL,
            [QUANTITY] [float] NULL,
            [MIN] [int] NULL,
            [MAX] [int] NULL,
            [MONEY] [nvarchar](50) NULL,
            [RATE] [float] NULL,
            [EFFECTIVE_DATE] [datetime] NULL,
            [IS_ACTIVE] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
        CONSTRAINT [PK_SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT] PRIMARY KEY CLUSTERED 
        (
            [SUPPORT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HEALTH_PRICE_PROTOCOL' ) )
    BEGIN
        CREATE TABLE [HEALTH_PRICE_PROTOCOL](
            [PROTOCOL_ID] [int] IDENTITY(1,1) NOT NULL,
            [PROTOCOL_NAME] [nvarchar](50) NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
        CONSTRAINT [PK_HEALTH_PRICE_PROTOCOL] PRIMARY KEY CLUSTERED 
        (
            [PROTOCOL_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HEALTH_ASSURANCE_CONTRACT_COMPANY' ) )
    BEGIN
        CREATE TABLE [HEALTH_ASSURANCE_CONTRACT_COMPANY](
            [CONTRACT_COMPANY_ID] [int] IDENTITY(1,1) NOT NULL,
            [COMPANY_ID] [int] NULL,
            [CONTRACT_NO] [nvarchar](50) NULL,
            [PROTOCOL_ID] [int] NULL,
            [DISCOUNT] [float] NULL,
            [ASSURANCE_ID] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
        CONSTRAINT [PK_HEALTH_ASSURANCE_CONTRACT_COMPANY] PRIMARY KEY CLUSTERED 
        (
            [CONTRACT_COMPANY_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    
</querytag>