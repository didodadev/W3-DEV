<cfquery name="GET_ACCIDENT_SECURITIES" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_ACCIDENT_SECURITY
	<cfif isDefined("attributes.ACCIDENT_SECURITY_ID")>
	WHERE
		ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#
	</cfif>
</cfquery>
