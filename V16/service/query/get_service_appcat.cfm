<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
	SELECT 
		* 
	FROM 	
		SERVICE_APPCAT
		<cfif isdefined("attributes.servicecat_id")>
	WHERE
		SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.servicecat_id#">
		</cfif>
	ORDER BY
		SERVICECAT
</cfquery>
