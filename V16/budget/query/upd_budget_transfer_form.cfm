<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cftransaction>
    <cf_date tarih = "attributes.demand_date"> 
    <!--- Belge --->
    <cfset upd_demand = demand.upd_budgetDemand(
                                                demand_id : attributes.demand_id,
                                                demand_no : "#attributes.demand_no#",
                                                budget_id : "#attributes.budget_id#",
                                                detail : attributes.detail,
                                                demand_stage : attributes.process_stage,
                                                demand_date : "#attributes.demand_date#",
                                                employee_id : "#attributes.employee_id#",
                                                reference_no : "#attributes.reference_no#",
                                                responsible_emp_id : "#attributes.responsible_emp_id#"

                                            )> 
    <cfset get_demand_ = demand.get_demand_(
                                                        demand_id : attributes.demand_id
                                                     )>

    <cfif len(get_demand_.demand_id)>
        <cfset del_demand_row = demand.del_demand_row(
                                                                    demand_id : valueList(get_demand_.demand_id)
                                                                 )>
    </cfif>
                                            
    <cfloop from = "1" to = "#attributes.rowcount#" index = "r">
        <cfif evaluate("attributes.row_kontrol_#r#") eq 1>
            <!--- card Satırları --->
            <cfset add_demand_row = demand.add_demand_row(
                                                            demand_id : attributes.demand_id,
                                                            expense_center : '#evaluate("acc_control_#r#_1")#',
                                                            expense_item : '#evaluate("bud_cat_control_#r#_1")#',
                                                            project_id : '#evaluate("proje_control_#r#_1")#',
                                                            activity_type : '#evaluate("exp_act_type_#r#_1")#',
                                                            transfer_activity_type : '#evaluate("exp_act_type_#r#_2")#',
                                                            transfer_expense_center : '#evaluate("acc_control_#r#_2")#',
                                                            transfer_expense_item : '#evaluate("bud_cat_control_#r#_2")#',
                                                            transfer_project_id : '#evaluate("proje_control_#r#_2")#',
                                                            rate : '#filterNum(evaluate("rate_#r#_1"))#',
                                                            serbest_budget : '#filterNum(evaluate("serbest_#r#_1"))#',
                                                            transfer_serbest_budget : '#filterNum(evaluate("serbest_#r#_2"))#',
                                                            money_type : '#evaluate("money_type_#r#_1")#',
                                                            transfer_status :"#(isdefined("attributes.transfer_status") ? attributes.transfer_status : '')#",
                                                            internaldemand_id :"#(isdefined("attributes.internaldemand_id") ? attributes.internaldemand_id : '')#",
                                                            offer_id :"#(isdefined("attributes.offer_id") ? attributes.offer_id : '')#",
                                                            order_id :"#(isdefined("attributes.order_id") ? attributes.order_id : '')#",
                                                            expense_ :"#(isdefined("attributes.expense_") ? attributes.expense_ : '')#",
                                                            block_type : '#filterNum(evaluate("budget_plan_type_#r#_2"))#'
                                                        )>
        </cfif>
    </cfloop>    
    <cf_workcube_process 
		is_upd='1' 
		data_source='#dsn2#' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='BUDGET_TRANSFER_DEMAND'
		action_column='DEMAND_ID'
		action_id='#attributes.demand_id#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.budget_transfer_demand&event=upd&demand_id=#attributes.demand_id#' 
		warning_description='Bütçe Aktarım Talebi : #attributes.demand_no#'>
</cftransaction>