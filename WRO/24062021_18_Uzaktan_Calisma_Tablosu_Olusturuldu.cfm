 <!-- Description : REMOTE_WORKING_DAY Tablosu Eklendi.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main-->
<querytag>
 IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REMOTE_WORKING_DAY' AND TABLE_SCHEMA = '@_dsn_main_@')
 BEGIN
    CREATE TABLE [REMOTE_WORKING_DAY](
        [REMOTE_DAY_ID] [int] IDENTITY(1,1) NOT NULL,
        [EMPLOYEE_ID] [int] NULL,
        [IN_OUT_ID] [int] NULL,
        [M1] [int] NULL,
        [M2] [int] NULL,
        [M3] [int] NULL,
        [M4] [int] NULL,
        [M5] [int] NULL,
        [M6] [int] NULL,
        [M7] [int] NULL,
        [M8] [int] NULL,
        [M9] [int] NULL,
        [M10] [int] NULL,
        [M11] [int] NULL,
        [M12] [int] NULL,
        [RECORD_DATE] [datetime] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [RECORD_EMP] [int] NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
        [UPDATE_EMP] [int] NULL,
        [PERIOD_YEAR] [int] NULL,
    PRIMARY KEY CLUSTERED 
    (
        [REMOTE_DAY_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END
</querytag>