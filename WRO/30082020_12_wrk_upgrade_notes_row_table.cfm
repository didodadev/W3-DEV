<!-- Description : Release Notes Row new table
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>

    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_UPGRADE_NOTES_ROW' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        CREATE TABLE [WRK_UPGRADE_NOTES_ROW](
            [NOTE_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
            [TASK_ID] [int] NULL,
            [HOOKID] [int] NULL,
            [RELEASE_NO] [nvarchar](50) NOT NULL,
            [PATCH_NO] [nvarchar](50) NULL,
            [NOTE_ROW_TYPE] [nvarchar](50) NOT NULL,
            [NOTE_ROW_TITLE] [nvarchar](max) NULL,
            [NOTE_ROW_DETAIL] [nvarchar](max) NOT NULL,
            [NOTE_ROW_STATUS] [bit] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_WRK_UPGRADE_NOTES_ROW] PRIMARY KEY CLUSTERED 
        (
            [NOTE_ROW_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END

</querytag>