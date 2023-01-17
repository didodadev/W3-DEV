<cflock name="#CreateUUID()#" timeout="40">
	<cftransaction>
		<cfscript>
			cari_sil(action_id:attributes.budget_plan_id,action_table:'BUDGET_PLAN',process_type:attributes.old_process_type);		
			muhasebe_sil(action_id:attributes.budget_plan_id,action_table:'BUDGET_PLAN',process_type:attributes.old_process_type);
			butce_sil (action_id:attributes.budget_plan_id,muhasebe_db:dsn2,process_type:attributes.old_process_type);
		</cfscript>
		<cfquery name="DEL_BUDGET_PLAN_MONEY" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.BUDGET_PLAN_MONEY WHERE ACTION_ID = #attributes.budget_plan_id#
		</cfquery>
		<cfquery name="DEL_BUDGET_PLAN_ROW" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID = #attributes.budget_plan_id#
		</cfquery>
		<cfquery name="DEL_BUDGET_PLAN" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN_ID = #attributes.budget_plan_id#
		</cfquery>
	</cftransaction>
</cflock>
<cfif not (isDefined('from_invoice') and from_invoice eq 1)>
	<cfif len(attributes.budget_id)>
		<script type="text/javascript">
			window.location.href = "<cfoutput>#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#attributes.budget_id#</cfoutput>";
		</script>
	<cfelse><!--- planlama fişi listesinden eklenenler için --->
		<script type="text/javascript">
			window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_plan_rows";
		</script>
		<cflocation url="" addtoken="no">
	</cfif>
</cfif>
