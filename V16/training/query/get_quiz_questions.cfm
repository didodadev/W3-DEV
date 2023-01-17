<cfif isdefined("attributes.limit")>
	<cfquery name="GET_QUIZ_QUESTIONS" DATASOURCE="#DSN#" MAXROWS="#attributes.LIMIT#">
		SELECT 
			QUESTION.*
		FROM 
			QUIZ_QUESTIONS,
			QUESTION
		WHERE
			QUIZ_QUESTIONS.QUIZ_ID = #attributes.QUIZ_ID#
			AND
			QUIZ_QUESTIONS.QUESTION_ID = QUESTION.QUESTION_ID
	</cfquery>
<cfelse>
	<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
		SELECT 
			QUESTION.*
		FROM 
			QUIZ_QUESTIONS,
			QUESTION
		WHERE
			QUIZ_QUESTIONS.QUIZ_ID = #attributes.QUIZ_ID#
			AND
			QUIZ_QUESTIONS.QUESTION_ID = QUESTION.QUESTION_ID
	</cfquery>
</cfif>
