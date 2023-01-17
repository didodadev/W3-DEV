<!-- Description : Payroll Job tablosu oluşturuldu. Eksik alanlar tekrar oluşturuldu.
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAYROLL_JOB' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [PAYROLL_JOB](
            [PAYROLL_ID] [int] IDENTITY(1,1) NOT NULL,
            [MONTH] [int] NULL,
            [YEAR] [int] NULL,
            [BRANCH_ID] [int] NULL,
            [EMPLOYEE_ID] [int] NULL,
            [BRANCH_PAYROLL_ID] [int] NULL,
            [PERCENT_COMPLETED] [bit] NULL,
            [PAYROLL_DRAFT] [nvarchar](max) NULL,
            [ACCOUNT_DRAFT] [nvarchar](max) NULL,
            [ACCOUNT_COMPLETED] [bit] NULL,
            [BUDGET_DRAFT] [varchar](max) NULL,
            [BUDGET_COMPLETED] [bit] NULL,
            [BANK_DRAFT] [varchar](max) NULL,
            [BANK_COMPLETED] [bit] NULL,
            [IN_OUT_ID] [int] NULL,
            [EMPLOYEE_PAYROLL_ID] [int] NULL,
            [PAYROLL_TYPE] [int] NULL,
        CONSTRAINT [PK_PAYROLL_JOB] PRIMARY KEY CLUSTERED 
        (
            [PAYROLL_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PAYROLL_JOB' AND COLUMN_NAME ='IN_OUT_ID' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN 
        ALTER TABLE PAYROLL_JOB ADD IN_OUT_ID int NULL
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PAYROLL_JOB' AND COLUMN_NAME ='EMPLOYEE_PAYROLL_ID' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN 
        ALTER TABLE PAYROLL_JOB ADD EMPLOYEE_PAYROLL_ID int NULL
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PAYROLL_JOB' AND COLUMN_NAME ='PAYROLL_TYPE' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN 
        ALTER TABLE PAYROLL_JOB ADD PAYROLL_TYPE int NULL
    END;
</querytag>