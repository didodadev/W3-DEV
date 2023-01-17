<cfquery name="SEL_SURVEY" datasource="#dsn#">
	SELECT
		SURVEY
	FROM
		SURVEY
	WHERE 
		SURVEY_ID = #survey_id#
</cfquery>

<script type="text/javascript">
	<cfoutput>
		window.opener.document.all.survey_id.value=#survey_id#;
		window.opener.document.all.anket.value="#PreserveSingleQuotes(SEL_SURVEY.survey)#";
		window.close();
	</cfoutput>
</script>

