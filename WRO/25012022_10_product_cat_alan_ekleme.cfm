<!-- Description :  Product_CAT tablosuna FORM_FACTOR alanı eklendi
Developer: Fatih Kara
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT_CAT' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='FORM_FACTOR')
    BEGIN
        ALTER TABLE PRODUCT_CAT
        ADD FORM_FACTOR INT NULL
    END;
</querytag>