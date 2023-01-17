<!-- Description : Miktar2 çalışması için eklenen bazı alanlar.
Developer: Fatih EKİN
Company : Gramoni
Destination: company-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_TREE' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'AMOUNT2')
    BEGIN
        ALTER TABLE PRODUCT_TREE ADD
        AMOUNT2 float NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCTION_ORDERS_STOCKS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'AMOUNT2')
    BEGIN
        ALTER TABLE PRODUCTION_ORDERS_STOCKS ADD
        AMOUNT2 float NULL
    END;
</querytag>