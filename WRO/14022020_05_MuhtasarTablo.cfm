<!-- Description : Muhtasar Table Create
Developer: Yunus Özay
Company : Team Yazılım
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_MUHTASAR_EXPORTS' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [EMPLOYEES_MUHTASAR_EXPORTS](
            [SSK_OFFICE] [nvarchar](100) NULL,
            [SSK_OFFICE_NO] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [EME_ID] [int] IDENTITY(1,1) NOT NULL,
            [EXCEL_FILE_NAME] [nvarchar](200) NULL,
            [FILE_NAME] [nvarchar](200) NULL,
            [SAL_MON] [int] NULL,
            [SAL_YEAR] [int] NULL,
            [EXPORT_REASON] [nvarchar](50) NULL,
            [EXPORT_TYPE] [nvarchar](50) NULL,
            [SSK_BRANCH_ID] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [ROW_COUNT] [int] NULL,
            [COMPANY_ID] [int] NULL,
            [FILE_NAME_7103] [nvarchar](200) NULL,
            [EXCEL_FILE_NAME_7103] [nvarchar](200) NULL
        ) ON [PRIMARY]
    END
</querytag>
