<cfquery name="Get_Locations" datasource="#dsn#">
    SELECT 
        COMMENT,
        DEPARTMENT_LOCATION
    FROM 
        STOCKS_LOCATION
</cfquery>
<cfquery name="Get_ProductCat" datasource="#dsn1#">
    SELECT 
        PRODUCT_CATID,
        PRODUCT_CAT
    FROM 
        PRODUCT_CAT
</cfquery>
<cfquery name="GET_CODES" datasource="#DSN3#">
    SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE IS_ACTIVE = 1
</cfquery>