<!---
    File: upd_allowance_expense.cfm
    Controller: fuseaction is myhome = AllowenceExpenseController.cfm, fuseaction is hr = hrAllowenceExpenseController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Harcırah güncelleme sayfasıdır.
--->
<cfset ExpenseRules = createObject("component","V16.hr.ehesap.cfc.expense_rules") />
<cfset allowanceExpense = createObject("component","V16.myhome.cfc.allowance_expense") />

<cfset GET_EXPENSE_RULES_LIST=ExpenseRules.GET_EXPENSE_RULES_LIST(is_active : 1) /><!--- harcırah kuralları --->

<cf_get_lang_set module_name="objects"><!--- sayfanin en altinda kapanisi var --->
    <cf_xml_page_edit fuseact="hr.expense_allowance">
    <!--- gündem den çağrılan sayfalarda id encrypt li gönderildiği için eklendi GSÖ 20131021 --->
    <cfif fusebox.circuit eq 'myhome'>
        <cfset attributes.request_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.request_id,accountKey:'wrk')>
    </cfif>
    <cfset fuseaction_first = listFirst(fuseaction,".")>
    <input type="hidden" name="control_field_value" id="control_field_value" value="">
    <cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
        SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
        SELECT 
            EXPENSE_ID,
            EXPENSE_CODE,
            EXPENSE 
        FROM 
            EXPENSE_CENTER
        <cfif x_authorized_branch_department eq 1>
        WHERE
            (EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR (EXPENSE_BRANCH_ID = -1))
            AND (EXPENSE_DEPARTMENT_ID IN 
                (	
                    SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                    UNION ALL 
                    SELECT CASE WHEN D.HIERARCHY_DEP_ID LIKE '%.%' THEN SUBSTRING(D.HIERARCHY_DEP_ID,1,(CHARINDEX('.',D.HIERARCHY_DEP_ID)-1)) ELSE D.HIERARCHY_DEP_ID END AS DEPARTMENT_ID 
                    FROM #dsn_alias#.DEPARTMENT D,#dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID
                    AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                ) 
                OR ( EXPENSE_DEPARTMENT_ID = -1)
            )
        </cfif>	
        ORDER BY EXPENSE
    </cfquery>
    <cfif xml_expense_center_budget_item eq 1>
        <cfquery name="expense_row" datasource="#dsn2#">
            SELECT 
                EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_CODE,
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_CENTER.IS_ACCOUNTING_BUDGET
            FROM 
                EXPENSE_CENTER,
                EXPENSE_CENTER_ROW
                LEFT JOIN EXPENSE_ITEMS ON EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
            WHERE 
                EXPENSE_CENTER.EXPENSE_ID = EXPENSE_CENTER_ROW.EXPENSE_ID AND 
                EXPENSE_CENTER_ROW.EXPENSE_ID = #GET_EXPENSE_CENTER.EXPENSE_ID#
            GROUP BY
                EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_CODE,
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_CENTER.IS_ACCOUNTING_BUDGET					
        </cfquery>
        <cfif EXPENSE_ROW.recordcount and len(EXPENSE_ROW.IS_ACCOUNTING_BUDGET)>
            <cfset is_accounting_budget = EXPENSE_ROW.IS_ACCOUNTING_BUDGET>
            <cfset expense_item_id_list = valuelist(EXPENSE_ROW.EXPENSE_ITEM_ID,',')>
            <cfset account_code_list = valuelist(EXPENSE_ROW.ACCOUNT_CODE,',')>
        </cfif>
        <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
            SELECT
                EI.EXPENSE_ITEM_ID,
                EI.EXPENSE_ITEM_NAME,
                EI.EXPENSE_ITEM_DETAIL,
                EI.ACCOUNT_CODE			
            FROM
                EXPENSE_ITEMS EI
                LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
            WHERE
                IS_EXPENSE = 1 AND 
                IS_ACTIVE=1
                <cfif isdefined("is_accounting_budget") and len(is_accounting_budget)>
                    <cfif is_accounting_budget eq 0>
                        <cfif len(expense_item_id_list)>
                            AND EXPENSE_ITEM_ID IN (#expense_item_id_list#)
                        </cfif>
                    <cfelseif is_accounting_budget eq 1>
                        <cfif len(account_code_list)>
                            AND (
                                <cfloop list="#account_code_list#" delimiters="," index="_account_code_">					
                                    (
                                        EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#"> OR EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#.%">
                                    )
                                    <cfif _account_code_ neq listlast(account_code_list,',') and listlen(account_code_list,',') gte 1> OR </cfif>
                                </cfloop>
                                )
                        </cfif>
                    </cfif>
                <cfelse>
                    AND 1 = 2
                </cfif>		
            ORDER BY
                EXPENSE_ITEM_NAME
        </cfquery>
    <cfelse>
    <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
    </cfquery>
    </cfif>
    <cfquery name="GET_MONEY" datasource="#dsn2#">
        SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = #attributes.request_id#
    </cfquery>
    <cfif not GET_MONEY.recordcount>
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
        </cfquery>
    </cfif>
    <cfquery name="GET_EXPENSE" datasource="#dsn2#">
        SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.request_id#
    </cfquery>
    <cfif GET_EXPENSE.RECORDCOUNT eq 0 or (isdefined('attributes.active_company') and attributes.active_company neq session.ep.company_id)>
        <script type="text/javascript">
            alert("<cf_get_lang_main no ='1531.Böyle Bir Kayıt Bulunmamaktadır'>");
            history.go(-1);
        </script>
        <cfabort>
    </cfif>
    <cfquery name="GET_TAX"  datasource="#dsn2#">
        SELECT * FROM SETUP_TAX ORDER BY TAX
    </cfquery>
    <cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
        SELECT
            SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
            SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
        FROM
            SETUP_DOCUMENT_TYPE,
            SETUP_DOCUMENT_TYPE_ROW
        WHERE
            SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
            SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%'
        ORDER BY
            DOCUMENT_TYPE_NAME
    </cfquery>
    <cfquery name="GET_ROWS" datasource="#dsn2#">
        SELECT 
            IPR.*,
            EHR.EXPENSE_HR_RULES_DETAIL
        FROM 
            EXPENSE_ITEM_PLAN_REQUESTS_ROWS IPR
        LEFT JOIN  #dsn#.EXPENSE_HR_RULES EHR ON IPR.ALLOWANCE_TYPE_ID = EHR.EXPENSE_HR_RULES_ID
            WHERE EXPENSE_ID = #attributes.request_id#
    </cfquery>
    <cfquery name="GET_KONTROL" datasource="#dsn2#">
        SELECT REQUEST_ID,PAPER_NO,EXPENSE_ID FROM EXPENSE_ITEM_PLANS WHERE REQUEST_ID = #attributes.request_id#
    </cfquery>
    <cfscript>
        Position_Assistant= createObject("component","V16.hr.ehesap.cfc.position_assistant");
        get_modules_no = Position_Assistant.GET_MODULES_NO(fuseaction:attributes.fuseaction)
    </cfscript>
<cfset get_emp_pos = allowanceExpense.get_position_detail(employee_id :get_expense.emp_id)/>
<cfset get_emp_det = allowanceExpense.get_employee_detail(employee_id : get_expense.emp_id)/>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cfform name="add_costplan" method="post" action="">
        <cfset  employee_id_ = "#get_expense.emp_id#">
        <cfif fuseaction_first is 'myhome'>
            <input type="hidden" name="cost_type" id="cost_type" value="1">
        <cfelse>
            <input type="hidden" name="cost_type" id="cost_type" value="2">
        </cfif>
        <cf_basket_form id="upd_expense">
            <input type="hidden" name="xml_select_project" id="xml_select_project" value="<cfif x_select_project eq 1>1<cfelse>0</cfif>">
            <input type="hidden" name="xml_select_work" id="xml_select_work" value="<cfif x_select_work eq 1>1<cfelse>0</cfif>">
            <input type="hidden" name="request_id" id="request_id" value="<cfoutput>#attributes.request_id#</cfoutput>">
            <cfif fuseaction is "myhome.list_my_expense_requests">
                <input type="hidden" name="cost_type" id="cost_type" value="1">
            <cfelseif fuseaction is "cost.list_expense_requests">
                <input type="hidden" name="cost_type" id="cost_type" value="2">
            </cfif>
            <cf_box>
                <cf_box_elements>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-expense_stage">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1447)#</cfoutput> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value='#get_expense.expense_stage#' process_cat_width='120' is_detail='1'>
                            </div>
                        </div>
                        <cfif (fuseaction_first is "hr") and (xml_show_process_stage eq 1)>
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='388.işlem tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat  process_cat='#get_expense.PROCESS_CAT#' slct_width="135">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-expense_paper_type">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1166)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <select name="expense_paper_type" id="expense_paper_type">
                                    <option value=""><cf_get_lang_main no='1166.Belge Türü'></option>
                                    <cfoutput query="get_document_type">
                                        <option value="#document_type_id#" <cfif get_expense.paper_type eq document_type_id>selected</cfif>>#document_type_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <cfif x_is_show_ref_no eq 1>
                            <div class="form-group" id="item-system_relation">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1382)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <input name="system_relation" id="system_relation" type="text" value="<cfoutput>#get_expense.system_relation#</cfoutput>">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-project">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',4)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>		
                                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_expense.project_id')>#get_expense.project_id#</cfif>">		
                                        <input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_expense.project_id') and len(get_expense.project_id)>#GET_PROJECT_NAME(get_expense.project_id)#</cfif>"  style="width:120px;" 		
                                        onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_costplan','3','135')" autocomplete="off">		
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_costplan.project_id&project_head=add_costplan.project_head');"></span>		
                                    </cfoutput>		
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-expense_date">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('objects',813)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="expense_date" id="expense_date" value="#dateformat(get_expense.expense_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#alert#" readonly maxlength="10" style="width:120px;" onblur="change_money_info('add_costplan','expense_date');">
                                    <span class="input-group-addon btnPointer">
                                        <cf_wrk_date_image date_field="expense_date" call_function="change_money_info">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_number">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',468)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <input name="paper_number" id="paper_number" type="text" value="<cfoutput>#get_expense.paper_no#</cfoutput>">
                            </div>
                        </div>
                        <cfif x_is_show_paymethod eq 1>
                            <cfif len(get_expense.paymethod_id)>
                                <cfquery name="get_pay_method" datasource="#dsn#">
                                    SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.paymethod_id#">
                                </cfquery>
                            </cfif>
                            <div class="form-group" id="item-paymethod_name">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1104)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfoutput>
                                            <input type="hidden" name="paymethod" id="paymethod" value="<cfif len(get_expense.paymethod_id)>#get_expense.paymethod_id#</cfif>">
                                            <input type="text" name="paymethod_name" id="paymethod_name" style="width:120px;" value="<cfif len(get_expense.paymethod_id)>#get_pay_method.paymethod#</cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=add_costplan.paymethod&field_dueday=add_costplan.basket_due_value&field_name=add_costplan.paymethod_name&is_paymethods=1&function_name=change_due_date','list');" title="<cfoutput>#getLang('main',322)#</cfoutput>"></span>
                                        </cfoutput>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif x_is_show_paymethod eq 1>
                            <cfoutput>
                                <div class="form-group" id="item-basket_due_value_date">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',228)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang no ='1366.Vade Tarihi İçin Geçerli Bir Format Giriniz'>!</cfsavecontent>
                                            <input type="text" name="basket_due_value" id="basket_due_value" value="<cfif len(get_expense.due_date) and len(get_expense.expense_date)>#datediff('d',get_expense.expense_date,get_expense.due_date)#</cfif>"  onChange="change_due_date();" style="width:37px;">
                                            <span class="input-group-addon no-bg"></span>
                                            <cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(get_expense.due_date,dateformat_style)#" onChange="change_due_date(1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:80px;" readonly>
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
                                        </div>
                                    </div>
                                </div>
                            </cfoutput>
                        </cfif>
                        <cfif x_is_show_cari eq 1>
                            <div class="form-group" id="item-sales_member">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1461)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_expense.sales_company_id)>
                                            <input type="hidden" name="sales_member_type" id="sales_member_type" value="partner">
                                            <input type="hidden" name="sales_company_id" id="sales_company_id" value="<cfoutput>#get_expense.sales_company_id#</cfoutput>">
                                            <input type="hidden" name="sales_partner_id" id="sales_partner_id" value="<cfoutput>#get_expense.sales_partner_id#</cfoutput>">
                                            <input type="text" name="sales_company" id="sales_company" onFocus="AutoComplete_Create('sales_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','MEMBER_TYPE,COMPANY_ID,PARTNER_ID2,MEMBER_PARTNER_NAME2','sales_member_type,sales_company_id,sales_partner_id,sales_partner','','3','250');" style="width:120px;" value="<cfoutput>#get_par_info(get_expense.sales_company_id,1,0,0)#</cfoutput>">
                                        <cfelseif len(get_expense.sales_consumer_id)>
                                            <cfquery name="GET_CONSUMER" datasource="#dsn#">
                                                SELECT CONSUMER_NAME, CONSUMER_SURNAME, COMPANY FROM CONSUMER WHERE CONSUMER_ID = #get_expense.sales_consumer_id#
                                            </cfquery>
                                            <input type="hidden" name="sales_member_type" id="sales_member_type" value="consumer">
                                            <input type="hidden" name="sales_company_id" id="sales_company_id" value="">
                                            <input type="hidden" name="sales_partner_id" id="sales_partner_id" value="<cfoutput>#get_expense.sales_consumer_id#</cfoutput>">
                                            <input type="text" name="sales_company" id="sales_company" onFocus="AutoComplete_Create('sales_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','MEMBER_TYPE,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_PARTNER_NAME','sales_member_type,sales_partner_id,sales_partner_id,sales_company_id,sales_partner','','3','250');" style="width:120px;" value="<cfoutput>#get_consumer.company#</cfoutput>">
                                        <cfelse>
                                            <input type="hidden" name="sales_member_type" id="sales_member_type" value="">
                                            <input type="hidden" name="sales_company_id" id="sales_company_id" value="">
                                            <input type="hidden" name="sales_partner_id" id="sales_partner_id">
                                            <input type="text" name="sales_company" id="sales_company" style="width:120px;">
                                        </cfif>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=add_costplan.sales_partner_id&field_comp_name=add_costplan.sales_company&field_name=add_costplan.sales_partner&field_comp_id=add_costplan.sales_company_id&field_type=add_costplan.sales_member_type&select_list=2,3,5,6','list');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif x_is_show_cari eq 1>
                            <div class="form-group" id="item-sales_partner">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',166)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif len(get_expense.sales_partner_id)>
                                        <input type="text" name="sales_partner" id="sales_partner" style="width:175px;" value="<cfoutput>#get_par_info(get_expense.sales_partner_id,0,-1,0)#</cfoutput>">
                                    <cfelseif len(get_expense.sales_consumer_id)>
                                        <input type="text" name="sales_partner" id="sales_partner" style="width:175px;" value="<cfoutput>#get_cons_info(get_expense.sales_consumer_id,0,0)#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="sales_partner" id="sales_partner" style="width:175px;" value="">
                                    </cfif>
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-action">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = "35196.İlişkili Seyahat"></label>
                            <div class="col col-8 col-xs-12" id="aksiyon_div">
                                <cfif len(employee_id_)>
                                    <cfquery name="get_travel" datasource="#dsn#">
                                        SELECT * FROM EMPLOYEES_TRAVEL_DEMAND WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id_#"> AND MANAGER1_VALID = 1  ORDER BY PAPER_NO
                                    </cfquery>
                                </cfif>
                                <select name="EXPENSE_HR_ALLOWANCE" id="EXPENSE_HR_ALLOWANCE">
                                    <option value=""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
                                    <cfif len(employee_id_)>
                                        <cfoutput query="get_travel">
                                            <option value="#travel_demand_id#" <cfif get_expense.expense_hr_allowance eq travel_demand_id>selected</cfif>>#paper_no#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <cfif len(get_expense.expense_hr_allowance)>
                            <cfquery name="get_travel_" datasource="#dsn#">
                                SELECT * FROM EMPLOYEES_TRAVEL_DEMAND WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id_#">  AND TRAVEL_DEMAND_ID =#get_expense.expense_hr_allowance#  ORDER BY PAPER_NO
                            </cfquery>
                        </cfif>
                        <div class="form-group" id="item-travel_start_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label>
                            <div class="col col-8 col-xs-12" id="travel_startdate">
                                <div class="input-group">
                                <cfoutput>   
                                <cfif isdefined('get_travel_')>
                                    <input type="text" name="travel_start_date" id="travel_start_date" value="#dateformat(get_travel_.departure_date,dateformat_style)#" validate="#validate_style#" required="yes" readonly maxlength="10">
                                <cfelse>
                                    <input type="text" name="travel_start_date" id="travel_start_date" value="" validate="#validate_style#" required="yes" readonly maxlength="10">
                                </cfif>
                                    <span class="input-group-addon btnPointer">
                                        <cf_wrk_date_image date_field="travel_start_date" call_function="change_money_info">
                                    </span>
                                </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-travel_finish_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-8 col-xs-12" id="travel_finish_date">
                                <div class="input-group">
                                   <cfoutput> 
                                    <cfif isdefined('get_travel_')>
                                       <input type="text" name="travel_finish_date" id="travel_finish_date" value="#dateformat(get_travel_.departure_of_date,dateformat_style)#" validate="#validate_style#" required="yes" readonly maxlength="10">
                                    <cfelse>
                                        <input type="text" name="travel_finish_date" id="travel_finish_date" value="" validate="#validate_style#" required="yes" readonly maxlength="10">
                                    </cfif>
                                    <span class="input-group-addon btnPointer">
                                        <cf_wrk_date_image date_field="travel_finish_date" call_function="change_money_info">
                                    </span></cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-travel_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="58651.Türü"></label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined('get_travel_')>
                                    <cfif get_travel_.travel_type eq 1>
                                        <cfset travel_type ="Görev Seyahatleri">
                                    <cfelseif get_travel_.travel_type eq 2>
                                        <cfset travel_type ="Uzun Süreli Seyahatler">
                                    <cfelseif get_travel_.travel_type eq 3>   
                                        <cfset travel_type ="Eğitim Seyahatleri">
                                    <cfelse>
                                        <cfset travel_type ="">
                                    </cfif>
                                <cfelse>
                                    <cfset travel_type ="">
                                </cfif>
                                    <cfinput type="text" name="travel_type" id="travel_type" value="#travel_type#" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="item-task_causes">
                            <label  class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="34777.Nedeni"></label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined('get_travel_')>
                                    <cfoutput><textarea name="task_causes" id="task_causes">#get_travel_.task_causes#</textarea></cfoutput>
                                <cfelse>
                                    <cfoutput><textarea name="task_causes" id="task_causes"></textarea></cfoutput>
                                </cfif>
                            </div>
                        </div>
                    
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',217)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail"><cfoutput>#get_expense.detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_employee">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="30368.Çalışan"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#employee_id_#</cfoutput>">
                                    <input type="hidden" name="expense_employee_type" id="expense_employee_type" value="<cfoutput>employee</cfoutput>">
                                    <input type="hidden" name="acc_type_id" id="acc_type_id" value="<cfif isdefined("get_expense.acc_type_id") and len(get_expense.acc_type_id)><cfoutput>#get_expense.acc_type_id#</cfoutput></cfif>">
                                    <cf_wrk_employee_positions form_name='add_costplan' emp_id='expense_employee_id' emp_name='expense_employee'>
                                    <cfif fuseaction_first is "myhome">
                                    <!--- Amiri olduğum Çalışanlar --->
                                        <input type="text" name="expense_employee" id="expense_employee" style="width:120px;" value="<cfoutput>#get_emp_info(employee_id_,0,0)#</cfoutput>" onblur="load_travel()" readonly><!--- onKeyUp="get_emp_pos_1();" --->
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_costplan.expense_employee_id&call_function=load_travel()&field_name=add_costplan.expense_employee&field_type=add_costplan.expense_employee_type&&field_id=add_costplan.position_code&field_pos_name=add_costplan.position_name&field_emp_no=add_costplan.employee_no&is_position_assistant=1&module_id=<cfoutput>#get_modules_no.module_no#</cfoutput>&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1&show_rel_pos=1','list');"></span>
                                    <cfelse>
                                        <input type="text" name="expense_employee" id="expense_employee" onFocus="AutoComplete_Create('expense_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,MEMBER_TYPE','expense_employee_id,expense_employee_type','','3','135');" style="width:120px;" value="<cfoutput>#get_emp_info(employee_id_,0,0)#</cfoutput>" onblur="load_travel()"><!--- onKeyUp="get_emp_pos_1();" --->
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=add_costplan.expense_employee_id&field_name=add_costplan.expense_employee&field_type=add_costplan.expense_employee_type&field_id=add_costplan.position_code&field_pos_name=add_costplan.position_name&field_emp_no=add_costplan.employee_no&select_list=1&call_function=load_travel()','list');"></span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-emp_position_id">
                            <cfoutput>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif listfirst(attributes.fuseaction,'.') is 'myhome'>	
                                        <input type="hidden" name="position_code" id="position_code" value="#get_emp_pos.position_code#">
                                        <input name="position_name" type="text" id="position_name" readonly="readonly" value="#get_emp_pos.position_name#">
                                    <cfelse>
                                        <input type="hidden" name="position_code" id="position_code" value="#get_emp_pos.position_code#">
                                        <input name="position_name" type="text" id="position_name" readonly="readonly" value="#get_emp_pos.position_name#">
                                    </cfif>
                                </div>
                            </cfoutput>
                        </div>
                        <div class="form-group" id="item-employee_no">
                            <cfoutput>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32328.Sicil No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif listfirst(attributes.fuseaction,'.') is 'myhome'>	
                                        <input name="employee_no" type="text" id="employee_no" readonly="readonly" value="#get_emp_det.employee_no#">
                                    <cfelse>
                                        <input name="employee_no" type="text" id="employee_no" readonly="readonly" value="#get_emp_det.employee_no#">
                                    </cfif>
                                </div>
                            </cfoutput>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_basket id="upd_expense_bask">
                    <cf_grid_list sort="0">
                        <thead>
                            <tr>
                                <th>
                                    <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_rows.recordcount#</cfoutput>">
                                    <a href="javascript://" title="<cf_get_lang_main no='170.Ekle'>" onClick="add_row();"><i class="fa fa-plus"></i></a>
                                    <input type="hidden" name="control_field_value" id="control_field_value" value=""><!--- Satir Hesaplamalari Icin --->
                                </th>
                                <cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
                                    <cfswitch expression="#xlr#">
                                        <cfcase value="20">
                                            <th style="width:190px;" nowrap="nowrap"><cf_get_lang dictionary_id='41539.Harcırah Tipi'>*</th>
                                        </cfcase>
                                        <cfcase value="1">
                                            <th style="width:90px;" nowrap="nowrap"><cf_get_lang_main no='330.Tarih'>*</th>
                                        </cfcase>
                                        <cfcase value="2">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang_main no='217.Açıklama'>*</th>
                                        </cfcase>
                                        <cfcase value="3">
                                            <cfif x_is_project_priority eq 0><th nowrap="nowrap">&nbsp;<cf_get_lang_main no='1048.Masraf Merkezi'> *</th></cfif>
                                        </cfcase>
                                        <cfcase value="4">
                                            <cfif x_is_project_priority eq 0><th nowrap="nowrap">&nbsp;<cf_get_lang_main no='1139.Gider Kalemi'> *</th></cfif>
                                        </cfcase>
                                        <cfcase value="5">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang_main no='245.Ürün'></th>
                                        </cfcase>
                                        <cfcase value="6">
                                            <th nowrap="nowrap"><cf_get_lang_main no='224.Birim'></th>
                                        </cfcase>
                                        <cfcase value="7">
                                            <th nowrap="nowrap"><cf_get_lang_main no='223.Miktar'></th>
                                        </cfcase>
                                        <cfcase value="8">
                                            <th style="text-align:right;" nowrap="nowrap"><cf_get_lang_main no='261.Tutar'> *</th>
                                        </cfcase>
                                        <cfcase value="9">
                                            <th style="text-align:right;" nowrap="nowrap">&nbsp;<cf_get_lang_main no='227.KDV'>%</th>
                                        </cfcase>
                                        <cfcase value="10">
                                            <th style="text-align:right;" nowrap="nowrap">&nbsp;<cf_get_lang_main no='227.KDV'></th>
                                        </cfcase>
                                        <cfcase value="11">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang_main no='268.KDV li Toplam'></th>
                                        </cfcase>
                                        <cfcase value="12">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang_main no='77.Para Br'></th>
                                        </cfcase>
                                        <cfcase value="13">
                                            <th style="text-align:right;" nowrap="nowrap">&nbsp;<cf_get_lang no='976.Dövizli Fiyat'></th>
                                        </cfcase>
                                        <cfcase value="14">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang no='777.Aktivite Tipi'></th>
                                        </cfcase>
                                        <cfcase value="15">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang_main no='1033.İş'> <cfif x_select_work eq 1>*</cfif></th>
                                        </cfcase>
                                        <cfcase value="16">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang_main no='200.Fırsat'></th>
                                        </cfcase>
                                        <cfcase value="17">
                                            <th nowrap="nowrap" style="min-width:300px;">&nbsp;<cf_get_lang no='867.Harcama Yapan'></th>
                                        </cfcase>
                                        <cfcase value="18">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang_main no='1421.Fiziki Varlık'></th>
                                        </cfcase>
                                        <cfcase value="19">
                                            <th nowrap="nowrap">&nbsp;<cf_get_lang_main no='4.Proje'> <cfif x_select_project eq 1>*</cfif></th>
                                        </cfcase>
                                    </cfswitch>
                                </cfloop>
                            </tr>
                        </thead>
                        <cfset work_head_list = "">
                        <cfset opp_head_list = "">
                        <cfset pyschical_asset_list = "">
                        <cfset expense_center_list = "">
                        <cfset expense_item_list = "">
                        <cfoutput query="get_rows">
                            <cfif len(expense_center_id) and not listfind(expense_center_list,expense_center_id)>
                                <cfset expense_center_list=listappend(expense_center_list,expense_center_id)>
                            </cfif>
                            <cfif len(expense_item_id) and not listfind(expense_item_list,expense_item_id)>
                                <cfset expense_item_list=listappend(expense_item_list,expense_item_id)>
                            </cfif>
                            <cfif len(work_id) and not listfind(work_head_list,work_id)>
                                <cfset work_head_list=listappend(work_head_list,work_id)>
                            </cfif>
                            <cfif len(opp_id) and not listfind(opp_head_list,opp_id)>
                                <cfset opp_head_list=listappend(opp_head_list,opp_id)>
                            </cfif>
                            <cfif len(pyschical_asset_id) and not listfind(pyschical_asset_list,pyschical_asset_id)>
                                <cfset pyschical_asset_list=listappend(pyschical_asset_list,pyschical_asset_id)>
                            </cfif>
                        </cfoutput>
                        <cfif len(work_head_list)>
                            <cfset work_head_list=listsort(work_head_list,"numeric","ASC",",")>
                            <cfquery name="get_work" datasource="#dsn#">
                                SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_head_list#) ORDER BY WORK_ID
                            </cfquery>
                            <cfset work_head_list = ListSort(ListDeleteDuplicates(ValueList(get_work.work_id)),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(opp_head_list)>
                            <cfset opp_head_list=listsort(opp_head_list,"numeric","ASC",",")>
                            <cfquery name="get_opportunities" datasource="#DSN3#">
                                SELECT OPP_ID,OPP_HEAD FROM OPPORTUNITIES WHERE OPP_ID IN (#opp_head_list#) ORDER BY OPP_ID
                            </cfquery>
                            <cfset opp_head_list = ListSort(ListDeleteDuplicates(ValueList(get_opportunities.opp_id)),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(pyschical_asset_list)>
                            <cfset pyschical_asset_list=listsort(pyschical_asset_list,"numeric","ASC",",")>
                            <cfquery name="GET_ASSETP_NAME" datasource="#dsn#">
                                SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#pyschical_asset_list#) ORDER BY ASSETP_ID
                            </cfquery>
                            <cfset pyschical_asset_list = ListSort(ListDeleteDuplicates(ValueList(GET_ASSETP_NAME.ASSETP_ID)),'numeric','ASC',',')>
                        </cfif>
                        <cfif ListLen(expense_center_list)>
                            <cfquery name="get_expense_center_list" datasource="#dsn2#">
                                SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_list#) ORDER BY EXPENSE_ID
                            </cfquery>
                            <cfset expense_center_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_center_list.expense_id)),'numeric','ASC',',')>
                        </cfif>
                        <cfif ListLen(expense_item_list)>
                            <cfquery name="get_expense_item_list" datasource="#dsn2#">
                                SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_list#) ORDER BY EXPENSE_ITEM_ID
                            </cfquery>
                            <cfset expense_item_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_item_list.expense_item_id)),'numeric','ASC',',')>
                        </cfif>
                        <tbody  name="table1" id="table1">
                        <cfset rows_ids = ''>
                        <cfoutput query="get_rows">
                            <cfif len(rows_ids)>
                                <cfset rows_ids = rows_ids & ',#exp_item_rows_id#'>
                            <cfelse>
                                <cfset rows_ids = exp_item_rows_id>
                            </cfif>
                            <input type="hidden" name="exp_item_rows_id#currentrow#" id="exp_item_rows_id#currentrow#" value="#exp_item_rows_id#">
                            <tr id="frm_row#currentrow#" class="color-row">
                                <cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),3) or x_is_project_priority eq 1>
                                    <input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
                                    <input type="hidden" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" value="<cfif len(expense_center_id)>#get_expense_center_list.expense[listfind(expense_center_list,expense_center_id,',')]#</cfif>" class="boxtext" style="width:180px;" onFocus="AutoComplete_Create('expense_center_name#currentrow#','EXPENSE','EXPENSE','get_expense_center','0,<cfif isDefined("x_authorized_branch_department") and x_authorized_branch_department eq 1>1<cfelse>0</cfif>','EXPENSE_ID','expense_center_id#currentrow#','add_costplan',1);" autocomplete="off">
                                </cfif>
                                <cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),4) or x_is_project_priority eq 1>
                                    <input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
                                    <input type="hidden" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" value="<cfif len(expense_item_id)>#get_expense_item_list.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#</cfif>" class="boxtext" style="width:230px;" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>','EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE','expense_item_id#currentrow#,account_code#currentrow#,tax_code#currentrow#','add_costplan',1);" autocomplete="off">
                                </cfif>
                                <cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),7)>
                                    <input type="hidden" name="quantity#currentrow#" id="quantity#currentrow#"  style="width:90px;" class="boxtext" value="#TLFormat(1,session.ep.our_company_info.rate_round_num)#">
                                </cfif>
                                <cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),10)>
                                    <input type="hidden" name="kdv_total#currentrow#" id="kdv_total#currentrow#" value="#tlformat(amount_kdv,session.ep.our_company_info.rate_round_num)#"class="box">
                                </cfif>
                                <td nowrap="nowrap">
                                    <ul class="ui-icon-list">
                                        <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                        <li><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></li>
                                        <li><a href="javascript://" onclick="copy_row('#currentrow#');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><i class="fa fa-copy"></i></a></li>
                                    </ul>
                                </td>
                                <cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
                                    <cfswitch expression="#xlr#">
                                        <cfcase value="20">
                                            <td nowrap="nowrap">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" name="expense_type#currentrow#" id="expense_type#currentrow#" value="#get_rows.ALLOWANCE_TYPE_ID#">
                                                        <input type="text" name="expense_type_name#currentrow#" id="expense_type_name#currentrow#" value="#get_rows.EXPENSE_HR_RULES_DETAIL#" class="boxtext" style="width:90%" readonly> 
                                                        <span class="input-group-addon icon-ellipsis" onClick="open_expense_allowance('#currentrow#');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                            </cfcase>
                                        <cfcase value="1">
                                            <td nowrap="nowrap">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="text" name="expense_date#currentrow#" id="expense_date#currentrow#" style="width:75px;" value="<cfif len(get_rows.expense_date)>#dateformat(get_rows.expense_date,dateformat_style)#<cfelse>#dateformat(get_expense.expense_date,dateformat_style)#</cfif>" title="#detail#">
                                                            <span class="input-group-addon"><cf_wrk_date_image date_field="expense_date#currentrow#"></span>
                                                    </div>
                                                </div>
                                            </td>
                                            </cfcase>
                                            <cfcase value="2">
                                            <td>
                                                <div class="form-group">
                                                    <input type="text"  class="boxtext" name="row_detail#currentrow#" id="row_detail#currentrow#" style="width:140px;" value="#detail#">
                                                </div>
                                            </td>
                                            </cfcase>
                                            <cfcase value="3">
                                                <cfif x_is_project_priority eq 0>
                                                <td nowrap="nowrap">
                                                    <div class="form-group">
                                                        <cfif xml_expense_center_is_popup eq 1>
                                                            <div class="input-group">
                                                                <input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
                                                                <input type="text" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" value="<cfif len(expense_center_id)>#get_expense_center_list.expense[listfind(expense_center_list,expense_center_id,',')]#</cfif>" class="boxtext" style="width:180px;" onFocus="AutoComplete_Create('expense_center_name#currentrow#','EXPENSE','EXPENSE','get_expense_center','0,<cfif isDefined("x_authorized_branch_department") and x_authorized_branch_department eq 1>1<cfelse>0</cfif>','EXPENSE_ID','expense_center_id#currentrow#','add_costplan',1);" autocomplete="off">
                                                                <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_exp('#currentrow#');"></span>
                                                            </div>
                                                        <cfelse>
                                                            <select name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" <cfif xml_expense_center_budget_item eq 1> onChange="ShowBudgetItems(#currentrow#);"</cfif> style="width:200px;" class="boxtext">
                                                                <cfset deger_expense_center_id = get_rows.expense_center_id>
                                                                <option value=""><cf_get_lang_main no='1048.Masraf Merkezi'></option>
                                                                <cfloop query="get_expense_center">
                                                                    <option value="#expense_id#" <cfif deger_expense_center_id eq expense_id>selected</cfif>>#expense#</option>
                                                                </cfloop>
                                                            </select>
                                                        </cfif>
                                                    </div>
                                                    
                                                </td>
                                            </cfif>
                                        </cfcase>
                                        <cfcase value="4">
                                                <cfif x_is_project_priority eq 0>
                                                <td nowrap="nowrap">
                                                    <div class="form-group">
                                                        <cfif xml_expense_center_is_popup eq 1>
                                                            <div class="input-group">
                                                                <input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
                                                                <input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" value="<cfif len(expense_item_id)>#get_expense_item_list.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#</cfif>" class="boxtext" style="width:230px;" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>','EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE','expense_item_id#currentrow#,account_code#currentrow#,tax_code#currentrow#','add_costplan',1);" autocomplete="off">
                                                                <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('#currentrow#',<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>);"></span>
                                                            </div>
                                                        <cfelse>
                                                            <select name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" style="width:200px;" class="boxtext">
                                                                <option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>
                                                                <cfset deger_gider_kalemi = get_rows.expense_item_id>
                                                                <cfloop query="get_expense_item">
                                                                    <option value="#expense_item_id#" <cfif deger_gider_kalemi eq expense_item_id>selected</cfif>>#expense_item_name#</option>
                                                                </cfloop>
                                                            </select>
                                                        </cfif>
                                                    </div>
                                                    
                                                </td>
                                            </cfif>
                                        </cfcase>
                                        <cfcase value="5">
                                            <!--- Urun --->
                                            <td nowrap="nowrap">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                                                        <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                                                        <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" maxlength="50" value="#left(product_name,50)#" onFocus="AutoComplete_Create('product_name#currentrow#','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id#currentrow#,stock_id#currentrow#','add_costplan',1);" style="width:135px;" class="boxtext">
                                                        <cfif len(PRODUCT_ID)><span class="input-group-addon" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id#currentrow#').value+'&sid='+document.getElementById('stock_id#currentrow#').value+'','list');"><img border="0" align="middle" src="/images/plus_thin_p.gif" id="product_info#currentrow#" title="<cf_get_lang no='458.Ürün Detay'>"></span><cfelse>&nbsp;&nbsp;&nbsp;</cfif>
                                                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=all.product_id#currentrow#&field_id=all.stock_id#currentrow#&field_name=all.product_name#currentrow#&field_unit_name= all.stock_unit#currentrow#&field_unit= all.stock_unit_id#currentrow#&field_product_cost=all.total#currentrow#&run_function=hesapla&run_function_param=#currentrow#&expense_date='+document.all.expense_date.value+'','list');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="6">
                                            <!---Birim --->
                                            <td>
                                                <div class="form-group">
                                                    <input type="hidden" name="stock_unit_id#currentrow#" id="stock_unit_id#currentrow#" value="#unit_id#">
                                                    <input type="text" name="stock_unit#currentrow#" id="stock_unit#currentrow#" class="boxtext" value="#unit#" readonly="yes" style="width:90px;">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="7">
                                            <!---Miktar --->
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="quantity#currentrow#" id="quantity#currentrow#"  style="width:90px;" class="box" value="#TLFormat(quantity,session.ep.our_company_info.rate_round_num)#" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#session.ep.our_company_info.rate_round_num#);this.select();" onBlur="hesapla('quantity','#currentrow#');" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="8">
                                            <!--- Tutar --->
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="total#currentrow#" id="total#currentrow#" value="#tlformat(amount,session.ep.our_company_info.rate_round_num)#" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#session.ep.our_company_info.rate_round_num#);this.select();" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" style="width:90px;" onBlur="hesapla('total','#currentrow#');" class="box">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="9">
                                            <td>
                                                <div class="form-group">
                                                    <select name="tax_rate#currentrow#" id="tax_rate#currentrow#" style="width:100%;" class="box" onChange="hesapla('tax_rate','#currentrow#');">
                                                        <cfloop query="get_tax">
                                                            <option value="#tax#" <cfif get_rows.kdv_rate eq tax>selected</cfif>>#tax#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="10">
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="kdv_total#currentrow#" id="kdv_total#currentrow#" value="#tlformat(amount_kdv,session.ep.our_company_info.rate_round_num)#" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" style="width:90px;" onBlur="hesapla('kdv_total','#currentrow#',1);" class="box">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="11">
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="net_total#currentrow#" id="net_total#currentrow#" value="#tlformat(total_amount,session.ep.our_company_info.rate_round_num)#" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#session.ep.our_company_info.rate_round_num#);this.select();" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" style="width:90px;" onBlur="hesapla('net_total','#currentrow#',2);" class="box">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="12">
                                            <td>
                                                <div class="form-group">
                                                    <select name="money_id#currentrow#" id="money_id#currentrow#" style="width:100%;" class="boxtext" onChange="other_calc('#currentrow#');">
                                                        <cfset deger_money = money_currency_id>
                                                        <cfloop query="get_money">
                                                            <option value="#money#,#rate1#,#rate2#" <cfif deger_money eq money>selected</cfif>>#money#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="13">
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="other_net_total#currentrow#" id="other_net_total#currentrow#" value="#tlformat(other_money_value,session.ep.our_company_info.rate_round_num)#" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#session.ep.our_company_info.rate_round_num#);this.select();" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" style="width:90px;" class="box" onBlur="other_calc('#currentrow#',2);">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="14">
                                            <td>
                                                <div class="form-group">
                                                    <select name="activity_type#currentrow#" id="activity_type#currentrow#" style="width:90px;" class="boxtext">
                                                        <cfset deger_activity_type = get_rows.activity_type>
                                                        <option value=""><cf_get_lang no='777.Akitivite Tipi'></option>
                                                        <cfloop query="get_activity_types">
                                                            <option value="#activity_id#" <cfif deger_activity_type eq activity_id>selected</cfif>>#activity_name#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="15">
                                            <td nowrap>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" class="boxtext" name="work_id#currentrow#" id="work_id#currentrow#" value="#work_id#">
                                                        <input name="work_head#currentrow#" id="work_head#currentrow#" type="text" class="boxtext" style="width:124px;" value="<cfif len(work_id)>#get_work.work_head[listfind(work_head_list,work_id,',')]#</cfif>" onFocus="AutoComplete_Create('work_head#currentrow#','WORK_HEAD','WORK_HEAD','get_work','3','WORK_ID','work_id#currentrow#','','3','135');">
                                                        <cfif isdefined('work_id') and len(work_id)><span class="input-group-addon" onclick="pencere_detail_work(#currentrow#);"><img src="/images/plus_thin_p.gif" title="<cf_get_lang_main no='1033.iş'><cf_get_lang_main no='359.detayı'> "align="absmiddle" border="0"></span><cfelse>&nbsp;&nbsp;&nbsp;</cfif>
                                                        <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_work('#currentrow#');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="16">
                                            <td nowrap>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" class="boxtext" name="opp_id#currentrow#" id="opp_id#currentrow#" value="#opp_id#">
                                                        <input type="text" name="opp_head#currentrow#" id="opp_head#currentrow#" class="boxtext" style="width:110px;" value="<cfif len(opp_id)>#get_opportunities.opp_head[listfind(opp_head_list,opp_id,',')]#</cfif>" onFocus="AutoComplete_Create('opp_head#currentrow#','OPP_HEAD','OPP_HEAD','get_opportunity','3','OPP_ID','opp_id#currentrow#','','3','135');">
                                                        <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_oppotunity('#currentrow#');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="17">
                                            <td nowrap>
                                                <cfif isdefined("member_type") and member_type is 'partner'>
                                                    <cfset member_type_ = "partner">
                                                    <cfset member_id_ = company_partner_id>
                                                    <cfset company_id_= company_id>
                                                    <cfset authorized_ = get_par_info(company_partner_id,0,-1,0)>
                                                    <cfset company_ = get_par_info(company_id,1,0,0)>
                                                <cfelseif isdefined("member_type") and member_type is 'consumer'>
                                                    <cfset member_type_ = "consumer">
                                                    <cfset member_id_ = company_partner_id>
                                                    <cfset company_id_= "">
                                                    <cfset authorized_ = get_cons_info(company_partner_id,0,0)>
                                                    <cfset company_ = get_cons_info(company_partner_id,2,0)>
                                                <cfelseif isdefined("member_type") and member_type is 'employee'>
                                                    <cfset member_type_ = "employee">
                                                    <cfset member_id_ = company_partner_id>
                                                    <cfset company_id_= "">
                                                    <cfset authorized_ = get_emp_info(company_partner_id,0,0)>
                                                    <cfset company_ = "">
                                                <cfelse>
                                                    <cfset member_type_ = "">
                                                    <cfset member_id_ = "">
                                                    <cfset company_id_= "">
                                                    <cfset authorized_ = "">
                                                    <cfset company_ = "">
                                                </cfif>
                                                <div class="form-group">
                                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                                        <input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#member_type_#">
                                                        <input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#member_id_#">
                                                        <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id_#">
                                                        <input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#authorized_#" onFocus="AutoComplete_Create('authorized#currentrow#','MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_NAME2','member_type#currentrow#,member_id#currentrow#,company_id#currentrow#,company#currentrow#','','3','115');" style="width:115px;" class="boxtext" title="#detail#">
                                                    </div>
                                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                                        <div class="input-group">
                                                            <input type="text" name="company#currentrow#" id="company#currentrow#" value="#company_#" readonly style="width:104px;" class="boxtext" title="#detail#">
                                                            <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_company('#currentrow#');"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="18">
                                            <td nowrap>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" name="asset_id#currentrow#" id="asset_id#currentrow#" value="#pyschical_asset_id#">
                                                        <input type="text" name="asset#currentrow#" id="asset#currentrow#" onFocus="autocomp_assetp('#currentrow#');" value="<cfif len(pyschical_asset_id)>#get_assetp_name.assetp[listfind(pyschical_asset_list,pyschical_asset_id,',')]#</cfif>" style="width:116px;" class="boxtext">
                                                        <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_asset('#currentrow#');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="19">
                                            <td nowrap>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#project_id#">
                                                        <input type="text" name="project#currentrow#" id="project#currentrow#" onFocus="AutoComplete_Create('project#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id#currentrow#','',3,105);" <cfif not len(product_id) or x_is_project_select eq 1><cfelse>readonly="yes"</cfif> value="<cfif len(project_id)>#get_project_name(project_id)#</cfif>" style="width:116px;" class="boxtext">
                                                        <cfif not len(product_id) or x_is_project_select eq 1><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_project('#currentrow#');"></span><cfelse>&nbsp;&nbsp;</cfif>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                    </cfswitch>
                                </cfloop>
                            </tr>
                        </cfoutput>
                        </tbody>
                        </cf_grid_list>
                        <cf_basket_footer height="150">  
                            <div class="ui-row">
                                <div id="sepetim_total" class="padding-0">
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <div class="totalBox">
                                            <div class="totalBoxHead font-grey-mint">
                                                <span class="headText"> <cf_get_lang_main no='265.Döviz'> </span>
                                                <div class="collapse">
                                                    <span class="icon-minus"></span>
                                                </div>
                                            </div>
                                            <div class="totalBoxBody">
                                                <table>
                                                    <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#GET_MONEY.recordcount#</cfoutput>">
                                                    <cfoutput>
                                                        <cfloop query="GET_MONEY">
                                                            <tr>
                                                                <td>
                                                                    <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                                                    <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                                                    <input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="other_calc();" <cfif get_expense.other_money eq money>checked</cfif>>
                                                                </td>
                                                                <td>#money#</td>
                                                                <cfif session.ep.rate_valid eq 1>
                                                                    <cfset readonly_info = "yes">
                                                                <cfelse>
                                                                    <cfset readonly_info = "no">
                                                                </cfif>
                                                                <td>#TLFormat(rate1,0)#/</td>
                                                                <td><input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" <cfif money eq session.ep.money>readonly="yes"</cfif> style="width:100%;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="other_calc();"></td>
                                                            </tr>
                                                        </cfloop>
                                                    </cfoutput>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                        <div class="totalBox">
                                            <div class="totalBoxHead font-grey-mint">
                                                <span class="headText"> <cf_get_lang_main no='80.Toplam'> </span>
                                                <div class="collapse">
                                                    <span class="icon-minus"></span>
                                                </div>
                                            </div>
                                            <div class="totalBoxBody">       
                                                <table>
                                                    <tr>
                                                        <td><cf_get_lang_main no='80.Toplam'></td>
                                                        <td style="text-align:right;"><input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_expense.total_amount,session.ep.our_company_info.rate_round_num)#</cfoutput>">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                                                    </tr>
                                                    <tr>
                                                        <td><cf_get_lang no='823.Toplam KDV'></td>
                                                        <td style="text-align:right;"><input type="text" name="kdv_total_amount" id="kdv_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_expense.net_total_amount,session.ep.our_company_info.rate_round_num)#</cfoutput>">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                                                    </tr>
                                                    <tr>
                                                        <td><cf_get_lang_main no='268.KDV li Toplam'></td>
                                                        <td style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_expense.net_kdv_amount,session.ep.our_company_info.rate_round_num)#</cfoutput>">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                                                    </tr>
                                                </table>
                                                        
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <div class="totalBox">
                                            <div class="totalBoxHead font-grey-mint">
                                                <span class="headText"><cf_get_lang dictionary_id='32823.Toplam Miktar'> </span>
                                                <div class="collapse">
                                                    <span class="icon-minus"></span>
                                                </div>
                                            </div>
                                            <div class="totalBoxBody" id="totalAmountList">  
                                                <table>
                                                    <tr>
                                                        <td><cf_get_lang_main no='712.Döviz Toplam'></td>
                                                        <td id="rate_value1" style="text-align:right;"><input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_expense.other_money_amount,session.ep.our_company_info.rate_round_num)#</cfoutput>">&nbsp;<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#get_expense.other_money#</cfoutput>" style="width:40px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="txtbold"><cf_get_lang no='824.Döviz KDV'></td>
                                                        <td id="rate_value2" style="text-align:right;"><input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_expense.other_money_kdv,session.ep.our_company_info.rate_round_num)#</cfoutput>">&nbsp;<input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" value="<cfoutput>#get_expense.other_money#</cfoutput>" style="width:40px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="txtbold"><cf_get_lang no='825.Döviz KDV li Toplam'></td>
                                                        <td id="rate_value3" style="text-align:right;"><input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_expense.other_money_net_total,session.ep.our_company_info.rate_round_num)#</cfoutput>">&nbsp;<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#get_expense.other_money#</cfoutput>" style="width:40px;"></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>               
                        </cf_basket_footer>                   
                </cf_basket>
                <cf_box_footer>
                    <cf_record_info query_name='get_expense'>
                        <cfset get_puantaj = allowanceExpense.GET_PUANTAJ_KONTROL(employee_id : employee_id_,expense_date : get_expense.expense_date)><!--- Belge puantaja yansımışmı?--->
                        <cfset get_harcırah = allowanceExpense.GET_HARCIRAH_KONTROL(expense_puantaj_id : attributes.request_id)><!--- Belgenin daha önce harcırahı oluşturulmuş mu?--->
                        <cfif get_puantaj.recordcount>
                            <font color="red" class="pull-right"><cf_get_lang dictionary_id ="59553.Harcırah Tarihinden Sonra Girilen Harcırah Kaydı Olduğu İçin Güncelleme Yapamazsınız"></font>
                        <cfelse>
                            <cfif not get_kontrol.recordcount><!--- masraf kaydi yok --->
                                <cfif fuseaction_first is "hr"><!--- masraf ekrani ise --->
                                    <cfif (get_expense.is_approve neq 0 and get_expense.is_approve neq 1)>
                                        <cfsavecontent variable="silinsin_mi"><cf_get_lang no ='1348.Bu Talebi Silmek İstediğinize Emin Misiniz'>?</cfsavecontent>
                                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' del_function_for_submit="approve_control()" delete_page_url='#request.self#?fuseaction=objects.del_expense_plan_request&request_id=#attributes.request_id#&allowance_expense=1' delete_alert='#silinsin_mi#'>
                                    <cfelseif get_expense.is_approve eq 1>
                                        <cfsavecontent variable="message"><cf_get_lang no='1102.Masraf Fişine Dönüştür'> </cfsavecontent>
                                        <cfsavecontent variable="messages"><cf_get_lang no='1101.Talep Masraf Fişine Dönüştürülecektir Emin misiniz'>?</cfsavecontent>
                                        <cfsavecontent variable="silinsin_mi"><cf_get_lang no ='1348.Bu Talebi Silmek İstediğinize Emin Misiniz'>?</cfsavecontent>
                                        <input type="button" value="<cf_get_lang no='1102.Masraf Fişine Dönüştür'>" onClick="window.location.href='<cfoutput>#request.self#?fuseaction=cost.form_add_expense_cost&request_id=#attributes.request_id#</cfoutput>';">
                                        <cf_workcube_buttons is_upd='1' is_cancel='0' add_function='kontrol()' is_delete='1' del_function_for_submit="approve_control()" delete_page_url='#request.self#?fuseaction=objects.del_expense_plan_request&request_id=#attributes.request_id#&allowance_expense=1' delete_alert='#silinsin_mi#'>
                                    <cfelseif get_expense.is_approve eq 0>
                                        <font color="##FF0000"><b><cf_get_lang no ='1349.Talep Reddedildi'></b></font>
                                    </cfif>&nbsp;
                                    <cfif get_harcırah.recordcount>
                                        <cfsavecontent variable="again_"><cf_get_lang dictionary_id='59594.yeniden harcırah oluştur'></cfsavecontent>
                                        <cf_workcube_buttons extraButton="1"  extraButtonClass="btn blue pull-right" extraButtonText="#again_#" update_status="0" extraFunction="submit_expense_allowance()">
                                    <cfelse>
                                        <cfsavecontent variable="create_"><cf_get_lang dictionary_id='59514.harcırah oluştur'></cfsavecontent>
                                        <cf_workcube_buttons extraButton="1"  extraButtonClass="btn blue pull-right" extraButtonText="#create_#" update_status="0" extraFunction="submit_expense_allowance()">
                                    </cfif>
                                <cfelse>
                                    <cfif (get_expense.is_approve neq 0 and get_expense.is_approve neq 1) or (get_faction_recordcount eq 1)>
                                        <cfsavecontent variable="silinsin_mi"><cf_get_lang no ='1348.Bu Talebi Silmek İstediğinize Emin Misiniz'>?</cfsavecontent>
                                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' del_function_for_submit="approve_control()" delete_page_url='#request.self#?fuseaction=objects.del_expense_plan_request&request_id=#attributes.request_id#&allowance_expense=1' delete_alert='#silinsin_mi#'>
                                    <cfelse>
                                        <cfif get_expense.is_approve eq 0><font color="##FF0000"><b><cf_get_lang no ='1349.Talep Reddedildi'></b></font></cfif>
                                    </cfif>
                                </cfif>
                            <cfelse>
                                <cfoutput>
                                    <cfif fuseaction contains 'myhome.'>
                                        <font color="red"><cf_get_lang_main no='652.Masraf Fişi'>:<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_cost_expense&period=#session.ep.period_id#&id=#get_kontrol.expense_id#','project');" title="Masraf Fişi Detay"><strong>#get_kontrol.paper_no#</strong></a></font>
                                    <cfelse>
                                        <font color="red"><cf_get_lang_main no='652.Masraf Fişi'>:<a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#get_kontrol.expense_id#" title="Masraf Fişi Detay"><strong>#get_kontrol.paper_no#</strong></a></font>
                                    </cfif>
                                </cfoutput>
                            </cfif>
                        </cfif>
                </cf_box_footer>
            </cf_box>
        </cf_basket_form>
    </cfform>
