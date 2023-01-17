
<cfquery name="GET_USER_JOIN_QUIZ" datasource="#dsn#">
	SELECT 
		RESULT_ID,
		EMP_ID
	FROM 
		EMPLOYEE_QUIZ_RESULTS
	WHERE
	<cfif isDefined("attributes.EMPLOYEE_ID")>
		EMP_ID=#attributes.EMPLOYEE_ID#
		AND
	</cfif>
		QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
