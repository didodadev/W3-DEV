<!-- Description : Son kullanma tarihi olmayan Raflı stokların çekildiği view yazıldı
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
   CREATE VIEW [GET_STOCK_SHELF_ONLY] AS
        SELECT
            SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
            SR.PRODUCT_ID, 
            SR.STOCK_ID,
            SR.SHELF_NUMBER AS SHELF_ID	
        FROM			
            STOCKS_ROW SR
        GROUP BY
            SR.PRODUCT_ID, 
            SR.STOCK_ID,
            SR.SHELF_NUMBER
</querytag>