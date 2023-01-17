<cfquery name="GET_CRM" datasource="#dsn3#">
SELECT 
	SERVICECAT_ID 
FROM 
	SERVICE
WHERE 
	SERVICE_ID= #GET_TIME_COST.CRM_ID#
</cfquery>

<cfif len(GET_CRM.SERVICECAT_ID)>
	<cfquery name="GET_CRM_NAME" datasource="#dsn3#">
	SELECT 
		SERVICECAT 
	FROM 
		SERVICE_APPCAT
	WHERE 
		SERVICECAT_ID= #GET_CRM.SERVICECAT_ID#
	</cfquery>
</cfif>
