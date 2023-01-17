<cfquery name="GET_SURVEY" datasource="#DSN#">
	SELECT
		*
	FROM
		SURVEY
	WHERE
		SURVEY_ID = #attributes.survey_id#
</cfquery>
