<cfif len(get_app.position_id)>
	<cfquery name="GET_APP_POSITION_QUIZ" datasource="#dsn#">
	SELECT 
		QUIZ_ID,
		QUIZ_HEAD,
		RECORD_EMP,
		RECORD_DATE
	FROM 
		EMPLOYEE_QUIZ
	WHERE 
		APP_POSITION_ID LIKE '%,#get_app.POSITION_ID#,%'
		AND
		IS_ACTIVE = 1
		AND
		STAGE_ID = -2
	</cfquery>
</cfif>
