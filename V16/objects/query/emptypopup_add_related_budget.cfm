<cfquery name="get_related_budget" datasource="#dsn#">
	SELECT RELATED_ID FROM PRO_RELATED_BUDGET WHERE BUDGET_ID = #attributes.budget_id# AND PROJECT_ID = #attributes.related_project_id#
</cfquery>
<cfif not(get_related_budget.recordcount)>
	<cfquery name="add_related_budget" datasource="#dsn#">
		INSERT INTO
			PRO_RELATED_BUDGET
			(
				BUDGET_ID,
				PROJECT_ID,
				IS_DELETE
			)
		VALUES
			(
				#attributes.budget_id#,
				#attributes.related_project_id#,
				1
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

