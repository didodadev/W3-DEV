<!-- Description : PRODUCT_PERIOD tablosuna tahakkuk işlem hesapları alanları eklendi.
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'ACCRUAL_MONTH')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD ACCRUAL_MONTH INT
        END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'ACCRUAL_INCOME_ITEM_ID')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD ACCRUAL_INCOME_ITEM_ID INT
        END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'ACCRUAL_EXPENSE_ITEM_ID')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD ACCRUAL_EXPENSE_ITEM_ID INT
        END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'NEXT_MONTH_INCOMES_ACC_CODE')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD NEXT_MONTH_INCOMES_ACC_CODE nvarchar(50)
        END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'NEXT_YEAR_INCOMES_ACC_CODE')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD NEXT_YEAR_INCOMES_ACC_CODE nvarchar(50)
        END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'NEXT_MONTH_EXPENSES_ACC_CODE')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD NEXT_MONTH_EXPENSES_ACC_CODE nvarchar(50)
        END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'NEXT_YEAR_EXPENSES_ACC_CODE')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD NEXT_YEAR_EXPENSES_ACC_CODE nvarchar(50)
        END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'RUN_REQUIREMENT')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD RUN_REQUIREMENT INT
        END;
</querytag>
