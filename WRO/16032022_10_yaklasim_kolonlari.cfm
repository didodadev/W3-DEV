<!-- Description :  STOCKS tablosuna yaklaşım alanları eklendi.
Developer: Fatih Kara
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='STOCKS' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='PRODUCTION_TYPE')
    BEGIN
        ALTER TABLE STOCKS
        ADD PRODUCTION_TYPE INT NULL
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='STOCKS' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='PRODUCTION_AMOUNT_TYPE')
    BEGIN
        ALTER TABLE STOCKS
        ADD PRODUCTION_AMOUNT_TYPE INT NULL
    END;
</querytag>