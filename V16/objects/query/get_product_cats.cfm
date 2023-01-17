<cfquery name="GET_PRODUCT_CATS" datasource="#dsn3#">
	SELECT 
		PRODUCT_CATID, 
		HIERARCHY, 
		PRODUCT_CAT,
		POSITION_CODE,
		POSITION_CODE2,
		PROFIT_MARGIN
	FROM 
		PRODUCT_CAT
	WHERE
		PRODUCT_CATID IS NOT NULL
	ORDER BY
		HIERARCHY
</cfquery>