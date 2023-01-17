<!-- Description : TRAINING_GROUP_SUBJECTS tablosu oluşturuldu.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TRAINING_GROUP_SUBJECTS' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [TRAINING_GROUP_SUBJECTS](
            [TRAINING_GROUP_SUBJECTS_ID] [int] IDENTITY(1,1) NOT NULL,
            [TRAINING_GROUP_ID] [int] NOT NULL,
            [TRAINING_SEC_ID] [int] NOT NULL,
            [TRAINING_CAT_ID] [int] NOT NULL,
            [TRAIN_ID] [int] NOT NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
         CONSTRAINT [PK_TRAINING_GROUP_SUBJECTS] PRIMARY KEY CLUSTERED 
        (
            [TRAINING_GROUP_SUBJECTS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>