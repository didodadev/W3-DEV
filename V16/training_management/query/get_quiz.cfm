<cfquery name="GET_QUIZ" datasource="#dsn#">
	SELECT 
		EMPLOYEE_QUIZ.*, SETUP_COMMETHOD.COMMETHOD
	FROM 
		EMPLOYEE_QUIZ, SETUP_COMMETHOD
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
		AND
		EMPLOYEE_QUIZ.COMMETHOD_ID = SETUP_COMMETHOD.COMMETHOD_ID
</cfquery>