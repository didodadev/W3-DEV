<cfquery name="GET_TRAINER" datasource="#DSN#">
	SELECT
		AVG(EQRD.QUESTION_POINT) AS AVG_TOTAL
	FROM
		EMPLOYEE_QUIZ EQU,
		EMPLOYEE_QUIZ_RESULTS_DETAILS EQRD,
		EMPLOYEE_QUIZ_RESULTS EQR,
		TRAINING_CLASS_QUIZES TCQ,
		TRAINING_CLASS TC
	WHERE
		EQU.IS_TRAINER=1 AND
		EQR.RESULT_ID=EQRD.RESULT_ID AND
		EQR.QUIZ_ID=EQU.QUIZ_ID AND
		TCQ.CLASS_ID=TC.CLASS_ID AND
		TCQ.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND
		EQRD.QUESTION_POINT IS NOT NULL
</cfquery>

