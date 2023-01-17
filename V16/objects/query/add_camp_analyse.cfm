<cfquery name="ADD_CAMP_ANALYSES" datasource="#dsn3#">
	INSERT INTO
		CAMPAIGN_ANALYSES
	(
		ANALYSE_ID,
		CAMP_ID
	)
	VALUES
	(
		#attributes.analysis_id#,
		#attributes.camp_id#
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
