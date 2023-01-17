<!-- Description :  SETUP_COMPANY_STOCK_CODE tablosuna UNIT_ID alanı eklendi
Developer: Emre Kaplan
Company : Gramoni
Destination: Product -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_COMPANY_STOCK_CODE' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='STOCK_CODE_COUNTER')
    BEGIN
        ALTER TABLE SETUP_COMPANY_STOCK_CODE
        ADD UNIT_ID INT NULL
    END;
</querytag>