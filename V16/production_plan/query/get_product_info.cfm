<cfquery name="get_product" datasource="#dsn3#">
    SELECT
        S.PRODUCT_ID,
        S.PRODUCT_NAME,
        P.P_SAMPLE_ID,
        P.BRAND_ID,
        P.PRODUCT_CODE,
        S.STOCK_ID,
        S.BARCOD,
        S.PROPERTY,
        S.IS_INVENTORY,
        S.STOCK_CODE,
        S.STOCK_CODE_2,
        S.PRODUCT_UNIT_ID,
        S.PRODUCTION_TYPE,
        S.PRODUCTION_AMOUNT_TYPE,
        PU.MAIN_UNIT,
        PS.PRODUCT_SAMPLE_ID,
        PS.PRODUCT_CAT_ID,
        P.PRODUCT_ID ,
        P.PRODUCT_CATID
    FROM
        STOCKS  as S
        LEFT JOIN PRODUCT_UNIT  as PU on PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID 
        LEFT JOIN #dsn1#.PRODUCT as P on  S.PRODUCT_ID = P.PRODUCT_ID 
        LEFT JOIN #dsn3#.PRODUCT_SAMPLE as PS on PS.PRODUCT_SAMPLE_ID=P.P_SAMPLE_ID 
    WHERE
        PU.IS_MAIN =1 AND
        S.STOCK_ID = #attributes.STOCK_ID# 
</cfquery>

