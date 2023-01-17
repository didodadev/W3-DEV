<!-- Description : Reserve işlemleri için wrk_row_id bazında yeni view oluşturuldu
Developer: Pınar Yıldız
Company : Workcube
Destination: Company-->
<querytag>
CREATE VIEW [GET_ORDER_ROWS_RESERVED] AS
            SELECT STOCK_ID,
               PRODUCT_ID,
			   SPECT_VAR_ID,
               ORDER_ID,
               STOCK_STRATEGY_ID,
			   ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID,
               SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
               SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
               SUM(STOCK_IN)              STOCK_IN,
               SUM(STOCK_OUT)             STOCK_OUT
            FROM   ORDER_ROW_RESERVED
               LEFT JOIN (
                        SELECT ORDER_WRK_ROW_ID,
                               COUNT(ROW_RESERVED_ID) AS SAYAC
                        FROM   ORDER_ROW_RESERVED
                        GROUP BY
                               ORDER_WRK_ROW_ID
                        HAVING COUNT(ROW_RESERVED_ID) > 1
                    )                  AS XXX
                    ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
            WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
               OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
               OR  (
                       (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                       AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                       AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                   )
            GROUP BY
               STOCK_ID,
               PRODUCT_ID,
			   SPECT_VAR_ID,
               ORDER_ID,
			   ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID,
               STOCK_STRATEGY_ID
</querytag>