	<cfquery name="GET_CATALOG" datasource="#dsn3#">
		SELECT 
			* 
		FROM 
			CATALOG
		WHERE 
			CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.catalog_id#">
	</cfquery>

