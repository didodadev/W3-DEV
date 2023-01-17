<!-- Description : WEX_FILES ve WEX_FILES_ROWS tabloları oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WEX_FILES' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [WEX_FILES](
            [WEX_FILE_ID] [int] IDENTITY(1,1) NOT NULL,
            [WEX_FILE_NAME] [nvarchar](max) NULL,
            [WEX_FILE_PATH] [nvarchar](max) NULL,
            [WEX_DETAIL] [nvarchar](max) NULL,
            [WEX_ROOT] [nvarchar](max) NULL,
            [WEX_ITEM] [nvarchar](max) NULL,
            [WEX_MONEY_TYPE] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_CREATED_XML_FILES] PRIMARY KEY CLUSTERED 
        (
            [WEX_FILE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WEX_FILES_ROWS' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [WEX_FILES_ROWS](
            [WEX_FILES_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
            [WEX_FILE_ID] [int] NULL,
            [WEX_ROW_ID] [nvarchar](100) NULL,
            [WEX_ROW_TEXT_NAME] [nvarchar](max) NULL,
        CONSTRAINT [PK_CREATED_XML_FILES_ROWS] PRIMARY KEY CLUSTERED 
        (
            [WEX_FILES_ROW_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
</querytag>