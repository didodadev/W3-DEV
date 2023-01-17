<!-- Description : Event tablosu eklendi
Developer: Halit Yurttaş
Company : Workcube
Destination: Main -->
<querytag>
    IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_EVENTS' ) )
    BEGIN

        CREATE TABLE [WRK_EVENTS](
            [EVENTID] [int] IDENTITY(1,1) NOT NULL,
            [EVENT_TITLE] [nvarchar](250) NOT NULL,
            [EVENT_FUSEACTION] [nvarchar](150) NULL,
            [EVENT_SOLUTIONID] [int] NOT NULL,
            [EVENT_SOLUTION] [nvarchar](50) NOT NULL,
            [EVENT_FAMILYID] [int] NOT NULL,
            [EVENT_FAMILY] [nvarchar](50) NOT NULL,
            [EVENT_MODULEID] [int] NOT NULL,
            [EVENT_MODULE] [nvarchar](50) NOT NULL,
            [EVENT_TYPE] [nvarchar](25) NOT NULL,
            [EVENT_STRUCTURE] [nvarchar](max) NULL,
            [EVENT_CODE] [nvarchar](max) NULL,
            [EVENT_FILE_PATH] [nvarchar](250) NULL,
            [EVENT_TOOL] [nvarchar](25) NOT NULL,
            [EVENT_DESCRIPTION] [nvarchar](max) NULL,
            [EVENT_LICENSE] [nvarchar](150) NULL,
            [EVENT_AUTHOR] [nvarchar](250) NULL,
            [EVENT_STATUS] [nvarchar](25) NOT NULL,
            [EVENT_STAGE] [nvarchar](25) NOT NULL,
            [EVENT_VERSION] [nvarchar](25) NOT NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_WRK_EVENTS] PRIMARY KEY CLUSTERED 
        (
            [EVENTID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    
    END;
</querytag>