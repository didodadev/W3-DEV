<!-- Description : Bütçe Reserve Tablosu
Developer: İlker Altındal
Company : Workcube
Destination: Period -->

<querytag>

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='EXPENSE_RESERVED_ROWS')
    BEGIN

    CREATE TABLE [EXPENSE_RESERVED_ROWS](
        [EXP_ITEM_ROWS_ID] [int] IDENTITY(1,1) NOT NULL,
        [EXPENSE_ID] [int] NULL,
        [EXPENSE_DATE] [datetime] NULL,
        [EXPENSE_CENTER_ID] [int] NULL,
        [EXPENSE_ITEM_ID] [int] NULL,
        [EXPENSE_COST_TYPE] [int] NULL,
        [EXPENSE_EMPLOYEE] [int] NULL,
        [PYSCHICAL_ASSET_ID] [int] NULL,
        [PROJECT_ID] [int] NULL,
        [PAPER_TYPE] [nvarchar](100) NULL,
        [AMOUNT] [float] NULL,
        [AMOUNT_KDV] [float] NULL,
        [MONEY_CURRENCY_ID] [nvarchar](43) NULL,
        [SYSTEM_RELATION] [nvarchar](250) NULL,
        [TOTAL_AMOUNT] [float] NULL,
        [COMPANY_ID] [int] NULL,
        [COMPANY_PARTNER_ID] [int] NULL,
        [ACTIVITY_TYPE] [int] NULL,
        [DETAIL] [nvarchar](max) NULL,
        [RATE] [float] NULL,
        [ACTION_ID] [int] NULL,
        [STOCK_ID] [int] NULL,
        [IS_INCOME] [bit] NULL,
        [MEMBER_TYPE] [nvarchar](43) NULL,
        [KDV_RATE] [nvarchar](43) NULL,
        [OTHER_MONEY_VALUE] [float] NULL,
        [INVOICE_ID] [int] NULL,
        [SALE_PURCHASE] [bit] NULL,
        [IS_DETAILED] [bit] NULL,
        [OTHER_MONEY_VALUE_2] [float] NULL,
        [MONEY_CURRENCY_ID_2] [nvarchar](43) NULL,
        [BUDGET_PLAN_ROW_ID] [int] NULL,
        [STOCK_FIS_ID] [int] NULL,
        [QUANTITY] [float] NULL,
        [PRODUCT_ID] [int] NULL,
        [SPECT_VAR_ID] [int] NULL,
        [STOCK_ID_2] [int] NULL,
        [PRODUCT_NAME] [nvarchar](500) NULL,
        [UNIT] [nvarchar](50) NULL,
        [UNIT_ID] [int] NULL,
        [OTV_RATE] [float] NULL,
        [AMOUNT_OTV] [float] NULL,
        [SUBSCRIPTION_ID] [int] NULL,
        [OTHER_MONEY_GROSS_TOTAL] [float] NULL,
        [WORKGROUP_ID] [int] NULL,
        [WRK_ROW_ID] [nvarchar](40) NULL,
        [EXPENSE_ACCOUNT_CODE] [nvarchar](50) NULL,
        [BRANCH_ID] [int] NULL,
        [IS_INTEREST] [bit] NULL,
        [WORK_ID] [int] NULL,
        [OPP_ID] [int] NULL,
        [ROW_PAPER_NO] [nvarchar](50) NULL,
        [ACTION_TABLE] [nvarchar](50) NULL,
        [RECORD_CONS] [int] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_DATE] [datetime] NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_EMP] [int] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
        [TAX_CODE] [nvarchar](50) NULL,
        [BSMV_RATE] [float] NULL,
        [AMOUNT_BSMV] [float] NULL,
        [BSMV_CURRENCY] [float] NULL,
        [OIV_RATE] [float] NULL,
        [AMOUNT_OIV] [float] NULL,
        [TEVKIFAT_RATE] [float] NULL,
        [AMOUNT_TEVKIFAT] [float] NULL,
        [DISCOUNT_TOTAL] [float] NULL,
        [DISCOUNT_PRICE] [float] NULL,
        [DISCOUNT_RATE] [nvarchar](43) NULL,
     CONSTRAINT [PK_EXPENSE_RESERVED_ROWS_EXP_ITEM_ROWS_ID] PRIMARY KEY CLUSTERED 
    (
        [EXP_ITEM_ROWS_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

    END;


</querytag>