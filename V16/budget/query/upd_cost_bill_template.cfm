<cflock timeout="30">
	<cftransaction> 
	<cfquery name="ADD_PLAN_TEMPLATE" datasource="#dsn2#">
		UPDATE
			EXPENSE_PLANS_TEMPLATES
		SET
			IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
			TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.template_name#">,
			IS_DEPARTMENT=<cfif isdefined("attributes.is_department")>1<cfelse>0</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
		WHERE
			TEMPLATE_ID = #attributes.template_id#
	</cfquery>
	<cfquery name="DEL_ROWS" datasource="#dsn2#">
		DELETE FROM EXPENSE_PLANS_TEMPLATES_ROWS WHERE TEMPLATE_ID = #attributes.template_id#
	</cfquery>
	<cfif len(attributes.record_num) and attributes.record_num neq "">
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfscript>
					form_rate = evaluate("attributes.rate#i#");
					form_expense_center_id = evaluate("attributes.expense_center_id#i#");
					form_expense_item_id = evaluate("attributes.expense_item_id#i#");
					form_activity_type = evaluate("attributes.activity_type#i#");
					form_member_id = evaluate("attributes.member_id#i#");
					form_member_code = evaluate("attributes.member_code#i#");
					form_company_id = evaluate("attributes.company_id#i#");
					form_member_type = evaluate("attributes.member_type#i#");
					form_company = evaluate("attributes.company#i#");
					form_authorized = evaluate("attributes.authorized#i#");
					form_asset=evaluate("attributes.asset#i#");
					form_asset_id=evaluate("attributes.asset_id#i#");
					form_project=evaluate("attributes.project#i#");
					form_project_id=evaluate("attributes.project_id#i#");
					form_dep_id=evaluate("attributes.department_id#i#");
					form_dep=evaluate("attributes.department#i#");
					form_sub_id = evaluate("attributes.subscription_id#i#");
					form_sub_name = evaluate("attributes.subscription_name#i#");
				</cfscript>
				<cfquery name="ADD_ROW" datasource="#dsn2#">
					INSERT
					INTO
						EXPENSE_PLANS_TEMPLATES_ROWS
						(
							TEMPLATE_ID,
							RATE,
							EXPENSE_ITEM_ID,
							EXPENSE_CENTER_ID,
							PROMOTION_ID,
							COMPANY_ID,
							COMPANY_PARTNER_ID,
							MEMBER_TYPE,
							ASSET_ID,
							PROJECT_ID,
							DEPARTMENT_ID,
							WORKGROUP_ID,
							SUBSCRIPTION_ID
						)
						VALUES
						(
							#attributes.template_id#,
							#form_rate#,
							#form_expense_item_id#,
							#form_expense_center_id#,
							<cfif len(form_activity_type)>#form_activity_type#,<cfelse>NULL,</cfif>
							<cfif len(form_company) and len(form_company_id)>#form_company_id#,<cfelse>NULL,</cfif>
							<cfif len(form_member_type) and form_member_type eq 'employee' and len(form_authorized)>
								<cfif len(form_member_code)>#form_member_code#,<cfelse>NULL,</cfif>
							<cfelse>
								<cfif len(form_member_id)>#form_member_id#,<cfelse>NULL,</cfif>
							</cfif>
							<cfif (len(form_authorized) or len(form_company))  and len(form_member_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_member_type#">,<cfelse>NULL,</cfif>
							<cfif len(form_asset) and len(form_asset_id)>#form_asset_id#,<cfelse>NULL,</cfif>
							<cfif len(form_project) and len(form_project_id)>#form_project_id#,<cfelse>NULL,</cfif>
							<cfif len(form_dep) and len(form_dep_id)>#form_dep_id#,<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.workgroup_id#i#") and len(evaluate("attributes.workgroup_id#i#"))>#evaluate("attributes.workgroup_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(form_sub_id) and len(form_sub_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_sub_id#"><cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	</cftransaction>
</cflock>
<cfset attributes.actionId=attributes.template_id/>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=budget.list_cost_bill_templates&event=upd&template_id=#attributes.template_id#</cfoutput>";
</script>

