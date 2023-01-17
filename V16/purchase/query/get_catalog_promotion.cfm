<cfquery name="get_cat_prom_name" datasource="#DSN3#">
	SELECT 
		CATALOG_HEAD 
	FROM 
		CATALOG_PROMOTION 
	WHERE
	 <cfif len(attributes.catalog_id)>CATALOG_ID = #attributes.catalog_id#<cfelse>0=1</cfif>
</cfquery>

