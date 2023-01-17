<cfquery name="get_process" datasource="#dsn2#">
	SELECT PAPER_NO,PROCESS_CAT FROM CASH_ACTIONS WHERE ACTION_ID = #URL.ID#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			cari_sil(action_id:URL.ID,process_type:attributes.old_process_type);
			muhasebe_sil(action_id:URL.ID,process_type:attributes.old_process_type);
		</cfscript>		
		<cfquery name="DEL_CASH_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM CASH_ACTION_MONEY WHERE ACTION_ID = #URL.ID#
		</cfquery>
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #URL.ID#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.detail#"  process_type="#attributes.old_process_type#" paper_no="#get_process.paper_no#"  data_source="#dsn2#">
	</cftransaction>
</cflock>