<!---
    File: V16\hr\ehesap\query\create_account_payroll.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Step Step Payroll
    Create Draft Account
        
    History:
        
    To Do:

--->
<cftry>
<cfinclude template="../../../invoice/query/control_bill_no.cfm">
<cfset account_cmp = createObject('component','V16.hr.ehesap.cfc.draft_functions')>
<cfif isdefined("arguments.payroll_id_list") and len(arguments.payroll_id_list)>
	<cfset employee_payroll_id = arguments.payroll_id_list>
<cfelse>
	<cfset employee_payroll_id = 0>
</cfif>
<cfset payroll_id_list = valuelist(get_puantaj_rows.account_bill_type_)>
<cfquery name="GET_ACCOUNTS" datasource="#dsn#">
	SELECT 
    	PAYROLL_ID, 
        DEFINITION, 
        RECORD_EMP, 
        UPDATE_EMP, 
        RECORD_IP, 
        UPDATE_IP, 
        RECORD_DATE, 
        UPDATE_DATE 
    FROM 
	    SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF 
    WHERE 
    	PAYROLL_ID IN (#payroll_id_list#)
</cfquery>
<cfif get_accounts.recordcount eq 0>
	<cfset return_error = "<cf_get_lang dictionary_id='59575.Çalışan Muhasebe Tanımları Bulunamadı. Lütfen Kayıtları Kontrol Ediniz'>!">
</cfif>
<cfif get_accounts.recordcount neq 0>
<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
    <cfset action_table = 'EMPLOYEES_PUANTAJ_VIRTUAL'>
    <cfelse>
        <cfset action_table = 'EMPLOYEES_PUANTAJ'>
    </cfif>
    <cfquery name="get_project_rates" datasource="#dsn#">
        SELECT
            PROJECT_ID,
            RATE,
            ACCOUNT_BILL_TYPE
        FROM
            PROJECT_ACCOUNT_RATES PA,
            PROJECT_ACCOUNT_RATES_ROW PAR
        WHERE
            PA.PROJECT_RATE_ID = PAR.PROJECT_RATE_ID
            AND PA.YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
            AND PA.MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
    </cfquery>
    <cfquery name="get_process_type" datasource="#dsn3#">
        SELECT IS_ACCOUNT_GROUP FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_process_cat#">
    </cfquery>
    <cfset puantaj_act_date = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_))>
    <cflock name="#createUUID()#" timeout="60">
        <cftransaction>
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
                    EI.IN_OUT_ID NOT IN (SELECT EIOP.IN_OUT_ID FROM #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIOP.ACCOUNT_BILL_TYPE IS NOT NULL AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">) AND
                    EI.EMPLOYEE_ID = E.EMPLOYEE_ID
                ORDER BY
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME
            </cfquery>
            <cfquery name="get_employee_accounts" datasource="#new_dsn2#">
                SELECT DISTINCT
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME,
                    EI.START_DATE,
                    EI.FINISH_DATE,
                    SA.DEFINITION,
                    EIOP.ACCOUNT_BILL_TYPE
                FROM 
                    #dsn_alias#.EMPLOYEES_IN_OUT EI,
                    #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP,
                    #dsn_alias#.EMPLOYEES E,
                    #dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SA
                WHERE 
                    EI.IN_OUT_ID IN (#in_out_list#) AND 
                    EIOP.ACCOUNT_BILL_TYPE IS NOT NULL AND
                    EIOP.IN_OUT_ID = EI.IN_OUT_ID AND
                    EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
                    EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                    SA.PAYROLL_ID = EIOP.ACCOUNT_BILL_TYPE	
                ORDER BY
                    SA.DEFINITION,
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME
            </cfquery>
            <cfset control_acc_type = 0>
            <cfif xml_control_account_type eq 1 and control_acc_type eq 1><!--- xml de Muhasebe Kod Grubu Tanımlı Olmayan Çalışanlar Kontrol Edilsin mi? evet seçili ve muhasebe kod grubu olmayan çalışan varsa kayıt yapılmaacak --->
                <table>
                    <tr height="25" class="formbold">
                        <td colspan="4"><font color="red"><cf_get_lang dictionary_id="59576.Muhasebe Kod Grubu Olmayan Çalışanlar Mevcut , Lütfen Kayıtları Kontrol Ediniz."></font></td>
                    </tr>
                </table>	
            <cfelse>
                    <cfscript>
                        DETAIL_1 = '#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# Personel Maaş Tahakkuku';
                        str_borclu_hesaplar = '';
                        str_borclu_tutarlar = '';
                        str_alacakli_hesaplar = '';
                        str_alacakli_tutarlar = '';
                        borclu_project_list = '';
                        alacakli_project_list = '';
                        satir_detay_list = ArrayNew(2);
                        sira_alacak_ = 0;
                        sira_borc_ = 0;
                    </cfscript>
                    <cfoutput query="GET_ACCOUNTS">
                        <cfquery name="get_account_rows" datasource="#new_dsn2#">
                            SELECT * FROM #dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS WHERE PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#"> AND ISNULL(IS_EXPENSE,0) = 0
                        </cfquery>
                        
                        <cfquery name="get_project_rates_row" dbtype="query">
                            SELECT 
                                * 
                            FROM 
                                get_project_rates 
                            WHERE 
                                ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#">
                        </cfquery>
                    <!--- <cfloop query="get_money">--->
                            <cfscript>
                                borclu_list = '';
                                borclu_name_list = '';
                                alacakli_list = '';
                                alacakli_name_list = '';
                                alacakli_detail_list = '';
                                borc_deger_ = '';
                                /*borc_deger_other_ = '';
                                borc_money_other_ = '';*/
                                borclu_detail_list = '';
                                alacak_deger_ = '';
                            /* alacak_deger_other_ = '';
                                alacak_money_other_ = '';*/
                                alacak_pay_id = '';
                                borc_pay_id = '';
                                alacak_pay_id_net = '';
                                borc_pay_id_net = '';
                                alacakli_rate_list='';
                                borclu_rate_list='';
                                if(account_card_type eq 0)
                                {
                                    sira_alacak_ = 0;
                                    sira_borc_ = 0;
                                    satir_detay_list = ArrayNew(2);
                                    borclu_project_list = '';
                                    alacakli_project_list = '';
                                }
                            </cfscript>					
                            <cfloop query="get_account_rows">
                                <cfif PUANTAJ_BORC_ALACAK eq 1>
                                    <cfif len(is_project) and is_project eq 1>
                                        <cfloop query="get_project_rates_row">
                                            <cfset sira_alacak_ = sira_alacak_ + 1>
                                            <cfset alacakli_list = listappend(alacakli_list,'#get_account_rows.ACCOUNT_CODE#')>
                                            <cfset alacakli_detail_list = listappend(alacakli_detail_list,'#get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#')>
                                            <cfset alacakli_name_list = listappend(alacakli_name_list,'#get_account_rows.PUANTAJ_ACCOUNT#')>
                                            <cfset alacakli_project_list = listappend(alacakli_project_list,get_project_rates_row.project_id)>
                                            <cfset alacakli_rate_list = listappend(alacakli_rate_list,get_project_rates_row.rate)>
                                            <cfset alacak_deger_ = listappend(alacak_deger_,0)>
                                        <!--- <cfset alacak_deger_other_ = listappend(alacak_deger_other_,0)>
                                            <cfset alacak_money_other_ = listappend(alacak_money_other_,0)>--->
                                            <cfif len(get_account_rows.comment_pay_id)>
                                                <cfif get_account_rows.is_net eq 1>
                                                    <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,get_account_rows.comment_pay_id)>
                                                    <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                                                <cfelse>
                                                    <cfset alacak_pay_id = listappend(alacak_pay_id,get_account_rows.comment_pay_id)>
                                                    <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                                                </cfif>
                                            <cfelse>
                                                <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                                                <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                                            </cfif>
                                            <cfif get_process_type.is_account_group eq 0>
                                                <cfset satir_detay_list[2][sira_alacak_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                                            <cfelse>
                                                <cfset satir_detay_list[2][sira_alacak_]=detail_1>
                                            </cfif>
                                        </cfloop>
                                    <cfelse>
                                        <cfset sira_alacak_ = sira_alacak_ + 1>
                                        <cfset alacakli_list = listappend(alacakli_list,'#ACCOUNT_CODE#')>
                                        <cfset alacakli_detail_list = listappend(alacakli_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
                                        <cfset alacakli_name_list = listappend(alacakli_name_list,'#PUANTAJ_ACCOUNT#')>
                                        <cfset alacakli_project_list = listappend(alacakli_project_list,0)>
                                        <cfset alacakli_rate_list = listappend(alacakli_rate_list,100)>
                                        <cfset alacak_deger_ = listappend(alacak_deger_,0)>
                                    <!--- <cfset alacak_deger_other_ = listappend(alacak_deger_other_,0)>
                                        <cfset alacak_money_other_ = listappend(alacak_money_other_,0)>--->
                                        <cfif len(get_account_rows.comment_pay_id)>
                                            <cfif get_account_rows.is_net eq 1>
                                                <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,get_account_rows.comment_pay_id)>
                                                <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                                            <cfelse>
                                                <cfset alacak_pay_id = listappend(alacak_pay_id,get_account_rows.comment_pay_id)>
                                                <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                                            </cfif>
                                        <cfelse>
                                            <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                                            <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                                        </cfif>
                                        <cfif get_process_type.is_account_group eq 0>
                                            <cfset satir_detay_list[2][sira_alacak_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                                        <cfelse>
                                            <cfset satir_detay_list[2][sira_alacak_]=detail_1>
                                        </cfif>
                                    </cfif>
                                <cfelse>
                                    <cfif len(is_project) and is_project eq 1>
                                        <cfloop query="get_project_rates_row">
                                            <cfset sira_borc_ = sira_borc_ + 1>
                                            <cfset borclu_list = listappend(borclu_list,'#get_account_rows.ACCOUNT_CODE#')>
                                            <cfset borclu_detail_list = listappend(borclu_detail_list,'#get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#')>
                                            <cfset borclu_name_list = listappend(borclu_name_list,'#get_account_rows.PUANTAJ_ACCOUNT#')>
                                            <cfset borclu_project_list = listappend(borclu_project_list,get_project_rates_row.project_id)>
                                            <cfset borclu_rate_list = listappend(borclu_rate_list,get_project_rates_row.rate)>
                                            <cfset borc_deger_ = listappend(borc_deger_,0)>
                                            <!---<cfset borc_deger_other_ = listappend(borc_deger_other_,0)>
                                            <cfset borc_money_other_ = listappend(borc_money_other_,0)>--->
                                            <cfif len(get_account_rows.comment_pay_id)>
                                                <cfif get_account_rows.is_net eq 1>
                                                    <cfset borc_pay_id_net = listappend(borc_pay_id_net,get_account_rows.comment_pay_id)>
                                                    <cfset borc_pay_id = listappend(borc_pay_id,0)>
                                                <cfelse>
                                                    <cfset borc_pay_id = listappend(borc_pay_id,get_account_rows.comment_pay_id)>
                                                    <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                                                </cfif>
                                            <cfelse>
                                                <cfset borc_pay_id = listappend(borc_pay_id,0)>
                                                <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                                            </cfif>
                                            <cfif get_process_type.is_account_group eq 0>
                                                <cfset satir_detay_list[1][sira_borc_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                                            <cfelse>
                                                <cfset satir_detay_list[1][sira_borc_]=detail_1>
                                            </cfif>
                                        </cfloop>
                                    <cfelse>
                                        <cfset sira_borc_ = sira_borc_ + 1>
                                        <cfset borclu_list = listappend(borclu_list,'#ACCOUNT_CODE#')>
                                        <cfset borclu_detail_list = listappend(borclu_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
                                        <cfset borclu_name_list = listappend(borclu_name_list,'#PUANTAJ_ACCOUNT#')>
                                        <cfset borclu_project_list = listappend(borclu_project_list,0)>
                                        <cfset borclu_rate_list = listappend(borclu_rate_list,100)>
                                        <cfset borc_deger_ = listappend(borc_deger_,0)>
                                        <!---<cfset borc_deger_other_ = listappend(borc_deger_other_,0)>
                                        <cfset borc_money_other_ = listappend(borc_money_other_,0)>--->
                                        <cfif len(get_account_rows.comment_pay_id)>
                                            <cfif get_account_rows.is_net eq 1>
                                                <cfset borc_pay_id_net = listappend(borc_pay_id_net,get_account_rows.comment_pay_id)>
                                                <cfset borc_pay_id = listappend(borc_pay_id,0)>
                                            <cfelse>
                                                <cfset borc_pay_id = listappend(borc_pay_id,get_account_rows.comment_pay_id)>
                                                <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                                            </cfif>
                                        <cfelse>
                                            <cfset borc_pay_id = listappend(borc_pay_id,0)>
                                            <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                                        </cfif>
                                        <cfif get_process_type.is_account_group eq 0>
                                            <cfset satir_detay_list[1][sira_borc_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                                        <cfelse>
                                            <cfset satir_detay_list[1][sira_borc_]=detail_1>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </cfloop>
                            <cfquery name="get_account_puantaj" dbtype="query">
                                SELECT 
                                    * 
                                FROM 
                                    get_puantaj_rows 
                                WHERE 
                                    ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACCOUNTS.PAYROLL_ID#">
                                    <!---AND MONEY_ = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money.MONEY_#">--->
                            </cfquery>
                            
                            <cfquery name="get_account_inout" dbtype="query">
                                SELECT 
                                    * 
                                FROM 
                                    get_employee_accounts 
                                WHERE 
                                    ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACCOUNTS.PAYROLL_ID#">
                            </cfquery>
                            <cfloop query="get_account_puantaj">
                                <cfset sira_ = 0>
                                <cfset money_ = get_account_puantaj.money_>
                                <cfloop list="#alacakli_name_list#" index="alacak_">
                                    <cfset sira_ = sira_ + 1>
                                    <cfset deger_ = listgetat(alacak_deger_,sira_)>
                                    <cfset deger_kontrol = listgetat(alacak_pay_id,sira_)>
                                    <cfset deger_kontrol2 = listgetat(alacak_pay_id_net,sira_)>
                                    <cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
                                    <cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_account_puantaj.#alacak_#"))>
                                        <cfset new_deger_ = deger_ + (evaluate("get_account_puantaj.#alacak_#")*deger_rate/100)>
                                        <!---<cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_*get_account_puantaj.amount_rate)>--->
                                        <cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
                                        <!---<cfset alacak_deger_other_ = listsetat(alacak_deger_other_,sira_,new_deger_)>
                                        <cfset alacak_money_other_ = listsetat(alacak_money_other_,sira_,money_)>--->
                                    </cfif>
                                </cfloop>
                                
                                <cfset sira_ = 0>
                                <cfloop list="#borclu_name_list#" index="alacak_">
                                    <cfset sira_ = sira_ + 1>
                                    <cfset deger_ = listgetat(borc_deger_,sira_)>
                                    <cfset deger_kontrol = listgetat(borc_pay_id,sira_)>
                                    <cfset deger_kontrol2 = listgetat(borc_pay_id_net,sira_)>
                                    <cfset deger_rate = listgetat(borclu_rate_list,sira_)>
                                    <cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_account_puantaj.#alacak_#"))>
                                        <cfset new_deger_ = deger_ + (evaluate("get_account_puantaj.#alacak_#")*deger_rate/100)>
                                        <cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
                                    </cfif>
                                </cfloop>
                                
                                <cfset sira_ = 0>
                                <cfloop list="#alacak_pay_id#" index="alacak_">
                                    <cfset sira_ = sira_ + 1>
                                    <cfset deger_ = listgetat(alacak_pay_id,sira_)>
                                    <cfset new_deger_ = listgetat(alacak_deger_,sira_)>
                                    <cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
                                    <cfif deger_ neq 0>
                                        <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                            SELECT #dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT) AMOUNT_ FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger_#"> AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_puantaj.employee_puantaj_id#">
                                        </cfquery>
                                        <cfloop query="get_ext_puantaj">
                                            <cfset new_deger_ = new_deger_ + (get_ext_puantaj.AMOUNT_*deger_rate/100)>
                                        </cfloop>
                                        <cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
                                    </cfif>
                                </cfloop>
                                <cfset sira_ = 0>
                                <cfloop list="#borc_pay_id#" index="borc_">
                                    <cfset sira_ = sira_ + 1>
                                    <cfset deger_ = listgetat(borc_pay_id,sira_)>
                                    <cfset new_deger_ = listgetat(borc_deger_,sira_)>
                                    <cfset deger_rate = listgetat(borclu_rate_list,sira_)>
                                    <cfif deger_ neq 0>
                                        <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                            SELECT #dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT) AMOUNT_ FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger_#"> AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_puantaj.employee_puantaj_id#">
                                        </cfquery>
                                        <cfloop query="get_ext_puantaj">
                                            <cfset new_deger_ = new_deger_ + (get_ext_puantaj.AMOUNT_*deger_rate/100)>
                                        </cfloop>
                                        <cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
                                    </cfif>
                                </cfloop>
                                <cfset sira_ = 0>
                                <cfloop list="#alacak_pay_id_net#" index="alacak_">
                                    <cfset sira_ = sira_ + 1>
                                    <cfset deger_ = listgetat(alacak_pay_id_net,sira_)>
                                    <cfset new_deger_ = listgetat(alacak_deger_,sira_)>
                                    <cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
                                    <cfif deger_ neq 0>
                                        <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                            SELECT ISNULL(AMOUNT_PAY,0) AMOUNT_PAY FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger_#"> AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_puantaj.employee_puantaj_id#">
                                        </cfquery>
                                        <cfloop query="get_ext_puantaj">
                                            <cfset new_deger_ = new_deger_ + wrk_round_(wrk_round_(get_ext_puantaj.amount_pay,2)*deger_rate/100,2)>
                                        </cfloop>
                                        <cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
                                    </cfif>
                                </cfloop>
                                <cfset sira_ = 0>
                                <cfloop list="#borc_pay_id_net#" index="borc_">
                                    <cfset sira_ = sira_ + 1>
                                    <cfset deger_ = listgetat(borc_pay_id_net,sira_)>
                                    <cfset new_deger_ = listgetat(borc_deger_,sira_)>
                                    <cfset deger_rate = listgetat(borclu_rate_list,sira_)>
                                    <cfif deger_ neq 0>
                                        <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                            SELECT ISNULL(AMOUNT_PAY,0) AMOUNT_PAY FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger_#"> AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_puantaj.employee_puantaj_id#">
                                        </cfquery>
                                        <cfloop query="get_ext_puantaj">
                                            <cfset new_deger_ = new_deger_ + wrk_round_(wrk_round_(get_ext_puantaj.amount_pay,2)*deger_rate/100,2)>
                                        </cfloop>
                                        <cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
                                    </cfif>
                                </cfloop>
                            </cfloop>

                    <!--- </cfloop>--->
                        <cfif account_card_type eq 0>
                            <cfscript>
                                str_borclu_hesaplar = borclu_list;
                                str_borclu_tutarlar = borc_deger_;
                                str_alacakli_hesaplar = alacakli_list;
                                str_alacakli_tutarlar = alacak_deger_;		
                                GET_NO_ = cfquery_(datasource:"#new_dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
                                //muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
                                str_fark_gelir =GET_NO_.FARK_GELIR;
                                str_fark_gider =GET_NO_.FARK_GIDER;
                                str_max_round = 0.9;
                                acc_flag=account_cmp.muhasebeci_hr(
                                    action_id :attributes.PUANTAJ_ID,
                                    workcube_process_type : 130,
                                    workcube_process_cat : account_process_cat,
                                    account_card_type : 13,
                                    action_table : action_table,
                                    islem_tarihi : puantaj_act_date,
                                    borc_hesaplar : str_borclu_hesaplar,
                                    borc_tutarlar : str_borclu_tutarlar,
                                    alacak_hesaplar : str_alacakli_hesaplar,
                                    alacak_tutarlar : str_alacakli_tutarlar,
                                    from_branch_id : get_puantaj_branch.branch_id,
                                    fis_detay : "#DETAIL_1#",
                                    fis_satir_detay : satir_detay_list,
                                    muhasebe_db:new_dsn2,
                                    dept_round_account :str_fark_gider,
                                    claim_round_account : str_fark_gelir,
                                    max_round_amount :str_max_round,
                                    round_row_detail:DETAIL_1,
                                    dsn3_alias:new_dsn3_alias,
                                    is_account_group : get_process_type.is_account_group,
                                    payroll_id_list : employee_payroll_id
                                );
                            </cfscript>
                            <cfif isdefined("acc_flag.ERROR_MESSAGE") and len(acc_flag.ERROR_MESSAGE) and acc_flag.ERROR_MESSAGE neq 0>
                                <cfset return_error = acc_flag.ERROR_MESSAGE>
                                <cfset upd_payroll = account_cmp.upd_payrol_job(employee_payroll_id: employee_payroll_id, new_dsn2: new_dsn2)>
                            <cfelse>
                                <cfset return_error = acc_flag>
                            </cfif>
                        <cfelse>
                            <cfscript>
                                str_borclu_hesaplar = listappend(str_borclu_hesaplar,borclu_list);
                                str_borclu_tutarlar = listappend(str_borclu_tutarlar,borc_deger_);
                                str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,alacakli_list);
                                str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,alacak_deger_);	
                            </cfscript>
                        </cfif>
                    </cfoutput>
                    
                    <cfif account_card_type eq 1>
                        <cfscript>
                            GET_NO_ = cfquery_(datasource:"#new_dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
                            //muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
                            str_fark_gelir =GET_NO_.FARK_GELIR;
                            str_fark_gider =GET_NO_.FARK_GIDER;
                            str_max_round = 2;
                            acc_flag=account_cmp.muhasebeci_hr(
                                action_id :attributes.PUANTAJ_ID,
                                workcube_process_type : 130,
                                workcube_process_cat : account_process_cat,
                                account_card_type : 13,
                                action_table : action_table,
                                islem_tarihi : puantaj_act_date,
                                borc_hesaplar : str_borclu_hesaplar,
                                borc_tutarlar : str_borclu_tutarlar,
                                alacak_hesaplar : str_alacakli_hesaplar,
                                alacak_tutarlar : str_alacakli_tutarlar,
                                from_branch_id : get_puantaj_branch.branch_id,
                                fis_detay : "#DETAIL_1#",
                                fis_satir_detay : satir_detay_list,
                                muhasebe_db:new_dsn2,
                                acc_project_list_borc : borclu_project_list,
                                acc_project_list_alacak : alacakli_project_list,
                                dept_round_account :str_fark_gider,
                                claim_round_account : str_fark_gelir,
                                max_round_amount :str_max_round,
                                round_row_detail:DETAIL_1,
                                dsn3_alias:new_dsn3_alias,
                                is_account_group : get_process_type.is_account_group,
                                payroll_id_list : employee_payroll_id
                            );
                        </cfscript>
                        <cfif isdefined("acc_flag")>
                            <cfif isdefined("acc_flag.ERROR_MESSAGE") and len(acc_flag.ERROR_MESSAGE) and acc_flag.ERROR_MESSAGE neq 0>
                                <cfset return_error = acc_flag.ERROR_MESSAGE>
                                <cfset upd_payroll = account_cmp.upd_payrol_job(employee_payroll_id : employee_payroll_id, new_dsn2: new_dsn2)>
                            <cfelse>
                                <cfset return_error = acc_flag>
                            </cfif>
                        </cfif>
                    </cfif>
                <cfquery name="get_puantaj_ext" datasource="#new_dsn2#">
                    SELECT 
                        CASE WHEN
                            LEN(EPR.ACCOUNT_CODE) > 0 THEN EPR.ACCOUNT_CODE 
                        ELSE 
                            (SELECT TOP 1 EA.ACCOUNT_CODE FROM #dsn_alias#.EMPLOYEES_ACCOUNTS EA INNER JOIN #dsn_alias#.SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = EA.ACC_TYPE_ID WHERE EA.IN_OUT_ID = EPR.IN_OUT_ID AND (SA.IS_SALARY_ACCOUNT = 1 OR SA.ACC_TYPE_ID = -1) AND EA.PERIOD_ID = #session.ep.period_id#)	 <!--- çalışan muhasebe kodu boş ise maaş tipli cari hesap tipinin hesap kodunu alacak SG20160107--->	
                        END AS EMP_ACC_CODE,   
                        EPR.IN_OUT_ID,
                        EPR.EMPLOYEE_ID,
                        E.EMPLOYEE_ID,
                        E.EMPLOYEE_NAME,
                        E.EMPLOYEE_SURNAME,
                        ISNULL(EPRE.ACCOUNT_CODE,(SELECT EA.ACCOUNT_CODE FROM #dsn_alias#.EMPLOYEES_ACCOUNTS EA WHERE EA.IN_OUT_ID = EPR.IN_OUT_ID AND EA.PERIOD_ID=#session.ep.period_id# AND EA.ACC_TYPE_ID = EPRE.ACC_TYPE_ID)) ACCOUNT_CODE_,
                        EPRE.* ,
                        #dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT) AMOUNT_
                    FROM 
                        #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT EPRE,
                        #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS EPR,
                        #dsn_alias#.EMPLOYEES E
                    WHERE 
                        EPRE.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PUANTAJ.PUANTAJ_ID#"> 
                        AND (EPRE.ACCOUNT_CODE IS NOT NULL OR EPRE.COMPANY_ID IS NOT NULL OR EPRE.CONSUMER_ID IS NOT NULL OR EPRE.ACC_TYPE_ID IS NOT NULL)
                        AND (EPRE.EXT_TYPE = 1 OR EPRE.EXT_TYPE = 3) <!--- 3=eski icra kesintisi --->
                        AND EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID
                        AND E.EMPLOYEE_ID = EPR.EMPLOYEE_ID
                        AND EPR.IN_OUT_ID = #in_out_list#
                </cfquery>
                <cfif get_puantaj_ext.recordcount and get_puantaj_ext.amount_2 neq 0>
                    <cfscript>
                        DETAIL_1 = '#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# Personel Kesintileri';
                        satir_detay_list = ArrayNew(2);
                        str_borclu_hesaplar = '';
                        str_borclu_tutarlar = '';
                        str_alacakli_hesaplar = '';
                        str_alacakli_tutarlar = '';		
                    </cfscript>
                    <cfoutput query="get_puantaj_ext">
                        <cfset row_detail = '#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay - #get_puantaj_ext.detail# - #get_puantaj_ext.comment_pay#'>
                        <cfif len(account_code_)>
                            <cfscript>
                                str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,'#ACCOUNT_CODE_#');
                                str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,wrk_round_(AMOUNT_,2));
                                if(get_process_type.is_account_group eq 0)
                                    satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#row_detail#';
                                else
                                    satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#DETAIL_1#';
                                str_borclu_hesaplar = listappend(str_borclu_hesaplar,'#EMP_ACC_CODE#');
                                str_borclu_tutarlar = listappend(str_borclu_tutarlar,wrk_round_(AMOUNT_,2));
                                if(get_process_type.is_account_group eq 0)
                                    satir_detay_list[1][listlen(str_borclu_tutarlar)]='#row_detail#';
                                else
                                    satir_detay_list[1][listlen(str_borclu_tutarlar)]='#DETAIL_1#';
                            </cfscript>
                        </cfif>
                    </cfoutput>
                    <cfscript>
                        acc_flag=account_cmp.muhasebeci_hr(
                            action_id :attributes.PUANTAJ_ID,
                            workcube_process_type : 161,
                            workcube_process_cat : budget_process_cat,
                            account_card_type : 13,
                            action_table : action_table,
                            islem_tarihi : puantaj_act_date,
                            borc_hesaplar : str_borclu_hesaplar,
                            borc_tutarlar : str_borclu_tutarlar,
                            alacak_hesaplar : str_alacakli_hesaplar,
                            alacak_tutarlar : str_alacakli_tutarlar,
                            from_branch_id : get_puantaj_branch.branch_id,
                            fis_detay : "#DETAIL_1#",
                            fis_satir_detay : satir_detay_list,
                            muhasebe_db:new_dsn2,
                            dsn3_alias:new_dsn3_alias,
                            is_account_group : get_process_type.is_account_group,
                            payroll_id_list : employee_payroll_id
                        );
                    </cfscript>
                    <cfif isdefined("acc_flag.ERROR_MESSAGE") and len(acc_flag.ERROR_MESSAGE) and acc_flag.ERROR_MESSAGE neq 0>
                        <cfset return_error = acc_flag.ERROR_MESSAGE>
                        <cfset upd_payroll = account_cmp.upd_payrol_job(employee_payroll_id : employee_payroll_id, new_dsn2: new_dsn2)>
                    <cfelse>
                        <cfset return_error = acc_flag>
                    </cfif>
                </cfif>
                <!--- Harcırah bordrosu muhasebeleştirme--->
                <cfscript>
                    DETAIL_1 = '#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# Harcırah Bordrosu';
                    str_borclu_hesaplar = '';
                    str_borclu_tutarlar = '';
                    str_alacakli_hesaplar = '';
                    str_alacakli_tutarlar = '';
                    borclu_project_list = '';
                    alacakli_project_list = '';
                    satir_detay_list = ArrayNew(2);
                    sira_alacak_ = 0;
                    sira_borc_ = 0;
                </cfscript>
                <cfscript>
                    borclu_list = '';
                    borclu_name_list = '';
                    alacakli_list = '';
                    alacakli_name_list = '';
                    alacakli_detail_list = '';
                    borc_deger_ = '';
                    borclu_detail_list = '';
                    alacak_deger_ = '';
                    alacak_pay_id = '';
                    borc_pay_id = '';
                    alacak_pay_id_net = '';
                    borc_pay_id_net = '';
                    alacakli_rate_list='';
                    borclu_rate_list='';
                </cfscript>
                <cfoutput query="GET_ACCOUNTS">
                <cfquery name="get_expense_puantaj" datasource="#new_dsn2#">
                    SELECT
                        SUM(EMPLOYEES_EXPENSE_PUANTAJ.BRUT_AMOUNT) AS BRUT_AMOUNT,
                        SUM(EMPLOYEES_EXPENSE_PUANTAJ.NET_AMOUNT) AS NET_AMOUNT,
                        SUM(EMPLOYEES_EXPENSE_PUANTAJ.DAMGA_VERGISI) AS DAMGA_VERGISI,
                        SUM(EMPLOYEES_EXPENSE_PUANTAJ.GELIR_VERGISI) AS GELIR_VERGISI
                    FROM
                        #dsn_alias#.EMPLOYEES_EXPENSE_PUANTAJ INNER JOIN #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS EPR 
                        ON EMPLOYEES_EXPENSE_PUANTAJ.IN_OUT_ID = EPR.IN_OUT_ID
                    WHERE
                        EMPLOYEES_EXPENSE_PUANTAJ.IN_OUT_ID IN(#valuelist(get_puantaj_rows.in_out_id)#) AND
                        YEAR(EXPENSE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows.sal_year#"> AND
                        MONTH(EXPENSE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows.sal_mon#"> AND
                        EPR.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#"> AND
                        EPR.ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACCOUNTS.PAYROLL_ID#">
                        AND EPR.IN_OUT_ID = #in_out_list#
                    GROUP BY 	
                        EMPLOYEES_EXPENSE_PUANTAJ.IN_OUT_ID
                </cfquery>
                <cfquery name="get_account_rows" datasource="#new_dsn2#">
                    SELECT * FROM #dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS WHERE PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#"> AND IS_EXPENSE = 1 <!--- harcırah bordro kalemleri SG 20140826--->
                </cfquery>
                    <cfscript>
                        borclu_list = '';
                        borclu_name_list = '';
                        alacakli_list = '';
                        alacakli_name_list = '';
                        alacakli_detail_list = '';
                        borc_deger_ = '';
                    /* borc_deger_other_ = '';
                        borc_money_other_ = '';*/
                        borclu_detail_list = '';
                        alacak_deger_ = '';
                        /*alacak_deger_other_ = '';
                        alacak_money_other_ = '';*/
                        alacak_pay_id = '';
                        borc_pay_id = '';
                        alacak_pay_id_net = '';
                        borc_pay_id_net = '';
                        alacakli_rate_list='';
                        borclu_rate_list='';
                    </cfscript>
                    <cfloop query="get_account_rows">
                        <cfif PUANTAJ_BORC_ALACAK eq 1>
                            <cfset sira_alacak_ = sira_alacak_ + 1>
                            <cfset alacakli_list = listappend(alacakli_list,'#ACCOUNT_CODE#')>
                            <cfset alacakli_detail_list = listappend(alacakli_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
                            <cfset alacakli_name_list = listappend(alacakli_name_list,'#PUANTAJ_ACCOUNT#')>
                            <cfset alacakli_project_list = listappend(alacakli_project_list,0)>
                            <cfset alacakli_rate_list = listappend(alacakli_rate_list,100)>
                            <cfset alacak_deger_ = listappend(alacak_deger_,0)>
                            <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                            <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                            <cfif get_process_type.is_account_group eq 0>
                                <cfset satir_detay_list[2][sira_alacak_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                            <cfelse>
                                <cfset satir_detay_list[2][sira_alacak_]=detail_1>
                            </cfif>
                        <cfelse>
                            <cfset sira_borc_ = sira_borc_ + 1>
                            <cfset borclu_list = listappend(borclu_list,'#ACCOUNT_CODE#')>
                            <cfset borclu_detail_list = listappend(borclu_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
                            <cfset borclu_name_list = listappend(borclu_name_list,'#PUANTAJ_ACCOUNT#')>
                            <cfset borclu_project_list = listappend(borclu_project_list,0)>
                            <cfset borclu_rate_list = listappend(borclu_rate_list,100)>
                            <cfset borc_deger_ = listappend(borc_deger_,0)>
                            <cfset borc_pay_id = listappend(borc_pay_id,0)>
                            <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                            <cfif get_process_type.is_account_group eq 0>
                                <cfset satir_detay_list[1][sira_borc_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                            <cfelse>
                                <cfset satir_detay_list[1][sira_borc_]=detail_1>
                            </cfif>
                        </cfif> 
                        </cfloop>
                        <cfif get_expense_puantaj.recordcount>
                            <cfloop query="get_expense_puantaj">
                                <cfset sira_ = 0>
                                <cfloop list="#alacakli_name_list#" index="alacak_">
                                    <cfset sira_ = sira_ + 1>
                                    <cfset deger_ = listgetat(alacak_deger_,sira_)>
                                    <cfset deger_kontrol = listgetat(alacak_pay_id,sira_)>
                                    <cfset deger_kontrol2 = listgetat(alacak_pay_id_net,sira_)>
                                    <cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
                                    <cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_expense_puantaj.#alacak_#"))>
                                        <cfset new_deger_ = deger_ + (evaluate("get_expense_puantaj.#alacak_#")*deger_rate/100)>
                                        <cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
                                    </cfif>
                                </cfloop>
                                <cfset sira_ = 0>
                                <cfloop list="#borclu_name_list#" index="alacak_">
                                    <cfset sira_ = sira_ + 1>
                                    <cfset deger_ = listgetat(borc_deger_,sira_)>
                                    <cfset deger_kontrol = listgetat(borc_pay_id,sira_)>
                                    <cfset deger_kontrol2 = listgetat(borc_pay_id_net,sira_)>
                                    <cfset deger_rate = listgetat(borclu_rate_list,sira_)>
                                    <cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_expense_puantaj.#alacak_#"))>
                                        <cfset new_deger_ = deger_ + (evaluate("get_expense_puantaj.#alacak_#")*deger_rate/100)>
                                        <cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
                                    </cfif>
                                </cfloop>
                                <cfscript>
                                    str_borclu_hesaplar = listappend(str_borclu_hesaplar,borclu_list);
                                    str_borclu_tutarlar = listappend(str_borclu_tutarlar,borc_deger_);
                                    str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,alacakli_list);
                                    str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,alacak_deger_);	
                                </cfscript>
                            </cfloop>
                            <cfscript>
                                str_borclu_hesaplar = borclu_list;
                                str_borclu_tutarlar = borc_deger_;
                                str_alacakli_hesaplar = alacakli_list;
                                str_alacakli_tutarlar = alacak_deger_;						
                                GET_NO_ = cfquery_(datasource:"#new_dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
                                //muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
                                str_fark_gelir =GET_NO_.FARK_GELIR;
                                str_fark_gider =GET_NO_.FARK_GIDER;
                                str_max_round = 0.9;
                                acc_flag=account_cmp.muhasebeci_hr(
                                    action_id :attributes.PUANTAJ_ID,
                                    workcube_process_type : 130,
                                    workcube_process_cat : account_process_cat,
                                    account_card_type : 13,
                                    action_table : action_table,
                                    islem_tarihi : puantaj_act_date,
                                    borc_hesaplar : str_borclu_hesaplar,
                                    borc_tutarlar : str_borclu_tutarlar,
                                    alacak_hesaplar : str_alacakli_hesaplar,
                                    alacak_tutarlar : str_alacakli_tutarlar,
                                    from_branch_id : get_puantaj_branch.branch_id,
                                    fis_detay : "#DETAIL_1#",
                                    fis_satir_detay : satir_detay_list,
                                    muhasebe_db:new_dsn2,
                                    acc_project_list_borc : '',
                                    acc_project_list_alacak : '',
                                    dept_round_account :str_fark_gider,
                                    claim_round_account : str_fark_gelir,
                                    max_round_amount :str_max_round,
                                    round_row_detail:DETAIL_1,
                                    dsn3_alias:new_dsn3_alias,
                                    is_account_group : get_process_type.is_account_group,
                                    payroll_id_list : employee_payroll_id
                                );
                            </cfscript>
                            <cfif isdefined("acc_flag.ERROR_MESSAGE") and len(acc_flag.ERROR_MESSAGE) and acc_flag.ERROR_MESSAGE eq 1>
                                Harcırah Muhasebe Fişi Oluşturuldu!
                            </cfif>
                        </cfif>
                </cfoutput>
            </cfif>
        </cftransaction>
    </cflock>
</cfif>
<cfcatch type="any">
    <cfset account_cmp = createObject('component','V16.hr.ehesap.cfc.draft_functions')>
    <cfset upd_payroll = account_cmp.upd_payrol_job(employee_payroll_id : employee_payroll_id, new_dsn2: new_dsn2)>
    <cfset this.returnResult( status: false, fileid: attributes.in_out_id, message: "", errorMessage: cfcatch) />
</cfcatch>
</cftry>
