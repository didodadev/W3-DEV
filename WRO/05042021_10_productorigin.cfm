<!-- Description : Product menşei alanı eklendi
Developer: İlker Altındal
Company : Workcube
Destination: Product -->

<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='ORIGIN_ID')
    BEGIN
        ALTER TABLE PRODUCT
        ADD ORIGIN_ID INT NULL
    END;

</querytag>