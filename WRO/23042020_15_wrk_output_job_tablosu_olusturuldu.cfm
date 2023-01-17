<!-- Description : WRK_OUTPUT_JOB tablosu oluşturuldu
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_OUTPUT_JOB' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [WRK_OUTPUT_JOB](
            [WOJ_ID] [int] IDENTITY(1,1) NOT NULL,
            [TEMPLATE_ID] [int] NOT NULL,
            [WOJ_PARAMETERS] [nvarchar](max) NOT NULL,
            [WOJ_OUTPUT_TYPE] [int] NULL,
            [WOJ_DELIVERY_TYPE] [int] NOT NULL,
            [WOJ_FUSEACTION] [nvarchar](200) NOT NULL,
            [WOJ_ACTION_ID] [int] NOT NULL,
            [WOJ_FILE_NAME] [nvarchar](200) NULL,
            [WOJ_FILE_ENCRYPTED_NAME] [nvarchar](200) NULL,
            [WOJ_IS_GROUP] [bit] NULL,
            [WOJ_GROUP_KEY] [nvarchar](50) NULL,
            [COMPANY_ID] [int] NOT NULL,
            [PERIOD_ID] [int] NOT NULL,
            [MAIL_TRAIL] [bit] NULL,
            [MAIL_SEND_TYPE] [bit] NULL,
            [MAIL_TO] [nvarchar](200) NULL,
            [MAIL_CC] [nvarchar](200) NULL,
            [MAIL_BCC] [nvarchar](200) NULL,
            [MAIL_SUBJECT] [nvarchar](1000) NULL,
            [MAIL_CONTENT] [nvarchar](max) NULL,
            [ASSET_AUTO_DOWNLOAD] [bit] NULL,
            [ASSET_NO] [nvarchar](50) NULL,
            [ASSET_STAGE_ID] [int] NULL,
            [ASSET_CAT_ID] [int] NULL,
            [ASSET_PROPERTY_ID] [int] NULL,
            [ASSET_GROUP] [nvarchar](100) NULL,
            [IS_COMPLETE] [bit] NULL CONSTRAINT [DF_WRK_OUTPUT_JOB_IS_COMPLETE]  DEFAULT ((0)),
            [RUN_DATE] [datetime] NULL,
            [RUN_EMP] [int] NULL,
            [RUN_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_WRK_OUTPUT_JOB] PRIMARY KEY CLUSTERED 
        (
            [WOJ_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
</querytag>
