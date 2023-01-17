<!-- Description : TRAINING_GROUP_ATTENDERS tablosu oluşturuldu.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TRAINING_GROUP_ATTENDERS' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [TRAINING_GROUP_ATTENDERS](
            [TRAINING_GROUP_ATTENDERS_ID] [int] IDENTITY(1,1) NOT NULL,
            [TRAINING_GROUP_ID] [int] NOT NULL,
            [EMP_ID] [int] NULL,
            [COMP_ID] [int] NULL,
            [PAR_ID] [int] NULL,
            [GRP_ID] [int] NULL,
            [CON_ID] [int] NULL,
            [STATUS] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL
         CONSTRAINT [PK_TRAINING_GROUP_ATTENDERS] PRIMARY KEY CLUSTERED 
        (
            [TRAINING_GROUP_ATTENDERS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>