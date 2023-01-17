<!-- Description : WRK_DATA_SOURCE tablosu eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_DATA_SOURCE' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [WRK_DATA_SOURCE](
            [DATA_SOURCE_ID] [int] IDENTITY(1,1) NOT NULL,
            [DATA_SOURCE_NAME] [nvarchar](150) NULL,
            [TYPE] [int] NULL,
            [DRIVER] [nvarchar](50) NULL,
            [IP] [nvarchar](50) NULL,
            [PORT] [int] NULL,
            [USERNAME] [nvarchar](250) NULL,
            [PASSWORD] [nvarchar](250) NULL,
            [DETAILS] [nvarchar](max) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_WRK_DATA_SOURCE] PRIMARY KEY CLUSTERED 
        (
            [DATA_SOURCE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
    
</querytag>