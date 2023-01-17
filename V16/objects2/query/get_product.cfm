<cfquery name="GET_PRODUCT" datasource="#DSN3#">
	SELECT 
		PRODUCT_CATID,
		IS_KARMA,
		PRODUCT_NAME,
		PRODUCT_DETAIL2,
		PRODUCT_DETAIL,
		BRAND_ID,
		SHORT_CODE,
		PRODUCT_CODE,
		PRODUCT_CODE_2,
		PRODUCT_ID,
		TAX,
		SEGMENT_ID,
		IS_ZERO_STOCK,
        MANUFACT_CODE,
        USER_FRIENDLY_URL,
		IS_PROTOTYPE 
	FROM 
		PRODUCT
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>

