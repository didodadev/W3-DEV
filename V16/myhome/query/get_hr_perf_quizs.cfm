<cfquery name="GET_HR_PERF_QUIZS" datasource="#dsn#">
	SELECT 
		EMPLOYEE_QUIZ.QUIZ_ID,
		EMPLOYEE_QUIZ.QUIZ_HEAD,
		EMPLOYEE_QUIZ.POSITION_CAT_ID,
		EMPLOYEE_QUIZ.POSITION_ID AS POSITION_IDS,
		<!--- EMPLOYEE_QUIZ.PERIOD_PART, --->
		EMPLOYEE_QUIZ.IS_ACTIVE,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME<!--- ,
		'#DatePart("yyyy",now())#' PERIOD_YEAR,
		'#DatePart("yyyy",now())#' PERIOD_ID --->
	FROM 
		EMPLOYEE_QUIZ,
		EMPLOYEE_POSITIONS<!--- ,
		SETUP_POSITION_CAT --->
	WHERE
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# 
	AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0 
	AND
		EMPLOYEE_QUIZ.IS_ACTIVE = 1
	AND
		EMPLOYEE_QUIZ.STAGE_ID = -2
	<!--- AND
		SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID --->
		<cfif isDefined("attributes.KEYWORD") AND len(attributes.KEYWORD)>
	AND
		(
		EMPLOYEE_QUIZ.QUIZ_HEAD LIKE '%#attributes.KEYWORD#%'
	OR
		EMPLOYEE_QUIZ.QUIZ_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
		)
		</cfif>
	ORDER BY 
			EMPLOYEE_QUIZ.QUIZ_HEAD
</cfquery>