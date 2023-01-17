<!-- Description : Add WRK_MOCKUP and WRK_MOCKUP_ROW table.
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_MOCKUP' )
    BEGIN
        CREATE TABLE [WRK_MOCKUP](
            [MOCKUP_ID] [int] IDENTITY(1,1) NOT NULL,
            [MOCKUP_NAME] [nvarchar](250) NULL,
            [MOCKUP_FOLDER_NAME] [nvarchar](150) NULL,
            [MOCKUP_AUTHOR_ID] [int] NULL,
            [WORK_ID] [int] NULL,
            [QPIC_RS_ID] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_WRK_MOCKUP] PRIMARY KEY CLUSTERED 
        (
            [MOCKUP_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_MOCKUP_ROW' )
    BEGIN
        CREATE TABLE [WRK_MOCKUP_ROW](
            [MOCKUP_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
            [MOCKUP_ID] [int] NOT NULL,
            [MOCKUP_EVENT] [nvarchar](50) NOT NULL,
            [MOCKUP_DESIGN] [nvarchar](max) NOT NULL,
            [MOCKUP_MODEL] [nvarchar](max) NOT NULL,
            [MOCKUP_CODE] [nvarchar](max) NOT NULL,
            [MOCKUP_DEPENDENCIES] [nvarchar](max) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_WRK_MOCKUP_ROW] PRIMARY KEY CLUSTERED 
        (
            [MOCKUP_ROW_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
</querytag>