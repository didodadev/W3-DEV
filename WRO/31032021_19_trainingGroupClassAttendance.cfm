<!-- Description : TRAINING_GROUP_CLASS_ATTENDANCE tablosu oluşturuldu.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TRAINING_GROUP_CLASS_ATTENDANCE' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [TRAINING_GROUP_CLASS_ATTENDANCE](
            [TRAINING_GROUP_CLASS_ATTENDANCE_ID] [int] IDENTITY(1,1) NOT NULL,
            [TRAINING_GROUP_ATTENDERS_ID] [int] NULL,
            [TRAINING_GROUP_ID] [int] NOT NULL,
            [CLASS_ID] [int] NULL,
            [EMP_ID] [int] NULL,
            [COMP_ID] [int] NULL,
            [PAR_ID] [int] NULL,
            [CON_ID] [int] NULL,
            [GRP_ID] [int] NULL,
            [STATUS] [bit] NULL,
            [JOINED] [bit] NULL,
        CONSTRAINT [PK_TRAINING_GROUP_CLASS_ATTENDANCE] PRIMARY KEY CLUSTERED 
        (
            [TRAINING_GROUP_CLASS_ATTENDANCE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>