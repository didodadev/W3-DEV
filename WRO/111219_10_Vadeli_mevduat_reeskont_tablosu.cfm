<!-- Description : Vadeli Mevduat Reeskont Kayıtlarının Atıldığı Tablo
Developer: İlker Altındal
Company : Workcube
Destination: Period -->
<querytag>
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='INTEREST_YIELD_VALUATION')
    BEGIN

    CREATE TABLE [INTEREST_YIELD_VALUATION](
        [YIELD_VALUATION_ID] [int] IDENTITY(1,1) NOT NULL,
        [YIELD_ROWS_ID] [int] NULL,
        [YIELD_VALUATION_DATE] [datetime] NULL,
        [YIELD_VALUATION_AMOUNT] [float] NULL,
        [BUDGET_PLAN_ROW_ID] [int] NULL,
    CONSTRAINT [PK_INTEREST_YIELD_VALUATION] PRIMARY KEY CLUSTERED 
    (
        [YIELD_VALUATION_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;

IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='INTEREST_YIELD_PLAN_ROWS' AND COLUMN_NAME='PAYMENT_PRINCIPAL' )
    BEGIN   
        ALTER TABLE INTEREST_YIELD_PLAN_ROWS ADD PAYMENT_PRINCIPAL int NULL 
    END;
</querytag>