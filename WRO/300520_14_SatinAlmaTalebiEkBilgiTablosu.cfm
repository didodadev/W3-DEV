<!-- Description :Satın Alma Talebi Ek Bilgi tablosu oluşturuldu..
Developer: Gülbahar Inan
Company : Workcube
Destination: Company -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'INTERNALDEMAND_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
    CREATE TABLE [INTERNALDEMAND_INFO_PLUS](
        [INFO_ID] [int] IDENTITY(1,1) NOT NULL,
        [INTERNAL_ID] [int] NULL,
        [PROPERTY1] [nvarchar](500) NULL,
        [PROPERTY2] [nvarchar](500) NULL,
        [PROPERTY3] [nvarchar](500) NULL,
        [PROPERTY4] [nvarchar](500) NULL,
        [PROPERTY5] [nvarchar](500) NULL,
        [PROPERTY6] [nvarchar](500) NULL,
        [PROPERTY7] [nvarchar](500) NULL,
        [PROPERTY8] [nvarchar](500) NULL,
        [PROPERTY9] [nvarchar](500) NULL,
        [PROPERTY10] [nvarchar](500) NULL,
        [PROPERTY11] [nvarchar](500) NULL,
        [PROPERTY12] [nvarchar](500) NULL,
        [PROPERTY13] [nvarchar](500) NULL,
        [PROPERTY14] [nvarchar](500) NULL,
        [PROPERTY15] [nvarchar](500) NULL,
        [PROPERTY16] [nvarchar](500) NULL,
        [PROPERTY17] [nvarchar](500) NULL,
        [PROPERTY18] [nvarchar](500) NULL,
        [PROPERTY19] [nvarchar](500) NULL,
        [PROPERTY20] [nvarchar](500) NULL,
        [COOKIE_NAME] [nvarchar](250) NULL,
        [RECORD_GUEST] [bit] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_DATE] [datetime] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
        [UPDATE_EMP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
     CONSTRAINT [PK_INTERNALDEMAND_INFO_PLUS_INFO_ID] PRIMARY KEY CLUSTERED 
    (
        [INFO_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'INTERNALDEMAND_INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
    CREATE TABLE [INTERNALDEMAND_INFO_PLUS_HISTORY](
        [INFO_ID_HIST] [int] IDENTITY(1,1) NOT NULL,
        [INFO_ID] [int] NOT NULL,
        [INTERNAL_ID] [int] NULL,
        [PROPERTY1] [nvarchar](500) NULL,
        [PROPERTY2] [nvarchar](500) NULL,
        [PROPERTY3] [nvarchar](500) NULL,
        [PROPERTY4] [nvarchar](500) NULL,
        [PROPERTY5] [nvarchar](500) NULL,
        [PROPERTY6] [nvarchar](500) NULL,
        [PROPERTY7] [nvarchar](500) NULL,
        [PROPERTY8] [nvarchar](500) NULL,
        [PROPERTY9] [nvarchar](500) NULL,
        [PROPERTY10] [nvarchar](500) NULL,
        [PROPERTY11] [nvarchar](500) NULL,
        [PROPERTY12] [nvarchar](500) NULL,
        [PROPERTY13] [nvarchar](500) NULL,
        [PROPERTY14] [nvarchar](500) NULL,
        [PROPERTY15] [nvarchar](500) NULL,
        [PROPERTY16] [nvarchar](500) NULL,
        [PROPERTY17] [nvarchar](500) NULL,
        [PROPERTY18] [nvarchar](500) NULL,
        [PROPERTY19] [nvarchar](500) NULL,
        [PROPERTY20] [nvarchar](500) NULL,
        [COOKIE_NAME] [nvarchar](250) NULL,
        [RECORD_GUEST] [bit] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_DATE] [datetime] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
        [UPDATE_EMP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
     CONSTRAINT [PK_INTERNALDEMAND_INFO_PLUS_HISTORY_INFO_ID_HIST] PRIMARY KEY CLUSTERED 
    (
        [INFO_ID_HIST] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END
</querytag>