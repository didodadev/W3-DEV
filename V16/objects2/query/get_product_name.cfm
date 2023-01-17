<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
	SELECT 
		PRODUCT_NAME
	FROM 
		PRODUCT
	WHERE
		<cfif isdefined("attributes.product_id")>
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		<cfelse>
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
		</cfif>
</cfquery>

