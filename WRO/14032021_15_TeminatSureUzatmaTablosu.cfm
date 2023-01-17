<!-- Description : Teminat Süre Uzatımı Tablosu eklendi.
Developer: Gülbahar İnan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SECUREFUND_EXTENSION_TIME' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        CREATE TABLE [SECUREFUND_EXTENSION_TIME](
            [SECUREFUND_EXTENSION_TIME_ID] [int] IDENTITY(1,1) NOT NULL,
            [SECUREFUND_ID] [int] NULL,
            [ACTION_CAT_ID] [int] NULL,
            [DETAIL] [nvarchar](500) NULL,
            [MONEY_CAT] [nvarchar](43) NULL,
            [EXPENSE_TOTAL] [float] NULL,
            [MONEY_CAT_EXPENSE] [nvarchar](43) NULL,
            [COMMISSION_RATE] [float] NULL,
            [EXTENSION_TIME_FINISH_DATE] [datetime] NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            CONSTRAINT [PK_SECUREFUND_EXTENSION_TIME] PRIMARY KEY CLUSTERED 
            (
                [SECUREFUND_EXTENSION_TIME_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY]
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='COMPANY_SECUREFUND' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='EXTENSION_TIME_FINISH_DATE')
    BEGIN
        ALTER TABLE COMPANY_SECUREFUND
        ADD EXTENSION_TIME_FINISH_DATE datetime NULL
    END;

</querytag>