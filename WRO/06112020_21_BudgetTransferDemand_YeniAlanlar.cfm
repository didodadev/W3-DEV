<!-- Description : BUDGET_TRANSFER_DEMAND_ROWS tablosuna yeni alanlar eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [BUDGET_TRANSFER_DEMAND_ROWS](
            [DEMAND_ROWS_ID] [int] IDENTITY(1,1) NOT NULL,
            [DEMAND_ID] [int] NULL,
            [DEMAND_EXP_CENTER] [int] NULL,
            [DEMAND_EXP_ITEM] [int] NULL,
            [DEMAND_ACTIVITY_TYPE] [int] NULL,
            [DEMAND_PROJECT_ID] [int] NULL,
            [AMOUNT] [float] NULL,
            [USABLE_MONEY] [float] NULL,
            [MONEY_CURRENCY] [nvarchar](43) NULL,
            [TRANSFER_EXP_CENTER] [int] NULL,
            [TRANSFER_EXP_ITEM] [int] NULL,
            [TRANSFER_ACTIVITY_TYPE] [int] NULL,
            [TRANSFER_PROJECT_ID] [int] NULL,
            [USABLE_TRANSFER_MONEY] [float] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [TRANSFER_STATUS] [bit] NULL,
            [OFFER_ID] [int] NULL,
            [INTERNAL_ID] [int] NULL,
            [ORDER_ID] [int] NULL,
            [EXPENSE_ID] [int] NULL,
            [BLOCK_TYPE] [bit] NULL,
        CONSTRAINT [PK_BUDGET_TRANSFER_DEMAND_ROWS_DEMAND_ROWS_ID] PRIMARY KEY CLUSTERED 
        (
            [DEMAND_ROWS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]

        ALTER TABLE [BUDGET_TRANSFER_DEMAND_ROWS] ADD  DEFAULT ((0)) FOR [BLOCK_TYPE]
    END
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'TRANSFER_STATUS')
        BEGIN
            ALTER TABLE BUDGET_TRANSFER_DEMAND_ROWS ADD TRANSFER_STATUS bit NULL         
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'OFFER_ID')
        BEGIN
        ALTER TABLE BUDGET_TRANSFER_DEMAND_ROWS ADD OFFER_ID int NULL      
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'INTERNAL_ID')
        BEGIN
            ALTER TABLE BUDGET_TRANSFER_DEMAND_ROWS ADD INTERNAL_ID int NULL       
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'ORDER_ID')
        BEGIN
            ALTER TABLE BUDGET_TRANSFER_DEMAND_ROWS ADD ORDER_ID int NULL    
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'EXPENSE_ID')
        BEGIN
            ALTER TABLE BUDGET_TRANSFER_DEMAND_ROWS ADD EXPENSE_ID int NULL    
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'BLOCK_TYPE')
        BEGIN
            ALTER TABLE BUDGET_TRANSFER_DEMAND_ROWS ADD BLOCK_TYPE bit DEFAULT 0         
        END;
    END;
</querytag>