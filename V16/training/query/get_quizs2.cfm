<cfquery name="GET_QUIZS" datasource="#dsn#">
	SELECT DISTINCT
		QUIZ.QUIZ_ID,
		QUIZ.QUIZ_HEAD,
		QUIZ.QUIZ_OBJECTIVE,
		QUIZ.QUIZ_DEPARTMENTS,
		QUIZ.RECORD_EMP,
		QUIZ.RECORD_PAR,
		QUIZ.RECORD_DATE,
		QUIZ.TOTAL_TIME		
	FROM 
		QUIZ,
		QUIZ_RESULTS
	WHERE
		QUIZ_RESULTS.EMP_ID = #SESSION.EP.USERID#
		AND
		QUIZ_RESULTS.QUIZ_ID = QUIZ.QUIZ_ID
	<cfif isDefined("attributes.TRAINING_CAT_ID")AND (TRAINING_CAT_ID NEQ 0)>
		AND
		TRAINING_CAT_ID=#attributes.TRAINING_CAT_ID#
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		QUIZ_HEAD LIKE '%#attributes.KEYWORD#%'
		OR
		QUIZ_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
</cfquery>
