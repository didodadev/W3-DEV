<!-- Description : Esnek çalışma saatleri belge ve satır tabloları açıldı.
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WORKTIME_FLEXIBLE' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        CREATE TABLE [WORKTIME_FLEXIBLE](
            [WORKTIME_FLEXIBLE_ID] [int] IDENTITY(1,1) NOT NULL,
            [EMPLOYEE_ID] [int] NULL,
            [POSITION_ID] [int] NULL,
            [DEPARTMENT_ID] [int] NULL,
            [REQUEST_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [STAGE_ID] [int] NULL,
            [WORKTIME_FLEXIBLE_NOTICE] [nvarchar](250) NULL,
            [BRANCH_ID] [int] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK__WORKTIME__DBE15BEE8739259A] PRIMARY KEY CLUSTERED 
        (
            [WORKTIME_FLEXIBLE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
        CREATE TABLE [WORKTIME_FLEXIBLE_ROW](
            [WORKTIME_FLEXIBLE_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
            [WORKTIME_FLEXIBLE_ID] [int] NULL,
            [FLEXIBLE_START_HOUR] [int] NULL,
            [FLEXIBLE_START_MINUTE] [int] NULL,
            [FLEXIBLE_FINISH_HOUR] [int] NULL,
            [FLEXIBLE_FINISH_MINUTE] [int] NULL,
            [FLEXIBLE_MONTH] [int] NULL,
            [FLEXIBLE_DAY] [int] NULL,
            [FLEXIBLE_DATE] [datetime] NULL,
            [FLEXIBLE_YEAR] [int] NULL,
            [STAGE_ID] [int] NULL,
            [APPROVE_HR_EMP_ID] [int] NULL,
            [APPROVE_DATE] [int] NULL,
            [IS_APPROVE] [bit] NULL,
        CONSTRAINT [PK__WORKTIME__FFC706F8B4484816] PRIMARY KEY CLUSTERED 
        (
            [WORKTIME_FLEXIBLE_ROW_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>