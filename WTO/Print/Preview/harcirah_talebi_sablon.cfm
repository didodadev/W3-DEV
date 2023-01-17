<cfif isNumeric(attributes.action_id)>
    <cfset attributes.request_id = attributes.action_id>
  <cfelse>
    <cfset attributes.request_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_id,accountKey:'wrk')>
</cfif>
<cfset ExpenseRules = createObject("component","V16.hr.ehesap.cfc.expense_rules") />
<cfset allowanceExpense = createObject("component","V16.myhome.cfc.allowance_expense") />
<cfset get_expense_upd = allowanceExpense.get_expense_upd(request_id : attributes.request_id)/>
<cfset get_rows = allowanceExpense.get_rows(request_id : attributes.request_id)/>
<cfif len(get_expense_upd.process_cat)>
    <cfset get_process_cat = allowanceExpense.get_process_cat(process_cat_id : get_expense_upd.process_cat)/>
</cfif>
<cfif len(get_expense_upd.paymethod_id)>
    <cfset get_pay_method = allowanceExpense.get_pay_method(paymethod_id : get_expense_upd.paymethod_id)/>
    <cfset paymethod_name = get_pay_method.paymethod>
<cfelse>
    <cfset paymethod_name = ''>
</cfif>
<cfif len(get_expense_upd.expense_hr_allowance)>
    <cfset get_travel = allowanceExpense.get_travel(expense_travel_id : get_expense_upd.expense_hr_allowance)/>
    <cfset expense_travel = get_travel.paper_no>
    <cfif get_travel.travel_type eq 1>
        <cfset travel_type ="Görev Seyahatleri">
    <cfelseif get_travel.travel_type eq 2>
        <cfset travel_type ="Uzun Süreli Seyahatler">
    <cfelseif get_travel.travel_type eq 3>   
        <cfset travel_type ="Eğitim Seyahatleri">
    <cfelse>
        <cfset travel_type ="">
    </cfif>
    <cfset task_causes_ = get_travel.task_causes>
    <cfset start_date = get_travel.departure_date>
    <cfset finish_date = get_travel.departure_of_date>
<cfelse>
    <cfset expense_travel = "">
    <cfset travel_type = "">
    <cfset task_causes_ = "">
    <cfset start_date = "">
    <cfset finish_date = "">
</cfif>
<cfif len(get_rows.activity_type)>
    <cfset activity_type = get_rows.activity_type>
<cfelse>
    <cfset activity_type = ''>
