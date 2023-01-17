<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			muhasebe_sil (action_id:listfirst(ATTRIBUTES.IDS,","),process_type:attributes.old_process_type);
		</cfscript>		
		<cfquery name="DEL_CASH_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM CASH_ACTION_MONEY WHERE ACTION_ID = #listfirst(ATTRIBUTES.IDS,",")#
		</cfquery>
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID IN (#ATTRIBUTES.IDS#)
		</cfquery>
        <cf_add_log log_type="-1" action_id="#listfirst(ATTRIBUTES.IDS,',')#" action_name="#attributes.pageHead#" paper_no="#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#attributes.old_process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
</script>

