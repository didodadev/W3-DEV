<cfsetting showdebugoutput="no">
<cfquery name="del_group_emp" datasource="#DSN3#">
	DELETE FROM  
		CAMPAIGN_TEAM
	WHERE
		POSITION_CODE= #URL.position_code#  	 
		AND CAMPAIGN_ID=#URL.CAMPAIGN_ID#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.is_ajax_delete")>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
