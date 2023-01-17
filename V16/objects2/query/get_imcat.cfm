<cfquery name="GET_IMCAT" datasource="#DSN#">
	SELECT 
		IMCAT 
	FROM 
		SETUP_IM 
	WHERE 
		IMCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.imcat_id#">
</cfquery>
