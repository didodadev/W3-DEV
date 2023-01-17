<!-- Description : Raflı stokların çekildiği querylerde hareket görmeyen ürünlerinde gelmesi sağlandı
Developer: Pınar Yıldız
Company : Workcube
Destination: Period-->
<querytag>
    ALTER VIEW [GET_STOCK_SHELF] AS
        SELECT
            SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
            SR.PRODUCT_ID, 
            SR.STOCK_ID,
            SR.DELIVER_DATE,
            SR.SHELF_NUMBER AS SHELF_ID	
        FROM			
            STOCKS_ROW SR
        GROUP BY
            SR.PRODUCT_ID, 
            SR.STOCK_ID,
            SR.DELIVER_DATE,
            SR.SHELF_NUMBER
</querytag>