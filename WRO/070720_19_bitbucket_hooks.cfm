<!-- Description : Bitbucket hooks için tabloları oluşturur
Developer: Halit Yurttaş
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='BITBUCKET_HOOKS')
	BEGIN
        CREATE TABLE [BITBUCKET_HOOKS](
            [HOOKID] [int] IDENTITY(1,1) NOT NULL,
            [PROC_TYPE] [nvarchar](150) NOT NULL,
            [TITLE] [nvarchar](500) NOT NULL,
            [DESCRIPTION] [nvarchar](max) NULL,
            [VIEW_URL] [nvarchar](250) NULL,
            [AUTHOR] [nvarchar](150) NULL,
            [AUTHOR_DATA] [nvarchar](max) NULL,
            [TASK_ID] [int] NULL,
            [BBID] [int] NULL,
            [DESTINATION_BRANCH] [nvarchar](150) NULL,
            [SOURCE_BRANCH] [nvarchar](150) NULL,
            [STATE] [nvarchar](50) NULL,
            [PARTICIPANTS] [nvarchar](max) NULL,
            [CREATED] [datetime] NULL,
        CONSTRAINT [PK_BITBUCKET_HOOKS] PRIMARY KEY CLUSTERED 
        (
            [HOOKID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

    END;	
</querytag>