<cfquery name="GET_ORGANIZATION_PLUS" datasource="#DSN#">
	SELECT 
		*
	FROM 
		ORGANIZATION_PLUS
	WHERE   
		ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.org_id#">
	ORDER BY 
		ORGANIZATION_ID DESC
</cfquery>
