<cfquery name="get_ques_questions" datasource="#DSN#">
	SELECT
		QUESTION_ID
	FROM
		QUIZ_QUESTIONS
	WHERE
		QUESTION_ID = #attributes.question_id#
</cfquery>
