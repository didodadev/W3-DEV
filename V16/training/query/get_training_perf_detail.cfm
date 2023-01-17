<cfquery name="GET_TRAINING_PERF_DETAIL" datasource="#dsn#">		
	SELECT 
		TRAINING_PERFORMANCE.*, 
		EMPLOYEE_QUIZ_RESULTS.QUIZ_ID ,
		TRAINING_CLASS.*
	FROM 
		TRAINING_PERFORMANCE, 
		EMPLOYEE_QUIZ_RESULTS ,
		TRAINING_CLASS 
	WHERE 
		TRAINING_PERFORMANCE.ENTRY_EMP_ID = #session.ep.userid# AND 
		TRAINING_PERFORMANCE.CLASS_ID = #attributes.class_id# AND
		TRAINING_PERFORMANCE.TRAINING_QUIZ_ID = #attributes.quiz_id# AND 
		TRAINING_PERFORMANCE.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID 
		AND TRAINING_PERFORMANCE.CLASS_ID = TRAINING_CLASS.CLASS_ID  
</cfquery>

<cfquery name="GET_ENTRY_EMP" datasource="#dsn#">
	SELECT 
		EMPLOYEE_NAME, EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE
		EMPLOYEE_ID = #session.ep.userid# 
</cfquery>
