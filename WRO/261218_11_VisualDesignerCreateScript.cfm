<!-- Description : Visual Designer'da kullanılacak tablonun create kodu 
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='VISUAL_DESIGNER' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        CREATE TABLE [VISUAL_DESIGNER](
            [PROCESS_ID] [int] IDENTITY(1,1) NOT NULL,
            [TYPE] [nvarchar](20) NULL,
            [XML] [nvarchar](max) NULL,
            [FILE_NAME] [nvarchar](200) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_EMP] [int] NULL,
        CONSTRAINT [PK_VISUAL_DESIGNER] PRIMARY KEY CLUSTERED 
        (
            [PROCESS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
</querytag>