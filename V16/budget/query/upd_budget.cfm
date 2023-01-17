<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_bud" datasource="#dsn#">
			UPDATE
				BUDGET
			SET
				BUDGET_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.budget_name#">,
				PERIOD_YEAR= #attributes.search_year#,
				OUR_COMPANY_ID = #attributes.search_company#,
				BUDGET_STAGE = #attributes.process_stage#,
				BRANCH_ID = <cfif len(attributes.branch_id) and len(attributes.branch_name)>#attributes.branch_id#<cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif len(attributes.department_id) and len(attributes.department)>#attributes.department_id#<cfelse>NULL</cfif>,
				WORKGROUP_ID = <cfif len(attributes.workgroup_id)>#attributes.workgroup_id#<cfelse>NULL</cfif>,
				PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.detail,300)#">,<cfelse>NULL,</cfif>
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE
				BUDGET_ID = #attributes.budget_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=budget.list_budgets&event=upd&budget_id=#attributes.budget_id#</Cfoutput>';
</script>
