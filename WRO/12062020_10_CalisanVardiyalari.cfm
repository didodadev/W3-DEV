<!-- Description : Çalışan vardiyaları tablosu açıldı.
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='SETUP_SHIFT_EMPLOYEE')
    BEGIN
        CREATE TABLE [SETUP_SHIFT_EMPLOYEE](
            [SETUP_SHIFT_EMPLOYEE_ID] [int] IDENTITY(1,1) NOT NULL,
            [EMPLOYEE_ID] [int] NULL,
            [SHIFT_ID] [int] NULL,
            [START_DATE] [datetime] NULL,
            [FINISH_DATE] [datetime] NULL,
        CONSTRAINT [PK_SETUP_SHIFT_EMPLOYEE] PRIMARY KEY CLUSTERED 
        (
            [SETUP_SHIFT_EMPLOYEE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

</querytag>