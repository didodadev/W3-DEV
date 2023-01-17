<!-- Description : Retail STOCKS Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='STOCKS' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='STOCK_IS_PURCHASE_M')
    BEGIN
        ALTER TABLE STOCKS ADD 
            [OLD_PRODUCT_ID] [int] NULL,
            [NEW_PRODUCT_ID] [int] NULL,
            [OLD_STOCK_ID] [int] NULL,
            [STOCK_IS_SALES] [bit] NULL,
            [STOCK_IS_PURCHASE] [bit] NULL,
            [STOCK_IS_PURCHASE_C] [bit] NULL,
            [STOCK_IS_PURCHASE_M] [bit] NULL
    END;
</querytag>
