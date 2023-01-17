<cfif isdefined("attributes.limit")>
	<cfquery name="GET_QUIZ_QUESTIONS" DATASOURCE="#DSN#" MAXROWS="#attributes.LIMIT#">
		SELECT 
			QUESTION.QUESTION_ID,
			QUESTION.QUESTION,
			QUESTION_POINT,
			<cfloop from="1" to="20" index="i">
			ANSWER#i#_TRUE,
			ANSWER#i#_PHOTO,
			ANSWER#i#_TEXT,
			</cfloop>
			ANSWER_NUMBER,
			QUESTION_INFO
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
			QUESTION.QUESTION_ID,
			QUESTION.QUESTION,
			QUESTION_POINT,
			<cfloop from="1" to="20" index="i">
			ANSWER#i#_TRUE,
			ANSWER#i#_PHOTO,
			ANSWER#i#_TEXT,
			</cfloop>
			ANSWER_NUMBER,
			QUESTION_INFO
		FROM 
			QUIZ_QUESTIONS,
			QUESTION
		WHERE
			QUIZ_QUESTIONS.QUIZ_ID = #attributes.QUIZ_ID#
			AND
			QUIZ_QUESTIONS.QUESTION_ID = QUESTION.QUESTION_ID
	</cfquery>
</cfif>
