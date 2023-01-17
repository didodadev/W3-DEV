<!-- Description : Retail Product Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='PROJECT_ID')
    BEGIN
        ALTER TABLE PRODUCT ADD 
        [PROJECT_ID] [int] NULL,
        [IS_PURCHASE_C] [bit] NULL,
        [IS_PURCHASE_M] [bit] NULL,
        [P_PROFIT] [float] NULL,
        [S_PROFIT] [float] NULL,
        [DUEDAY] [int] NULL,
        [MAXIMUM_STOCK] [int] NULL,
        [ORDER_LIMIT] [int] NULL,
        [MINIMUM_STOCK] [int] NULL,
        [REVENUE_RATE] [float] NULL,
        [ADD_STOCK_DAY] [int] NULL,
        [IS_ORDER_NO] [bit] NULL,
        [S_PROFIT_OLD] [float] NULL,
        [FORCE_UPDATE_DATE] [datetime] NULL,
        [G_PRODUCT_TYPE] [int] NULL
    END;
</querytag>
