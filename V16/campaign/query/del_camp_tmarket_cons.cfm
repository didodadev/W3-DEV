<cfquery name="del_cons" datasource="#DSN3#">
	DELETE FROM
		CAMPAIGN_TARGET_PEOPLE
	WHERE
		CAMP_ID = #url.camp_id#
		AND CON_ID = #url.con_id#
</cfquery>
<!--- CONSUMER IN NOTLARINI SILIYORUZ --->
<cfquery name="del_notes" datasource="#dsn3#">
	DELETE FROM 
		CAMPAIGN_NOTES 
	WHERE
		CAMPAIGN_ID = #url.camp_id#
		AND CONS_ID = #url.con_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
