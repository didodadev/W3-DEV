<!-- Description : Tablolara yeni alanlar eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_OTV' AND COLUMN_NAME = 'INWARD_PROCESS_CODE')
    BEGIN
        ALTER TABLE SETUP_OTV ADD INWARD_PROCESS_CODE nvarchar(50) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_OTV' AND COLUMN_NAME = 'EXP_PURCHASE_CODE')
    BEGIN
        ALTER TABLE SETUP_OTV ADD EXP_PURCHASE_CODE nvarchar(50) NULL
    END;
   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_OTV' AND COLUMN_NAME = 'EXP_SALES_CODE')
    BEGIN
        ALTER TABLE SETUP_OTV ADD EXP_SALES_CODE nvarchar(50) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'CREDIT_CARD_BANK_PAYMENTS' AND COLUMN_NAME = 'ACTION_TYPE')
    BEGIN
        ALTER TABLE CREDIT_CARD_BANK_PAYMENTS ALTER COLUMN ACTION_TYPE nvarchar(50)
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER' AND COLUMN_NAME = 'ACTIVITY_TYPE_ID')
    BEGIN
        ALTER TABLE OFFER ADD ACTIVITY_TYPE_ID int NULL
    END;

     IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER' AND COLUMN_NAME = 'EXPENSE_ITEM_ID')
    BEGIN
        ALTER TABLE OFFER ADD EXPENSE_ITEM_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER' AND COLUMN_NAME = 'ACC_CODE')
    BEGIN
        ALTER TABLE OFFER ADD ACC_CODE nvarchar(100) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER' AND COLUMN_NAME = 'EXPENSE_CENTER_ID')
    BEGIN
        ALTER TABLE OFFER ADD EXPENSE_CENTER_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SERVICE' AND COLUMN_NAME = 'SERVICE_HEAD')
    BEGIN
        ALTER TABLE SERVICE ALTER COLUMN SERVICE_HEAD nvarchar(100)
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PRODUCT_PERIOD_CAT' AND COLUMN_NAME = 'REASON_CODE')
    BEGIN
        ALTER TABLE SETUP_PRODUCT_PERIOD_CAT ALTER COLUMN REASON_CODE nvarchar(1000)
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL' AND COLUMN_NAME = 'DETAIL')
    BEGIN
        ALTER TABLE SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL ALTER COLUMN DETAIL nvarchar(150)
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_BSMV' AND COLUMN_NAME = 'DIRECT_EXPENSE_CODE')
    BEGIN
        ALTER TABLE SETUP_BSMV ALTER COLUMN DIRECT_EXPENSE_CODE nvarchar(250)
    END;
    
</querytag>