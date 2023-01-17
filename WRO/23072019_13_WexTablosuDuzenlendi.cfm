<!-- Description : WEX Tablosuna yeni alanlar eklendi.
Developer: Botan KAYĞAN
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_WEX' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
        BEGIN
            IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WEX' AND COLUMN_NAME='URL_ADDRESS')
            BEGIN
                EXEC sp_rename 'WRK_WEX.URL_ADDRESS', 'REST_NAME';
            END;

            IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WEX' AND COLUMN_NAME='SOURCE_WO')
            BEGIN
            ALTER TABLE WRK_WEX ADD SOURCE_WO nvarchar(250)
            END;

            IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WEX' AND COLUMN_NAME='WEX_FILE_ID')
            BEGIN
            ALTER TABLE WRK_WEX ADD WEX_FILE_ID int
            END;
        END
    ELSE
        BEGIN
            CREATE TABLE [WRK_WEX](
                [WEX_ID] [int] IDENTITY(1,1) NOT NULL,
                [IS_ACTIVE] [bit] NULL,
                [MODULE] [int] NOT NULL,
                [HEAD] [nvarchar](250) NOT NULL,
                [DICTIONARY_ID] [int] NOT NULL,
                [VERSION] [nvarchar](50) NULL,
                [TYPE] [int] NULL,
                [LICENCE] [int] NULL,
                [REST_NAME] [nvarchar](250) NOT NULL,
                [TIME_PLAN_TYPE] [int] NOT NULL,
                [TIME_PLAN] [int] NULL,
                [AUTHENTICATION] [int] NOT NULL,
                [STATUS] [nvarchar](50) NOT NULL,
                [STAGE] [int] NULL,
                [AUTHOR] [nvarchar](50) NULL,
                [FILE_PATH] [nvarchar](250) NOT NULL,
                [RECORD_IP] [nvarchar](50) NULL,
                [RECORD_EMP] [int] NULL,
                [RECORD_DATE] [datetime] NULL,
                [UPDATE_IP] [nvarchar](50) NULL,
                [UPDATE_EMP] [int] NULL,
                [UPDATE_DATE] [datetime] NULL,
                [RELATED_WO] [nvarchar](250) NULL,
                [IMAGE] [nvarchar](100) NULL,
                [DETAIL] [nvarchar](max) NULL,
                [SOURCE_WO] [nvarchar](250) NULL,
                [WEX_FILE_ID] [int] NULL,
            CONSTRAINT [PK_WRK_WEX] PRIMARY KEY CLUSTERED 
            (
                [WEX_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
        END;
</querytag>