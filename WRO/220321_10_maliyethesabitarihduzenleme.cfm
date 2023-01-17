<!-- Description : maliyet hesabı getiren viewde tarih filtresinde saat farkına takılıyordu kosulda düzenleme yapıldı
Developer: İlker Altındal
Company : Workcube
Destination: Period-->
<querytag>
    ALTER VIEW [GET_ALL_STOCKS_ROW_COST] AS
        SELECT 
            PRODUCT_ID,
            STOCK_ID,
            SPECT_VAR_ID,
            LOT_NO,
            ISNULL((SELECT
                TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
            FROM 
                GET_PRODUCT_COST_PERIOD
            WHERE
                CONVERT(DATE, GET_PRODUCT_COST_PERIOD.START_DATE) <= CONVERT(DATE, STOCKS_ROW.PROCESS_DATE)
                AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
                AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0)
            ORDER BY
                GET_PRODUCT_COST_PERIOD.START_DATE DESC,
                GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
                GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
                ),0) AS NET_MALIYET,
            ISNULL((SELECT
                TOP 1 (PURCHASE_NET_SYSTEM_2 + PURCHASE_EXTRA_COST_SYSTEM_2)  
            FROM 
                GET_PRODUCT_COST_PERIOD
            WHERE
                CONVERT(DATE, GET_PRODUCT_COST_PERIOD.START_DATE) <= CONVERT(DATE, STOCKS_ROW.PROCESS_DATE)
                AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
                AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0)
            ORDER BY 
                GET_PRODUCT_COST_PERIOD.START_DATE DESC,
                GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
                GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
                ),0) AS NET_MALIYET_2,
            STOCK_IN,
            STOCK_OUT,
            UPD_ID,
            PROCESS_DATE,
            PROCESS_TYPE,
            STORE,
            STORE_LOCATION
        FROM 
            STOCKS_ROW
</querytag>