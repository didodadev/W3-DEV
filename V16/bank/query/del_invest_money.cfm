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
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</cfif>
</script>

