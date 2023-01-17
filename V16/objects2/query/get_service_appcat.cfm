<cfquery name="GET_SERVICE_APPCAT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 	
		SERVICE_APPCAT
		<cfif isdefined("attributes.SERVICECAT_ID")>
	WHERE
		SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.servicecat_id#">
		</cfif>
	ORDER BY
		SERVICECAT
</cfquery>
<cfquery name="GET_APPCAT" datasource="#dsn3#">
	SELECT 
		SERVICE_APPCAT.SERVICECAT 
	FROM 
		SERVICE_APPCAT,
		SERVICE
	WHERE
		SERVICE_APPCAT.SERVICECAT_ID = SERVICE.SERVICECAT_ID
</cfquery>
