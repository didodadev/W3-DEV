<!-- Description : Stok listeleme sayfası icin stok tablosunda guncelleme yapıldı.
Developer: Canan Ebret
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'STOCKS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'stock_STATUS')
    BEGIN
        UPDATE  STOCKS SET stock_STATUS = PRODUCT_STATUS WHERE PRODUCT_STATUS = 0 and STOCK_STATUS = 1
    END
</querytag>