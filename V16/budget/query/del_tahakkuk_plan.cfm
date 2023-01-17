<cflock name="#CreateUUID()#" timeout="40">
	<cftransaction>
		<cfquery name="GET_CARD_ID" datasource="#dsn2#">
			SELECT
				*
			FROM
				ACCOUNT_CARD
			WHERE
				ACTION_ID = #attributes.tplan_id#							
				AND ACTION_TABLE = 'TAHAKKUK_PLAN'
				<cfif isdefined("attributes.wrk_id") and len(attributes.wrk_id)>AND WRK_ID = '#attributes.wrk_id#'</cfif>
		</cfquery>
		<cfif GET_CARD_ID.recordcount>
			<cfquery name="DEL_MONEY_INFO" datasource="#dsn2#">
				DELETE FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = #GET_CARD_ID.CARD_ID#
			</cfquery>
		</cfif>
		<cfscript>
			cari_sil(action_id:attributes.tplan_id,action_table:'TAHAKKUK_PLAN',process_type:attributes.old_process_type);		
			muhasebe_sil(action_id:attributes.tplan_id,action_table:'TAHAKKUK_PLAN',process_type:attributes.old_process_type);			
		</cfscript>
		<cfquery name="DEL_BUDGET_PLAN_MONEY" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.TAHAKKUK_PLAN_MONEY WHERE ACTION_ID = #attributes.tplan_id#
		</cfquery>
		<cfquery name="DEL_BUDGET_PLAN_ROW" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.TAHAKKUK_PLAN_ROW WHERE TAHAKKUK_PLAN_ID = #attributes.tplan_id#
		</cfquery>
		<cfquery name="DEL_BUDGET_PLAN" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.TAHAKKUK_PLAN WHERE TAHAKKUK_PLAN_ID = #attributes.tplan_id#
		</cfquery>
		<cfquery name="DEL_BUDGET_PLAN" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.TAHAKKUK_PAYMENT_PLAN WHERE TAHAKKUK_ID = #attributes.tplan_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_tahakkuk";
</script>