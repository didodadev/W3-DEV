<cftry>
    <cfquery name="get_func_cont" datasource="#dsn2#">
        SELECT
            fnc_stok_devir_hizi(1,{ts '2014-01-01 00:00:00'},{ts '2014-01-01 00:00:00'})
    </cfquery>
<cfcatch type="any">
	<cfquery name="get_func_cont" datasource="#dsn2#">
    	CREATE FUNCTION fnc_stok_devir_hizi
        (
        @pno int,
        @date1 datetime,
        @date2 datetime
        )
        RETURNS float 
        AS
        BEGIN
          DECLARE @Result float
          SET @Result = 
            (
                SELECT
                    SATILAN_MAL_MALIYETI / ((DONEM_BASI_STOK+DONEM_SONU_STOK)/2)
                FROM
                    (
                        SELECT
                            SUM(COST*STOCK_OUT) SATILAN_MAL_MALIYETI,
                            (SELECT 
                                SUM(STOCK_IN - STOCK_OUT)*
                                (
                                    SELECT 
                                        TOP 1 PC.PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST 
                                      FROM #dsn1#.PRODUCT_COST PC
                                      WHERE 
                                        PC.PRODUCT_ID = SR2.PRODUCT_ID AND 
                                        PC.START_DATE <= @date1
                                      ORDER BY
                                        PC.START_DATE DESC
                                ) 
                             FROM 
                                STOCKS_ROW SR2 
                             WHERE 
                                SR2.PRODUCT_ID = A.PRODUCT_ID AND 
                                SR2.PROCESS_DATE <= @date1
                            GROUP BY
                                SR2.PRODUCT_ID
                             ) DONEM_BASI_STOK,
                             (SELECT 
                                SUM(STOCK_IN - STOCK_OUT)*
                                (SELECT 
                                        TOP 1 PC.PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST 
                                      FROM #dsn1#.PRODUCT_COST PC
                                      WHERE 
                                        PC.PRODUCT_ID = SR2.PRODUCT_ID AND 
                                        PC.START_DATE<= @date2
                                      ORDER BY
                                        PC.START_DATE DESC
                                      ) 
                             FROM 
                                STOCKS_ROW SR2 
                             WHERE 
                                SR2.PRODUCT_ID = A.PRODUCT_ID AND 
                                SR2.PROCESS_DATE <= @date2
                            GROUP BY
                                SR2.PRODUCT_ID
                             ) DONEM_SONU_STOK
                        FROM
                        (
                                SELECT
                                    (SELECT 
                                        TOP 1 PC.PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST 
                                      FROM #dsn1#.PRODUCT_COST PC
                                      WHERE 
                                        PC.PRODUCT_ID = SR.PRODUCT_ID AND 
                                        PC.START_DATE<= SR.PROCESS_DATE
                                      ORDER BY
                                        PC.START_DATE DESC
                                      ) COST
                                    ,STOCK_OUT
                                    ,PRODUCT_ID
                                FROM
                                    STOCKS_ROW SR
                                WHERE
                                    PRODUCT_ID = @pno AND
                                    PROCESS_TYPE IN (67,71) AND
                                    PROCESS_DATE BETWEEN @date1 AND @date2
                            ) A	
                        GROUP BY
                            A.PRODUCT_ID
                    ) B
            ) 
        RETURN(@Result)
        END
    </cfquery>
</cfcatch>
</cftry>