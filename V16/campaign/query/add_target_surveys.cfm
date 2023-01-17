<cfif isdefined("attributes.tmarket_id")>
	<cfquery name="ADD_TARGET_SURVEYS" datasource="#dsn3#">
		INSERT INTO
			TARGET_SURVEYS
		(
			TMARKET_ID,
			SURVEY_ID
		)
		VALUES	
		(
			#attributes.tmarket_id#,
			#attributes.survey_id#
		)
	</cfquery>
<cfelse>
	<cfquery name="ADD_CAMPAIGN_SURVEYS" datasource="#dsn3#">
		INSERT INTO
			CAMPAIGN_SURVEYS
		(
			CAMP_ID,
			SURVEY_ID
		)
		VALUES
		(
			#attributes.camp_id#,
			#attributes.survey_id#
		)
	</cfquery>
</cfif>
<script type="text/javascript">
	opener.wrk_opener_reload();
	window.close();
</script>
