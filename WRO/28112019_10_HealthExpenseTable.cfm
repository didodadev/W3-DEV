<!-- Description : Sağlık Harcaması Detay TAblosu oluşturuldu
Developer: Esma Uysal
Company : Workcube
Destination: Period-->
<querytag>
    IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'HEALTH_EXPENSE' ) )
    BEGIN
        CREATE TABLE [HEALTH_EXPENSE](
            [HEALTH_EXPENSE_ID] [int] IDENTITY(1,1) NOT NULL,
            [EXPENSE_ID] [int] NULL,
            [HEALTH_EXPENSE_CODE] [nvarchar](50) NULL,
            [HEALTH_EXPENSE_AMOUNT] [float] NULL,
            [HEALTH_EXPENSE_PRICE] [float] NULL,
            [HEALTH_EXPENSE_TOTAL] [float] NULL,
            [COMPLAINT_ID] [int] NULL,
            [DRUG_ID] [int] NULL,
            [HEALTH_EXPENSE_DETAIL] [nvarchar](max) NULL,
            [MONEY] [nvarchar](50) NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_HEALTH_EXPENSE] PRIMARY KEY CLUSTERED 
        (
            [HEALTH_EXPENSE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
</querytag>