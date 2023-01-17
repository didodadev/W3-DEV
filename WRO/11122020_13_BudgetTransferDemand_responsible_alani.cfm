<!-- Description : BUDGET_TRANSFER_DEMAND tablosuna sorumlu alanı eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN    
        CREATE TABLE [BUDGET_TRANSFER_DEMAND](
            [DEMAND_ID] [int] IDENTITY(1,1) NOT NULL,
            [BUDGET_ID] [int] NULL,
            [DEMAND_EMP_ID] [int] NULL,
            [DEMAND_DATE] [datetime] NULL,
            [DEMAND_NO] [nvarchar](100) NULL,
            [DEMAND_STAGE] [int] NULL,
            [DETAIL] [nvarchar](max) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [REFERENCE] [nvarchar](50) NULL,
            [RESPONSIBLE_EMP] [int] NULL,
        CONSTRAINT [PK_BUDGET_TRANSFER_DEMAND_DEMAND_ID] PRIMARY KEY CLUSTERED 
        (
            [DEMAND_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'RESPONSIBLE_EMP')
        BEGIN
            ALTER TABLE BUDGET_TRANSFER_DEMAND ADD RESPONSIBLE_EMP int null       
        END;
    END;
</querytag>