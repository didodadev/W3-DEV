<!-- Description : TRAINING_GROUP_CLASS_DELETE tablosu oluşturuldu.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TRAINING_GROUP_CLASS_DELETE' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [TRAINING_GROUP_CLASS_DELETE](
            [TRAINING_GROUP_CLASS_DELETE_ID] [int] IDENTITY(1,1) NOT NULL,
            [REASON] [nvarchar](250) NOT NULL,
            [TRAINING_GROUP_ID] [int] NOT NULL,
            [DELETED_BY_EMP_ID] [int] NOT NULL,
            [CLASS_ID] [int] NOT NULL,
            [SEND_EMAIL] [bit] NULL,
            [DELETED_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
         CONSTRAINT [PK_TRAINING_GROUP_CLASS_DELETE] PRIMARY KEY CLUSTERED 
        (
            [TRAINING_GROUP_CLASS_DELETE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>