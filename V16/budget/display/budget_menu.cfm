<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='147.Bütçe'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='112.Bütçeler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang no='17.Planlama/Tahakkuk Fişleri'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='677.Gelirler'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang no='91.Masraflar'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang no="95.Tahakkuk İşlemleri"></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang_main no='117.tanimlar'></cfsavecontent>

<cfif get_module_user(49)>
	<cfset add_adm_ = "cost.list_expense_management*0*0*#m_dil_5#">
<cfelse>
	<cfset add_adm_ = "">
</cfif>

<cfset f_n_action_list = "budget.list_budgets*0*0*#m_dil_1#,budget.list_budgets*0*0*#m_dil_2#,budget.list_plan_rows*0*0*#m_dil_3#,budget.budget_income_summery*0*0*#m_dil_4#,#add_adm_#,budget.list_accrual_operations*0*0*#m_dil_7#,budget.definitions*0*0*#m_dil_6#">
<cfset menu_module_layer = "budget">
<cfinclude template="../../design/module_menu.cfm">



