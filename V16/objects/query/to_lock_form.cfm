<cfsetting showdebugoutput="no">
<cfif attributes.lock eq 1>
	<cfquery name="upd_main_result" datasource="#dsn#">
		UPDATE
			SURVEY_MAIN_RESULT
		SET
			IS_CLOSED = 0
		WHERE
			SURVEY_MAIN_RESULT_ID = #attributes.survey_main_result_id#
	</cfquery>
<cfelseif attributes.lock eq 0>
	<cfquery name="upd_main_result" datasource="#dsn#">
		UPDATE
			SURVEY_MAIN_RESULT
		SET
			IS_CLOSED = 1
		WHERE
			SURVEY_MAIN_RESULT_ID = #attributes.survey_main_result_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	window.close();
</script>
