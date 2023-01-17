<cfquery name="GET_STOCK" datasource="#DSN3#">
	SELECT 
		PRODUCT_ID,
        STOCK_ID,
        SERIAL_BARCOD,
        STOCK_CODE,
        BARCOD,
        STOCK_CODE_2,
        PROPERTY,
        MANUFACT_CODE,
        PRODUCT_UNIT_ID,
        PACKAGE_TYPE_ID,
        FRIENDLY_URL,
        STOCK_STATUS,
        COUNTER_TYPE_ID,
        COUNTER_MULTIPLIER,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE,
        ASSORTMENT_DEFAULT_AMOUNT
	FROM 
		STOCKS 
	WHERE 
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
