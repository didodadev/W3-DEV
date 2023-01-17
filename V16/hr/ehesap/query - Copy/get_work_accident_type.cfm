<cfquery name="GET_WORK_ACCIDENT_TYPE" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_WORK_ACCIDENT_TYPE
	<cfif isDefined("attributes.ACCIDENT_TYPE_ID")>
	WHERE
		ACCIDENT_TYPE_ID = #attributes.ACCIDENT_TYPE_ID#
	</cfif>
</cfquery>
