<cfquery name="get_process" datasource="#dsn#">
	SELECT PROCESS_CAT FROM COMPANY_DEBIT_POSTPONE WHERE COMPANY_DEBIT_POSTPONE_ID = #attributes.debit_postpone_id#
</cfquery>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="DEL_NOTES" datasource="#DSN#">
			DELETE FROM NOTES WHERE ACTION_SECTION = '#ucase('COMPANY_DEBIT_POSTPONE_ID')#' AND ACTION_ID = #attributes.debit_postpone_id#
		</cfquery>
		<cfquery name="DEL_COMPANY_DEBIT" datasource="#DSN#">
			DELETE FROM COMPANY_DEBIT_POSTPONE WHERE COMPANY_DEBIT_POSTPONE_ID = #attributes.debit_postpone_id#
		</cfquery>
		<cfquery name="DEL_COMPANY_DEBIT_ROW" datasource="#DSN#">
			DELETE FROM COMPANY_DEBIT_POSTPONE_ROW WHERE POSTPONE_ID = #attributes.debit_postpone_id#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.debit_postpone_id#" action_name="Borc Erteleme" process_stage="#get_process.process_cat#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
