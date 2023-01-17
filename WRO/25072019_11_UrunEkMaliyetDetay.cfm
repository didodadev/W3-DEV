<!--Description : Ürün Ek Maliyet Detay Tablosu eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Period-->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='PRODUCT_EXTRA_COST_DETAIL')
    BEGIN
        CREATE TABLE [PRODUCT_EXTRA_COST_DETAIL](
            [ID] [int] IDENTITY(1,1) NOT NULL,
            [ACCOUNT_ID] [nvarchar](50) NULL,
            [EXPENSE_ID] [int] NULL,
            [EXPENSE_SHIFT] [float] NULL,
            [AMOUNT] [float] NULL,
            [STATION_ID] [int] NULL,
            [PRODUCT_ID] [int] NULL,
            [MONEY] [nvarchar](50) NULL,
            [P_ORDER_ID] [int] NULL,
        CONSTRAINT [PK_PRODUCT_EXTRA_COST_DETAIL] PRIMARY KEY CLUSTERED 
        (
            [ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>