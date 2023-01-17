<cfquery name="get_quiz_category" datasource="#dsn#">
	SELECT
		TRAINING_CAT
	FROM
		TRAINING_CAT
	WHERE
		TRAINING_CAT.TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
</cfquery>

