<!-- Description :  Product_CAT tablosuna STOCK_CODE_COUNTER alanı eklendi
Developer: Emre Kaplan
Company : Gramoni
Destination: Product -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT_CAT' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='STOCK_CODE_COUNTER')
    BEGIN
        ALTER TABLE PRODUCT_CAT
        ADD STOCK_CODE_COUNTER INT NULL
    END;
</querytag>