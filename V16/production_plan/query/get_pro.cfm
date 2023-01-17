<cfquery name="get_pro" datasource="#dsn3#">
    SELECT
        (SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID =WSP.WS_ID) AS STATION_NAME,
        WSP.*,
        S.PROPERTY,
        P.PRODUCT_NAME,
        PU.MAIN_UNIT
    FROM
        WORKSTATIONS_PRODUCTS WSP,
        PRODUCT P,
        STOCKS S,
        PRODUCT_UNIT PU
    WHERE
        WSP.WS_P_ID=#attributes.UPD#
        AND
        WSP.STOCK_ID=S.STOCK_ID
        AND
        S.PRODUCT_ID=P.PRODUCT_ID
        AND
        P.PRODUCT_ID=PU.PRODUCT_ID
        AND
        PU.IS_MAIN=1
</cfquery>
