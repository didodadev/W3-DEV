<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset GET_TRAINING_EVAL_QUIZS = cmp.GET_TRAINING_EVAL_QUIZS_F()>
<!--- <cfquery name="GET_TRAINING_EVAL_QUIZS" datasource="#DSN#">
	SELECT
		QUIZ_ID,
		QUIZ_HEAD
	FROM
		EMPLOYEE_QUIZ
	WHERE
		STAGE_ID = -2 AND
		IS_ACTIVE = 1 AND
		IS_EDUCATION = 1
	ORDER BY 
		QUIZ_HEAD
</cfquery> --->