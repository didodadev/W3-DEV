<!--Description : Ürün Kodu,Stok Kodu ve Barcod alanlarına değerler atandı.
Developer: Melek KOCABEY
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS (SELECT 1 FROM @_dsn_product_@.PRODUCT_NO)
    BEGIN
        INSERT INTO 
            @_dsn_product_@.PRODUCT_NO 
            (
                PRODUCT_NO,
                STOCK_NO,
                BARCODE,
                BARCODE_EAN8
            )
            VALUES
            (
                10000,
                10000,
                '211000000001x',
                '0000043X'
            )
    END;
</querytag>