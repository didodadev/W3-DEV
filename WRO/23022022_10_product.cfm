<!-- Description : holistic 21.5 sürümü tablolar ve kolon değişiklikleri
Developer: Fatih Kara
Company : Workcube
Destination: Product -->
<querytag>  
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_GENERAL_PARAMETERS' AND COLUMN_NAME = 'OTV_TYPE')
BEGIN
    ALTER TABLE PRODUCT_GENERAL_PARAMETERS ADD OTV_TYPE int;
END;
</querytag>