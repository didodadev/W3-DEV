<!-- Description : Fiyat listesinden eklenen fiyatlar için boş stok id değerlerinin update edilmesi sağlandı
Developer: Pınar Yıldız
Company : Workcube
Destination: Company-->
<querytag>
   UPDATE
        pr
        SET 
            pr.STOCK_ID = s.STOCK_ID
    FROM PRICE pr
            INNER JOIN PRODUCT pp ON pr.PRODUCT_ID = pp.PRODUCT_ID
            INNER JOIN STOCKS s ON s.PRODUCT_ID = pr.PRODUCT_ID AND s.STOCK_CODE = pp.PRODUCT_CODE
    WHERE 
        ISNULL(pr.STOCK_ID, 0) = 0
</querytag>