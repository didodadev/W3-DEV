<cfquery name="get_process" datasource="#dsn3#">
	SELECT TMARKET_NO,CONSUMER_STAGE FROM TARGET_MARKETS WHERE TMARKET_ID = #TMARKET_ID#
</cfquery>
<cftransaction>
	<cfquery name="DEL_TMARKET" datasource="#dsn3#">
		DELETE FROM
			TARGET_MARKETS
		WHERE
			TMARKET_ID = #TMARKET_ID#
	</cfquery>	
	<cfquery name="ADD_TMARKET_TO_CAMP" datasource="#dsn3#">
		DELETE  FROM
			CAMPAIGN_TARGET_MARKETS
		WHERE
			TMARKET_ID = #TMARKET_ID#
	</cfquery>
	<cfquery name="DEL_TARGET_PEOPLE" datasource="#DSN3#">
		DELETE FROM
		  CAMPAIGN_TARGET_PEOPLE
		WHERE
		   TMARKET_ID = #TMARKET_ID#
	</cfquery>
	<cf_add_log log_type="-1" action_id="#attributes.TMARKET_id#" action_name="#attributes.head#" paper_no="#get_process.tmarket_no#" process_stage="#get_process.consumer_stage#" data_source="#dsn3#">
</cftransaction>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=campaign.list_target_markets</cfoutput>";
</script>


