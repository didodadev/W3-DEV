<cfquery name="GET_QUIZS" datasource="#dsn#">
	SELECT 
		QUIZ.QUIZ_ID,
		QUIZ.QUIZ_HEAD,
		QUIZ.QUIZ_OBJECTIVE,
		QUIZ.QUIZ_PARTNERS,
		QUIZ.QUIZ_CONSUMERS,
		QUIZ.QUIZ_DEPARTMENTS,
		QUIZ.RECORD_EMP,
		QUIZ.RECORD_PAR,
		QUIZ.RECORD_DATE,
		QUIZ.TOTAL_TIME,
		QUIZ.STAGE_ID
		<!---,SETUP_QUIZ_STAGE.STAGE_NAME--->
	FROM 
		QUIZ<!---,
		SETUP_QUIZ_STAGE--->
	WHERE
		QUIZ_ID IS NOT NULL
		<!---QUIZ.STAGE_ID = SETUP_QUIZ_STAGE.STAGE_ID--->
	<cfif isDefined("attributes.TRAINING_SEC_ID") and (attributes.TRAINING_SEC_ID NEQ 0)>
		AND QUIZ.TRAINING_SEC_ID=#attributes.TRAINING_SEC_ID#
	</cfif>
	<cfif isDefined("attributes.ATTENDERS")>
		<cfif attributes.ATTENDERS EQ 1>
		AND QUIZ.QUIZ_DEPARTMENTS IS NOT NULL
		<cfelseif attributes.ATTENDERS EQ 2>
		AND QUIZ.QUIZ_PARTNERS IS NOT NULL
		<cfelseif attributes.ATTENDERS EQ 3>
		AND QUIZ.QUIZ_CONSUMERS IS NOT NULL
		</cfif>
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(QUIZ.QUIZ_HEAD LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR QUIZ.QUIZ_OBJECTIVE LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
	</cfif>
	ORDER BY
		QUIZ_ID DESC
</cfquery>
