<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cftransaction>
    <cf_date tarih = "attributes.demand_date"> 
    <!--- Belge --->
    <cfset add_demand = demand.add_budgetDemand(
                                                demand_no : "#attributes.demand_no#",
                                                budget_id : "#attributes.budget_id#",
                                                detail : attributes.detail,
                                                demand_stage : attributes.process_stage,
                                                demand_date : "#attributes.demand_date#",
                                                employee_id : "#attributes.employee_id#",
                                                reference_no : "#attributes.reference_no#",
                                                responsible_emp_id : "#attributes.responsible_emp_id#"
                                            )>    
    <cfloop from = "1" to = "#attributes.rowcount#" index = "r">
        <cfif evaluate("attributes.row_kontrol_#r#") eq 1>
            <!--- card Satırları --->
            <cfset add_demand_row = demand.add_demand_row(
                                                            demand_id : add_demand,
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
    <cfset paper_number = listLast(attributes.demand_no,"-")>
    <cfif len(paper_number)>
        <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
            UPDATE 
                #dsn3_alias#.GENERAL_PAPERS
            SET
                BUDGET_TRANSFER_DEMAND_NUMBER = #paper_number#
            WHERE
                BUDGET_TRANSFER_DEMAND_NUMBER IS NOT NULL
        </cfquery>
    </cfif>
     <cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
    	<cfset add_demand_ = contentEncryptingandDecodingAES(isEncode:1,content:add_demand,accountKey:'wrk')>
  	<cfelse>
      	<cfset add_demand_ = add_demand>
 	</cfif>
    <cf_workcube_process 
		is_upd='1' 
		data_source='#dsn2#' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='BUDGET_TRANSFER_DEMAND'
		action_column='DEMAND_ID'
		action_id='#add_demand#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.budget_transfer_demand&event=upd&demand_id=#add_demand#' 
		warning_description='Bütçe Aktarım Talebi : #attributes.demand_no#'>
</cftransaction>
<script type="text/javascript">
    window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.budget_transfer_demand&event=upd&demand_id=#add_demand_#</cfoutput>";
</script>