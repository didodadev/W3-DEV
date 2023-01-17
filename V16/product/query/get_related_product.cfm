<cfquery name="GET_RELATED_PRODUCT" datasource="#dsn3#">
	SELECT
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		RP.RELATED_PRODUCT_NO PRO_NO,
		RP.RELATED_ID
	FROM
		RELATED_PRODUCT AS RP,
		PRODUCT AS P
	WHERE
		RP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
		RP.RELATED_PRODUCT_ID = P.PRODUCT_ID	
</cfquery>

<cfquery name="GET_RELATED_PRODUCT2" datasource="#dsn3#">
	SELECT
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		RP.RELATED_PRODUCT_NO PRO_NO,
		RP.RELATED_ID
	FROM
		RELATED_PRODUCT AS RP,
		PRODUCT AS P
	WHERE
		RP.RELATED_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
		RP.PRODUCT_ID = P.PRODUCT_ID
	ORDER BY
		PRO_NO
</cfquery>

