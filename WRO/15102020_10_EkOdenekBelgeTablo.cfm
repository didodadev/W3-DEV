<!-- Description : Ek ödenekler için Belge tablosu oluşturuldu.
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='BONUS_PAYROLL' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        CREATE TABLE [BONUS_PAYROLL](
            [BONUS_ID] [int] IDENTITY(1,1) NOT NULL,
            [PAPER_NO] [nvarchar](50) NULL,
            [PROCESS_ID] [int] NULL,
            [PROCESS_CAT] [int] NULL,
            [EMPLOYEE_ID] [int] NULL,
            [PAPER_DATE] [datetime] NULL,
            [DETAIL] [nvarchar](250) NULL,
            [COMMENT_PAY_ID] [int] NULL,
            [TERM] [int] NULL,
            [START_SAL_MON] [int] NULL,
            [END_SAL_MON] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_BONUS_PAYROLL] PRIMARY KEY CLUSTERED 
        (
            [BONUS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALARYPARAM_PAY' AND COLUMN_NAME = 'BONUS_ID')
    BEGIN
        ALTER TABLE SALARYPARAM_PAY ADD
		BONUS_ID int NULL
    END;
</querytag>