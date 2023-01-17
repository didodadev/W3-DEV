<cfquery name="GET_PROPERTY_DETAIL" datasource="#DSN1#">
	SELECT 
		* 
	FROM 
		PRODUCT_PROPERTY_DETAIL 
	WHERE 
		PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
	ORDER BY
		PROPERTY_DETAIL
</cfquery>
