<!-- Description :  Ürün detayına carbon footprint tabı 
Developer: Mahmut Aslan
Company : Workcube
Destination: Product -->
<querytag> 
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME = 'RECOVERY_AMOUNT')
    BEGIN 
        ALTER TABLE PRODUCT ADD RECOVERY_AMOUNT float NULL 
    END; 
</querytag>