<!---
    File: V16\hr\ehesap\query\create_budget_payroll.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Step Step Payroll
    Create Draft Budget
        
    History:
        
    To Do:

--->
<cftry>
    <cfif isdefined("arguments.payroll_id_list") and len(arguments.payroll_id_list)>
        <cfset employee_payroll_id = arguments.payroll_id_list>
    <cfelse>
        <cfset employee_payroll_id = 0>
    </cfif>
    <cfset payroll_id_list = valuelist(get_puantaj_rows.account_bill_type_)>
    <!--- Muhasebe hesap grupları XML'inde "Proje Bazında Dağılım Yapılsın mı?" seçeneğine balandı. ---->
    <cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
    <cfset get_project_rate = get_fuseaction_property.get_fuseaction_property(
        company_id : session.ep.company_id,
        fuseaction_name : 'ehesap.popup_form_upd_payroll_accounts',
        property_name : 'is_project_acc'
        )
    >
    <cfset budget_cmp = createObject('component','V16.hr.ehesap.cfc.draft_functions')>
    <cfquery name="GET_ACCOUNTS" datasource="#dsn#">
        SELECT    
        
            SS.DEFINITION,
            SS.PAYROLL_ID 
            <cfif isdefined("get_project_rate.PROPERTY_VALUE") and get_project_rate.PROPERTY_VALUE eq 1>
                ,PA.*
            </cfif>
        FROM 
            SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SS
            <cfif isdefined("get_project_rate.PROPERTY_VALUE") and get_project_rate.PROPERTY_VALUE eq 1>
                INNER JOIN PROJECT_ACCOUNT_RATES PA ON PA.ACCOUNT_BILL_TYPE = SS.PAYROLL_ID
            </cfif>
        WHERE
            SS.PAYROLL_ID IN (#payroll_id_list#)
            <cfif isdefined("get_project_rate.PROPERTY_VALUE") and get_project_rate.PROPERTY_VALUE eq 1>
                AND PA.YEAR = #attributes.sal_year#
                AND MONTH=#attributes.SAL_MON#
            </cfif>
    </cfquery>
    <cfset puantaj_act_date = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_))>
    <cfif not GET_ACCOUNTS.recordcount>
        <cfset return_error = "<cf_get_lang dictionary_id='53384.Dönemde Tanımlı Muhasebe Hesap Planı Bulunamadı Lütfen Şirket Hesap Planlarını Tanımlayınız'>">
    </cfif>
    <cfquery name="get_employee_no_accounts" datasource="#new_dsn2#">
        SELECT 
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            EI.START_DATE,
            EI.FINISH_DATE
        FROM 
            #dsn_alias#.EMPLOYEES_IN_OUT EI,
            #dsn_alias#.EMPLOYEES E
        WHERE 
            EI.IN_OUT_ID IN (#in_out_list#) AND 
            EI.IN_OUT_ID NOT IN (SELECT EIOP.IN_OUT_ID FROM #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIOP.ACCOUNT_BILL_TYPE IS NOT NULL AND EIOP.PERIOD_ID = #new_period_id#) AND
            EI.EMPLOYEE_ID = E.EMPLOYEE_ID
        ORDER BY
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
    </cfquery>
    <cfif get_employee_no_accounts.recordcount>
        <cfset return_error = "<cf_get_lang dictionary_id='64481.Çalışanın Muhasebe Hesap Tanımı Bulunmamaktadır'>.">
    </cfif>
    <cfif not get_employee_no_accounts.recordcount and GET_ACCOUNTS.recordcount and return_error eq 1>
        <cflock name="#createUUID()#" timeout="60">
            <cftransaction>
                <cfoutput query="GET_ACCOUNTS">
                    <cfif isdefined("get_project_rate.PROPERTY_VALUE") and get_project_rate.PROPERTY_VALUE eq 1>
                        <cfquery name="get_poject_id" datasource="#new_dsn2#">
                            SELECT RATE,(SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROJECT_ID=PROJECT_ACCOUNT_RATES_ROW.PROJECT_ID) PROJECT_HEAD,* FROM #dsn_alias#.PROJECT_ACCOUNT_RATES_ROW WHERE PROJECT_RATE_ID = #GET_ACCOUNTS.PROJECT_RATE_ID#
                        </cfquery>
                    </cfif>
                    <cfquery name="get_account_rows" datasource="#new_dsn2#">
                        SELECT 
                            PAYROLL_ID, 
                            BUDGET_ITEM, 
                            PUANTAJ_ACCOUNT_DEFINITION, 
                            PUANTAJ_ACCOUNT, 
                            COMMENT_PAY_ID,
                            PUANTAJ_BORC_ALACAK
                        FROM 
                            #dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS 
                        WHERE 
                            BUDGET_ITEM IS NOT NULL AND PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#">
                            AND IS_EXPENSE = 0
                    </cfquery>
                    <cfquery name="get_account_puantaj" dbtype="query">
                        SELECT 
                            *
                        FROM 
                            get_puantaj_rows 
                        WHERE 
                            ACCOUNT_BILL_TYPE = #PAYROLL_ID#
                    </cfquery>
                    <cfset definition_=get_accounts.definition>
                    <cfset list=" ,(,),%,+,.,/,-">
                    <cfset list2="__,__,__,__,__,__,__">
                    <cfset expense_center_item_list = ''>
                    <cfset kontrol_budget = 0>
                    <cfloop query="get_account_puantaj">
                        <cfquery name="get_expense_row" datasource="#new_dsn2#">
                            SELECT EXPENSE_CENTER_ID,RATE,ACTIVITY_TYPE_ID FROM #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD_ROW WHERE IN_OUT_ID = #get_account_puantaj.in_out_id# AND PERIOD_ID = #new_period_id#
                        </cfquery>
                        <cfif len(get_account_puantaj.emp_expense_center) or get_expense_row.recordcount>
                            <cfloop query="get_account_rows">
                                <cfset definition_ = replacelist(get_account_rows.puantaj_account_definition,list,list2)>
                                <cfif get_account_rows.PUANTAJ_BORC_ALACAK eq 0> <!--- Borç --->
                                    <cfset is_income_expense_ = 0>
                                <cfelseif get_account_rows.PUANTAJ_BORC_ALACAK eq 1> <!--- Alacak --->
                                    <cfset is_income_expense_ = 1>
                                <cfelse>
                                    <cfset is_income_expense_ = 0>
                                </cfif>
                                <cfif len(get_account_rows.comment_pay_id)>
                                    <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                        SELECT SUM(#dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT)) AMOUNT_ FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = #get_account_rows.comment_pay_id# AND EMPLOYEE_PUANTAJ_ID=#get_account_puantaj.EMPLOYEE_PUANTAJ_ID#
                                    </cfquery>
                                    <cfif len(get_ext_puantaj.AMOUNT_)>
                                        <cfset amount_total_ = get_ext_puantaj.AMOUNT_>
                                    <cfelse>
                                        <cfset amount_total_ = 0>
                                    </cfif>
                                <cfelse>
                                    <cfset amount_total_ = evaluate("get_account_puantaj.#get_account_rows.puantaj_account#")>
                                </cfif>
                                <cfif is_add_emp_act eq 1><!--- XML Bütçe işlemi çalışan bazında yapılıyorsa --->
                                    <cfif amount_total_ gt 0>
                                        <cfset kontrol_budget = 1>
                                        <cfif len(get_account_puantaj.emp_expense_center)>
                                            <cfscript>
                                                row_detail = '#session.ep.period_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# #get_account_rows.puantaj_account_definition#';
                                                acc_flag = budget_cmp.butceci_hr(
                                                        action_id : attributes.puantaj_id,
                                                        is_income_expense : #is_income_expense_#,
                                                        process_type : 161,
                                                        nettotal : amount_total_,
                                                        other_money_value : amount_total_,
                                                        action_currency : session.ep.money,
                                                        action_table : 'EMPLOYEES_PUANTAJ',
                                                        expense_date : puantaj_act_date,
                                                        expense_center_id : get_account_puantaj.emp_expense_center,
                                                        expense_item_id : get_account_rows.budget_item,
                                                        detail : '#row_detail#',
                                                        branch_id : get_puantaj_branch.branch_id,
                                                        employee_id : get_account_puantaj.employee_id,
                                                        insert_type : 1,
                                                        muhasebe_db:new_dsn2,
                                                        activity_type : get_expense_row.ACTIVITY_TYPE_ID,
                                                        project_id : isdefined("get_poject_id.project_id") ? get_poject_id.project_id : "",
                                                        payroll_id_list : employee_payroll_id
                                                        );
                                            </cfscript>		
                                            <cfif kontrol_budget eq 1 and acc_flag eq 1>
                                                <cfset return_error = 1>
                                            <cfelseif acc_flag neq 0>
                                                <cfset return_error = acc_flag>
                                            </cfif>			
                                        <cfelse>
                                            <cfloop query="get_expense_row">
                                                <cfscript>
                                                    row_detail = '#session.ep.period_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# #get_account_rows.puantaj_account_definition#';
                                                    acc_flag = budget_cmp.butceci_hr(
                                                            action_id : attributes.puantaj_id,
                                                            is_income_expense : #is_income_expense_#,
                                                            process_type : 161,
                                                            nettotal : amount_total_*get_expense_row.rate/100,
                                                            other_money_value : amount_total_*get_expense_row.rate/100,
                                                            action_currency : session.ep.money,
                                                            action_table : 'EMPLOYEES_PUANTAJ',
                                                            expense_date : puantaj_act_date,
                                                            expense_center_id : get_expense_row.expense_center_id,
                                                            expense_item_id : get_account_rows.budget_item,
                                                            detail : '#row_detail#',
                                                            branch_id : get_puantaj_branch.branch_id,
                                                            employee_id : get_account_puantaj.employee_id,
                                                            insert_type : 1,
                                                            muhasebe_db:new_dsn2,
                                                            activity_type : get_expense_row.ACTIVITY_TYPE_ID,
                                                            project_id : isdefined("get_poject_id.project_id") ? get_poject_id.project_id : "",
                                                            payroll_id_list : employee_payroll_id
                                                            );
                                                </cfscript>	
                                                <cfif kontrol_budget eq 1 and acc_flag eq 1>
                                                    <cfset return_error = 1>
                                                <cfelseif acc_flag neq 0>
                                                    <cfset return_error = acc_flag>
                                                </cfif>
                                            </cfloop>
                                        </cfif>
                                    </cfif>
                                <cfelse>
                                    <cfif len(get_account_puantaj.emp_expense_center)>
                                        <cfif not listfind(expense_center_item_list,"#get_account_puantaj.emp_expense_center#_#get_account_rows.budget_item#_#definition_#")>
                                            <cfset expense_center_item_list = listappend(expense_center_item_list,"#get_account_puantaj.emp_expense_center#_#get_account_rows.budget_item#_#definition_#")>
                                        </cfif>
                                        <cfif isdefined("all_total_#get_account_puantaj.emp_expense_center#_#get_account_rows.budget_item#_#definition_#")>
                                            <cfset "all_total_#get_account_puantaj.emp_expense_center#_#get_account_rows.budget_item#_#definition_#" = evaluate("all_total_#get_account_puantaj.emp_expense_center#_#get_account_rows.budget_item#_#definition_#") + amount_total_>
                                        <cfelse>
                                            <cfset "all_total_#get_account_puantaj.emp_expense_center#_#get_account_rows.budget_item#_#definition_#" = amount_total_>
                                        </cfif>
                                        <cfset "is_income_expense_#get_account_puantaj.emp_expense_center#_#get_account_rows.budget_item#_#definition_#" = is_income_expense_>
                                    <cfelse>
                                        <cfloop query="get_expense_row">
                                            <cfif not listfind(expense_center_item_list,"#get_expense_row.expense_center_id#_#get_account_rows.budget_item#_#definition_#")>
                                                <cfset expense_center_item_list = listappend(expense_center_item_list,"#get_expense_row.expense_center_id#_#get_account_rows.budget_item#_#definition_#")>
                                            </cfif>
                                            <cfif isdefined("all_total_#get_expense_row.expense_center_id#_#get_account_rows.budget_item#_#definition_#")>
                                                <cfset "all_total_#get_expense_row.expense_center_id#_#get_account_rows.budget_item#_#definition_#" = evaluate("all_total_#get_expense_row.expense_center_id#_#get_account_rows.budget_item#_#definition_#") + amount_total_*get_expense_row.rate/100>
                                            <cfelse>
                                                <cfset "all_total_#get_expense_row.expense_center_id#_#get_account_rows.budget_item#_#definition_#" = amount_total_*get_expense_row.rate/100>
                                            </cfif>	
                                            <cfset "is_income_expense_#get_expense_row.expense_center_id#_#get_account_rows.budget_item#_#definition_#" = is_income_expense_>
                                        </cfloop>	
                                    </cfif>
                                </cfif>
                            </cfloop>
                        </cfif>
                    </cfloop>
                    <cfif listlen(expense_center_item_list)>
                        <cfloop list="#expense_center_item_list#" index="kk">
                            <cfif isdefined("all_total_#kk#") and len(evaluate("all_total_#kk#")) and evaluate("all_total_#kk#") gt 0>
                                <cfset kontrol_budget = 1>
                                <cfset row_center_id = listfirst(kk,'_')>
                                <cfset row_item_id = listgetat(kk,2,'_')>
                                <cfset row_definition = replacelist(listgetat(kk,3,'_'),list2,list)>
                                <cfset is_income_expense_ = evaluate("is_income_expense_#kk#")>
                                <cfscript>
                                    row_detail = '#session.ep.period_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# #row_definition#';
                                    acc_flag = budget_cmp.butceci_hr(
                                            action_id : attributes.puantaj_id,
                                            is_income_expense : #is_income_expense_#,
                                            process_type : 161,
                                            nettotal : evaluate("all_total_#kk#"),
                                            other_money_value : evaluate("all_total_#kk#"),
                                            action_currency : session.ep.money,
                                            action_table : 'EMPLOYEES_PUANTAJ',
                                            expense_date : puantaj_act_date,
                                            expense_center_id : row_center_id,
                                            expense_item_id : row_item_id,
                                            detail : '#row_detail#',
                                            branch_id : get_puantaj_branch.branch_id,
                                            employee_id : 0,
                                            insert_type : 1,
                                            muhasebe_db:new_dsn2,
                                            project_id:isdefined("get_poject_id.project_id") ? get_poject_id.project_id : "",
                                            payroll_id_list : employee_payroll_id
                                            );
                                    "all_total_#kk#" = 0;
                                </cfscript>
                                <cfif kontrol_budget eq 1 and acc_flag eq 1>
                                    <cfset return_error = 1>
                                <cfelseif acc_flag neq 0>
                                    <cfset return_error = acc_flag>
                                </cfif>
                            </cfif>
                        </cfloop>
                    </cfif>
                    <cfquery name="get_puantaj_ext" datasource="#new_dsn2#"> <!--- Kesintiler PY --->
                        SELECT 
                        EPRE.COMMENT_PAY,
                        SEB.EXPENSE_CENTER_ID,
                        SEB.EXPENSE_ITEM_ID,
                        SUM(	#dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT)) AMOUNT_
                        FROM 
                            #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT EPRE
                            JOIN 	#dsn_alias#.SETUP_PAYMENT_INTERRUPTION SP ON SP.COMMENT_PAY =  EPRE.COMMENT_PAY
                            JOIN 	#dsn_alias#.SETUP_PAYMENT_INTERRUPTION_BUDGET_ACCOUNTS SEB on SEB.ODKES_ID = SP.ODKES_ID
                        WHERE 
                            EPRE.PUANTAJ_ID = #attributes.puantaj_id#
                            AND (EPRE.EXT_TYPE = 1 OR EPRE.EXT_TYPE = 3) 
                            AND sp.COMMENT_PAY <> 'Avans'
                        GROUP BY 
                            EPRE.COMMENT_PAY,
                            SEB.EXPENSE_CENTER_ID,
                            SEB.EXPENSE_ITEM_ID
                    </cfquery>
                    <cfif get_puantaj_ext.recordcount>
                        <cfloop query="get_puantaj_ext">
                            <cfif get_puantaj_ext.amount_ gt 0>
                                <cfset row_center_id = get_puantaj_ext.EXPENSE_CENTER_ID>
                                <cfset row_item_id = get_puantaj_ext.EXPENSE_ITEM_ID>
                                <cfset row_definition =  get_puantaj_ext.COMMENT_PAY>
                                <cfset is_income_expense_ = 1>
                                <cfset ext_total = get_puantaj_ext.AMOUNT_>
                                <cfscript>
                                    row_detail = '#session.ep.period_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# #row_definition#';
                                    acc_flag = budget_cmp.butceci_hr(
                                            action_id : attributes.puantaj_id,
                                            is_income_expense : #is_income_expense_#,
                                            process_type : 161,
                                            nettotal : ext_total,
                                            other_money_value : ext_total,
                                            action_currency : session.ep.money,
                                            action_table : 'EMPLOYEES_PUANTAJ',
                                            expense_date : puantaj_act_date,
                                            expense_center_id : row_center_id,
                                            expense_item_id : row_item_id,
                                            detail : '#row_detail#',
                                            branch_id : get_puantaj_branch.branch_id,
                                            employee_id : 0,
                                            insert_type : 1,
                                            muhasebe_db:new_dsn2,
                                            project_id:isdefined("get_poject_id.project_id") ? get_poject_id.project_id : ""
                                            );
                                    ext_total = 0;
                                </cfscript>
                                <cfif kontrol_budget eq 1 and acc_flag eq 1>
                                    <cfset return_error = 1>
                                <cfelseif acc_flag neq 0>
                                    <cfset return_error = acc_flag>
                              
                                </cfif>
                            </cfif>
                        </cfloop>
                    </cfif>
                    
                    <!--- Harcırah Bordrosu Bütçe İşlemi 20140826--->
                    <cfquery name="get_account_rows" datasource="#new_dsn2#">
                        SELECT 
                            PAYROLL_ID, 
                            BUDGET_ITEM, 
                            PUANTAJ_ACCOUNT_DEFINITION, 
                            PUANTAJ_ACCOUNT, 
                            COMMENT_PAY_ID,
                            PUANTAJ_BORC_ALACAK
                        FROM 
                            #dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS 
                        WHERE 
                            BUDGET_ITEM IS NOT NULL AND PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#">
                            AND IS_EXPENSE = 1
                    </cfquery>
                    <cfquery name="get_expense_puantaj" datasource="#new_dsn2#">
                        SELECT
                            SUM(BRUT_AMOUNT) AS BRUT_AMOUNT,
                            SUM(NET_AMOUNT) AS NET_AMOUNT,
                            SUM(DAMGA_VERGISI) AS DAMGA_VERGISI,
                            SUM(GELIR_VERGISI) AS GELIR_VERGISI,
                            EXPENSE_CENTER_ID,
                            EMPLOYEE_ID,
                            IN_OUT_ID
                        FROM
                            #dsn_alias#.EMPLOYEES_EXPENSE_PUANTAJ
                        WHERE
                            IN_OUT_ID IN(#valuelist(get_puantaj_rows.in_out_id)#) AND
                            YEAR(EXPENSE_DATE) = #get_puantaj_rows.sal_year# AND
                            MONTH(EXPENSE_DATE) = #get_puantaj_rows.sal_mon#
                        GROUP BY
                            EXPENSE_CENTER_ID,
                            EMPLOYEE_ID,
                            IN_OUT_ID
                    </cfquery>
                    <cfset definition_=get_accounts.definition>
                    <cfset list=" ,(,),%,+,.,/">
                    <cfset list2="__,__,__,__,__,__">
                    <cfset expense_center_item_list = ''>
                    <cfset kontrol_budget = 0>
                    <cfloop query="get_expense_puantaj">
                        <cfif len(get_expense_puantaj.expense_center_id)>
                            <cfloop query="get_account_rows">
                                <cfset definition_ = replacelist(get_account_rows.puantaj_account_definition,list,list2)>
                                <cfset amount_total_ = evaluate("get_expense_puantaj.#get_account_rows.puantaj_account#")>
                                <cfif get_account_rows.PUANTAJ_BORC_ALACAK eq 0> <!--- Borç --->
                                    <cfset is_income_expense_ = 0>
                                <cfelseif get_account_rows.PUANTAJ_BORC_ALACAK eq 1> <!--- Alacak --->
                                    <cfset is_income_expense_ = 1>
                                <cfelse>
                                    <cfset is_income_expense_ = 0>
                                </cfif>
                                <cfif is_add_emp_act eq 1><!--- Bütçe işlemi çalışan bazında yapılıyorsa --->
                                    <cfif amount_total_ gt 0>
                                        <cfset kontrol_budget = 1>
                                        <cfif len(get_expense_puantaj.expense_center_id)>
                                            <cfscript>
                                                row_detail = '#session.ep.period_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# #get_account_rows.puantaj_account_definition#';
                                                acc_flag = budget_cmp.butceci_hr(
                                                        action_id : attributes.puantaj_id,
                                                        is_income_expense : #is_income_expense_#,
                                                        process_type : 161,
                                                        nettotal : amount_total_,
                                                        other_money_value : amount_total_,
                                                        action_currency : session.ep.money,
                                                        action_table : 'EMPLOYEES_PUANTAJ',
                                                        expense_date : puantaj_act_date,
                                                        expense_center_id : get_expense_puantaj.expense_center_id,
                                                        expense_item_id : get_account_rows.budget_item,
                                                        detail : '#row_detail#',
                                                        branch_id : get_puantaj_branch.branch_id,
                                                        employee_id : get_expense_puantaj.employee_id,
                                                        insert_type : 1,
                                                        muhasebe_db:new_dsn2,
                                                        project_id:isdefined("get_poject_id.project_id") ? get_poject_id.project_id : "",
                                                        payroll_id_list : employee_payroll_id
                                                        );
                                            </cfscript>	
                                            <cfif kontrol_budget eq 1 and acc_flag eq 1>
                                                <cfset return_error = 1>
                                            <cfelseif acc_flag neq 0>
                                                <cfset return_error = acc_flag>
                                            </cfif>				
                                        </cfif>
                                    </cfif>
                                <cfelse>
                                    <cfif len(get_expense_puantaj.expense_center_id)>
                                        <cfif not listfind(expense_center_item_list,"#get_expense_puantaj.expense_center_id#_#get_account_rows.budget_item#_#definition_#")>
                                            <cfset expense_center_item_list = listappend(expense_center_item_list,"#get_expense_puantaj.expense_center_id#_#get_account_rows.budget_item#_#definition_#")>
                                        </cfif>
                                        <cfif isdefined("all_total_#get_expense_puantaj.expense_center_id#_#get_account_rows.budget_item#_#definition_#")>
                                            <cfset "all_total_#get_expense_puantaj.expense_center_id#_#get_account_rows.budget_item#_#definition_#" = evaluate("all_total_#get_expense_puantaj.expense_center_id#_#get_account_rows.budget_item#_#definition_#") + amount_total_>
                                        <cfelse>
                                            <cfset "all_total_#get_expense_puantaj.expense_center_id#_#get_account_rows.budget_item#_#definition_#" = amount_total_>
                                        </cfif>	
                                        <cfset "is_income_expense_#get_expense_puantaj.expense_center_id#_#get_account_rows.budget_item#_#definition_#" = is_income_expense_>	
                                </cfif>
                                </cfif>
                            </cfloop>
                        </cfif>
                    </cfloop>
                    <cfif listlen(expense_center_item_list)>
                        <cfloop list="#expense_center_item_list#" index="kk">
                            <cfif isdefined("all_total_#kk#") and len(evaluate("all_total_#kk#")) and evaluate("all_total_#kk#") gt 0>
                                <cfset kontrol_budget = 1>
                                <cfset row_center_id = listfirst(kk,'_')>
                                <cfset row_item_id = listgetat(kk,2,'_')>
                                <cfset row_definition = replacelist(listgetat(kk,3,'_'),list2,list)>
                                <cfset is_income_expense_ = evaluate("is_income_expense_#kk#")>
                                <cfscript>
                                    row_detail = '#session.ep.period_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# #row_definition#';
                                    acc_flag = budget_cmp.butceci_hr(
                                            action_id : attributes.puantaj_id,
                                            is_income_expense : #is_income_expense_#,
                                            process_type : 161,
                                            nettotal : evaluate("all_total_#kk#"),
                                            other_money_value : evaluate("all_total_#kk#"),
                                            action_currency : session.ep.money,
                                            action_table : 'EMPLOYEES_PUANTAJ',
                                            expense_date : puantaj_act_date,
                                            expense_center_id : row_center_id,
                                            expense_item_id : row_item_id,
                                            detail : '#row_detail#',
                                            branch_id : get_puantaj_branch.branch_id,
                                            employee_id : 0,
                                            insert_type : 1,
                                            muhasebe_db:new_dsn2,
                                            project_id:isdefined("get_poject_id.project_id") ? get_poject_id.project_id : "",
                                            payroll_id_list : employee_payroll_id
                                            );
                                    "all_total_#kk#" = 0;
                                </cfscript>
                                <cfif kontrol_budget eq 1 and acc_flag eq 1>
                                    <cfset return_error = 1>
                                <cfelseif acc_flag neq 0>
                                    <cfset return_error = acc_flag>
                                </cfif>
                            </cfif>
                        </cfloop>
                    </cfif>
                </cfoutput>
            </cftransaction>
        </cflock>
    </cfif>
    <cfif not (isdefined("acc_flag") and len(acc_flag)) and return_error neq 1>
        <cfset  return_error =return_error>
    <cfelseif not (isdefined("acc_flag") and len(acc_flag))>
        <cfset return_error ="<cf_get_lang dictionary_id='64482.Çalışanın Masraf Merkezi, Gider Kalemlerini Kontrol Ediniz'>!">
    </cfif>
<cfcatch type="any">
    <cfset this.returnResult( status: false, fileid: attributes.in_out_id, message: "", errorMessage: cfcatch) />
</cfcatch>
</cftry>
