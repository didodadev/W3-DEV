<cfquery name="DEL_ANALYSE" datasource="#dsn3#">
	DELETE FROM CAMPAIGN_ANALYSES WHERE ANALYSE_ID = #attributes.analyse_id# AND CAMP_ID = #attributes.camp_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
