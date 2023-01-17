<!-- Description : Vadeli Mevduat Satır Tablosundaki Eksik Alan
Developer: İlker Altındal
Company : Workcube
Destination: Period -->

<querytag>  
    
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='INTEREST_YIELD_PLAN_ROWS')
        BEGIN

        CREATE TABLE [INTEREST_YIELD_PLAN_ROWS](
            [YIELD_ROWS_ID] [int] IDENTITY(1,1) NOT NULL,
            [YIELD_ID] [int] NULL,
            [OPERATION_NAME] [varchar](200) NULL,
            [IS_PAYMENT] [int] NULL,
            [BANK_ACTION_DATE] [datetime] NULL,
            [AMOUNT] [float] NULL,
            [STORE_REPORT_DATE] [datetime] NULL,
            [STOPAJ_RATE] [float] NULL,
            [STOPAJ_TOTAL] [float] NULL,
            [EXPENSE_ITEM_TAHAKKUK_ID] [int] NULL,
            [BANK_ACTION_ID] [int] NULL,
            [PAYMENT_PRINCIPAL] [int] NULL,
        CONSTRAINT [PK_INTEREST_YIELD_PLAN_ROWS] PRIMARY KEY CLUSTERED 
        (
            [YIELD_ROWS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
        END;

    ELSE

    BEGIN
        IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='INTEREST_YIELD_PLAN_ROWS' AND COLUMN_NAME='PAYMENT_PRINCIPAL' )
        BEGIN   
            ALTER TABLE INTEREST_YIELD_PLAN_ROWS ADD PAYMENT_PRINCIPAL int NULL 
        END;
    END;
</querytag>