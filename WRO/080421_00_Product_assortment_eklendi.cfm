<!-- Description : Stok tablosuna ASSORTMENT_AMOUNT eklendi
Developer: Halit Yurttaş
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'ASSORTMENT_AMOUNT' AND COLUMN_NAME = 'ASSORTMENT_AMOUNT')
    BEGIN
        ALTER TABLE STOCKS ADD ASSORTMENT_AMOUNT float;
    END;
</querytag>