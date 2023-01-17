<cfquery name="GET_USER_JOIN_QUIZ" datasource="#dsn#"><!--- TrainingTest.cfc'ye taşındı ---->
	SELECT 
		RESULT_ID,
		EMP_ID
	FROM 
		QUIZ_RESULTS
	WHERE
	<cfif isDefined("attributes.EMPLOYEE_ID")>
		EMP_ID=#attributes.EMPLOYEE_ID#
		AND
	</cfif>
		QUIZ_ID = #attributes.QUIZ_ID#
		AND IS_STOPPED_QUIZ = 0
</cfquery>
