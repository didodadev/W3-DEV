<cfquery name="GET_SURVEY_RESULT" datasource="#dsn#">
	SELECT
		SURVEY_VOTES.VOTES
	FROM
		SURVEY_VOTES
	WHERE
		SURVEY_VOTES.CON_ID = #attributes.CONSUMER_ID# 
		AND
		SURVEY_VOTES.SURVEY_ID = #attributes.SURVEY_ID#
</cfquery>
<cfif GET_SURVEY_RESULT.RECORDCOUNT>
	<cfquery name="GET_SURVEY_ANSWER" datasource="#dsn#">
	SELECT
		SURVEY_ALTS.ALT
	FROM
		SURVEY_ALTS
	WHERE
		SURVEY_ALTS.ALT_ID IN (#listsort(GET_SURVEY_RESULT.VOTES,'Numeric')#) 
		AND
		SURVEY_ALTS.SURVEY_ID = #attributes.SURVEY_ID#
	</cfquery>
</cfif>
