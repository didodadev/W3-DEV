<cfquery name="GET_KARMA_PRODUCT" datasource="#DSN1#">
	SELECT 
		KP.*,
		P.PRODUCT_NAME
	FROM 
		KARMA_PRODUCTS AS KP,
		PRODUCT P
	WHERE
		KP.PRODUCT_ID = P.PRODUCT_ID AND
		KP.KARMA_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.karma_product_id#">
	ORDER BY
		KP.PRODUCT_ID
</cfquery>



