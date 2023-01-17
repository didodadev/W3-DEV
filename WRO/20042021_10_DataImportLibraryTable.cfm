<!-- Description : WRK_DATA_IMPORT_LIBRARY tablosu eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_DATA_IMPORT_LIBRARY' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [WRK_DATA_IMPORT_LIBRARY](
            [DATA_IMPORT_ID] [int] IDENTITY(1,1) NOT NULL,
            [NAME] [nvarchar](150) NULL,
            [TYPE] [int] NULL,
            [IMPORT_WO] [nvarchar](250) NULL,
            [AUTHOR] [nvarchar](100) NULL,
            [FILE_PATH] [nvarchar](500) NULL,
            [BEST_PRACTICE] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_WRK_DATA_IMPORT_LIBRARY] PRIMARY KEY CLUSTERED 
        (
            [DATA_IMPORT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    
</querytag>