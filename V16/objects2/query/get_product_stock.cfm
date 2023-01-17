<cfif isDefined("product_id")>
		<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#dsn2#">
			SELECT 
				PRODUCT_TOTAL_STOCK 
			FROM 
				GET_PRODUCT_STOCK 
			WHERE 
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
		</cfquery>
	<cfif product_total_stock.recordcount>
		<cfset product_stock = product_total_stock.PRODUCT_TOTAL_STOCK>
	<cfelse>
		<cfset product_stock = 0>
	</cfif>
</cfif>