</div>
    <script type="text/javascript">
        row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
        function sil(sy)
        {
            eval("add_costplan.row_kontrol"+sy).value=0;
            var my_element=eval("frm_row"+sy);
            my_element.style.display="none";
            toplam_hesapla();
        }
        function copy_row(no_info)
        {
            if(document.getElementById('no_info'+no_info) != undefined)
                row_detail = document.getElementById('row_detail'+no_info).value;
            else
                row_detail = '';
                
            if(document.getElementById('expense_center_id'+no_info) != undefined)
                exp_center = document.getElementById('expense_center_id'+no_info).value;
            else
                exp_center = '';
                
            <cfif xml_expense_center_is_popup eq 1>
                if(document.getElementById('expense_center_name'+no_info) != undefined)
                    exp_center_name = document.getElementById('expense_center_name'+no_info).value;
                else
                    exp_center_name = '';
            <cfelse>
                exp_center_name = '';
            </cfif>
                
            if(document.getElementById('expense_item_id'+no_info) != undefined)
                exp_item = document.getElementById('expense_item_id'+no_info).value;
            else
                exp_item = '';
                
            <cfif xml_expense_center_is_popup eq 1>
                if(document.getElementById('expense_item_name'+no_info) != undefined)
                    exp_item_name = document.getElementById('expense_item_name'+no_info).value;
                else
                    exp_item_name = '';
            <cfelse>
                exp_item_name = '';
            </cfif>
                
            if(document.getElementById('activity_type'+no_info) != undefined)
                activity = document.getElementById('activity_type'+no_info).value;
            else
                activity = '';
            if(document.getElementById('stock_id'+no_info) != undefined)
            {
                exp_stock_id = document.getElementById('stock_id'+no_info).value;  
                exp_product_id = document.getElementById('product_id'+no_info).value;
                exp_product_name = document.getElementById('product_name'+no_info).value;
            }
            else
            {
                exp_stock_id = '';
                exp_product_id = '';
                exp_product_name = '';
            }
            if (document.getElementById('stock_unit' + no_info) == undefined) exp_stock_unit =""; else exp_stock_unit = document.getElementById('stock_unit' + no_info).value;
            if (document.getElementById('stock_unit_id' + no_info) == undefined) exp_stock_unit_id =""; else exp_stock_unit_id = document.getElementById('stock_unit_id' + no_info).value;
            if(document.getElementById('tax_rate'+no_info) != undefined)
                exp_tax_rate = document.getElementById('tax_rate'+no_info).value; 
            else
            {
                exp_tax_rate = '';
            }
            exp_money_id = document.getElementById('money_id'+no_info).value;
            if(document.getElementById('member_type'+no_info) != undefined)
            {
                exp_member_type = document.getElementById('member_type'+no_info).value;
                exp_member_id = document.getElementById('member_id'+no_info).value;
                exp_company_id = document.getElementById('company_id'+no_info).value;
                exp_authorized = document.getElementById('authorized'+no_info).value;
                exp_company = document.getElementById('company'+no_info).value;
            }
            else
            {
                exp_member_type = '';
                exp_member_id = '';
                exp_company_id = '';
                exp_authorized = '';
                exp_company = '';
            }
            if(document.getElementById('project_id'+no_info) != undefined)
            {
                exp_project_id = document.getElementById('project_id'+no_info).value;
                exp_project = document.getElementById('project'+no_info).value;
            }
            else
            {
                exp_project_id = '';
                exp_project = '';
            }
            if(document.getElementById('asset_id'+no_info) != undefined)
            {
                exp_asset_id = document.getElementById('asset_id'+no_info).value;
                exp_asset = document.getElementById('asset'+no_info).value;
            }
            else
            {
                exp_asset_id = '';
                exp_asset = '';
            }
            if( document.getElementById('expense_date'+no_info) != undefined)
                exp_date = document.getElementById('expense_date'+no_info).value;
            else
                exp_date = '';
            if( document.getElementById('work_id'+no_info) != undefined)
            {
                row_work_id =  document.getElementById('work_id'+no_info).value;
                row_work_head =  document.getElementById('work_head'+no_info).value;
            }
            else
            {
                row_work_id = '';
                row_work_head = '';
            }	
            if( document.getElementById('opp_id'+no_info) != undefined)
            {
                exp_opp_id = document.getElementById('opp_id'+no_info).value; 
                exp_opp_head =  document.getElementById('opp_head'+no_info).value;
            }
            else
            {
                exp_opp_id = '';	
                exp_opp_head = '';
            }
            
            add_row(row_detail,exp_center,exp_item,activity,exp_stock_id,exp_product_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_tax_rate,exp_money_id,exp_date,exp_member_type,exp_member_id,exp_company_id,exp_authorized,exp_company,exp_project_id,exp_project,exp_asset_id,exp_asset,row_work_id,row_work_head,exp_opp_id,exp_opp_head,exp_center_name,exp_item_name);
        }
        function add_row(row_detail,exp_center,exp_item,activity,exp_stock_id,exp_product_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_tax_rate,exp_money_id,expense_date,exp_member_type,exp_member_id,exp_company_id,exp_authorized,exp_company,exp_project_id,exp_project,exp_asset_id,exp_asset,row_work_id,row_work_head,exp_opp_id,exp_opp_head,exp_center_name,exp_item_name)
        {
            //Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
            if (row_detail == undefined)row_detail ="";
            if (exp_center == undefined){exp_center =""; exp_center_name="";}
            if (exp_item == undefined){exp_item =""; exp_item_name="";}
            if (activity == undefined)activity ="";
            if (exp_member_type == undefined)exp_member_type ="";
            if (exp_member_id == undefined)exp_member_id ="";
            if (exp_company_id == undefined)exp_company_id ="";
            if (exp_authorized == undefined)exp_authorized ="";
            if (exp_company == undefined)exp_company ="";
            if (exp_stock_id == undefined)exp_stock_id ="";
            if (exp_product_id == undefined)exp_product_id ="";
            if (exp_product_name == undefined)exp_product_name ="";
            if (exp_stock_unit == undefined)exp_stock_unit ="";
            if (exp_stock_unit_id == undefined) exp_stock_unit_id ="";
            if (exp_project_id == undefined)exp_project_id ="";
            if (exp_project == undefined)exp_project ="";
            if (expense_date == undefined)expense_date = document.getElementById("expense_date").value;
            if (exp_asset_id == undefined)exp_asset_id ="";
            if (exp_asset == undefined)exp_asset ="";
            if (exp_tax_rate == undefined)exp_tax_rate ="0";
            if (exp_money_id == undefined)exp_money_id ="";
            if (row_work_id == undefined) row_work_id ="";
            if (row_work_head == undefined) row_work_head ="";
            if (exp_opp_id == undefined) exp_opp_id ="";
            if (exp_opp_head == undefined) exp_opp_head ="";
            
            rate_round_num_ = "<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>";
            if(rate_round_num_ == "") rate_round_num_ = "2";
            
            row_count++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
            newRow.setAttribute("name","frm_row" + row_count);
            newRow.setAttribute("id","frm_row" + row_count);		
            newRow.setAttribute("NAME","frm_row" + row_count);
            newRow.setAttribute("ID","frm_row" + row_count);		
            newRow.className = 'color-row';
            document.add_costplan.record_num.value=row_count;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<ul class="ui-icon-list"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><li><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a></li><li><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><i class="fa fa-copy"></i></a></li></ul>';
            <cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),3) or x_is_project_priority eq 1>
                newCell.innerHTML += '<input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center+'"><input type="hidden" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" value="'+exp_center+'">';
            </cfif>
            <cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),4) or x_is_project_priority eq 1>
                newCell.innerHTML += '<input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item+'"><input type="hidden" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item+'">';
            </cfif>
            <cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),7)>
                newCell.innerHTML += '<input type="hidden" name="quantity' + row_count +'" id="quantity' + row_count +'" value="'+1+'">';
            </cfif>
            <cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),10)>
                newCell.innerHTML += '<input type="hidden" name="kdv_total'+ row_count +'" id="kdv_total' + row_count +'" value="0" class="box">';
            </cfif>
            <cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
                <cfswitch expression="#xlr#">
                    <cfcase value="20"><!--- Harcırah kuralları --->
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.innerHTML = '<div class="form-group"><div class="input-group"> <input type="hidden" name="expense_type'+row_count+'" id="expense_type'+row_count+'" value=""> <input type="text" name="expense_type_name'+row_count+'" id="expense_type_name'+row_count+'" value="" class="boxtext" style="width:90%" readonly> <span class="input-group-addon icon-ellipsis" onClick="open_expense_allowance('+row_count+');"></span></div></div>';
                    </cfcase>
                    <cfcase value="1">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.setAttribute("id","expense_date" + row_count + "_td");
                        newCell.innerHTML = '<input type="text" name="expense_date' + row_count +'" id="expense_date' + row_count +'" class="text" maxlength="10" style="width:75px;" value="' +expense_date +'"> ';
                        wrk_date_image('expense_date' + row_count);
                    </cfcase>
                    <cfcase value="2">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"><input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:140px;" class="boxtext" value="'+row_detail+'"></div>';
                    </cfcase>
                    <cfcase value="3">
                        <cfif x_is_project_priority eq 0>
                            <cfif xml_expense_center_is_popup eq 1>
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.setAttribute("nowrap","nowrap");
                                newCell.innerHTML =' <div class="form-group"> <div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center+'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="AutoComplete_Create(\'expense_center_name' + row_count +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'0,<cfif isDefined("x_authorized_branch_department") and x_authorized_branch_department eq 1>1<cfelse>0</cfif>\',\'EXPENSE_ID\',\'expense_center_id' + row_count +'\',\'add_costplan\',1);" value="'+exp_center_name+'" style="width:184px;" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_exp('+ row_count +');"></span></div></div>';
                            <cfelse>
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.setAttribute("nowrap","nowrap");
                                a = ' <div class="form-group"><select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" <cfif xml_expense_center_budget_item eq 1>onChange="ShowBudgetItems('+ row_count +');" </cfif> style="width:200px;" class="boxtext"><option value=""><cf_get_lang_main no='1048.Masraf Merkezi'></option>';
                                <cfoutput query="get_expense_center">
                                    if('#expense_id#' == exp_center)
                                        a += '<option value="#expense_id#" selected>#replace(expense,"'","\'")#</option>';
                                    else
                                        a += '<option value="#expense_id#">#replace(expense,"'","\'")#</option>';
                                </cfoutput>
                                newCell.innerHTML =a+ '</select></div>';
                            </cfif>
                        </cfif>
                    </cfcase>
                    <cfcase value="4">
                        <cfif x_is_project_priority eq 0>
                            <cfif xml_expense_center_is_popup eq 1>
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.setAttribute("nowrap","nowrap");
                                newCell.innerHTML =' <div class="form-group"> <div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item+'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item_name+'" style="width:233px;" onFocus="AutoComplete_Create(\'expense_item_name' + row_count +'\',\'EXPENSE_ITEM_NAME\',\'EXPENSE_ITEM_NAME\',\'get_expense_item\',\'<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>\',\'EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE\',\'expense_item_id' + row_count +',account_code' + row_count +',tax_code' + row_count +'\',\'add_costplan\',1);"  class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('+ row_count +',<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>);"></span></div></div>';
                            <cfelse>
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.setAttribute("nowrap","nowrap");
                                a = ' <div class="form-group"><select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="boxtext"><option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>';
                                <cfoutput query="get_expense_item">
                                    if('#expense_item_id#' == exp_item)
                                        a += '<option value="#expense_item_id#" selected>#replace(expense_item_name,"'","\'")#</option>';
                                    else
                                        a += '<option value="#expense_item_id#">#replace(expense_item_name,"'","\'")#</option>';
                                </cfoutput>
                                newCell.innerHTML =a+ '</select></div>';
                            </cfif>
                        </cfif>
                    </cfcase>
                    <cfcase value="5">	
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"> <div class="input-group"><input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+exp_product_id+'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+exp_stock_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name'+ row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product\',\'0\',\'STOCK_ID,PRODUCT_ID,PRODUCT_NAME\',\'stock_id' + row_count +',product_id' + row_count +',product_name'+ row_count +'\',\'\',3,150);" maxlength="50" style="width:150px;" <!--- onFocus="hesapla(' + row_count +');"  --->value="'+exp_product_name+'">'+'<span class="input-group-addon icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=all.product_id" + row_count + "&field_id=all.stock_id" + row_count + "&field_product_cost=all.total"+row_count +"&field_unit_name= all.stock_unit"+row_count +"&field_unit= all.stock_unit_id"+row_count+"&run_function=hesapla&run_function_param="+row_count+"&expense_date='+document.all.expense_date.value+'&field_name=all.product_name" + row_count + "','list');"+'"></span>'+ '<span class="input-group-addon" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_detail_product</cfoutput>&pid='+document.getElementById('product_id"+row_count+"').value+'&sid='+document.getElementById('stock_id"+row_count+"').value+'','list');"+'"><img src="/images/plus_thin_p.gif" border="0" align="absbottom" alt="<cf_get_lang no="458.Ürün Detay">" style="display:none;" id="product_info'+row_count+'"></span></div></div>';
                    </cfcase>
                    <cfcase value="6">	
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"><input type="hidden" name="stock_unit_id' + row_count +'" id="stock_unit_id' + row_count +'" value="'+exp_stock_unit_id+'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'"  value="'+exp_stock_unit+'" style="width:90px;" class="boxtext" readonly></div>';
                    </cfcase>
                    <cfcase value="7">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"><input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" style="width:90px;" class="box" value="'+ commaSplit(1,rate_round_num_)+ '" onBlur="hesapla(\'quantity\',' + row_count +');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));"></div>';
                    </cfcase>
                    <cfcase value="8">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"><input type="text" name="total' + row_count +'"  id="total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;" onBlur="hesapla(\'total\',' + row_count +');" class="box"></div>';
                    </cfcase>
                    <cfcase value="9">
                        newCell = newRow.insertCell(newRow.cells.length);
                        xx = ' <div class="form-group"><select name="tax_rate'+ row_count +'" id="tax_rate'+ row_count +'" style="width:100%;" class="box" onChange="hesapla(\'tax_rate\','+ row_count +');">';
                        <cfoutput query="get_tax">
                        if('#tax#' == exp_tax_rate)
                            xx += '<option value="#tax#" selected>#tax#</option>';
                        else
                            xx += '<option value="#tax#">#tax#</option>';
                        </cfoutput>
                        newCell.innerHTML =xx + '</select></div>';
                    </cfcase>
                    <cfcase value="10">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"><input type="text" name="kdv_total'+ row_count +'" id="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;;" onBlur="hesapla(\'kdv_total\',' + row_count +',1);" class="box"></div>';
                    </cfcase>
                    <cfcase value="11">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"><input type="text" name="net_total' + row_count +'" id="net_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;;" onBlur="hesapla(\'net_total\',' + row_count +',2);" class="box"></div>';
                    </cfcase>
                    <cfcase value="12">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        yy = ' <div class="form-group"><select name="money_id' + row_count  +'" id="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="other_calc('+ row_count +');">';
                        <cfoutput query="get_money">
                            if('#money#,#rate1#,#rate2#' == exp_money_id)
                                yy += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
                            else
                                yy += '<option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>';
                        </cfoutput>
                        newCell.innerHTML =yy+ '</select></div>';
                    </cfcase>
                    <cfcase value="13">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"><input type="text" name="other_net_total' + row_count +'" id="other_net_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;" class="box" onBlur="other_calc('+row_count+',2);"></div>';
                    </cfcase>
                    <cfcase value="14">	
                        newCell = newRow.insertCell(newRow.cells.length);
                        a = ' <div class="form-group"><select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:90px;" class="boxtext"><option value=""><cf_get_lang no='777.Aktivite Tipi'></option>';
                        <cfoutput query="get_activity_types">
                            if('#activity_id#' == activity)
                                a += '<option value="#activity_id#" selected>#activity_name#</option>';
                            else
                                a += '<option value="#activity_id#">#activity_name#</option>';
                        </cfoutput>
                        newCell.innerHTML =a+ '</select></div>';
                    </cfcase>
                    <cfcase value="15">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"> <div class="input-group"><input type="hidden" name="work_id' + row_count +'" id="work_id'+ row_count +'" value="'+row_work_id+'"><input type="text" name="work_head' + row_count +'" id="work_head'+ row_count +'" value="'+row_work_head+'" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,200,\'\');" style="width:139px;" class="boxtext">';
                        newCell.innerHTML +='<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_work('+ row_count +');"></span></div></div>';
                    </cfcase>
                    <cfcase value="16">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = ' <div class="form-group"><div class="form-group"><input type="hidden" name="opp_id' + row_count +'" id="opp_id'+ row_count +'" value="'+exp_opp_id+'"><input type="text" name="opp_head' + row_count +'" id="opp_head'+ row_count +'" value="'+exp_opp_head+'" onFocus="AutoComplete_Create(\'opp_head'+ row_count +'\',\'OPP_HEAD\',\'OPP_HEAD\',\'get_opportunity\',\'\',\'OPP_ID\',\'opp_id'+ row_count +'\',\'\',3,200,\'\');" style="width:110px;" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_oppotunity('+ row_count +');"></span></div></div>';
                    </cfcase>
                    <cfcase value="17">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<div class="form-group"><div class="col col-6 col-md-6 col-sm-6 col-xs-6"><input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+exp_member_type+'"><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value="'+exp_member_id+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+exp_company_id+'"><input type="text" style="width:110px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+exp_authorized+'" class="boxtext" onFocus="auto_company('+ row_count +');" autocomplete="off">&nbsp;</div><div class="col col-6 col-md-6 col-sm-6 col-xs-6"><div class="input-group"><input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="'+exp_company+'"  style="width:110px;" class="boxtext" readonly><span class="input-group-addon icon-ellipsis"" onClick="pencere_ac_company('+ row_count +');"></a></div></div></div>';
                    </cfcase>
                    <cfcase value="18">
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value="'+exp_asset_id+'"><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="'+exp_asset+'" style="width:120px;" class="boxtext" onFocus="autocomp_assetp('+ row_count +');"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_asset('+ row_count +');"></span></div></div>';
                    </cfcase>
                    <cfcase value="19">	
                        newCell = newRow.insertCell(newRow.cells.length);
                        newCell.setAttribute("nowrap","nowrap");
                        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+exp_project_id+'"><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="'+exp_project+'" style="width:120px;" class="boxtext" onFocus="AutoComplete_Create(\'project'+ row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID\',\'project_id'+ row_count +'\',\'\',3,200,\'\');"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
                    </cfcase>
                </cfswitch>
            </cfloop>
        }
        function ShowBudgetItems(no)    
        {			
            for ( var i= $('#expense_item_id'+no+' option').length-1 ; i>-1 ; i--)
                {				
                    $('#expense_item_id'+no+' option')[i].remove();					
                }
                my_val = $("#expense_center_id"+no).val();
                var sql = 'SELECT EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,EXPENSE_ITEMS.EXPENSE_ITEM_NAME FROM EXPENSE_CENTER,EXPENSE_CENTER_ROW LEFT JOIN EXPENSE_ITEMS ON EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID WHERE EXPENSE_CENTER.EXPENSE_ID = EXPENSE_CENTER_ROW.EXPENSE_ID AND EXPENSE_CENTER_ROW.EXPENSE_ID = ' + my_val;
                get_expense_item = wrk_query(sql,'dsn2');			
                if(get_expense_item.recordcount > 0)
                {
                    var selectBox = $('#expense_item_id'+no+'').attr('disabled');
                    if(selectBox) $('#expense_item_id'+no+'').removeAttr('disabled');
                    $('#expense_item_id'+no+'').append($("<option></option>").attr("value", '').text( "Seçiniz !" ));
                    for(i = 1;i<=get_expense_item.recordcount;++i)
                    {
                        $('#expense_item_id'+no+'').append($("<option></option>").attr("value", get_expense_item.EXPENSE_ITEM_ID[i-1]).text(get_expense_item.EXPENSE_ITEM_NAME[i-1]));
                    } 
                }   
        } 
        function autocomp_assetp(no)
        {
            <cfif isdefined("xml_exp_center_from_assetp") and xml_exp_center_from_assetp eq 1>
                AutoComplete_Create('asset'+ row_count +'','ASSETP','ASSETP','get_assetp_autocomplete','\'\',1','ASSETP_ID,EMPLOYEE_ID,EMP_NAME,MEMBER_TYPE,EXPENSE_CENTER_ID,EXPENSE_CODE_NAME','asset_id'+no+',member_id'+no+',authorized'+no+',member_type'+no+',expense_center_id'+no+'','',3,130);
            <cfelse>
                AutoComplete_Create('asset'+ row_count +'','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID','asset_id'+no+'',3,130);
            </cfif>
        }
        function auto_company(no)
        {
            AutoComplete_Create('authorized'+no,'MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_NAME2','member_type'+no+',member_id'+no+',company_id'+no+',company'+no+'','','3','250');
        }
        function autocomp_expense_item(no) 
        {
            AutoComplete_Create('expense_item_name' + row_count +'','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>,1,\'' + GetExpenseId(row_count) +'\'','EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE','expense_item_id' + row_count +',account_code' + row_count +',tax_code' + row_count +'','add_costplan',1);		
        }
        function GetExpenseId(no)
        {
            return document.getElementById("expense_center_id" + no).value;
        }
        function pencere_ac_oppotunity(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_opportunities&field_opp_id=all.opp_id' + no +'&field_opp_head=all.opp_head' + no ,'list');
        }
        function pencere_detail_work(no)
        {	
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=project.works&event=det&id='+eval("document.all.work_id"+no).value,'list');
        }
        function pencere_ac_work(no)
        {
            p_id_ = document.getElementById("project_id" + no).value;
            p_name_ = document.getElementById("project" + no).value;
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=all.work_id' + no +'&field_name=all.work_head' + no +'&project_id=' + p_id_ + '&project_head=' + p_name_ +'&field_pro_id=all.project_id' +no + '&field_pro_name=all.project' +no,'list');
        }
        function pencere_ac_company(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=all.member_id' + no +'&field_emp_id=all.member_id' + no +'&field_comp_name=all.company' + no +'&field_name=all.authorized' + no +'&field_comp_id=all.company_id' + no + '&field_type=all.member_type' + no + '&select_list=1,2,3,5,6','list');
        }
        function pencere_ac_asset(no)
        {
            adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps';
            adres += '&field_id=all.asset_id' + no +'&field_name=all.asset' + no +'&event_id=0&motorized_vehicle=0';
            <cfif x_is_add_position_to_asset_list eq 1>
                adres += '&member_type=all.member_type' + no;
                adres += '&employee_id=all.member_id' + no;
                adres += '&position_employee_name=all.authorized' + no;	
            </cfif>
            <cfif isdefined("xml_exp_center_from_assetp") and xml_exp_center_from_assetp eq 1>
                adres += '&exp_center_id=all.expense_center_id' + no;	
            </cfif>
            windowopen(adres,'list');
        }
        function pencere_ac_project(no)
        {
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=all.project_id' + no +'&project_head=all.project' + no);
        }
        function pencere_ac_campaign(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_campaigns&field_id=all.campaign_id' + no +'&field_name=all.campaign' + no,'list');
        }
        <cfoutput>
        function hesapla(field_name,satir,hesap_type,extra_type)
        {
            if(satir == undefined)
            {
                satir = field_name;
                field_name = 'total';
            }
            if(field_name != '' && field_name != 'product_id' && field_name != 'product_name')
            {
                var input_name_ = field_name+satir;
                field_changed_value = filterNum(document.getElementById(input_name_).value,'#session.ep.our_company_info.rate_round_num#');
            }
            else
                field_changed_value = '-1';
            if(field_changed_value == '-1' || document.getElementById("control_field_value") == undefined || (document.getElementById("control_field_value") != undefined && field_changed_value != document.getElementById("control_field_value").value))
            {
                var toplam_dongu_0 = 0;//satir toplam
                if(document.getElementById('row_kontrol'+satir).value==1)
                {
                    deger_total = document.getElementById('total'+satir);//tutar
                    deger_kdv_total= document.getElementById('kdv_total'+satir);//kdv tutarı
                    deger_net_total = document.getElementById('net_total'+satir);//kdvli tutar
                    deger_tax_rate = document.getElementById('tax_rate'+satir);//kdv oranı
                    if(document.getElementById('quantity'+satir) != undefined) 
                        deger_quantity =  document.getElementById('quantity'+satir).value; 
                    else 
                        deger_quantity ="";//miktar
                    if(document.getElementById("other_net_total"+satir) != undefined) deger_other_net_total = document.getElementById("other_net_total"+satir); else deger_other_net_total="";//dovizli tutar kdv dahil
                    if(deger_total.value == "") deger_total.value = 0;
                    if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
                    if(deger_net_total.value == "") deger_net_total.value = 0;
                    deger_money_id = document.getElementById('money_id'+satir);
                    deger_money_id =  list_getat(deger_money_id.value,1,',');
                    for(s=1;s<=add_costplan.kur_say.value;s++)
                    {
                        money_deger =list_getat(add_costplan.rd_money[s-1].value,1,',');
                        if(money_deger == deger_money_id)
                        {
                            deger_diger_para_satir = document.add_costplan.rd_money[s-1];
                            form_value_rate_satir = document.getElementById('txt_rate2_'+s);
                        }
                    }
                    deger_para_satir = list_getat(deger_diger_para_satir.value,3,',');
                    deger_total.value = filterNum(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
                    if(deger_quantity != "") deger_quantity = filterNum(deger_quantity,'#session.ep.our_company_info.rate_round_num#'); else deger_quantity = 1;
                    deger_kdv_total.value = filterNum(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
                    deger_net_total.value = filterNum(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
                    if(document.getElementById('other_net_total'+satir) != undefined)
                        deger_other_net_total.value = filterNum(deger_other_net_total.value,'#session.ep.our_company_info.rate_round_num#');
                    if(hesap_type == undefined)
                    {
                        if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity) * deger_tax_rate.value)/100;
                    }
                    else if(hesap_type == 2)
                    {
                        deger_total.value = ((parseFloat(deger_net_total.value)/ parseFloat(deger_quantity))*100) / (parseFloat(deger_tax_rate.value)+100);
                        deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity * deger_tax_rate.value))/100;
                    }
                    toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity);
                    if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
                    //if(document.getElementById('other_net_total'+satir) != undefined) deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
                    if(extra_type != 2)
                        if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
                    deger_net_total.value = commaSplit(toplam_dongu_0,'#session.ep.our_company_info.rate_round_num#');
                    deger_total.value = commaSplit(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
                    deger_quantity = commaSplit(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
                    
                    deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
                    if(document.getElementById('other_net_total'+satir) != undefined)
                        deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#session.ep.our_company_info.rate_round_num#');
                }
                if(extra_type == 2 || extra_type == undefined)
                    toplam_hesapla(extra_type);
            }
        }
        function toplam_hesapla(type)
        {
            var toplam_dongu_1 = 0;//tutar genel toplam
            var toplam_dongu_2 = 0;// kdv genel toplam
            var toplam_dongu_3 = 0;// kdvli genel toplam
            if(type != 2)
                doviz_hesapla();
            for(r=1;r<=add_costplan.record_num.value;r++)
            {
                if(document.getElementById('row_kontrol'+r).value==1)
                {
                    deger_total = document.getElementById('total'+r);//tutar
                    deger_quantity =  document.getElementById('quantity'+r).value; //miktar
                    deger_kdv_total= document.getElementById('kdv_total'+r);//kdv tutarı
                    deger_net_total = document.getElementById('net_total'+r);//kdvli tutar
                    deger_tax_rate = document.getElementById('tax_rate'+r);//kdv oranı
                    if(document.getElementById('other_net_total'+r) != undefined) deger_other_net_total = document.getElementById('other_net_total'+r); else deger_other_net_total="";//dovizli tutar kdv dahil
                    deger_total.value = filterNum(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
                    deger_quantity = filterNum(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
                    deger_kdv_total.value = filterNum(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
                    deger_net_total.value = filterNum(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
                    toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_quantity);
                    toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
                    toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_quantity) + parseFloat(deger_kdv_total.value));
                    deger_net_total.value = commaSplit(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
                    deger_quantity = commaSplit(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
                    deger_total.value = commaSplit(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
                    deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
                }
            }
            document.add_costplan.total_amount.value = commaSplit(toplam_dongu_1,'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.kdv_total_amount.value = commaSplit(toplam_dongu_2,'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.net_total_amount.value = commaSplit(toplam_dongu_3,'#session.ep.our_company_info.rate_round_num#');
            for(s=1;s<=add_costplan.kur_say.value;s++)
            {
                form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
                if(form_txt_rate2_.value == "")
                    form_txt_rate2_.value = 1;
            }
            if(add_costplan.kur_say.value == 1)
                for(s=1;s<=add_costplan.kur_say.value;s++)
                {
                    if(document.add_costplan.rd_money[s-1].checked == true)
                    {
                        deger_diger_para = document.add_costplan.rd_money;
                        form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
                    }
                }
            else 
                for(s=1;s<=add_costplan.kur_say.value;s++)
                {
                    if(document.add_costplan.rd_money[s-1].checked == true)
                    {
                        deger_diger_para = document.add_costplan.rd_money[s-1];
                        form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
                    }
                }
            deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
            deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
            deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
            form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
        
            document.add_costplan.tl_value1.value = deger_money_id_1;
            document.add_costplan.tl_value2.value = deger_money_id_1;
            document.add_costplan.tl_value3.value = deger_money_id_1;
            form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
        }
        function doviz_hesapla()
        {
            for(k=1;k<=add_costplan.record_num.value;k++)
            {		
                deger_money_id = document.getElementById('money_id'+k);
                deger_money_id =  list_getat(deger_money_id.value,1,',');
                for (var t=1; t<=add_costplan.kur_say.value; t++)
                {
                money_deger =list_getat(add_costplan.rd_money[t-1].value,1,',');
                if(money_deger == deger_money_id)	
                    {		
                        rate2_value = filterNum(document.getElementById('txt_rate2_'+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
                        if(document.getElementById('other_net_total'+k) != undefined)
                            document.getElementById('other_net_total'+k).value = commaSplit(filterNum(document.getElementById('net_total'+k).value,'#session.ep.our_company_info.rate_round_num#')/rate2_value,'#session.ep.our_company_info.rate_round_num#');
                    }
                }
            }
        }
        record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
        row_count_ilk = row_count;
        function unformat_fields()
        {
            for(r=1;r<=add_costplan.record_num.value;r++)
            {
                document.getElementById('total'+r).value = filterNum(document.getElementById('total'+r).value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('kdv_total'+r).value = filterNum(document.getElementById('kdv_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('net_total'+r).value = filterNum(document.getElementById('net_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
                if(document.getElementById('other_net_total'+r) != undefined)
                    document.getElementById('other_net_total'+r).value = filterNum(document.getElementById('other_net_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('quantity'+r).value = filterNum(document.getElementById('quantity'+r).value,'#session.ep.our_company_info.rate_round_num#');	
            }
            document.add_costplan.total_amount.value = filterNum(document.add_costplan.total_amount.value,'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.kdv_total_amount.value = filterNum(document.add_costplan.kdv_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.net_total_amount.value = filterNum(document.add_costplan.net_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.other_total_amount.value = filterNum(document.add_costplan.other_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.other_kdv_total_amount.value = filterNum(document.add_costplan.other_kdv_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
            document.add_costplan.other_net_total_amount.value = filterNum(document.add_costplan.other_net_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
            
            for(s=1;s<=add_costplan.kur_say.value;s++)
            {
                document.getElementById('txt_rate2_'+s).value = filterNum(document.getElementById('txt_rate2_'+s).value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('txt_rate1_'+s).value = filterNum(document.getElementById('txt_rate1_'+s).value,'#session.ep.our_company_info.rate_round_num#');
            }
            <cfif not (browserdetect() contains 'MSIE') or (browserdetect() contains 'MSIE' and browserdetect() contains '9.')>
                for(i=1;i<=document.all.record_num.value;i++)
                {
                    var satir_ = i;
                    document.add_costplan.appendChild(eval("document.all.row_kontrol" + satir_));
                    document.add_costplan.appendChild(eval("document.all.row_detail" + satir_));
                    document.add_costplan.appendChild(eval("document.all.expense_center_id" + satir_));
                    document.add_costplan.appendChild(eval("document.all.expense_item_id" + satir_));
                    if(document.getElementById('product_id'+satir_) != undefined)
                    {
                        document.add_costplan.appendChild(eval("document.all.product_id" + satir_));
                        document.add_costplan.appendChild(eval("document.all.stock_id" + satir_));
                        document.add_costplan.appendChild(eval("document.all.product_name" + satir_));
                    }
                    if(document.getElementById('stock_unit'+satir_) != undefined)
                    {
                        document.add_costplan.appendChild(eval("document.all.stock_unit" + satir_));
                        document.add_costplan.appendChild(eval("document.all.stock_unit_id" + satir_));
                    }
                    document.add_costplan.appendChild(eval("document.all.quantity" + satir_));
                    if(document.getElementById('total'+satir_) != undefined)
                        document.add_costplan.appendChild(eval("document.all.total" + satir_));
                    if(document.getElementById('tax_rate'+satir_) != undefined)
                        document.add_costplan.appendChild(eval("document.all.tax_rate" + satir_));
                    if(document.getElementById('kdv_total'+satir_) != undefined)
                        document.add_costplan.appendChild(eval("document.all.kdv_total" + satir_));
                    if(document.getElementById('net_total'+satir_) != undefined)
                        document.add_costplan.appendChild(eval("document.all.net_total" + satir_));
                    if(document.getElementById('money_id'+satir_) != undefined)
                        document.add_costplan.appendChild(eval("document.all.money_id" + satir_));
                    if(document.getElementById('other_net_total'+satir_) != undefined)
                        document.add_costplan.appendChild(eval("document.all.other_net_total" + satir_));
                    if(document.getElementById('activity_type'+satir_) != undefined)
                        document.add_costplan.appendChild(eval("document.all.activity_type" + satir_));
                    if(document.getElementById('member_type'+satir_) != undefined)
                    {
                        document.add_costplan.appendChild(eval("document.all.member_type" + satir_));
                        document.add_costplan.appendChild(eval("document.all.member_id" + satir_));
                        document.add_costplan.appendChild(eval("document.all.company_id" + satir_));
                        document.add_costplan.appendChild(eval("document.all.authorized" + satir_));
                        document.add_costplan.appendChild(eval("document.all.company" + satir_));
                    }
                    if(document.getElementById('asset_id'+satir_) != undefined)
                    {
                        document.add_costplan.appendChild(eval("document.all.asset_id" + satir_));
                        document.add_costplan.appendChild(eval("document.all.asset" + satir_));
                    }
                    if(document.getElementById('project_id'+satir_) != undefined)
                    {
                        document.add_costplan.appendChild(eval("document.all.project_id" + satir_));
                        document.add_costplan.appendChild(eval("document.all.project" + satir_));
                    }
                    if(eval("document.all.expense_date" + satir_) != undefined)
                        document.add_costplan.appendChild(eval("document.all.expense_date" + satir_));
                    if(eval("document.all.work_id" + satir_) != undefined && eval("document.all.work_head" + satir_) != undefined)
                    {
                        document.add_costplan.appendChild(eval("document.all.work_id" + satir_));
                        document.add_costplan.appendChild(eval("document.all.work_head" + satir_));
                    }
                    if(eval("document.all.opp_id" + satir_) != undefined && eval("document.all.opp_head" + satir_) != undefined)
                    {
                        document.add_costplan.appendChild(eval("document.all.opp_id" + satir_));
                        document.add_costplan.appendChild(eval("document.all.opp_head" + satir_));
                    }
                }
            </cfif>
        }
        </cfoutput>
        function approve_control()
        {
            //Belge Acikken Masraf Yonetiminden Onaylanabilir, Bu Durumda Kontrol Edilerek Guncelleme Yapilmasini Engeller
            <cfif ListFirst(attributes.fuseaction,'.') is 'myhome'>
            var get_approve_control = wrk_safe_query("obj_expense_request_approve_control","dsn2",1,document.getElementById("request_id").value);
            if(get_approve_control.IS_APPROVE != "" && get_approve_control.IS_APPROVE == 1)
            {
                alert("Talep Onaylanmıştır, Belge Üzerinde İşlem Yapamazsınız. Lüften Sayfayı Yenileyiniz!");
                return false;	
            }
            else if(get_approve_control.IS_APPROVE != "" && get_approve_control.IS_APPROVE == 0)
            {
                alert("Talep Reddedilmiştir, Belge Üzerinde İşlem Yapamazsınız. Lüften Sayfayı Yenileyiniz!");
                return false;	
            }
            </cfif>
            return true;
        }
        function kontrol()
        {
            if(document.getElementById('paper_number').value == "")
            {
                alert("Lütfen Belge Numarası Giriniz!");
                return false;
            }
            if(add_costplan.expense_date.value == "")
            {
                alert("<cf_get_lang no='1064.Lütfen Harcama Tarihi Giriniz'>");
                return false;
            }
            record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
            for(r=1;r<=add_costplan.record_num.value;r++)
            {
                deger_row_kontrol =  document.getElementById('row_kontrol'+r);
                deger_expense_center_id = document.getElementById('expense_center_id'+r);
                deger_expense_item_id = document.getElementById('expense_item_id'+r);
                deger_total = document.getElementById('total'+r);
                deger_row_detail = document.getElementById('row_detail'+r);
                if(document.getElementById('work_head'+r) != undefined) work_name = document.getElementById('work_head'+r).value; else work_name = "";
                if(document.getElementById("project_id"+r) != undefined) deger_project = document.getElementById("project_id"+r).value;
                if(document.getElementById("project"+r) != undefined) project_name = document.getElementById("project"+r).value;
                if(document.getElementById("work_id"+r) != undefined) deger_work = document.getElementById("work_id"+r).value;
        
                if(deger_row_kontrol.value == 1)
                {
                    record_exist=1;
                    if (document.getElementById('expense_date'+r)!= undefined && document.getElementById('expense_date'+r).value == "")
                    { 
                        alert ("<cf_get_lang_main no='810.Lütfen Tarih giriniz'>");
                        return false;
                    }
                    <cfif x_is_project_priority eq 1>
                        if (deger_project == "" || project_name == "")
                        { 
                            alert ("Lütfen Proje Seçiniz !");
                            return false;
                        }
                        var get_proje_ = wrk_safe_query("obj_get_project_period","dsn3","1",deger_project);
                        var proje_record_ = get_proje_.recordcount;
                        if(proje_record_<1 || get_proje_.EXPENSE_CENTER_ID =='' || get_proje_.EXPENSE_CENTER_ID==undefined)
                        {
                            alert("Proje Masraf Merkezi Bulunamadı!");
                            return false;
                        }
                        else
                        {
                            document.getElementById("expense_center_id"+r).value = get_proje_.EXPENSE_CENTER_ID;
                        }
                        if(proje_record_<1 || get_proje_.EXPENSE_ITEM_ID =='' || get_proje_.EXPENSE_ITEM_ID==undefined)
                        {
                            alert("Proje Gider Kalemi Bulunamadı !");
                            return false;
                        }
                        else
                        {
                            document.getElementById("expense_item_id"+r).value = get_proje_.EXPENSE_ITEM_ID;
                        }			
                    </cfif>
                    <cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),2) and x_is_project_priority eq 0>
                        if (deger_expense_center_id.value == "")
                        { 
                            alert ("<cf_get_lang no='1069.Lütfen Masraf Merkezi Seçiniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
                            return false;
                        }
                    </cfif>
                    <cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),3) and x_is_project_priority eq 0>
                        if (deger_expense_item_id.value == "")
                        { 
                            alert ("<cf_get_lang no='1071.Lütfen Gider Kalemi Seçiniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
                            return false;
                        }	
                    </cfif>
                    if (deger_row_detail.value == "")
                    { 
                        alert ("<cf_get_lang no='1073.Lütfen Açıklama Giriniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
                        return false;
                    }	
                    if (filterNum(deger_total.value) == 0 || deger_total.value == "")
                    { 
                        alert ("<cf_get_lang_main no='1738.Lütfen Tutar giriniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
                        return false;
                    }
                    if(document.getElementById("xml_select_project").value ==1) {		
                        if (deger_project == "" || project_name == "")
                        { 
                            alert ("Lütfen Proje Seçiniz !");
                            return false;
                        }	
                    }	
                    if(document.getElementById("xml_select_work").value ==1) {
                        if (deger_work == "" || work_name == "")
                        { 
                            alert ("Lutfen İş Seçiniz !");
                            return false;
                        }
                    }			
                }
            }
            if (record_exist == 0) 
            {
                alert("<cf_get_lang no='1432.Lütfen Satır Ekleyiniz'>");
                return false;
            }
            unformat_fields();
            return true;
            
        }
        <cfif x_is_show_paymethod eq 1>
            change_due_date();
        </cfif>
        function change_due_date(type)
        {
            if (type==1)
                document.getElementById("basket_due_value").value = datediff(document.getElementById("expense_date").value,document.getElementById("basket_due_value_date_").value,0);
            else
            {
                if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
                    document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,document.getElementById("expense_date").value);
                else
                    document.getElementById("basket_due_value_date_").value = document.getElementById("expense_date").value;
            }
        }
        <cfoutput>
            function other_calc(row_info,type_info)
            {
                if(row_info != undefined)
                {
                    if(document.getElementById('row_kontrol'+row_info).value==1)
                    {
                        deger_money_id = list_getat(document.getElementById('money_id'+row_info).value,1,',');
                        for(kk=1;kk<=document.add_costplan.kur_say.value;kk++)
                        {
                            money_deger =list_getat(document.all.rd_money[kk-1].value,1,',');
                            if(money_deger == deger_money_id)
                            {
                                deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
                                form_value_rate_satir = document.getElementById('txt_rate2_'+kk);
                            }
                        }
                        /* if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#'); */
                        if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#')*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
                        if(document.getElementById("other_net_total"+row_info) != undefined ) document.getElementById("other_net_total"+row_info).value = commaSplit(filterNum(document.getElementById("other_net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
                        if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#');
                    }
                    if(type_info==undefined)
                        hesapla('other_net_total',row_info,2);
                    else
                        hesapla('other_net_total',row_info,2,type_info);
                }
                else
                {
                    for(yy=1;yy<=document.add_costplan.record_num.value;yy++)
                    {	
                        if(document.getElementById('row_kontrol'+yy).value==1)
                        {
                            other_calc(yy,1);
                        }
                    }
                    toplam_hesapla();
                }
            }
            function pencere_ac_exp(no)
            {
                <cfif isdefined("x_authorized_branch_department") and x_authorized_branch_department eq 1>
                    var xml_deger = 1;
                <cfelse>
                    var xml_deger = 0;
                </cfif>
                windowopen('#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&x_authorized_branch_department='+xml_deger+'&field_id=all.expense_center_id' + no +'&field_name=all.expense_center_name' + no,'list');
                document.getElementById("expense_item_name"+no).value = "";
            }
            function pencere_ac_item(no,inc)
            {
                <cfif xml_expense_center_budget_item eq 1><!--- xml'e bağlı olarak masraf/gelir merkezine bağlı bütçe kalemleri ilişkisi kurulsun. MK 011019 --->
                    var exp_center_id_ = "";
                    var exp_center_name_ = "";
                    if (document.getElementById("expense_center_id"+no) != undefined && document.getElementById("expense_center_id"+no).value != ''  && document.getElementById("expense_center_name"+no).value != '')
                    {					
                        exp_center_id_ = document.getElementById("expense_center_id"+no).value;
                        exp_center_name_ = document.getElementById("expense_center_name"+no).value;
                    }
                    else
                        {
                            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'>!");
                            document.getElementById("expense_center_id"+no).focus();
                            return false;
                        }
                    if(inc == 1) inc_ = "&is_income=1"; else inc_ = "";
                    windowopen('#request.self#?fuseaction=objects.popup_list_exp_item&is_exp=1&field_id=all.expense_item_id' + no +'&field_name=all.expense_item_name' + no + inc_ +'&expense_center_id='+exp_center_id_+'&expense_center_name='+exp_center_name_,'list');
                <cfelse>
                    if(inc == 1) inc_ = "&is_income=1"; else inc_ = "";
                    windowopen('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id' + no +'&field_name=all.expense_item_name' + no + inc_,'list');
                </cfif>
            }
        </cfoutput>
        function open_expense_allowance(no)
        {
            current_expense_employee_id_value = document.getElementById("expense_employee_id").value;
            if (current_expense_employee_id_value === undefined || current_expense_employee_id_value == "") {
                alert("<cf_get_lang dictionary_id="31905.Lütfen çalışan seçiniz">");
                return;
            }
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_allowance_rules&field_id=expense_type'+no+'&field_money_type=money_id'+no+'&field_money_type=money_id'+no+'&field_name=expense_type_name'+no+'&field_expense_item_id=expense_item_id' + no +'<cfif xml_expense_center_is_popup eq 1>&field_expense_item_name=expense_item_name' + no +'</cfif>&field_expense_center_id=expense_center_id' + no +'<cfif xml_expense_center_is_popup eq 1>&field_expense_center_name=expense_center_name' + no +'</cfif>&field_expense_total=other_net_total'+no+'&call_function=other_calc('+no+',2)&employee_id=' + current_expense_employee_id_value,'list');

        }
        function load_travel(){
            employee_id = document.getElementById("expense_employee_id").value;
            var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ajax_employee_travel&employee_id="+employee_id<cfif isdefined('attributes.travel_demand_id') and len(attributes.travel_demand_id)>+"&travel_demand_id="+<cfoutput>#attributes.travel_demand_id#</cfoutput></cfif>;
            AjaxPageLoad(send_address,'aksiyon_div',1,'İlişkili Departmanlar');
        }
        function submit_expense_allowance(type){
            if(confirm('<cf_get_lang dictionary_id="59592.Harcırah oluşturmak istediğinizden emin misiniz?">'))
            {
                if(type != 1)
                    type = 0;
                unformat_fields();
                $("#add_costplan").attr("action", "<cfoutput>#request.self#?fuseaction=#fuseaction_first#.allowance_expense&event=expense</cfoutput>&type="+type)
                $("#add_costplan").submit();
            }
            else
            {
                return false;
            }
        }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    