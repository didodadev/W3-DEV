<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="get_act_type" datasource="#dsn2#">
			SELECT ACTION_TYPE FROM CARI_DUE_DIFF_ACTIONS WHERE DUE_DIFF_ID = #attributes.due_diff_id#
		</cfquery>
		<cfif get_act_type.action_type eq 1>
			<cfquery name="get_actions" datasource="#dsn2#">
				SELECT ACTION_ID FROM CARI_ACTIONS WHERE DUE_DIFF_ID = #attributes.due_diff_id#
			</cfquery>
			<cfoutput query="get_actions">
				<cfscript>
					is_transaction = 1;
					is_from_premium = 1;
					url.action_id = get_actions.ACTION_ID;
					attributes.action_id = get_actions.ACTION_ID;
					attributes.process_type = 41;
				</cfscript>
				<cfinclude template="del_debit_claim_ic.cfm">
			</cfoutput>
		<cfelseif get_act_type.action_type eq 2>
			<cfquery name="del_subs" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE DUE_DIFF_ID = #attributes.due_diff_id# AND PERIOD_ID = #session.ep.period_id#
			</cfquery>
		<cfelseif get_act_type.action_type eq 3>
			<cfquery name="del_inv_control" datasource="#dsn2#">
				DELETE FROM INVOICE_CONTROL WHERE DUE_DIFF_ID = #attributes.due_diff_id#
			</cfquery>
			<cfquery name="del_contract" datasource="#dsn2#">
				DELETE FROM INVOICE_CONTRACT_COMPARISON WHERE DUE_DIFF_ID = #attributes.due_diff_id#
			</cfquery>
		</cfif>
		<cfquery name="del_due_diff" datasource="#dsn2#">
			DELETE FROM CARI_DUE_DIFF_ACTIONS WHERE DUE_DIFF_ID = #attributes.due_diff_id#
		</cfquery>
		<cfquery name="del_due_money" datasource="#dsn2#">
			DELETE FROM CARI_DUE_DIFF_ACTIONS_MONEY WHERE ACTION_ID = #attributes.due_diff_id#
		</cfquery>
		<cfquery name="del_rows" datasource="#dsn2#">
			DELETE FROM CARI_DUE_DIFF_ACTIONS_ROW WHERE DUE_DIFF_ID = #attributes.due_diff_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_due_diff_actions</cfoutput>';
</script>
