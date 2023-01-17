<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_BUDGET" datasource="#dsn#">
			INSERT INTO
				BUDGET
			(
				BUDGET_NAME,
				OUR_COMPANY_ID,
				PERIOD_YEAR,
				BUDGET_STAGE,
				BRANCH_ID,
				DEPARTMENT_ID,
				WORKGROUP_ID,
				PROJECT_ID,
				DETAIL,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.budget_name#">,
				#attributes.search_company#,
				#attributes.search_year#,
				#attributes.process_stage#,
				<cfif len(attributes.branch_id) and len(attributes.branch_name)>#attributes.branch_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.department_id) and len(attributes.department)>#attributes.department_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.workgroup_id)>#attributes.workgroup_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.detail,300)#">,<cfelse>NULL,</cfif>
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
		<cfquery name="GET_MAX_BUDGET" datasource="#dsn#">
			SELECT MAX(BUDGET_ID) MAX_BUDGET_ID FROM BUDGET
		</cfquery>
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			<cfquery name="ADD_RELATED_BUDGET" datasource="#dsn#">
				INSERT INTO
					PRO_RELATED_BUDGET
					(
						BUDGET_ID,
						PROJECT_ID
					)
				VALUES
					(
						#get_max_budget.max_budget_id#,
						#attributes.project_id#
					)
			</cfquery>
		</cfif>		
	</cftransaction>
</cflock>
<cfset attributes.actionId = get_max_budget.max_budget_id>
<script type="text/javascript">
	<cfif isDefined("attributes.is_project_info")>
		wrk_opener_reload();
	<cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#GET_MAX_BUDGET.MAX_BUDGET_ID#</Cfoutput>';
	</cfif>
</script>
