<!-- Description :  Ürün imaj detay inputu genişletme
Developer: Fatih Kara
Company : Workcube
Destination: Product -->
<querytag>
    IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_IMAGES_1' AND object_id = OBJECT_ID('[PRODUCT_IMAGES]'))
    BEGIN
    DROP INDEX [NCL_PRODUCT_IMAGES_1] ON [PRODUCT_IMAGES] 
    END;

    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT_IMAGES' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='DETAIL')
    BEGIN
        ALTER TABLE PRODUCT_IMAGES 
        ALTER COLUMN DETAIL nvarchar(MAX) NULL;
    END;

    IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='NCL_PRODUCT_IMAGES_1' AND object_id = OBJECT_ID('[PRODUCT_IMAGES]'))
    BEGIN
    CREATE NONCLUSTERED INDEX [NCL_PRODUCT_IMAGES_1] ON [PRODUCT_IMAGES] ([PRODUCT_ID] ASC,[IMAGE_SIZE] ASC,[PRODUCT_IMAGEID] ASC,[PATH] ASC,[PATH_SERVER_ID] ASC)
    END;
</querytag>
