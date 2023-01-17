<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
	SELECT 
		SERVICECAT_ID,
		SERVICECAT
	FROM 	
		SERVICE_APPCAT
	<cfif isdefined("attributes.servicecat_id")>
		WHERE
			SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.servicecat_id#">
	</cfif>
	ORDER BY
		SERVICE_APPCAT.SERVICECAT 
</cfquery>
<cfquery name="GET_APPCAT" datasource="#DSN3#">
	SELECT 
		SERVICE_APPCAT.SERVICECAT 
	FROM 
		SERVICE_APPCAT,
		SERVICE
	WHERE
		SERVICE_APPCAT.SERVICECAT_ID = SERVICE.SERVICECAT_ID
	ORDER BY 
		SERVICE_APPCAT.SERVICECAT 
</cfquery>
