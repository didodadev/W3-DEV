<cfquery name="get_process" datasource="#dsn#">
	SELECT STAGE_ID FROM SURVEY WHERE SURVEY_ID=#SURVEY_ID#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="DEL_SURVEY" datasource="#dsn#">
		DELETE FROM
			SURVEY
		WHERE
			SURVEY_ID = #SURVEY_ID#
	</cfquery>
	<cfquery name="DEL_SURVEY_ANSWERS" datasource="#dsn#">
		DELETE FROM
			SURVEY_ALTS
		WHERE
			SURVEY_ID = #SURVEY_ID#
	</cfquery>
	<cfquery name="DEL_SURVEY_VOTES" datasource="#dsn#">
		DELETE FROM
			SURVEY_VOTES
		WHERE
			SURVEY_ID = #SURVEY_ID#
	</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=campaign.list_survey</cfoutput>';
</script>

