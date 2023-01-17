<!-- Description : Workcube Data Service Table
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_DATA_SERVICE' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        CREATE TABLE [WRK_DATA_SERVICE](
            [WRK_DATA_SERVICE_ID] [int] IDENTITY(1,1) NOT NULL,
            [HEAD] [nvarchar](150) NULL,
            [DETAIL] [nvarchar](max) NULL,
            [ZONE] [nvarchar](5) NULL,
            [AUTHOR] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [IS_WORK] [bit] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [VERSION] [nvarchar](50) NULL,
            [WEX_ID] [int] NULL,
            [MAIN_VERSION] [nvarchar](50) NULL,
            [PUBLISHING_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
        CONSTRAINT [PK_WRK_DATA_SERVICE] PRIMARY KEY CLUSTERED 
        (
            [WRK_DATA_SERVICE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
<querytag>