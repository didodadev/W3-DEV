<!-- Description : Olay Tutanağı tablosuna Olay Tarihi alanı açıldı.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_EVENT_REPORT' AND COLUMN_NAME='EVENT_DATE')
    BEGIN
        ALTER TABLE EMPLOYEES_EVENT_REPORT ADD
        EVENT_DATE datetime null
    END
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EVENT_WITNESS_STATEMENT' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo')
    BEGIN
        CREATE TABLE [EVENT_WITNESS_STATEMENT](
            [WITNESS_STATEMENT_ID] [int] IDENTITY(1,1) NOT NULL,
            [EVENT_ID] [int] NOT NULL,
            [SIGN_DATE] [datetime] NULL,
            [WITNESS_1] [int] NULL,
            [WITNESS1_DETAIL] [nvarchar](max) NULL,
            [WITNESS_2] [int] NULL,
            [WITNESS2_DETAIL] [nvarchar](max) NULL,
            [WITNESS_3] [int] NULL,
            [WITNESS3_DETAIL] [nvarchar](max) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](43) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](43) NULL,
        CONSTRAINT [PK_EVENT_WITNESS_STATEMENT_WITNESS_STATEMENT_ID] PRIMARY KEY CLUSTERED 
        (
            [WITNESS_STATEMENT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
</querytag>