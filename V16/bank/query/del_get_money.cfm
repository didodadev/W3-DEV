<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_CASH_ACTION" datasource="#dsn2#">
			SELECT ACTION_ID FROM CASH_ACTIONS WHERE BANK_ACTION_ID = #attributes.ID#
		</cfquery>
		<cfscript>
			muhasebe_sil(action_id:attributes.ID,process_type:attributes.old_process_type,belge_no:attributes.paper_no);
		</cfscript>		
		<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = #attributes.ID#
		</cfquery>
		<cfquery name="DEL_CASH_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM CASH_ACTION_MONEY WHERE ACTION_ID = #GET_CASH_ACTION.ACTION_ID#
		</cfquery>
		<cfquery name="DEL_FROM_BANK_ACTIONS" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.ID#
		</cfquery>
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE BANK_ACTION_ID = #attributes.ID#
		</cfquery>
        
        <cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.ID#" action_name= "#attributes.pageHead#" paper_no= "#attributes.paper_no#" period_id="#session.ep.period_id#" process_type="#attributes.old_process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
</script>