</cfif>
<cfif not get_expense_upd.recordcount>
    <cfset hata  = 10>
    <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfoutput>
        <cf_woc_header>
        <cf_woc_elements style="width:180mm">
            <cfif len(get_expense_upd.sales_company_id)>
                <cfset sales_company = get_par_info(get_expense_upd.sales_company_id,1,0,0)>
            <cfelseif len(get_expense_upd.sales_consumer_id)>
                <cfset sales_company = get_cons_info(get_expense_upd.sales_consumer_id,1,0,0)>
            <cfelse>
                <cfset sales_company = ''>
            </cfif>
            <tr>
                <cf_wuxi id="process_cat" data="#get_process_cat.process_cat#" label="61806" type="cell" is_row="0" style_th="text-align:left">
                <cf_wuxi id="employee_id" data="#get_emp_info(get_expense_upd.emp_id,0,0)#" label="57576" type="cell"  style_th="text-align:left" is_row="0">
                <cf_wuxi id="expense_travel" data="#expense_travel#" label="35196" type="cell"  style_th="text-align:left" is_row="0">
                <cf_wuxi id="travel_start_date" data="#dateformat(start_date,dateformat_style)#" label="57655" type="cell" is_row="0" style_th="text-align:left">
            </tr>
            <tr>
                <cf_wuxi id="paper_no" data="#get_expense_upd.paper_no#" label="57880" type="cell" is_row="0" style_th="text-align:left">
                <cf_wuxi id="sales_company" data="#sales_company#" label="58873" type="cell" is_row="0" style_th="text-align:left">
                <cf_wuxi id="travel_type" data="#travel_type#" label="63802" type="cell" is_row="0" style_th="text-align:left">
                <cf_wuxi id="travel_finish_date" data="#dateformat(finish_date,dateformat_style)#" label="57700" type="cell" is_row="0" style_th="text-align:left">

            </tr>
            <tr>
                <cf_wuxi id="expense_date" data="#dateformat(get_expense_upd.expense_date,dateformat_style)#" label="57073" type="cell" is_row="0" style_th="text-align:left">
                <cf_wuxi id="paymethod" data="#paymethod_name#" label="58516" type="cell" is_row="0"  style_th="text-align:left">
                <cf_wuxi id="travel_causes" data="#task_causes_#" label="63803" type="cell" is_row="0" style_th="text-align:left">
            </tr>
        </cf_woc_elements>
        <cf_woc_elements>
            <cf_woc_list id="aaa">
                <thead>
                <tr> <cf_wuxi label="47461" type="cell" is_row="1" id="wuxi_47461"> </tr>
                    <tr>
                        <cf_wuxi label="41539" type="cell" is_row="0" id="wuxi_41539"> 
                        <cf_wuxi label="58460" type="cell" is_row="0" id="wuxi_58460"> 
                        <cf_wuxi label="58551" type="cell" is_row="0" id="wuxi_58551"> 
                        <cf_wuxi label="51319" type="cell" is_row="0" id="wuxi_51319"> 
                        <cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
                        <cf_wuxi label="57673" type="cell" is_row="0" id="wuxi_57673"> 
                        <cf_wuxi label="57639" type="cell" is_row="0" id="wuxi_57639"> 
                    </tr>
                </thead>
                <cfset expense_center_list = "">
                <cfset expense_item_list = "">
                <cftry>
                <cfloop query="get_rows">
                    <cfif len(get_rows.expense_center_id) and not listfind(expense_center_list,get_rows.expense_center_id)>
                        <cfset expense_center_list=listappend(expense_center_list,get_rows.expense_center_id)>
                    </cfif>
                    <cfif len(get_rows.expense_item_id) and not listfind(expense_item_list,get_rows.expense_item_id)>
                        <cfset expense_item_list=listappend(expense_item_list,get_rows.expense_item_id)>
                    </cfif>
                    <cfif ListLen(expense_center_list)>
                        <cfset get_expense_center_list = allowanceExpense.get_expense_center_list(expense_center_list : expense_center_list)/>
                        <cfset expense_center_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_center_list.expense_id)),'numeric','ASC',',')>
                    </cfif>
                    <cfif ListLen(expense_item_list)>
                        <cfset get_expense_item_list = allowanceExpense.get_expense_item_list(expense_item_list : expense_item_list)/>
                        <cfset expense_item_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_item_list.expense_item_id)),'numeric','ASC',',')>
                    </cfif>
                    
                    <tbody>
                        <tr>
                            <cf_wuxi data="#get_rows.EXPENSE_HR_RULES_DETAIL#" type="cell" is_row="0"> 
                            <cf_wuxi data="#get_expense_center_list.expense[listfind(expense_center_list,get_rows.expense_center_id,',')]#" type="cell" is_row="0"> 
                            <cf_wuxi data="#get_expense_item_list.expense_item_name[listfind(expense_item_list,get_rows.expense_item_id,',')]#" type="cell" is_row="0"> 
                            <cf_wuxi data="#activity_type#" type="cell" is_row="0" style_th="text-align:left"> 
                            <cf_wuxi data="#tlformat(get_rows.quantity)#" type="cell" is_row="0"> 
                            <cf_wuxi data="#tlformat(get_rows.amount)#" type="cell" is_row="0"> 
                            <cf_wuxi data="#get_rows.kdv_rate#" type="cell"  is_row="0">              
                        </tr>
                    </tbody>
                </cfloop>
            <cfcatch>
                <cfdump var="#cfcatch#" abort>
            </cfcatch>
        </cftry>
            </cf_woc_list>
        </cf_woc_elements>
        <cf_woc_elements>
            <cf_woc_list id="bbb">
                <thead>
                    <tr><cf_wuxi label="57771" type="cell" is_row="1" id="wuxi_57771"></tr>
                    <tr>
                        <cf_wuxi label="57492" type="cell" is_row="0" id="wuxi_57492"> 
                        <cf_wuxi label="51317" type="cell" is_row="0" id="wuxi_51317"> 
                        <cf_wuxi label="56975" type="cell" is_row="0" id="wuxi_56975"> 
                        <cf_wuxi label="58124" type="cell" is_row="0" id="wuxi_58124"> 
                        <cf_wuxi label="51331" type="cell" is_row="0" id="wuxi_51331"> 
                        <cf_wuxi label="56993" type="cell" is_row="0" id="wuxi_56993"> 
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <cf_wuxi data="#tlformat(get_expense_upd.total_amount)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#tlformat(get_expense_upd.net_total_amount)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#tlformat(get_expense_upd.net_kdv_amount)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#tlformat(get_expense_upd.other_money_amount)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#tlformat(get_expense_upd.other_money_kdv)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#tlformat(get_expense_upd.other_money_net_total)#" type="cell" is_row="0">          
                    </tr>
                </tbody>
            </cf_woc_list>
        </cf_woc_elements>
        <cf_woc_footer>
    </cfoutput>
</cfif>