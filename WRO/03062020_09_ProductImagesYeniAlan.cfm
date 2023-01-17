<!-- Description :  Product_Images tablosuna LIST_NO alanı eklendi
Developer: Botan Kayğan
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT_IMAGES' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='LIST_NO')
    BEGIN
        ALTER TABLE PRODUCT_IMAGES ADD 
        LIST_NO int NULL
    END;
</querytag>