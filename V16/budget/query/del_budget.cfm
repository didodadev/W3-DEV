<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined("attributes.relation_id") and len(attributes.relation_id)>
			<cfquery name="get_related_budget" datasource="#dsn#">
				DELETE FROM PRO_RELATED_BUDGET WHERE RELATED_ID = #attributes.relation_id#
			</cfquery>
		<cfelse>
			<cfquery name="DEL_BUDGET" datasource="#dsn#">
				DELETE FROM BUDGET WHERE BUDGET_ID = #attributes.budget_id#
			</cfquery>
			<cfquery name="DEL_RELATED_BUDGET" datasource="#dsn#">
				DELETE FROM PRO_RELATED_BUDGET WHERE BUDGET_ID = #attributes.budget_id#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<!--- budget expnse ve row dakileri silmeye gerek yok cunku zaten fiş kaydı yoksa silm seçenegi gelir... --->
<script type="text/javascript">
	<cfif isDefined("attributes.relation_id")>
		wrk_opener_reload();
	<cfelse>
		window.opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_budgets';
	</cfif>
	window.close();
</script>
