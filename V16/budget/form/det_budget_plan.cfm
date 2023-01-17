
<cfparam name="#attributes.budget_plan_id#" default="">
<cfscript>
	budget_plan=createObject("component","V16.budget.cfc.budget_plan") ;
	get_budget_plan=budget_plan.get_budget_plan(budget_plan_id:attributes.budget_plan_id);
	get_branches=budget_plan.get_branches();
	get_budget_plan_row=budget_plan.get_budget_plan_row(budget_plan_id:attributes.budget_plan_id);
	get_budget_plan_money=budget_plan.get_budget_plan_money(budget_plan_id:attributes.budget_plan_id);
	get_expense_center=budget_plan.get_expense_center();
	get_activity_types=budget_plan.get_activity_types();
	get_workgroups=budget_plan.get_workgroups();
</cfscript>
<cf_catalystHeader>
<cf_get_workcube_asset asset_cat_id="-17"  module_id='46' action_section='BUDGET_PLAN_ID' action_id='#attributes.budget_plan_id#'>