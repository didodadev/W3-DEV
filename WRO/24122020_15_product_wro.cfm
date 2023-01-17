<!-- Description : Product WRO
Developer: Uğur Hamurpet
Company : Workcube
Destination: Product -->

<querytag>      
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='ADD_STOCK_DAY' )
    BEGIN   
        ALTER TABLE PRODUCT ADD ADD_STOCK_DAY int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='IS_ORDER_NO' )
    BEGIN   
        ALTER TABLE PRODUCT ADD IS_ORDER_NO bit NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='IS_PURCHASE_C' )
    BEGIN   
        ALTER TABLE PRODUCT ADD IS_PURCHASE_C bit NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='P_PROFIT' )
    BEGIN   
        ALTER TABLE PRODUCT ADD P_PROFIT float NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='S_PROFIT' )
    BEGIN   
        ALTER TABLE PRODUCT ADD S_PROFIT float NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='ORDER_LIMIT' )
    BEGIN   
        ALTER TABLE PRODUCT ADD ORDER_LIMIT int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='MAXIMUM_STOCK' )
    BEGIN   
        ALTER TABLE PRODUCT ADD MAXIMUM_STOCK int NULL 
    END;
    
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='REVENUE_RATE' )
    BEGIN   
        ALTER TABLE PRODUCT ADD REVENUE_RATE float NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='FORCE_UPDATE_DATE' )
    BEGIN   
        ALTER TABLE PRODUCT ADD FORCE_UPDATE_DATE datetime NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='MINIMUM_STOCK' )
    BEGIN   
        ALTER TABLE PRODUCT ADD MINIMUM_STOCK int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='S_PROFIT_OLD' )
    BEGIN   
        ALTER TABLE PRODUCT ADD S_PROFIT_OLD float NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='IS_PURCHASE_M' )
    BEGIN   
        ALTER TABLE PRODUCT ADD IS_PURCHASE_M bit NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='PROJECT_ID' )
    BEGIN   
        ALTER TABLE PRODUCT ADD PROJECT_ID int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='DUEDAY' )
    BEGIN   
        ALTER TABLE PRODUCT ADD DUEDAY int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT' AND COLUMN_NAME='G_PRODUCT_TYPE' )
    BEGIN   
        ALTER TABLE PRODUCT ADD G_PRODUCT_TYPE int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='STOCKS' AND COLUMN_NAME='OLD_STOCK_ID' )
    BEGIN   
        ALTER TABLE STOCKS ADD OLD_STOCK_ID int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='STOCKS' AND COLUMN_NAME='NEW_PRODUCT_ID' )
    BEGIN   
        ALTER TABLE STOCKS ADD NEW_PRODUCT_ID int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='STOCKS' AND COLUMN_NAME='STOCK_IS_PURCHASE_C' )
    BEGIN   
        ALTER TABLE STOCKS ADD STOCK_IS_PURCHASE_C bit NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='STOCKS' AND COLUMN_NAME='STOCK_IS_SALES' )
    BEGIN   
        ALTER TABLE STOCKS ADD STOCK_IS_SALES bit NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='STOCKS' AND COLUMN_NAME='STOCK_IS_PURCHASE' )
    BEGIN   
        ALTER TABLE STOCKS ADD STOCK_IS_PURCHASE bit NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='STOCKS' AND COLUMN_NAME='STOCK_IS_PURCHASE_M' )
    BEGIN   
        ALTER TABLE STOCKS ADD STOCK_IS_PURCHASE_M bit NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='STOCKS' AND COLUMN_NAME='OLD_PRODUCT_ID' )
    BEGIN   
        ALTER TABLE STOCKS ADD OLD_PRODUCT_ID int NULL 
    END;
</querytag>