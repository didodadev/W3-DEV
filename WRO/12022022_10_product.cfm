<!-- Description : holistic 21.4 sürümü tablolar ve kolon değişiklikleri
Developer: Uğur Hamurpet
Company : Workcube
Destination: Product -->
<querytag>  
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'WATALOGY_ID')
BEGIN
    ALTER TABLE PRODUCT ADD WATALOGY_ID int;
END;
</querytag>