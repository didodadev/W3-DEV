<cfquery name="GET_BRAND" datasource="#DSN3#">
	SELECT 
		PB.BRAND_NAME,
		PB.DETAIL,
		PBI.PATH,
		PBI.PATH_SERVER_ID
   	FROM
		PRODUCT_BRANDS PB,
        #dsn1_alias#.PRODUCT_BRANDS_IMAGES PBI
	WHERE
    	PBI.BRAND_ID = PB.BRAND_ID AND
		PB.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
</cfquery>
