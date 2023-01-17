<cfquery name="get_process" datasource="#dsn2#">
	SELECT PAPER_NO,PROCESS_CAT FROM CASH_ACTIONS WHERE ACTION_ID = #attributes.ID#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			cari_sil(action_id:attributes.ID,process_type:attributes.old_process_type);
			muhasebe_sil(action_id:attributes.ID,process_type:attributes.old_process_type,belge_no:get_process.paper_no);
			butce_sil(action_id:attributes.ID,process_type:attributes.old_process_type);
		</cfscript>		
		<cfquery name="DEL_CASH_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM CASH_ACTION_MONEY WHERE ACTION_ID = #attributes.ID#
		</cfquery>
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #attributes.ID#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#get_process.paper_no# Silindi" process_type="#attributes.old_process_type#" paper_no="#get_process.paper_no#"  data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
	wrk_opener_reload();
	window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
	</cfif>
</script>
