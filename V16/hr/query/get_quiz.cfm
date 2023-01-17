<cfquery name="GET_QUIZ" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_QUIZ WHERE QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
