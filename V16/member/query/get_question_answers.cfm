<cfquery name="GET_QUESTION_ANSWERS" datasource="#DSN#">
	SELECT
		QUESTION_ANSWER_ID,
		QUESTION_ID,
		ANSWER_TEXT,
		ANSWER_INFO,
		ANSWER_POINT,
		ANSWER_PHOTO,
		ANSWER_PHOTO_SERVER_ID,
		ANSWER_PRODUCT_ID,
		ROW
	FROM
		MEMBER_QUESTION_ANSWERS
	WHERE
		QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
	ORDER BY
		QUESTION_ANSWER_ID
</cfquery>
