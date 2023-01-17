<cfquery name="get_process" datasource="#dsn2#">
	SELECT PAPER_NO,PROCESS_CAT FROM CASH_ACTIONS WHERE ACTION_ID = #attributes.ID#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			cari_sil(action_id:attributes.ID,process_type:attributes.old_process_type);
			muhasebe_sil(action_id:attributes.ID,process_type:attributes.old_process_type,belge_no:get_process.paper_no);
		</cfscript>		
		<cfquery name="DEL_CASH_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM CASH_ACTION_MONEY WHERE ACTION_ID = #attributes.ID#
		</cfquery>
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #attributes.ID#
		</cfquery>
	</cftransaction>
    <cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#get_process.paper_no# Silindi" paper_no="#get_process.paper_no#" period_id="#session.ep.period_id#" process_type="#attributes.old_process_type#" data_source="#dsn2#"> 
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
</script>

