<cfquery name="GET_QUIZ_INFO" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_QUIZ WHERE QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
