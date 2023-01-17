<cfquery name="CHECK_USER_VOTE" datasource="#DSN#">
	SELECT
		EMP_ID,
		PAR_ID,
		CON_ID,
		GUEST,
		RECORD_IP
	FROM
		SURVEY_VOTES
	WHERE
		SURVEY_ID = #attributes.survey_id#
</cfquery>

