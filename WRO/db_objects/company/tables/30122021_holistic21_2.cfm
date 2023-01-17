CREATE TABLE [@_dsn_company_@].[PROGRESS_PAYMENT_ROW](	  
    [PROGRESS_ID] int NOT NULL, 
    [STOCK_ID] int NULL, 
    [DETAIL] nvarchar(250) NULL
);

CREATE TABLE [@_dsn_company_@].[order_row_reserved_15122021_0949500](	  
    [ROW_RESERVED_ID] int NOT NULL IDENTITY(1,1), 
    [STOCK_ID] int NULL, 
    [PRODUCT_ID] int NULL, 
    [SPECT_VAR_ID] int NULL, 
    [ORDER_ID] int NULL, 
    [ORDER_ROW_ID] int NULL, 
    [SHIP_ID] int NULL, 
    [INVOICE_ID] int NULL, 
    [PERIOD_ID] int NULL, 
    [RESERVE_STOCK_IN] float NULL, 
    [RESERVE_STOCK_OUT] float NULL, 
    [RESERVE_CANCEL_AMOUNT] float NULL, 
    [STOCK_IN] float NULL, 
    [STOCK_OUT] float NULL, 
    [DEPARTMENT_ID] int NULL, 
    [LOCATION_ID] int NULL, 
    [SHELF_NUMBER] int NULL,
    [PRE_ORDER_ID] nvarchar(60) NULL, 
    [STOCK_STRATEGY_ID] int NULL, 
    [IS_BASKET] int NULL, 
    [ORDER_WRK_ROW_ID] nvarchar(40) NULL
);