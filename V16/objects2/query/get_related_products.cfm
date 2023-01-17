<cfquery name="GET_RELATED_PRODUCTS" datasource="#dsn3#">
	SELECT 
		PCR.*,
		P.PRODUCT_NAME	
	FROM
		#dsn_alias#.CONTENT_RELATION PCR,
		PRODUCT_CAT PC,
		PRODUCT P
	WHERE
		PCR.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND
		PCR.ACTION_TYPE = 'PRODUCT_ID' AND
		PCR.ACTION_TYPE_ID = P.PRODUCT_ID AND
		P.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PC.IS_PUBLIC = 1		
</cfquery>
