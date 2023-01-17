<!-- Description : Ürün açıklaması popup açıklama metni karakter kısıtı 500 e çıkarıldı.
Developer: Yunus Emre Yazıcı
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT_IMAGES' AND TABLE_SCHEMA = '@_dsn_product_@' AND COLUMN_NAME='DETAIL')
    BEGIN
        ALTER TABLE PRODUCT_IMAGES
        ALTER COLUMN DETAIL nvarchar(500)
    END;
</querytag>