<!---
    File: payroll_cfc.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Step Step Payroll Functions
        
    History:
        
    To Do:

--->
 
<cfcomponent displayname="PAYROLL_JOB_FILE" extends="WMO.functions">
     
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn2_alias = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3_alias = '#dsn#_#session.ep.company_id#'>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset fusebox.use_period = application.systemParam.systemParam().fusebox.use_period>
    <cfset fusebox.dynamic_hierarchy = application.systemParam.systemParam().fusebox.dynamic_hierarchy>
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <cfset request.self = 'index.cfm'>
    <cfset dateformat_style = session.ep.dateformat_style>
    <cfset response = "">
    <cfset data = "">
    <cfset serializedStr = "">
    <cfset account_response = "">
    <cfset budget_response = "">
    <cfset payroll_type_ = "">
    <!--- Payroll job toablosuna kayıt atar --->
    <cffunction name="ADD_PAYROLL_JOB" access="public" returntype="any">
        <cfargument  name="branch_id" default="" required="yes">
        <cfargument  name="month" default="" required="yes">
        <cfargument  name="year" default="" required="yes">
        <cfargument  name="payroll_type" default="" required="yes">
        <cfargument  name="employee_ids" default="" required="yes"><!--- liste---->
        <cfargument  name="in_out_ids" default="" required="yes"><!--- liste---->
        <cfargument  name="branch_payroll_id" default="" required="no">
        <cfargument  name="statue" default="1" required="yes">
        <cfargument  name="statue_type" default="0" required="yes">
        <cfargument  name="statue_type_individual" default="0" required="yes">
        <cfargument  name="PERCENT_COMPLETED" default="" required="no">
        <cfargument  name="PAYROLL_DRAFT" default="" required="no">
        <cfargument  name="ACCOUNT_DRAFT" default="" required="no">
        <cfargument  name="ACCOUNT_COMPLETED" default="" required="no">
        <cfargument  name="BUDGET_DRAFT" default="" required="no">
        <cfargument  name="BUDGET_COMPLETED" default="" required="no">
        <cfargument  name="BANK_DRAFT" default="" required="no">
        <cfargument  name="BANK_COMPLETED" default="" required="no">
        <cfset indx = 1>
        <cfloop list="#arguments.in_out_ids#" index="in_out_id">
            <cfquery name="get_emp_id" datasource="#dsn#">
                SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#in_out_id#" null = "no">
            </cfquery>
            <cfquery name="ADD_PAYROLL_JOB" datasource="#dsn#">
                INSERT INTO 
                    PAYROLL_JOB   
                    (
                        MONTH
                        ,YEAR
                        ,BRANCH_ID
                        ,EMPLOYEE_ID
                        ,IN_OUT_ID
                        ,BRANCH_PAYROLL_ID
                        ,PERCENT_COMPLETED
                        ,PAYROLL_DRAFT
                        ,ACCOUNT_DRAFT
                        ,ACCOUNT_COMPLETED
                        ,BUDGET_DRAFT
                        ,BUDGET_COMPLETED
                        ,BANK_DRAFT
                        ,BANK_COMPLETED
                        ,PAYROLL_TYPE
                        ,STATUE
                        ,STATUE_TYPE
                        ,STATUE_TYPE_INDIVIDUAL
                    )
                    VALUES
                    (
                        <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.month#" null = "no">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.year#" null = "no">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.branch_id#" null = "no">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#get_emp_id.employee_id#" null = "no">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#in_out_id#" null = "no">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.branch_payroll_id#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_bit" value = "#arguments.PERCENT_COMPLETED#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_varchar" value = "#arguments.PAYROLL_DRAFT#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_varchar" value = "#arguments.ACCOUNT_DRAFT#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_bit" value = "#arguments.ACCOUNT_COMPLETED#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_varchar" value = "#arguments.BUDGET_DRAFT#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_bit" value = "#arguments.BUDGET_COMPLETED#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_varchar" value = "#arguments.BANK_DRAFT#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_bit" value = "#arguments.BANK_COMPLETED#" null = "yes">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.payroll_type#" null = "no">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue#">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type#">
                        ,<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#">
                    )
            </cfquery>
            <cfset indx = indx + 1>
        </cfloop>
        <cfreturn 1>
    </cffunction>

    <!--- Daha önce geçerli ay ve yıl için kayıt atılmış mı kontrol eder --->
    <cffunction name="PAYROLL_JOB_CONTROL" access="public" returntype="any">
        <cfargument  name="branch_id" default="" required="yes">
        <cfargument  name="month" default="" required="yes">
        <cfargument  name="year" default="" required="yes">
        <cfargument  name="payroll_type" default="" required="yes">
        <cfargument  name="puantaj_id" default="" required="no">
        <cfargument  name="employee_ids" default="" required="no"><!--- liste---->
        <cfargument  name="statue" default="1" required="yes">
        <cfargument  name="statue_type" default="1" required="yes">
        <cfargument  name="jury_membership" default="0" required="no">
        <cfargument  name="land_compensation_score" default="0" required="no">
        <cfargument  name="start_date_new" default="" required="no">
        <cfargument  name="finish_date_new" default="" required="no">
        <cfargument  name="statue_type_individual" default="0" required="yes">

        <cfquery name="PAYROLL_JOB_CONTROL" datasource="#dsn#">
            SELECT
                PAYROLL_JOB.*,
                EMPLOYEES_IDENTY.TC_IDENTY_NO,
                EMPLOYEES_IN_OUT.IN_OUT_ID
            FROM 
                PAYROLL_JOB
                INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = PAYROLL_JOB.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_IDENTY ON EMPLOYEES_IDENTY.EMPLOYEE_ID = PAYROLL_JOB.EMPLOYEE_ID
                INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEES_IN_OUT.BRANCH_ID = PAYROLL_JOB.BRANCH_ID AND EMPLOYEES_IN_OUT.IN_OUT_ID = PAYROLL_JOB.IN_OUT_ID
                <cfif arguments.statue_type_individual neq 0>
                    INNER JOIN SALARYPARAM_PAY SP ON SP.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID 
                </cfif> 
            WHERE 
                PAYROLL_JOB.BRANCH_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.branch_id#" null = "no">
                AND PAYROLL_JOB.MONTH = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.month#" null = "no">
                AND PAYROLL_JOB.YEAR = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.year#" null = "no">
                <cfif len(arguments.employee_ids)>
                    AND PAYROLL_JOB.EMPLOYEE_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.employee_ids#">
                </cfif>
                <cfif len(arguments.puantaj_id)>
                    AND PAYROLL_JOB.BRANCH_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.puantaj_id#">
                </cfif>
                <cfif len(arguments.start_date_new) and len(arguments.finish_date_new)>
                    AND EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#arguments.finish_date_new#">
                    AND
                    (
                        (EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#arguments.start_date_new#">) OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
                    )
                <cfelse>
                    AND EMPLOYEES_IN_OUT.START_DATE <= #CREATEDATE(arguments.year,arguments.month,DAYSINMONTH(CREATEDATE(arguments.year,arguments.month,1)))#
                    AND
                    (
                        (EMPLOYEES_IN_OUT.FINISH_DATE >= #CREATEDATE(arguments.year,arguments.month,1)#) OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
                    )
                </cfif>
                <cfif arguments.statue_type_individual neq 0>
                    AND SP.START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.month#">
			        AND SP.END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.month#">
                </cfif>
                AND PAYROLL_JOB.PAYROLL_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.payroll_type#">
                AND ISNULL(EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF,0) <> 1
                AND PAYROLL_JOB.STATUE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue#">
                <cfif arguments.statue eq 2>
                    AND PAYROLL_JOB.STATUE_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type#">
                    <cfif arguments.statue_type_individual neq 0>
                        AND PAYROLL_JOB.STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#">
                        AND SP.COMMENT_PAY_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#">
                    </cfif>
                </cfif>
                AND EMPLOYEES_IN_OUT.USE_SSK = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue#">
                <cfif isdefined("arguments.jury_membership") and arguments.jury_membership eq 1>
                    AND EMPLOYEES_IN_OUT.JURY_MEMBERSHIP = <cfqueryparam CFSQLType = "cf_sql_bit" value = "1">
                </cfif> 
                <cfif isdefined("arguments.land_compensation_score") and arguments.land_compensation_score eq 1>
                    AND ISNULL(EMPLOYEES_IN_OUT.LAND_COMPENSATION_SCORE,0) <> <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">
                </cfif>
                <cfif arguments.statue eq 2 and arguments.statue_type eq 8>
                    AND ADMINISTRATIVE_ACADEMIC = <cfqueryparam CFSQLType = "cf_sql_integer" value = "3">
                <cfelseif arguments.statue eq 2>
                    AND ISNULL(ADMINISTRATIVE_ACADEMIC,0) <> <cfqueryparam CFSQLType = "cf_sql_integer" value = "3">
                </cfif>
            ORDER BY
                EMPLOYEE_NAME ASC,
                EMPLOYEE_SURNAME ASC
        </cfquery>
        <cfreturn PAYROLL_JOB_CONTROL>
    </cffunction>
    
    <!--- Çalışanın Geçmiş Zaman puantajı --->
    <cffunction name="GET_OLD_PAYROLL" access="public" returntype="any">
        <cfargument  name="in_out_id" default="" required="yes">
        <cfargument  name="payroll_id" default="" required="yes">
        <cfargument  name="payroll_type" default="" required="yes">
        <cfquery name="GET_OLD_PAYROLL" datasource="#dsn#">
            SELECT
                EMPLOYEE_PUANTAJ_ID
            FROM 
                EMPLOYEES_PUANTAJ_ROWS
            WHERE 
                PUANTAJ_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.payroll_id#" null = "no">
                AND IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.in_out_id#" null = "no">
        </cfquery>
        <cfreturn GET_OLD_PAYROLL>
    </cffunction>

    <!---- Puantaj, Muhasebe Taslakları ---->
    <cffunction name="PAYROLL_JOB_DRAFT" access="public" returntype="any">
        <cfargument  name="employee_payroll_id" default="" required="no">
        <cfquery name="PAYROLL_JOB_DRAFT" datasource="#dsn#">
            SELECT
                PAYROLL_DRAFT,
                PERCENT_COMPLETED,
                ACCOUNT_DRAFT,
                ACCOUNT_COMPLETED,
                BUDGET_DRAFT,
                BUDGET_COMPLETED
            FROM 
                PAYROLL_JOB
            WHERE 
                EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.employee_payroll_id#" null = "no">
        </cfquery>
        <cfreturn PAYROLL_JOB_DRAFT>
    </cffunction>

    <!--- Muhasebe Tanımları Kontrolü ---->
    <cffunction name="ACCOUNT_CONTROL" access="remote" returntype="any" returnformat="JSON"> 
        <cfargument  name="employee_id" default="" required="yes">
        <cfargument  name="in_out_id" default="" required="yes">
        <cfargument  name="sal_mon" default="" required="yes">
        <cfargument  name="sal_year" default="" required="yes">
        <cfargument  name="ssk_office" default="" required="yes">
        <cfquery name="get_puantaj_branch" datasource="#dsn#" maxrows="1">
            SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE BRANCH_ID = '#arguments.ssk_office#'
        </cfquery>
        <cfquery name="get_period_id" datasource="#dsn#" maxrows="1">
            SELECT PERIOD_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(arguments.sal_year,arguments.sal_mon,1)#">)) AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_branch.company_id#">
        </cfquery>
         <cfif get_period_id.recordcount eq 0>
            <cfset this.returnResult( status: false, fileid: arguments.in_out_id, message: "", errorMessage: "#getLang('','Muhasebe Hesap Tanımı Yapılmamıştır','64479')#") />
            <cfabort>
            <!--- <cfset account_response = "Muhasebe Hesap Tanımı Yapılmamıştır"> --->
        </cfif>
        <cfquery name="get_employee_no_accounts" datasource="#dsn#">
			SELECT 
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EI.START_DATE,
				EI.FINISH_DATE
			FROM 
                EMPLOYEES_IN_OUT EI,
				EMPLOYEES E
			WHERE 
				EI.IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.in_out_id#" null = "no"> AND 
				EI.IN_OUT_ID NOT IN (SELECT EIOP.IN_OUT_ID FROM EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIOP.ACCOUNT_BILL_TYPE IS NOT NULL AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_period_id.period_id#">) AND
				EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			ORDER BY
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
        </cfquery>
        <cfif get_employee_no_accounts.recordcount gt 0>
            <cfset this.returnResult( status: false, fileid: arguments.in_out_id, message: "", errorMessage: "#getLang('','Muhasebe Hesap Tanımı Yapılmamıştır','64479')#") />
            <!--- <cfset account_response = "Muhasebe Hesap Tanımı Yapılmamıştır"> --->
        <cfelse>
            <cfset account_response = 1>
        </cfif>
        <cfreturn account_response>
    </cffunction>

    <!--- Taslak Muhasebe Oluşturma ---->
    <cffunction name="CREATE_PAYROLL_ACCOUNT" access="remote" returntype="any" returnformat="JSON"> 
        <cfargument  name="in_out_id" default="" required="yes">
        <cfargument  name="payroll_id_list" default="" required="yes">
        <cfargument  name="sal_mon" default="" required="yes">
        <cfargument  name="sal_year" default="" required="yes">
        <cfargument  name="ssk_office" default="" required="yes">
        <cfargument  name="from_payroll_rows" default="1" required="yes">

        <!--- <cfset attributes.employee_id = arguments.employee_id> --->
        <cfquery name="get_emp_id" datasource="#dsn#">
            SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.in_out_id#" null = "no">
        </cfquery>
        <cfset attributes.employee_id = get_emp_id.employee_id>
        <cfset attributes.in_out_id = arguments.in_out_id>
        <cfset attributes.payroll_id_list = arguments.payroll_id_list>
        <cfset attributes.sal_mon = arguments.sal_mon>
        <cfset attributes.sal_year = arguments.sal_year>
        <cfset attributes.ssk_office = arguments.ssk_office>
        <cfset attributes.from_cpa = 1>
        <cfset attributes.from_payroll_rows = arguments.from_payroll_rows>

        <cfset from_payroll_rows = arguments.from_payroll_rows>
        <cfset payroll_id_list = arguments.payroll_id_list>
        <cfset return_error = 1>
        <cfset xml_cmp = createObject('component','V16.objects.cfc.fuseaction_properties')>
        <cfinclude template="../query/get_puantaj.cfm">
        <cfset attributes.puantaj_id = arguments.payroll_id_list>
        <cftry>
            <cfquery name="get_puantaj_branch" datasource="#dsn#" maxrows="1">
                SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE BRANCH_ID = '#get_puantaj.SSK_BRANCH_ID#'
            </cfquery>
            <cfquery name="get_period_id" datasource="#dsn#" maxrows="1">
                SELECT PERIOD_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(get_puantaj.sal_year,get_puantaj.sal_mon,1)#">)) <cfif len(get_puantaj_branch.company_id)>AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_branch.company_id#"></cfif>
            </cfquery>
            <cfcatch type="any">
                <cfset error_message = structnew()>
                <cfset error_message.message = cfcatch.Message>
                <cfset error_message.line = cfcatch.TagContext[1].LINE>
                <cfset error_message.raw_trace = cfcatch.TagContext[1].RAW_TRACE>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, message: "", errorMessage: error_message) />
            </cfcatch>
        </cftry>
        <!--- Xml ayarları --->
        <cfset account_process_cat_val = xml_cmp.get_fuseaction_property(
                company_id : get_puantaj_branch.company_id,
                fuseaction_name : 'ehesap.popup_add_puantaj_to_muhasebe',
                property_name : 'account_process_cat'
        )>
        <cfset budget_process_cat_val = xml_cmp.get_fuseaction_property(
                company_id : get_puantaj_branch.company_id,
                fuseaction_name : 'ehesap.popup_add_puantaj_to_muhasebe',
                property_name : 'budget_process_cat'
        )>
        <cfset xml_control_account_type_val = xml_cmp.get_fuseaction_property(
            company_id : get_puantaj_branch.company_id,
            fuseaction_name : 'ehesap.popup_add_puantaj_to_muhasebe',
            property_name : 'xml_control_account_type'
        )> 
        <cfset account_card_type_val = xml_cmp.get_fuseaction_property(
            company_id : get_puantaj_branch.company_id,
            fuseaction_name : 'ehesap.popup_add_puantaj_to_muhasebe',
            property_name : 'account_card_type'
        )>
        <cfset budget_process_cat = budget_process_cat_val.PROPERTY_VALUE>
        <cfset account_process_cat = account_process_cat_val.PROPERTY_VALUE>
        <cfset xml_control_account_type = xml_control_account_type_val.PROPERTY_VALUE>
        <cfset account_card_type = account_card_type_val.PROPERTY_VALUE>

        <cfif get_period_id.recordcount>
            <cfset new_period_id = get_period_id.period_id>
            <cfset new_dsn2 = '#dsn#_#get_period_id.period_year#_#get_puantaj_branch.COMPANY_ID#'>
            <cfset new_dsn3_alias = '#dsn#_#get_puantaj_branch.company_id#'>
            <cfinclude template="../query/get_puantaj_rows.cfm">

            <cfquery name="GET_IS_INTEGRATED" datasource="#dsn#">
                SELECT IS_INTEGRATED FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">
            </cfquery>
            <cfif get_puantaj_rows.recordcount>
                <cfset in_out_list = ListRemoveDuplicates(valuelist(get_puantaj_rows.in_out_id))>
            <cfelse>
                <cfset return_error = "<cf_get_lang dictionary_id='64479.Muhasebe Hesap Tanımı Yapılmamıştır'>">
            </cfif>
            <cfif not len(account_process_cat) or not len(budget_process_cat)>
                <cfset return_error = "<cf_get_lang dictionary_id='64480.Muhasebe işlemi yapabilmek için XML tanımlama sayfasında İşlem Kategorilerini tanımlamalısınız'>">
            </cfif>
            <cfif return_error eq 1>
                <cfinclude template="../query/create_account_payroll.cfm">
            </cfif>
        </cfif>
        <cfif return_error neq 1>
            <!--- <cfreturn Replace(SerializeJSON(return_error),"//","")> --->
            <cfset this.returnResult( status: false, fileid: arguments.in_out_id, message: "", errorMessage: return_error) />
        <cfelse>
            <cfreturn return_error>
        </cfif>
    </cffunction>

    <!--- Taslak Bütçe Oluşturma ---->
    <cffunction name="CREATE_PAYROLL_BUDGET" access="remote" returntype="any" returnformat="JSON"> 
        <cfargument  name="in_out_id" default="" required="yes">
        <cfargument  name="payroll_id_list" default="" required="yes">
        <cfargument  name="sal_mon" default="" required="yes">
        <cfargument  name="sal_year" default="" required="yes">
        <cfargument  name="ssk_office" default="" required="yes">
        <cfargument  name="from_payroll_rows" default="1" required="yes">

        <cfquery name="get_emp_id" datasource="#dsn#">
            SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.in_out_id#" null = "no">
        </cfquery>
        <cfset attributes.employee_id = get_emp_id.employee_id>
        <cfset attributes.in_out_id = arguments.in_out_id>
        <cfset attributes.payroll_id_list = arguments.payroll_id_list>
        <cfset attributes.sal_mon = arguments.sal_mon>
        <cfset attributes.sal_year = arguments.sal_year>
        <cfset attributes.ssk_office = arguments.ssk_office>
        <cfset attributes.from_cpa = 1>
        <cfset attributes.from_payroll_rows = arguments.from_payroll_rows>

        <cfset from_payroll_rows = arguments.from_payroll_rows>
        <cfset payroll_id_list = arguments.payroll_id_list>
        <cfset return_error = 1>
        <cftry>
            <cfinclude template="../query/get_puantaj.cfm">
            <cfquery name="get_puantaj_branch" datasource="#dsn#" maxrows="1">
                SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE BRANCH_ID = '#get_puantaj.SSK_BRANCH_ID#'
            </cfquery>
            <cfset attributes.sal_mon = get_puantaj.sal_mon>
            <cfset attributes.sal_year = get_puantaj.sal_year>
            
            <cfquery name="get_period_id" datasource="#dsn#" maxrows="1">
                SELECT 
                    PERIOD_ID,PERIOD_YEAR 
                FROM 
                    SETUP_PERIOD 
                WHERE 
                <cfif len(get_puantaj.sal_year)>
                    (PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.sal_year#"> 
                    OR 
                </cfif>
                    YEAR(FINISH_DATE) = #get_puantaj.sal_year#) 
                    AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #createdate(get_puantaj.sal_year,get_puantaj.sal_mon,1)#)) 
                    AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_branch.company_id#">
            </cfquery>
             <!--- Xml ayarları --->
            <cfset xml_cmp = createObject('component','V16.objects.cfc.fuseaction_properties')>
            <cfset is_add_emp_act_val = xml_cmp.get_fuseaction_property(
                    company_id : get_puantaj_branch.company_id,
                    fuseaction_name : 'ehesap.popup_add_puantaj_to_budget.xml',
                    property_name : 'is_add_emp_act'
            )>
            <cfset is_add_emp_act = is_add_emp_act_val.PROPERTY_VALUE>
            <cfset new_dsn2 = '#dsn#_#get_period_id.period_year#_#get_puantaj_branch.COMPANY_ID#'>
            <cfset new_period_id = get_period_id.period_id>
            <cfset new_dsn2_alias = "#new_dsn2#">
            <cfset attributes.puantaj_id = arguments.payroll_id_list>
            <cfinclude template="../query/get_puantaj_rows.cfm">
            <cfquery name="GET_IS_INTEGRATED" datasource="#dsn#">
                SELECT IS_INTEGRATED FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">
            </cfquery>
            <cfif get_puantaj_rows.recordcount>
                <cfset in_out_list = ListRemoveDuplicates(valuelist(get_puantaj_rows.in_out_id))>
            <cfelse>
                <cfset return_error = "<cf_get_lang dictionary_id ='53377.Puantaja Bağlı Satır Bulunamadı'>!">
            </cfif>
            <cfif return_error eq 1>
                <cfinclude template="../query/create_budget_payroll.cfm">
            </cfif>
            <cfif return_error neq 1>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, message: "", errorMessage: return_error) />
            <cfelse>
                <cfreturn return_error>
            </cfif>
        <cfcatch type="any">
            <cfset error_message = structnew()>
            <cfset error_message.message = cfcatch.Message>
            <cfset error_message.line = cfcatch.TagContext[1].LINE>
            <cfset error_message.raw_trace = cfcatch.TagContext[1].RAW_TRACE>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, message: "", errorMessage: error_message) />
        </cfcatch>
        </cftry>
    </cffunction>
    
    <cffunction name="CREATE_PAYROLL" access="remote" returntype="any" returnformat="JSON">
        <cfargument  name="statue_type_individual" default="0">

        <cfset attributes.in_out_id = arguments.in_out_id>
        <cfset attributes.statue_type_individual = arguments.statue_type_individual>
        <cfset from_step_payroll = 1>
        <cfif isdefined("arguments.from_fire_action")>
            <cfset from_fire_action = arguments.from_fire_action>
        <cfelse>
            <cfset from_fire_action = 0>
        </cfif>
        <cfquery name="get_emp_id" datasource="#dsn#">
            SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.in_out_id#" null = "no">
        </cfquery>
        <cfset attributes.employee_id = get_emp_id.employee_id>
        <cftry>
            <!--- <cfinclude template="/WMO/functions.cfc"> --->
            <cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
            <cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
            <cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
            <cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
            <cfset maas_puantaj_table = "EMPLOYEES_SALARY">
            <cfquery name="get_hours" datasource="#dsn#">
                SELECT
                    OUR_COMPANY_HOURS.OCH_ID,
                    OUR_COMPANY_HOURS.OUR_COMPANY_ID,
                    OUR_COMPANY_HOURS.DAILY_WORK_HOURS,
                    OUR_COMPANY_HOURS.SATURDAY_WORK_HOURS,
                    OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS,
                    OUR_COMPANY_HOURS.SSK_WORK_HOURS,
                    OUR_COMPANY_HOURS.UPDATE_DATE,
                    OUR_COMPANY_HOURS.WEEKLY_OFFDAY,
                    OUR_COMPANY_HOURS.SATURDAY_OFF,
                    OUR_COMPANY_HOURS.START_HOUR,
                    OUR_COMPANY_HOURS.START_MIN,
                    OUR_COMPANY_HOURS.END_HOUR,
                    OUR_COMPANY_HOURS.END_MIN,
                    OUR_COMPANY.NICK_NAME,
                    EMPLOYEES.EMPLOYEE_NAME,
                    EMPLOYEES.EMPLOYEE_SURNAME
                FROM
                    OUR_COMPANY_HOURS, 
                    EMPLOYEES, 
                    OUR_COMPANY
                WHERE
                    OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
                    OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
                    OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
                    OUR_COMPANY.COMP_ID = OUR_COMPANY_HOURS.OUR_COMPANY_ID
                    AND EMPLOYEES.EMPLOYEE_ID = OUR_COMPANY_HOURS.UPDATE_EMP
                <cfif isdefined("attributes.och_id") and len(attributes.och_id)>
                    AND OUR_COMPANY_HOURS.OCH_ID = #attributes.och_id#
                <cfelseif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
                    AND OUR_COMPANY_HOURS.OUR_COMPANY_ID = #attributes.our_company_id#
                </cfif>
            </cfquery> 
            <cfif arguments.puantaj_type eq 0>
                <cfset maas_puantaj_table = "EMPLOYEES_SALARY_PLAN">
            </cfif>


            <cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
            <cfset puantaj_action.dsn = dsn />
            
            <cfset arguments.ssk_office = urldecode(arguments.ssk_office)>
            <cfif isdefined("arguments.hierarchy_puantaj") and len(arguments.hierarchy_puantaj)>
                <cfquery name="get_hierarchy_employees" datasource="#dsn#">
                    SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE HIERARCHY LIKE '#arguments.hierarchy_puantaj#%'
                </cfquery>
                <cfif get_hierarchy_employees.recordcount>
                    <cfset hierarchy_emp_list = valuelist(get_hierarchy_employees.EMPLOYEE_ID)>
                <cfelse>
                    <cfset hierarchy_emp_list = 0>	
                </cfif>
            <cfelse>
                <cfset hierarchy_emp_list = ''>
            </cfif>

            <cfset branch_id_ = arguments.ssk_office>
            <cfset ilk_sal_mon_ = arguments.SAL_MON>
            <cfset ilk_sal_year_ = arguments.sal_year>
            <!---<cfset ilk_ssk_office_ = arguments.SSK_OFFICE>--->
            <cfset ilk_puantaj_type_ = arguments.puantaj_type>
            <cfquery name="get_action_id" datasource="#dsn#">
                SELECT
                    *
                FROM
                    EMPLOYEES_PUANTAJ
                WHERE
                    PUANTAJ_TYPE = #ilk_puantaj_type_# AND
                    SAL_MON = #ilk_sal_mon_# AND
                    SAL_YEAR = #ilk_sal_year_# AND
                    SSK_BRANCH_ID = #branch_id_#
                    <cfif isdefined("arguments.hierarchy_puantaj") and len(arguments.hierarchy_puantaj)>
                        AND HIERARCHY = '#arguments.hierarchy_puantaj#'
                    </cfif>
                    <cfif isdefined("arguments.ssk_statue") and len(arguments.ssk_statue)>
                        AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#">
                        <cfif isdefined("arguments.ssk_statue") and len(arguments.ssk_statue) and arguments.ssk_statue eq 2>
                            AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                            <cfif arguments.statue_type_individual neq 0>
                                AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#">
                            </cfif>
                        </cfif>
                    </cfif>
            </cfquery>
            <cfset payroll_type_ = arguments.puantaj_type>
            <cfif arguments.puantaj_type eq -2><!--- fark puantaji varsada silinir bir daha yazilir --->
                <cfif get_action_id.recordcount>
                    <cfset arguments.reload_off = 1>
                    <cfset arguments.puantaj_id = get_action_id.puantaj_id>
                    <cfinclude template="delet_puantaj.cfm">
                    
                    <cfquery name="get_action_id_2" datasource="#dsn#">
                        SELECT
                            *
                        FROM
                            EMPLOYEES_PUANTAJ
                        WHERE
                            PUANTAJ_TYPE = -3 AND
                            SAL_MON = #ilk_sal_mon_# AND
                            SAL_YEAR = #ilk_sal_year_# AND
                            SSK_BRANCH_ID = #branch_id_#
                            <cfif isdefined("arguments.hierarchy_puantaj") and len(arguments.hierarchy_puantaj)>
                                AND hierarchy_puantaj = '#arguments.hierarchy_puantaj#'
                            </cfif>
                            AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#">
                            <cfif isdefined("arguments.ssk_statue") and len(arguments.ssk_statue) and arguments.ssk_statue eq 2>
                                AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                                <cfif isdefined("arguments.statue_type_individual") and arguments.statue_type_individual neq 0>
                                    AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#">
                                </cfif>
                            </cfif>
                    </cfquery>
                    <cfif get_action_id_2.recordcount>
                        <cfset arguments.reload_off = 1>
                        <cfset arguments.puantaj_id = get_action_id_2.puantaj_id>
                        <cfinclude template="delet_puantaj.cfm">
                    </cfif>	
                    <cfset get_action_id.recordcount = 0>	
                </cfif>
            </cfif>
            <cfquery name="get_comp_info" datasource="#DSN#">
                SELECT
                    OUR_COMPANY.NICK_NAME COMP_NICK_NAME,
                    OUR_COMPANY.COMPANY_NAME COMP_FULL_NAME,
                    BRANCH.BRANCH_FULLNAME,
                    BRANCH.BRANCH_NAME,
                    BRANCH.SSK_OFFICE,
                    BRANCH.SSK_NO
                FROM
                    OUR_COMPANY,
                    BRANCH
                WHERE
                    OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
                    BRANCH.BRANCH_ID = #branch_id_#
            </cfquery>

            <cfif not get_action_id.recordcount>
                <cftransaction>
                    <cfquery name="ADD_PUANTAJ" datasource="#dsn#">
                        INSERT INTO #main_puantaj_table#
                        (
                            PUANTAJ_TYPE,
                            SAL_MON,
                            SAL_YEAR,
                            IS_ACCOUNT,
                            IS_LOCKED,
                            COMP_NICK_NAME,
                            COMP_FULL_NAME,
                            PUANTAJ_BRANCH_NAME,
                            PUANTAJ_BRANCH_FULL_NAME,
                            SSK_OFFICE,
                            SSK_OFFICE_NO,
                            SSK_BRANCH_ID,
                            HIERARCHY,
                            STAGE_ROW_ID,
                            IS_LOCK_CONTROL,
                            PAYMENT_DATE,
                            RECORD_DATE,
                            RECORD_IP,
                            RECORD_EMP,
                            STATUE,
                            STATUE_TYPE,
                            STATUE_TYPE_INDIVIDUAL
                        )
                        VALUES
                        (
                            #arguments.puantaj_type#,
                            #arguments.SAL_MON#,
                            #arguments.sal_year#,
                            0,
                            0,
                            '#get_comp_info.COMP_NICK_NAME#',
                            '#get_comp_info.COMP_FULL_NAME#',
                            '#get_comp_info.BRANCH_NAME#',
                            '#get_comp_info.BRANCH_FULLNAME#', 
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value='#get_comp_info.SSK_OFFICE#'>,
                            '#get_comp_info.SSK_NO#',
                            #arguments.SSK_OFFICE#,
                            <cfif isdefined("arguments.hierarchy_puantaj") and len(arguments.hierarchy_puantaj)>'#arguments.hierarchy_puantaj#'<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>#arguments.process_stage#<cfelse>NULL</cfif>,
                            1,
                            <cfif isdefined("arguments.payment_day") and len(arguments.payment_day)><cfqueryparam value = "#arguments.payment_day#" CFSQLType = "CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
                            #now()#,
                            '#cgi.remote_addr#',
                            #session.ep.userid#,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#">,
                            <cfif isdefined("arguments.statue_type") and len(arguments.statue_type) and arguments.ssk_statue eq 2>
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                            <cfelse>0</cfif>,
                            <cfif isdefined("attributes.statue_type_individual")>
                                <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#">
                            <cfelse>
                                0
                            </cfif>
                        )
                    </cfquery>
                    <cfquery name="GET_PUANTAJ_ID" datasource="#dsn#">
                        SELECT MAX(PUANTAJ_ID) AS MAX_ID FROM #main_puantaj_table#
                    </cfquery>
                    <cfif arguments.puantaj_type eq -2><!--- fark puantaji olusuyor ---> 
                            <cfquery name="ADD_PUANTAJ" datasource="#dsn#">
                                INSERT INTO #main_puantaj_table#
                                (
                                    PUANTAJ_TYPE,
                                    SAL_MON,
                                    SAL_YEAR,
                                    IS_ACCOUNT,
                                    IS_LOCKED,
                                    COMP_NICK_NAME,
                                    COMP_FULL_NAME,
                                    PUANTAJ_BRANCH_NAME,
                                    PUANTAJ_BRANCH_FULL_NAME,
                                    SSK_OFFICE,
                                    SSK_OFFICE_NO,
                                    SSK_BRANCH_ID,
                                    HIERARCHY,
                                    PAYMENT_DATE,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    RECORD_EMP,
                                    STATUE,
                                    STATUE_TYPE,
                                    STATUE_TYPE_INDIVIDUAL
                                )
                                VALUES
                                (
                                    -3,
                                    #arguments.SAL_MON#,
                                    #arguments.sal_year#,
                                    0,
                                    0,
                                    '#get_comp_info.COMP_NICK_NAME#',
                                    '#get_comp_info.COMP_FULL_NAME#',
                                    '#get_comp_info.BRANCH_NAME#',
                                    '#get_comp_info.BRANCH_FULLNAME#', 
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value='#get_comp_info.SSK_OFFICE#'>,
                                    '#get_comp_info.SSK_NO#',
                                    #arguments.SSK_OFFICE#,
                                    <cfif isdefined("arguments.hierarchy_puantaj") and len(arguments.hierarchy_puantaj)>'#arguments.hierarchy_puantaj#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.payment_day") and len(arguments.payment_day)><cfqueryparam value = "#arguments.payment_day#" CFSQLType = "CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
                                    #now()#,
                                    '#cgi.remote_addr#',
                                    #session.ep.userid#,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#">,
                                    <cfif isdefined("arguments.statue_type") and len(arguments.statue_type) and arguments.ssk_statue eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#"><cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.statue_type_individual")><cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#"><cfelse>0</cfif>
                                )
                            </cfquery>
                            <cfquery name="GET_SON_PUANTAJ_ID" datasource="#dsn#">
                                SELECT MAX(PUANTAJ_ID) AS MAX_ID FROM #main_puantaj_table#
                            </cfquery>
                            <cfset son_puantaj_id = GET_SON_PUANTAJ_ID.MAX_ID>
                    </cfif>
                </cftransaction>
                <cfset puantaj_id = GET_PUANTAJ_ID.MAX_ID>
            <cfelse>
                <cfset puantaj_id = get_action_id.PUANTAJ_ID>
                <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                    <cfquery name="upd_puantaj" datasource="#dsn#">
                        UPDATE 
                            #main_puantaj_table# 
                        SET 
                            STAGE_ROW_ID = #arguments.process_stage#
                        WHERE 
                            PUANTAJ_ID = #puantaj_id# 
                    </cfquery>
                </cfif>
            </cfif>
            <!--- Ödeme Günü 201091016ERU --->
            <cfif isdefined("arguments.payment_day") and len(arguments.payment_day)>
                <cfquery name="upd_puantaj" datasource="#dsn#">
                    UPDATE 
                        #main_puantaj_table# 
                    SET 
                        PAYMENT_DATE = <cfqueryparam value = "#arguments.payment_day#" CFSQLType = "CF_SQL_TIMESTAMP">	 
                    WHERE 
                        PUANTAJ_ID = #puantaj_id# 
                </cfquery>
            </cfif>
            <cfset arguments.puantaj_id = puantaj_id>
            <cfset arguments.action_type = "puantaj_aktarim">
            <cfset attributes.SSK_OFFICE = arguments.SSK_OFFICE>
            <cfset attributes.sal_year  = arguments.sal_year> 
            <cfset attributes.sal_mon  = arguments.sal_mon> 
            <cfset attributes.ssk_statue  = arguments.ssk_statue> 
            <cfif isdefined("arguments.statue_type") and len(arguments.statue_type) and arguments.ssk_statue eq 2>
                <cfset attributes.statue_type  = arguments.statue_type>
            <cfelse>
                <cfset attributes.statue_type  = 0>
            </cfif> 
            <cfset attributes.fuseaction = 'ehesap.list_puantaj'>
            <cfset attributes.branch_id = arguments.SSK_OFFICE>
            <cfinclude template="../query/get_program_parameter.cfm">
	        <cfif (isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0)) >
                <cfset start_date_new = CreateDateTime(attributes.sal_year,attributes.sal_mon,get_program_parameters.FIRST_DAY_MONTH,0,0,0)>
                <cfset finish_date_new = CreateDateTime(attributes.sal_year,attributes.sal_mon,get_program_parameters.LAST_DAY_MONTH,0,0,0)>
                <cfset finish_date_new = dateadd("m",1,finish_date_new)>
            </cfif>
            <cfinclude template="../query/get_ssk_employees.cfm">
            <cfset is_from_branch_puantaj = 1>
            <cfset index_ = 0>
            <cfloop query="GET_SSK_EMPLOYEES">
                <cfset index_ = index_ + 1>
                <cfset arguments.EMPLOYEE_ID = GET_SSK_EMPLOYEES.employee_id>
                <cfset arguments.branch_id = GET_SSK_EMPLOYEES.BRANCH_ID>
                <cfset arguments.group_id = "">
                
                <cfset attributes.employee_id  = arguments.employee_id>
                <cfif len(GET_SSK_EMPLOYEES.PUANTAJ_GROUP_IDS)>
                    <cfset arguments.group_id = "#GET_SSK_EMPLOYEES.PUANTAJ_GROUP_IDS#,">
                </cfif>
                <cfif index_ eq 1 or (index_ gt 1 and GET_SSK_EMPLOYEES.employee_id[index_ - 1] neq GET_SSK_EMPLOYEES.employee_id[index_])>
                    <cfscript>
                    add_personal_puantaj_ajax();
                    </cfscript>
                </cfif>
            </cfloop>

            <cfset ilk_sal_mon_ = arguments.SAL_MON>
            <cfset ilk_sal_year_ = arguments.sal_year>
            <cfset ilk_ssk_office_ = arguments.SSK_OFFICE>
            <cfset ilk_puantaj_type_ = arguments.puantaj_type>
            <cfquery name="get_action_id" datasource="#dsn#">
                SELECT
                    PUANTAJ_ID
                FROM
                    EMPLOYEES_PUANTAJ
                WHERE
                    PUANTAJ_TYPE = #ilk_puantaj_type_# AND
                    SAL_MON = #ilk_sal_mon_# AND
                    SAL_YEAR = #ilk_sal_year_# AND
                    SSK_BRANCH_ID = #ilk_ssk_office_#
                    <cfif isdefined("arguments.hierarchy_puantaj") and len(arguments.hierarchy_puantaj)>
                        AND HIERARCHY = '#arguments.hierarchy_puantaj#'
                    </cfif>
                    AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#">
                    <cfif isdefined("arguments.ssk_statue") and len(arguments.ssk_statue) and arguments.ssk_statue eq 2>
                        AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                        <cfif isdefined("arguments.statue_type_individual") and arguments.statue_type_individual neq 0>
                            AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#">
                        </cfif>
                    </cfif>
            </cfquery>
            <cfset arguments.puantaj_id = get_action_id.puantaj_id>

            <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
            <cfsavecontent variable = "description_">
                <cf_get_lang dictionary_id = "60761.Puantaj Aşama Güncelle">
            </cfsavecontent>
            <cf_workcube_process
                is_upd='1' 
                data_source='#dsn#' 
                old_process_line='0'
                process_stage='#arguments.process_stage#' 
                record_member='#session.ep.userid#'
                record_date='#now()#' 
                action_table='EMPLOYEE_PUANTAJ'
                action_column='PUANTAJ_ID'
                action_id='#arguments.PUANTAJ_ID#' 
                action_page='#request.self#?fuseaction=ehesap.list_puantaj' 
                warning_description='#description_# : #arguments.PUANTAJ_ID#'>
            </cfif>
            <cfif isdefined("get_hr_ssk.in_out_id") and len(get_hr_ssk.in_out_id)>
                <cfset in_out_id_ = get_hr_ssk.in_out_id>
            <cfelseif isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE)>
                <cfset in_out_id_ = attributes.SSK_OFFICE>
            <cfelse>
                <cfset in_out_id_ = ilk_ssk_office_>
            </cfif>
            
            <!--- ? En yüksek id yi aldığı için şuan memuriyette taslakta yanlış id veriyor tekrar kontrol edilecek  --->
            
            <cfquery name="GET_PUANTAJ_ID_" datasource="#dsn#">
                SELECT MAX(EMPLOYEE_PUANTAJ_ID) AS MAX_ID FROM EMPLOYEES_PUANTAJ_ROWS
            </cfquery>
            <cfif from_fire_action eq 0>
                <cfset this.returnResult( status: true, fileid: attributes.in_out_id, in_out_id:in_out_id_,employee_payroll_id: GET_PUANTAJ_ID_.MAX_ID ) />
            </cfif>
        <cfcatch type="any">
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, message: "", errorMessage: cfcatch) />
        </cfcatch>
        </cftry>
    </cffunction>
    <cffunction name="add_personal_puantaj_ajax" access="remote" returntype="any">
        <cftry>
            <cfparam name="attributes.puantaj_type" default="#payroll_type_#">
            <cfif not(isdefined('attributes.process_stage') and len(attributes.process_stage))><!--- Kişi puantajdan geliyorsa süreç olmadığı için db den ilk kayıt aşamasını alıyoruz. --->
                <cfquery name="get_process_type" datasource="#dsn#">
                    SELECT
                        PTR.STAGE,
                        PTR.PROCESS_ROW_ID 
                    FROM
                        PROCESS_TYPE_ROWS PTR,
                        PROCESS_TYPE_OUR_COMPANY PTO,
                        PROCESS_TYPE PT
                    WHERE
                        PT.IS_ACTIVE = 1 AND
                        PT.PROCESS_ID = PTR.PROCESS_ID AND
                        PT.PROCESS_ID = PTO.PROCESS_ID AND
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                        (PT.FACTION LIKE '%ehesap.list_puantaj' OR PT.FACTION LIKE '%ehesap.list_puantaj,%') 
                    ORDER BY
                        PTR.LINE_NUMBER
                </cfquery>
                <cfif get_process_type.recordcount>
                    <cfset attributes.process_stage = get_process_type.process_row_id>
                </cfif>
            </cfif>
            <cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
            <cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
            <cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
            <cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
            <cfset maas_puantaj_table = "EMPLOYEES_SALARY">
            <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq 0>
                <cfset maas_puantaj_table = "EMPLOYEES_SALARY_PLAN">
            </cfif>
            <cfif not isdefined("is_from_branch_puantaj")>
                <cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
                <cfset puantaj_action.dsn = dsn />
            </cfif>
            <!---<cfinclude template="../query/get_program_parameter.cfm">--->
            <cfif (not isDefined("attributes.ihbar_amount")) or (not len(attributes.ihbar_amount))>
                <cfset attributes.IHBAR_AMOUNT=0>
            <cfelse>
                <cfset attributes.IHBAR_AMOUNT=replacenocase(attributes.IHBAR_AMOUNT,".","","all")>
            </cfif>
            
            <cfif (not isDefined("attributes.kidem_amount")) or (not len(attributes.kidem_amount))>
                <cfset attributes.KIDEM_AMOUNT=0>
            <cfelse>
                <cfset attributes.KIDEM_AMOUNT=replacenocase(attributes.KIDEM_AMOUNT,".","","all")>
            </cfif>
            <!--- Puantaj ekleme sayfasında özel kod xml i açıksa ona göre işlem yapılacak --->
            <cfquery name="get_puantaj_xml" datasource="#dsn#">
                SELECT 
                    PROPERTY_VALUE,
                    PROPERTY_NAME
                FROM
                    FUSEACTION_PROPERTY
                WHERE
                    OUR_COMPANY_ID = #session.ep.company_id# AND
                    FUSEACTION_NAME = 'ehesap.list_puantaj' AND
                    PROPERTY_NAME = 'x_select_special_code'
            </cfquery>
            <cfif (get_puantaj_xml.recordcount and get_puantaj_xml.property_value eq 0) or get_puantaj_xml.recordcount eq 0><cfset x_select_special_code = 0><cfelse><cfset x_select_special_code = 1></cfif>
            <cfset get_hr_ssk = puantaj_action.get_hr_ssk(
                sal_mon : attributes.sal_mon,
                sal_year : attributes.sal_year,
                employee_id : attributes.employee_id,
                in_out_id : attributes.in_out_id,
                start_date_new : isdefined("start_date_new") ? start_date_new : '',
			    finish_date_new : isdefined("finish_date_new") ? finish_date_new : '')
            />
            <cfset attributes.puantaj_ids = ''>
            <cfoutput query="get_hr_ssk">
                <cfif len(get_hr_ssk.FINISH_DATE) and not len(get_hr_ssk.valid)><!--- cikis tarihi dolu olan ancak onay verilmemis calisan --->
                    <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: "#getLang('','Çıkış İşlemi Onaylanmamış Çalışan Tespit Edildi','65077')# : #get_hr_ssk.EMPLOYEE_NAME# #get_hr_ssk.EMPLOYEE_SURNAME#" , in_out_id: attributes.in_out_id) /> 
                </cfif>
                <cfif len(get_hr_ssk.FINISH_DATE) and len(get_hr_ssk.valid) and get_hr_ssk.valid eq 0><!--- cikis tarihi dolu olan ancak onay verilmemis calisan --->
                    <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: "#getLang('','Çıkış İşlemi Reddedilmiş Çalışan Tespit Edildi','65078')# : #get_hr_ssk.EMPLOYEE_NAME# #get_hr_ssk.EMPLOYEE_SURNAME#" , in_out_id: attributes.in_out_id) /> 
                </cfif>
                <cfif len(get_hr_ssk.KULLANILMAYAN_IZIN_AMOUNT) and get_hr_ssk.KULLANILMAYAN_IZIN_AMOUNT lt 0><!--- cikis tarihi dolu olan ancak izin parasi eksik olan --->
                    <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: "#getLang('','Çıkış İşlemi Hatalı Çalışan Tespit Edildi','65079')# , #getLang('','Lütfen İzin Gün ve Tutarlarında Düzenleme Yapınız','65080')#!<cf_get_lang dictionary_id='57576.Çalışan'> : #get_hr_ssk.EMPLOYEE_NAME# #get_hr_ssk.EMPLOYEE_SURNAME#" , in_out_id: attributes.in_out_id) /> 
                </cfif>
                <cfif x_select_special_code eq 1><!--- Eğer özel kod ile çalıştırılıyorsa çalışanın özel kodunun ait olduğu puantajı bulsun diye eklendi --->
                    <cfset get_action_id = puantaj_action.get_action_id(puantaj_type: attributes.puantaj_type,sal_mon: attributes.sal_mon,sal_year: attributes.sal_year,branch_id: get_hr_ssk.BRANCH_ID,hiearchy: get_hr_ssk.HIERARCHY,ssk_statue: attributes.ssk_statue,statue_type: attributes.statue_type,statue_type_individual : attributes.statue_type_individual)/>
                <cfelse>
                    <cfset get_action_id = puantaj_action.get_action_id(puantaj_type: attributes.puantaj_type,sal_mon: attributes.sal_mon,sal_year: attributes.sal_year,branch_id: get_hr_ssk.BRANCH_ID,ssk_statue: attributes.ssk_statue,statue_type: attributes.statue_type,statue_type_individual : attributes.statue_type_individual)/>
                </cfif>
                <cfif get_action_id.recordcount>
                    <cfquery name="get_dekont" datasource="#dsn#">
                        SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PUANTAJ_ID = #get_action_id.puantaj_id#
                    </cfquery>
                    <cfif get_action_id.is_account eq 1 or get_action_id.is_locked eq 1 or get_action_id.is_budget eq 1 or get_dekont.recordcount>
                        <cfreturn  {
                            status: false,
                            message: "Çalışan İçin Yapılan Puantajlardan Biri Carileştiği , Muhasebeleştirildiği , Bütçeleştirildiği ve/veya Kilitlendiği İçin İşlem Yapamazsınız!"
                        } />
                    <cfelseif not listfind(attributes.puantaj_ids,get_action_id.PUANTAJ_ID,',')>
                        <cfset attributes.puantaj_ids = listappend(attributes.puantaj_ids,get_action_id.PUANTAJ_ID,',')>
                    </cfif>
                </cfif>
            </cfoutput>
            <cfif listlen(attributes.puantaj_ids)>
                <cfset del_puantaj_rows_ext = puantaj_action.del_puantaj_rows_ext(attributes.puantaj_ids,attributes.EMPLOYEE_ID,attributes.in_out_id)>
                <cfset del_puantaj_rows_add = puantaj_action.del_puantaj_rows_add(attributes.puantaj_ids,attributes.EMPLOYEE_ID,attributes.in_out_id)>
                <cfset control = puantaj_action.control_devir_matrah(attributes.puantaj_ids,attributes.EMPLOYEE_ID)/>
                <cfif control.recordcount>
                    <cfoutput query="control">
                        <cfset attributes.sal_mon = SAL_MON>
                        <cfif len(ssk_devir) and ssk_devir gt 0>
                            <cfset update_puantaj_rows_add_devir = puantaj_action.update_puantaj_rows_add_devir_last(ssk_devir,control.puantaj_type,EMPLOYEE_ID,attributes.sal_mon,attributes.sal_year,attributes.in_out_id,attributes.ssk_statue,attributes.statue_type)>
                        </cfif>
                        <cfif len(ssk_devir_last) and ssk_devir_last gt 0>
                            <cfset update_puantaj_rows_add_devir_last = puantaj_action.update_puantaj_rows_add_devir(ssk_devir_last,control.puantaj_type,EMPLOYEE_ID,attributes.sal_mon,attributes.sal_year,attributes.in_out_id,attributes.ssk_statue,attributes.statue_type)>
                        </cfif>
                    </cfoutput>
                </cfif>
                <cfset del_puantaj_rows = puantaj_action.del_puantaj_rows(attributes.puantaj_ids,attributes.EMPLOYEE_ID,attributes.in_out_id)>
                <cfif get_hr_ssk.USE_SSK eq 2>
                    <!--- Memur Bordrosu ise --->
                    <cfset del_puantaj_rows_officer = puantaj_action.del_puantaj_rows_officer(attributes.puantaj_ids,attributes.EMPLOYEE_ID,attributes.in_out_id)>
                </cfif>
            </cfif>
            <cfset get_relatives = puantaj_action.get_relatives(attributes.EMPLOYEE_ID,attributes.sal_mon,attributes.sal_year)/>
            <cfoutput query="get_hr_ssk">
                <cfquery name="get_action_id" datasource="#dsn#">
                    SELECT
                        PUANTAJ_ID,
                        IS_ACCOUNT,
                        IS_BUDGET,
                        IS_LOCKED
                    FROM
                        EMPLOYEES_PUANTAJ
                    WHERE
                        PUANTAJ_TYPE = #attributes.puantaj_type# AND
                        SAL_MON = #attributes.sal_mon# AND
                        SAL_YEAR = #attributes.sal_year# AND
                        SSK_BRANCH_ID = #get_hr_ssk.BRANCH_ID[currentrow]#
                        <cfif x_select_special_code eq 1 and len(get_hr_ssk.HIERARCHY[currentrow])>
                            AND HIERARCHY = '#get_hr_ssk.HIERARCHY[currentrow]#'
                        </cfif>
                        AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
                        <cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2>
                            AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
                            <cfif isdefined("attributes.statue_type_individual") and attributes.statue_type_individual neq 0>
                                AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#">
                            </cfif>
                        </cfif>
                </cfquery>
                <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2><!--- fark puantaji olusuyor --->
                    <cfquery name="get_action_id_son" datasource="#dsn#">
                        SELECT
                            PUANTAJ_ID,
                            IS_ACCOUNT,
                            IS_BUDGET,
                            IS_LOCKED
                        FROM
                            EMPLOYEES_PUANTAJ
                        WHERE
                            PUANTAJ_TYPE = -3 AND
                            SAL_MON = #attributes.sal_mon# AND
                            SAL_YEAR = #attributes.sal_year# AND
                            SSK_BRANCH_ID = #get_hr_ssk.BRANCH_ID[currentrow]#
                            <cfif x_select_special_code eq 1 and len(get_hr_ssk.HIERARCHY[currentrow])>
                                AND HIERARCHY = '#get_hr_ssk.HIERARCHY[currentrow]#'
                            </cfif>
                            AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
                            <cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2>
                                AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
                                <cfif isdefined("attributes.statue_type_individual") and attributes.statue_type_individual neq 0>
                                    AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#">
                                </cfif>
                            </cfif>
                    </cfquery>
                </cfif>
                <cfif not get_action_id.recordcount>
                    <cflock name="#CREATEUUID()#" timeout="20">
                        <cftransaction>
                            <cfquery name="ADD_PUANTAJ" datasource="#dsn#" result="MAX_ID">
                                INSERT INTO
                                EMPLOYEES_PUANTAJ
                                (
                                    PUANTAJ_TYPE,
                                    SAL_MON,
                                    SAL_YEAR,
                                    IS_ACCOUNT,
                                    IS_LOCKED,
                                    SSK_OFFICE,
                                    SSK_OFFICE_NO,
                                    SSK_BRANCH_ID,
                                    COMP_NICK_NAME,
                                    COMP_FULL_NAME,
                                    PUANTAJ_BRANCH_NAME,
                                    PUANTAJ_BRANCH_FULL_NAME,
                                    <cfif x_select_special_code eq 1 and len(get_hr_ssk.HIERARCHY[currentrow])>
                                        HIERARCHY,
                                    </cfif>
                                    STAGE_ROW_ID,
                                    IS_LOCK_CONTROL,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    RECORD_EMP,
                                    STATUE,
                                    STATUE_TYPE,
                                    STATUE_TYPE_INDIVIDUAL
                                )
                                VALUES
                                (
                                    #attributes.puantaj_type#,
                                    #attributes.sal_mon#,
                                    #attributes.sal_year#,
                                    0,
                                    0,
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value='#get_hr_ssk.SSK_OFFICE[currentrow]#'>,
                                    '#get_hr_ssk.SSK_NO[currentrow]#',
                                    #get_hr_ssk.BRANCH_ID[currentrow]#,
                                    '#get_hr_ssk.COMP_NICK_NAME[currentrow]#',
                                    '#get_hr_ssk.COMP_FULL_NAME[currentrow]#',
                                    '#get_hr_ssk.BRANCH_NAME[currentrow]#',
                                    '#get_hr_ssk.BRANCH_FULLNAME[currentrow]#',
                                    <cfif x_select_special_code eq 1 and len(get_hr_ssk.HIERARCHY[currentrow])>
                                        '#get_hr_ssk.HIERARCHY[currentrow]#',
                                    </cfif>
                                    <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
                                    1,
                                    #now()#,
                                    '#cgi.remote_addr#',
                                    #session.ep.userid#,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">,
                                    <cfif isdefined("attributes.statue_type") and len(attributes.statue_type) AND attributes.ssk_statue eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#"><cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.statue_type_individual")><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#"><cfelse>0</cfif>
                                )
                            </cfquery>
                            <cfset GET_PUANTAJ_ID.MAX_ID = MAX_ID.IDENTITYCOL>
                            <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2><!--- fark puantaji olusuyor ---> 
                                <cfquery name="ADD_PUANTAJ" datasource="#dsn#">
                                    INSERT INTO
                                    EMPLOYEES_PUANTAJ
                                    (
                                        PUANTAJ_TYPE,
                                        SAL_MON,
                                        SAL_YEAR,
                                        IS_ACCOUNT,
                                        IS_LOCKED,
                                        SSK_OFFICE,
                                        SSK_OFFICE_NO,
                                        SSK_BRANCH_ID,
                                        COMP_NICK_NAME,
                                        COMP_FULL_NAME,
                                        PUANTAJ_BRANCH_NAME,
                                        PUANTAJ_BRANCH_FULL_NAME,
                                        <cfif x_select_special_code eq 1 and len(get_hr_ssk.HIERARCHY[currentrow])>
                                            HIERARCHY,
                                        </cfif>
                                        RECORD_DATE,
                                        RECORD_IP,
                                        RECORD_EMP,
                                        STATUE,
                                        STATUE_TYPE,
                                        STATUE_TYPE_INDIVIDUAL
                                    )
                                    VALUES
                                    (
                                        -3,
                                        #attributes.sal_mon#,
                                        #attributes.sal_year#,
                                        0,
                                        0,
                                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value='#get_hr_ssk.SSK_OFFICE[currentrow]#'>,
                                        '#get_hr_ssk.SSK_NO[currentrow]#',
                                        #get_hr_ssk.BRANCH_ID[currentrow]#,
                                        '#get_hr_ssk.COMP_NICK_NAME[currentrow]#',
                                        '#get_hr_ssk.COMP_FULL_NAME[currentrow]#',
                                        '#get_hr_ssk.BRANCH_NAME[currentrow]#',
                                        '#get_hr_ssk.BRANCH_FULLNAME[currentrow]#',
                                        <cfif x_select_special_code eq 1 and len(get_hr_ssk.HIERARCHY[currentrow])>
                                            '#get_hr_ssk.HIERARCHY[currentrow]#',
                                        </cfif>
                                        #now()#,
                                        '#cgi.remote_addr#',
                                        #session.ep.userid#,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">,
                                        <cfif isdefined("attributes.statue_type") and len(attributes.statue_type) AND attributes.ssk_statue eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#"><cfelse>NULL</cfif>,
                                        <cfif isdefined("attributes.statue_type_individual")><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#"><cfelse>0</cfif>
                                    )
                                </cfquery>
                                <cfquery name="GET_SON_PUANTAJ_ID" datasource="#dsn#">
                                    SELECT MAX(PUANTAJ_ID) AS MAX_ID FROM #main_puantaj_table#
                                </cfquery>
                                <cfset son_puantaj_id = GET_SON_PUANTAJ_ID.MAX_ID>
                            </cfif>
                        </cftransaction>
                    </cflock>
                    <cfset puantaj_id = GET_PUANTAJ_ID.MAX_ID>
                <cfelse>
                    <cfset puantaj_id = get_action_id.PUANTAJ_ID>
                    <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2><!--- fark puantaji olusuyor --->
                        <cfset son_puantaj_id = get_action_id_son.PUANTAJ_ID>	
                    </cfif>
                </cfif>
                
                <cfset attributes.puantaj_id = puantaj_id>
                <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2><!--- fark puantaji olusuyor --->
                    <cfset attributes.son_puantaj_id = son_puantaj_id>
                </cfif>
                <cfset attributes.row_department_head = get_hr_ssk.DEPARTMENT_HEAD>
                <cfset attributes.in_out_id = get_hr_ssk.IN_OUT_ID>
                <cfset attributes.our_company_id = get_hr_ssk.COMPANY_ID>
                <cfset attributes.SOCIALSECURITY_NO = get_hr_ssk.SOCIALSECURITY_NO>
                <cfif not isdefined("attributes.action_type")>
                    <cfset attributes.action_type = "puantaj_aktarim_personal">
                </cfif>
                <cfset salary = 0>
                <cfif isdefined('attributes.finish_date_')><!--- SG 20140123 işten çıkış ekranı 1ekranda hesaplama yaparken güne göre hesaplanan ödeneklerin doğru hesaplanması için eklendi--->
                    <cfset get_hr_ssk.finish_date = attributes.finish_date_>
                </cfif>
                <cfscript>
                    get_hr_compass_loop();
                </cfscript>
            </cfoutput>
            <cfif isdefined("attributes.ajax")>
                <cfif attributes.fuseaction is not 'ehesap.emptypopup_add_puantaj_list_from_salary'>
                    <script type="text/javascript">
                        <cfif isdefined("attributes.from_list_puantaj") and len(attributes.from_list_puantaj) and attributes.from_list_puantaj eq 1>
                            AjaxPageLoad(adres_,'puantaj_list_layer_from_list_puantaj','1','Puantaj Listeleniyor');
                        <cfelse>
                            AjaxPageLoad(adres_,'puantaj_list_layer','1','Puantaj Listeleniyor');
                        </cfif>
                        AjaxPageLoad(adres_menu_2,'menu_puantaj_2','1','Puantaj Menüsü Yükleniyor');
                    </script>
                </cfif>
            </cfif>
        <cfcatch type="any">
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: cfcatch , in_out_id: attributes.in_out_id) />
        </cfcatch>
        </cftry>
    </cffunction>
    <cffunction name="get_hr_compass_loop" access="remote" returntype="any">
        <cftry>
            <cfif not isdefined("puantaj_action")>
                <cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
                <cfset puantaj_action.dsn = dsn />
                
                <cfset get_hr_ssk = puantaj_action.get_hr_ssk(
                    sal_mon : attributes.sal_mon,
                    sal_year : attributes.sal_year,
                    employee_id : attributes.employee_id,
                    in_out_id : attributes.in_out_id,
                    start_date_new : isdefined("start_date_new") ? start_date_new : '',
                    finish_date_new : isdefined("finish_date_new") ? finish_date_new : '')/>
            </cfif>
            
            <cfset month_loop = 0>
            
            
            <cfset gelir_vergisi_matrah_ay_icinde_nakil = 0>
            <cfscript>
                employee_id_ = attributes.EMPLOYEE_ID;               
                this_expense_code_ = get_hr_ssk.expense_code;
                this_account_code_ = get_hr_ssk.account_code;
                this_account_bill_type_ = get_hr_ssk.account_bill_type;
            </cfscript>
            <!---SG 20130227 --->
            <cfset get_half_offtimes.recordcount = 0>
            <cfset get_half_offtimes_total_hour = 0>
            <!---// --->
            <cfset last_branch_id = get_hr_ssk.BRANCH_ID>
            <cfif not isdefined("attributes.in_out_id") or not len(attributes.in_out_id)>
                <cfset attributes.in_out_id = get_hr_ssk.in_out_id>
            </cfif>
            <cfset attributes.branch_id = get_hr_ssk.BRANCH_ID>	
            <cfset attributes.group_id = "">
            <cfif len(get_hr_ssk.puantaj_group_ids)>
                <cfset attributes.group_id = "#get_hr_ssk.PUANTAJ_GROUP_IDS#,">
            </cfif>
            <cfset attributes.fuseaction = 'ehesap.list_puantaj'>
            <cfinclude template="../query/get_program_parameter.cfm">
            <cfscript>
                //Bordro akış parametrelerinden eğer bordro tarihleri girildiyse o tarihleri alır
                if(isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0))
                {
                    last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_program_parameters.FIRST_DAY_MONTH,0,0,0);
                    
                    last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_program_parameters.LAST_DAY_MONTH,23,59,59);
                    last_month_30 = dateadd("m",1,last_month_30);

                    last_month_1_general = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_program_parameters.FIRST_DAY_MONTH,0,0,0);

                    last_month_30_general = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_program_parameters.LAST_DAY_MONTH,23,59,59);
                    last_month_30_general = dateadd("m",1,last_month_30_general);
                }
                else
                {
                    last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon,1,0,0,0);
                    last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon,daysinmonth(last_month_1),23,59,59);
                    
                    last_month_1_general = CreateDateTime(attributes.sal_year, attributes.sal_mon,1,0,0,0);
                    last_month_30_general = CreateDateTime(attributes.sal_year, attributes.sal_mon,daysinmonth(last_month_1_general),23,59,59);
                    
                } 
                if (datediff("h",last_month_1,get_hr_ssk.start_date) gte 0)
                {
                    last_month_1 = get_hr_ssk.start_date;
                    last_month_1_general = get_hr_ssk.start_date;
                }
                last_month_1 = date_add("d",0,last_month_1);

                if (len(get_hr_ssk.finish_date) and datediff("d",get_hr_ssk.finish_date,last_month_30) gt 0)
                    last_month_30 = CreateDateTime(year(get_hr_ssk.finish_date),month(get_hr_ssk.finish_date),day(get_hr_ssk.finish_date), 23,59,59);
            </cfscript>
           
            <cfif isdefined("pp_error") and len(pp_error)>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: pp_error , in_out_id: attributes.in_out_id) />
            </cfif>
            <cfquery name="get_active_program_parameter" dbtype="query"><!--- maxrows="1" --->
                SELECT * FROM get_program_parameters  <!---WHERE STARTDATE <= #last_month_1#  AND FINISHDATE >= #last_month_30# --->
            </cfquery>

            <!--- Memur değilse ve  parametrelerinden eğer bordro tarihleri 1-aysonu hariç seçilmişse --->
            <cfif (get_hr_ssk.USE_SSK neq 2) and (isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0)) >
                
                <cfset last_salary = this.get_salary_history(start_month: last_month_1)>
                <cfset last_salary_end = this.get_salary_history(start_month: last_month_30)>

                <!--- 2 ay arasında maaş farklıysa --->
                <cfif evaluate("last_salary.M#month(last_month_1)#") neq evaluate("last_salary_end.M#month(last_month_30)#")>

                    <cfset last_month_1 = listappend(last_month_1,CreateDateTime(year(last_month_30),month(last_month_30),1,0,0,0))>

                    <cfset temp_last = last_month_30>
                    <cfset last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon,daysinmonth(last_month_1),23,59,59)>
                    <cfset last_month_30 = listAppend(last_month_30,temp_last)>

                   <cfset last_month_1_general = last_month_1>
                    <cfset last_month_30_general = last_month_30>
                    <cfset for_ssk_day = 1>

                </cfif>
            </cfif>
            <cfset last_month_30_temp = last_month_30>
            <cfset last_month_30_general_temp = last_month_30_general>

            <cfloop list="#last_month_1#" item="date" index="date_row">

                <cfset last_month_1 = date>
                <cfif listlen(last_month_1) gt 1>
                    <cfset last_month_1_general = date>
                    <cfset last_month_30_general = ListGetAt(last_month_30_general_temp,date_row)>
                </cfif>

                <cfset last_month_30 = ListGetAt(last_month_30_temp,date_row)>
                <cfset attributes.sal_mon = month(last_month_1)>
                <cfset attributes.sal_year = year(last_month_1)>

                <cfif not isdefined("get_general_offtimes_all.recordcount")>
                    <cfset get_general_offtimes_all = puantaj_action.get_general_offtimes_all(last_month_1_general,last_month_30_general)/>
                </cfif>
                
                <cfquery name="get_general_offtimes" dbtype="query">
                    SELECT 
                        START_DATE,
                        FINISH_DATE 
                    FROM 
                        get_general_offtimes_all
                    WHERE 
                        START_DATE BETWEEN #LAST_MONTH_1# AND #LAST_MONTH_30# OR 
                        FINISH_DATE BETWEEN #LAST_MONTH_1# AND #LAST_MONTH_30#
                    GROUP BY
                        START_DATE,
                        FINISH_DATE 
                    ORDER BY
                        START_DATE ASC
                </cfquery>
                
                <cfif len(get_active_program_parameter.CAST_STYLE)><!--- hesaplama turu , normal (0) - asgari gecim (1) --->
                    <cfset this_cast_style_ = get_active_program_parameter.CAST_STYLE>
                <cfelse>
                    <cfset this_cast_style_ = 0>
                </cfif>
                <cfif len(get_active_program_parameter.TAX_ACCOUNT_STYLE)>
                    <cfset this_tax_account_style_ = get_active_program_parameter.TAX_ACCOUNT_STYLE>
                <cfelse>
                    <cfset this_tax_account_style_ = 0>
                </cfif>
                <cfif get_active_program_parameter.is_avans_off eq 1><!--- avanslar puantaja yansisin veya yansimasin --->
                    <cfset is_avans_off_ = 1>
                <cfelse>
                    <cfset is_avans_off_ = 0>
                </cfif>
                <cfquery name="get_days" datasource="#dsn#">
                    SELECT 
                        ISNULL(SUM(EPR.TOTAL_DAYS),0) AS KUMULATIF_DAYS 
                    FROM 
                        EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP 
                        ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID 
                    WHERE 
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#"> AND 
                        SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
                        SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
                        AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
                        <cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2>
                            AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
                            <cfif isdefined("attributes.statue_type_individual") and attributes.statue_type_individual neq 0>
                                AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#">
                            </cfif>
                        </cfif>
                </cfquery> 
                <!--- İşçi Bordrosu ise --->
                <cfif get_hr_ssk.USE_SSK eq 2>
                    <!--- Memur Bordrosu ise --->
                    <cfset get_salary_info = this.get_salary_history(start_month: last_month_1)>
                    <cfif (evaluate("get_salary_info.M#month(last_month_1)#") eq 0 or not len(evaluate("get_salary_info.M#month(last_month_1)#"))) and get_hr_ssk.administrative_academic eq 2>
                        <cfset a= getLang('','isimli çalışan için','64483')>
                        <cfset b= getLang('','ayın Maaş, SSK, Para Kuru bilgilerinden bir veya birkaçı Eksik','64484')>
                        <cfset response = "#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# #a# #attributes.sal_mon#. #b# !">
                        <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: response, in_out_id:attributes.in_out_id ) />
                        <cfabort>
                    <cfelse>
                        <cfscript>
                            officer_payroll();
                        </cfscript>
                    </cfif>
                </cfif>
                <cfset DATABASE_TYPE  = 'MSSQL'>
                <cfinclude  template="../query/get_hr_compass.cfm">
                <cfif isdefined("ssk_matrah_kullanilan") and ssk_matrah_kullanilan gt 0>
                    <cfset devir_kalan_tutar = ssk_matrah_kullanilan>
                    <cfquery name="get_onceki_ay" dbtype="query">
                        SELECT 
                            * 
                        FROM 
                            get_devir_mahrah 
                        WHERE 
                            <cfif attributes.sal_mon gt 2>
                                (
                                SAL_YEAR = #attributes.sal_year# AND
                                SAL_MON = #attributes.sal_mon - 2#
                                )
                                <cfelseif attributes.sal_mon eq 1>
                                (
                                SAL_YEAR = #attributes.sal_year-1# AND
                                SAL_MON = 11
                                )
                                <cfelseif attributes.sal_mon eq 2>
                                (
                                (SAL_YEAR = #attributes.sal_year-1# AND SAL_MON = 12)
                                )
                                </cfif>
                            </cfquery>
                    <cfif get_onceki_ay.recordcount and get_onceki_ay.amount gt get_onceki_ay.amount_used>
                        <cfset onceki_aydan_gelen = get_onceki_ay.amount - get_onceki_ay.amount_used>
                        <cfif onceki_aydan_gelen gte devir_kalan_tutar>
                            <cfset onceki_aydan_dusulecek = devir_kalan_tutar>
                            <cfset devir_kalan_tutar = 0>
                            <cfquery name="upd_" datasource="#dsn#">
                                UPDATE #add_puantaj_table# SET AMOUNT_USED = #get_onceki_ay.amount_used + onceki_aydan_dusulecek# WHERE ROW_ID = #get_onceki_ay.row_id#
                            </cfquery>
                        <cfelse>
                            <cfset devir_kalan_tutar = devir_kalan_tutar - onceki_aydan_gelen>
                            <cfset onceki_aydan_dusulecek = onceki_aydan_gelen>
                            <cfquery name="upd_" datasource="#dsn#">
                                UPDATE #add_puantaj_table# SET AMOUNT_USED = #get_onceki_ay.amount# WHERE ROW_ID = #get_onceki_ay.row_id#
                            </cfquery>
                        </cfif>
                    </cfif>
                    <cfif devir_kalan_tutar gt 0>
                        <cfquery name="get_gecen_ay" dbtype="query">
                            SELECT 
                                * 
                            FROM 
                                get_devir_mahrah
                            WHERE 
                                <cfif attributes.sal_mon gt 2>
                                (
                                SAL_YEAR = #attributes.sal_year# AND
                                SAL_MON = #attributes.sal_mon - 1# 
                                )
                                <cfelseif attributes.sal_mon eq 1>
                                (
                                SAL_YEAR = #attributes.sal_year-1# AND
                                SAL_MON = 12
                                )
                                <cfelseif attributes.sal_mon eq 2>
                                SAL_YEAR = #attributes.sal_year# AND 
                                SAL_MON = 1		
                                </cfif>
                        </cfquery>
                        <cfif get_gecen_ay.recordcount and get_gecen_ay.amount gt get_gecen_ay.amount_used>
                            <cfset gecen_aydan_gelen = get_gecen_ay.amount - get_gecen_ay.amount_used>
                            <cfif gecen_aydan_gelen gte devir_kalan_tutar>
                                <cfset gecen_aydan_dusulecek = devir_kalan_tutar>
                                <cfset devir_kalan_tutar = 0>
                                <cfquery name="upd_" datasource="#dsn#">
                                    UPDATE #add_puantaj_table# SET AMOUNT_USED = #get_gecen_ay.amount_used + gecen_aydan_dusulecek# WHERE ROW_ID = #get_gecen_ay.row_id#
                                </cfquery>
                            <cfelse>
                                <cfset devir_kalan_tutar = devir_kalan_tutar - gecen_aydan_gelen>
                                <cfset gecen_aydan_dusulecek = gecen_aydan_gelen>
                                <cfquery name="upd_" datasource="#dsn#">
                                    UPDATE #add_puantaj_table# SET AMOUNT_USED = #get_gecen_ay.amount# WHERE ROW_ID = #get_gecen_ay.row_id#
                                </cfquery>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfif>
                <cfif attributes.action_type is "pusula_görüntüleme">
                    <cfset attributes.comp_id = get_hr_ssk.company_id>
                    <cfinclude template="get_our_comp_name.cfm">
                    <cfsavecontent variable="icerik_mevcut_durum"><cfinclude template="../display/view_price_compass_2.cfm"></cfsavecontent>
                    <table cellpadding="0" cellspacing="0" style="width:210mm;height:284.9mm;;" align="center" border="0">
                        <tr>
                            <td height="5">&nbsp;</td>
                        </tr>
                        <tr>
                            <td valign="top"><cfoutput>#icerik_mevcut_durum#</cfoutput></td>
                        </tr>
                        <tr>
                            <td valign="top"><cfoutput>#icerik_mevcut_durum#</cfoutput></td>
                        </tr>
                    </table>
                <cfelse>
                    <cfif not len(response)>
                        <cfinclude  template="../query/add_personal_puantaj_2.cfm">
                    <cfelse>
                        <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: response, in_out_id:attributes.in_out_id ) />
                    </cfif>
                </cfif> 
            </cfloop>
        <cfcatch type="any">
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: cfcatch , in_out_id: attributes.in_out_id) />
        </cfcatch>
        </cftry>
    </cffunction>
    <cfscript>
        public any function returnResult( boolean status, numeric fileid = 0, string message = "", any errorMessage = "",numeric in_out_id = 0,numeric employee_payroll_id = 0 ) returnformat = "JSON" {
            response = structNew();
            response = {
                status: status,
                fileid: fileid,
                message: message,
                errorMessage: errorMessage,
                in_out_id: in_out_id,
                employee_payroll_id: employee_payroll_id
            };
            GetPageContext().getCFOutput().clear();
            writeOutput(Replace(SerializeJSON(response),"//",""));
            abort;
        }
    </cfscript>
    <cffunction name="cfquery_" returntype="any" output="false">
        <!--- 
            usage : my_query_name = cfquery_(SQLString:required,Datasource:required(bos olabilir),dbtype:optional,is_select:optinal); 
            Select olmayan yerlerde is_select:false olarak verilmelidir
        --->
        <cfargument name="SQLString" type="string" required="true">
        <cfargument name="Datasource" type="string" required="true">
        <cfargument name="dbtype" type="string" required="no">
        <cfargument name="is_select" type="boolean" required="no" default="true">
        
        <cfif isdefined("arguments.dbtype") and len(arguments.dbtype)>
            <cfquery name="workcube_cf_query" dbtype="query">
                #preserveSingleQuotes(arguments.SQLString)#
            </cfquery>
        <cfelse>
            <cfquery name="workcube_cf_query" datasource="#arguments.Datasource#">
                #preserveSingleQuotes(arguments.SQLString)#
            </cfquery>
        </cfif>
        <cfif arguments.is_select>
            <cfreturn workcube_cf_query>
        <cfelse>
            <cfreturn true>
        </cfif>
    </cffunction>
    <!--- Bu fonksiyon yuvarlama işlemi yapar. --->
    <cffunction name="wrk_round_" returntype="string" output="false">
        <cfargument name="number" required="true">
        <cfargument name="decimal_count" required="no" default="2">
        <cfargument name="kontrol_float" required="no" default="0"><!--- ürün ağacında çok ufak değerler girildiğinde E- formatında yazılanlar bozulmasın diye eklendi SM20101007 --->
        <cfscript>
            if (not len(arguments.number)) return '';
            if(arguments.kontrol_float eq 0)
            {
                if (arguments.number contains 'E') arguments.number = ReplaceNoCase(NumberFormat(arguments.number), ',', '', 'all');
            }
            else
            {
                if (arguments.number contains 'E') 
                {
                    first_value = listgetat(arguments.number,1,'E-');
                    first_value = ReplaceNoCase(first_value,',','.');
                    last_value = ReplaceNoCase(listgetat(arguments.number,2,'E-'),'0','','all');
                    //if(last_value gt 5) last_value = 5;
                    for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
                    {
                        zero_info = ReplaceNoCase(first_value,'.','');
                        first_value = '0.#zero_info#';
                    }
                    arguments.number = first_value;
                            first_value = listgetat(arguments.number,1,'.');
                arguments.number = "#first_value#.#Left(listgetat(arguments.number,2,'.'),8)#";
                    if(arguments.number lt 0.00000001) arguments.number = 0;
                    return arguments.number;
                }
            }
            if (arguments.number contains '-'){
                negativeFlag = 1;
                arguments.number = ReplaceNoCase(arguments.number, '-', '', 'all');}
            else negativeFlag = 0;
            if(not isnumeric(arguments.decimal_count)) arguments.decimal_count= 2;	
            if(Find('.', arguments.number))
            {
                tam = listfirst(arguments.number,'.');
                onda =listlast(arguments.number,'.');
                if(onda neq 0 and arguments.decimal_count eq 0) //yuvarlama sayısı sıfırsa noktadan sonraki ilk rakama gore tam kısımda yuvarlama yapılır
                {
                    if(Mid(onda, 1,1) gte 5) // yuvarlama 
                        tam= tam+1;	
                }
                else if(onda neq 0 and len(onda) gt arguments.decimal_count)
                {
                    if(Mid(onda,arguments.decimal_count+1,1) gte 5) // yuvarlama
                    {
                        onda = Mid(onda,1,arguments.decimal_count);
                        textFormat_new = "0.#onda#";
                        textFormat_new = textFormat_new+1/(10^arguments.decimal_count);
                        
                        decimal_place_holder = '_.';
                        for(decimal_index=1;decimal_index<=arguments.decimal_count;++decimal_index)
                            decimal_place_holder = '#decimal_place_holder#_';
                        textFormat_new = LSNumberFormat(textFormat_new,decimal_place_holder);
                            
                        if(listlen(textFormat_new,'.') eq 2)
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda =listlast(textFormat_new,'.');
                        }
                        else
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda = '';
                        }
                    }
                    else
                        onda= Mid(onda,1,arguments.decimal_count);
                }
            }
            else
            {
                tam = arguments.number;
                onda = '';
            }
            textFormat='';
            if(len(onda) and onda neq 0 and arguments.decimal_count neq 0)
                textFormat = "#tam#.#onda#";
            else
                textFormat = "#tam#";
            if (negativeFlag) textFormat =  "-#textFormat#";
            return textFormat;
        </cfscript>
    </cffunction>

    <!--- Memur Puantaj Hesap Giriş --->
    <cffunction name="officer_payroll" access="public" returntype="any">
        <!--- Yabancı Dil Component --->
        <cfset get_component_lang = createObject("component","V16.settings.cfc.language_allowance")>

        <!--- Akademik Teşvik Ödeneği Oranları --->
        <cfset get_academic_personnel = createObject("component","V16.hr.ehesap.cfc.academic_personnel_rate")>

        <cfset officer_salary = 0><!--- Maaş --->
        <cfset officer_salary_retired = 0><!--- Emeklilik Maaş --->
        <cfset additional_indicators = 0><!--- Ek Gösterge --->
        <cfset additional_indicators_retired = 0><!--- Emeklilik Ek Gösterge --->
        <cfset severance_pension = 0> <!--- Kıdem Aylığı --->
        <cfset business_risk = 0> <!--- İş Güç /İş Riski --->
        <cfset university_allowance_payroll = 0 > <!--- Üniversite Ödeneği --->
        <cfset private_service_compensation = 0><!--- Özel Hizmet Tazminatı --->
        <cfset language_allowance = 0> <!--- Yabancı Dil Tazminatı --->
        <cfset executive_indicator_compensation = 0><!--- Makam Tazminatı --->
        <cfset administrative_compensation = 0> <!--- Görev Tazminatı --->
        <cfset administrative_duty_allowance = 0><!--- İdari Görev Ödeneği --->
        <cfset education_allowance = 0><!--- Eğitim Ödeneği --->
        <cfset family_assistance = 0><!--- Aile Yardımı --->
        <cfset child_assistance = 0><!--- Çocuk Yardımı --->
        <cfset extra_pay = 0><!--- Ek Ödeme --->
        <cfset promotion_difference = 0><!--- Terfi Farkı--->
        <cfset child_count = 0><!--- Terfi Farkı--->
        <cfset officer_total_salary = 0><!--- Toplam--->
        <cfset base_salary = 0><!--- Taban Aylık--->
        <cfset retirement_allowance = 0><!--- Emekli Keseneği Devlet --->
        <cfset retirement_allowance_personal = 0><!--- Emekli Keseneği Kişi --->
        <cfset retirement_allowance_personal_interruption = 0><!--- Emekli Keseneği Kişi Eksi(kesinti kısmı) --->
        <cfset general_health_insurance = 0><!--- Genel Sağlık Sigortası --->
        <cfset sgk_base = 0><!--- SGK Matrahı --->
        <cfset sgk_base_additional_score_normal = 0><!--- SGK Matrahı ek gösterge ye göre(sadece ek gösterge ve emeklilik ek gösterge puanı arasında fark varsa) --->
        <cfset deductible_contribution_rate_normal = 0><!--- Kesenek Katkı Oranı (sadece ek gösterge ve emeklilik ek gösterge puanı arasında fark varsa)--->
        <cfset deductible_contribution_rate = 0><!--- Kesenek Katkı Oranı --->
        <cfset highest_civil_servant_salary = 0><!---  En Yüksek Devlet Memuru Aylığı --->
        <cfset collective_agreement_bonus_amount = 0><!--- Toplu Sözleşme İkramiyesi Tutarı --->
        <cfset collective_agreement_bonus = 0><!---  Toplu Sözleşme İkramiyesi --->
        <cfset severance_pension_diff = 0><!--- Kıdem aylığı önceki ay ile fark --->
        <cfset additional_score_diff = 0><!--- Ek Gösterge önceki ay ile fark --->
        <cfset diff_value = 0><!--- derece kademe önceki ay ile fark --->
        <cfset plus_retired = 0><!--- Artış %100 --->
        <cfset plus_retired_person = 0><!--- Kişi Devlet %100 --->
        <cfset additional_indicator_compensation_ = 0><!--- Ek Ödeme Tazminatı --->
        <cfset retirement_allowance_5510 = 0><!--- Emekli Keseneği/Malul Yaşlı (Devlet) (5510) --->
        <cfset retirement_allowance_personal_5510 = 0><!--- Emekli Keseneği/Malul Yaşlı (Kişi) (5510) --->
        <cfset health_insurance_premium_5510 = 0><!--- Sağlık Sigortası Primi (Devlet) (5510) --->
        <cfset health_insurance_premium_personal_5510 = 0><!--- Sağlık Sigortası Primi (Kişi)(5510)--->
        <cfset normal_indicator_score = 0><!--- Gösterge Puanı--->
        <cfset high_education_compensation_payroll = 0><!--- Yüksek Öğrenim Tazminatı --->
        <cfset net_pay_officer = 0><!--- Net Ücret --->
        <cfset penance_deduction = 0><!--- Kefalet Kesintisi --->
        <cfset academic_incentive_allowance_amount = 0><!--- Akademik Teşvik Ödeneği --->
        <cfset academic_position_rate = 0><!--- Akademik kadro oranı --->
        <cfset audit_compensation_amount = 0><!--- Denetim Tazminatı --->
        <cfset additional_score_control = 0><!--- Emeklilik Ek Gösterge Puanı ve Ek Gösterge Puanı arasındaki fark --->
        <cfset additional_score_base_control = 0><!--- Emeklilik Ek Gösterge matrahı ve Ek Gösterge matrahı arasındaki fark --->
        <cfset suspension_factor = 1><!--- Açığa alma çarpanı ödenek --->
        <cfset suspension_factor_basis = 1><!--- Açığa alma çarpanı matrah --->
        <cfset land_compensation_amount = 0><!--- Arazi Tazminatı --->
        <cfset retired_academic = 0><!--- Emekli akademik --->
        <cfset administrative_academic_diff = 0><!--- Emekli akademik fark bordrosu --->
        <cfset jury_membership_value = 0><!--- Jüri Üyeliği --->
        <cfset artist_salary = 0><!--- Sanatçı Maaşı --->
        <cfset weekday_rate_value = 0><!--- Hafta içi Fazla Mesai Ücreti Çarpan --->
        <cfset weekday_fee_value = 0><!--- Hafta içi Fazla Mesai Ücreti --->
        <cfset month_work_day = 0><!--- İşe giriş veya çıkış varsa--->
        <cfif len(get_hr_ssk.finish_date) or datediff("h",last_month_1,get_hr_ssk.start_date) eq 0>
            <cfset month_work_day =  datediff('d',last_month_1,last_month_30) + 1>
        <cfelse>
            
        </cfif>
        <cfif not(len(get_hr_ssk.grade) and len(get_hr_ssk.step))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='58541.Emekli'> <cf_get_lang dictionary_id='37566.Derece / Kademe'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not len(get_hr_ssk.step)>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='58541.Emekli'> <cf_get_lang dictionary_id='37566.Derece / Kademe'>)  !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not len(get_hr_ssk.step_normal)>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='37566.Derece / Kademe'>)  !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not len(get_hr_ssk.grade_normal)>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='37566.Derece / Kademe'>)  !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />   
        <cfelseif not len(get_hr_ssk.additional_score)>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not(len(get_hr_ssk.perquisite_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62878.Yan Ödeme Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not(len(get_hr_ssk.university_allowance))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62884.Ünversite Ödeneği'> - <cf_get_lang dictionary_id='58456.Oran'> %) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.private_service_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62881.Özel Hizmet Tazminatı Gösterge Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.executive_indicator_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62879.Makam Tazminatı Gösterge Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.administrative_indicator_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62880.Görev Tazminatı Gösterge Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.administrative_function_allowance))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62882.İdari Görev Ödeneği'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.additional_indicator_compensation))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='63812.Ek Ödeme Tazminatı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.severance_pension_score))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='63970.Kıdem Aylığı Puanı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />  
        <cfelseif not(len(get_hr_ssk.high_education_compensation))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62937.Yüksek Öğretim Tazminatı'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />     
        <cfelseif not(len(get_hr_ssk.academic_incentive_allowance))>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='62936.Akademik Teşvik Ödeneği'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) /> 
        <cfelseif not(len(get_hr_ssk.additional_course_position)) and get_hr_ssk.administrative_academic eq 2>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='55441.Kadro'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />       
        </cfif>

        <!--- Jüri Üyeliği --->
        <cfif attributes.statue_type eq 6 and len(get_hr_ssk.JURY_MEMBERSHIP) and get_hr_ssk.JURY_MEMBERSHIP eq 1 and not len(get_hr_ssk.JURY_MEMBERSHIP_PERIOD)>	
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='64674.Jüri Üyeliği Katsayı Dönemi'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />   
        <cfelseif attributes.statue_type eq 6 and len(get_hr_ssk.JURY_MEMBERSHIP) and get_hr_ssk.JURY_MEMBERSHIP eq 1 and not len(get_hr_ssk.JURY_NUMBER)>
            <cfsavecontent variable="grade_step"><cf_get_lang dictionary_id='63026.Çalışanın Memur Tanımlarını Yapınız'> (<cf_get_lang dictionary_id='64673.Jüri Üyeliği'>) !</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: grade_step , in_out_id: attributes.in_out_id) />   
        <cfelseif attributes.statue_type eq 6 and len(get_hr_ssk.JURY_MEMBERSHIP) and get_hr_ssk.JURY_MEMBERSHIP eq 1 and len(get_hr_ssk.JURY_MEMBERSHIP_PERIOD)>
            <cfset get_jury_period_factor = this.get_factor_definition(definition_id : get_hr_ssk.JURY_MEMBERSHIP_PERIOD)>
            <cfset jury_period_factor = get_jury_period_factor.salary_factor>
            <cfset jury_membership_value = 3000 * get_hr_ssk.JURY_NUMBER * jury_period_factor>
        </cfif>

        <!--- Ayın ilk ve son günü --->
        <cfset start_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0)>
	    <cfset end_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0)>
        
        <!--- Ücret Kuralları Memuriyet Gösterge Tablosu --->
        <cfset cmp_grade_step_params = createObject('component','V16.hr.ehesap.cfc.grade_step_params')>
        <cfset get_grade_step = cmp_grade_step_params.GET_EMPLOYEES_GRADE_STEP_PARAMS(
            start_month : start_month,
            end_month : end_month,
            grade : get_hr_ssk.grade,
            step : get_hr_ssk.step
        )>
        <!--- Memur Gösterge Tablosu Kontrolü --->
        <cfif get_grade_step.recordcount eq 0>
            <cfsavecontent variable="table_error"><cf_get_lang dictionary_id='62929.Girilen Tarihler Arasında Memur Gösterge Tablosu Bulunmaktadır!'></cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: table_error , in_out_id: attributes.in_out_id) />   
        <cfelse>
            <cfset indicator_score = evaluate("get_grade_step.step_#get_hr_ssk.step#")><!--- Emeklilik Gösterge Puanı --->
        </cfif>
        <cfset get_grade_step_normal = cmp_grade_step_params.GET_EMPLOYEES_GRADE_STEP_PARAMS(
            start_month : start_month,
            end_month : end_month,
            grade : get_hr_ssk.grade_normal,
            step : get_hr_ssk.step_normal
        )>
        <cfif get_grade_step_normal.recordcount eq 0>
            <cfsavecontent variable="table_error"><cf_get_lang dictionary_id='62929.Girilen Tarihler Arasında Memur Gösterge Tablosu Bulunmaktadır!'></cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: table_error , in_out_id: attributes.in_out_id) />   
        <cfelse>
            <cfset normal_indicator_score = evaluate("get_grade_step_normal.step_#get_hr_ssk.step_normal#")><!--- Gösterge Puanı --->
        </cfif>

        <!--- Ücret Kuralları Kesenek Katkı Oranları --->
        <cfset cmp_deductible_contribution_rate = createObject('component','V16.hr.ehesap.cfc.deductible_contribution_rate')>
        <cfset get_deductible_contribution_rate  = cmp_deductible_contribution_rate.GET_DEDUCTIBLE_CONTRIBUTION_RATE(
            startdate : start_month,
            finishdate : end_month
        )>
        <!--- Çalışan statüsü  5434 Sayılı Kanuna Tabi Çalışan ise --->
        <cfif get_hr_ssk.SSK_STATUTE eq 33>
            <!--- Kesenek Tablosu Kontrolü --->
            <cfif get_deductible_contribution_rate.recordcount eq 0>
                <cfsavecontent variable="table_error"><cf_get_lang dictionary_id='63748.Girilen Tarihler Arasında Kesenek Katkı Oranları Bulunmaktadır!'></cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: table_error , in_out_id: attributes.in_out_id) />  
            <cfelse>
                <cfif get_hr_ssk.additional_score gte get_deductible_contribution_rate.min_payment_1 and get_hr_ssk.additional_score lt get_deductible_contribution_rate.max_payment_1>
                    <cfset deductible_contribution_rate = get_deductible_contribution_rate.ratio_1>
                <cfelseif get_hr_ssk.additional_score gte get_deductible_contribution_rate.min_payment_2 and get_hr_ssk.additional_score lt get_deductible_contribution_rate.max_payment_2>
                    <cfset deductible_contribution_rate = get_deductible_contribution_rate.ratio_2>
                <cfelseif get_hr_ssk.additional_score gte get_deductible_contribution_rate.min_payment_3 and get_hr_ssk.additional_score lt get_deductible_contribution_rate.max_payment_3>
                    <cfset deductible_contribution_rate = get_deductible_contribution_rate.ratio_3>
                <cfelseif get_hr_ssk.additional_score gte get_deductible_contribution_rate.min_payment_4 and get_hr_ssk.additional_score lt get_deductible_contribution_rate.max_payment_4>
                    <cfset deductible_contribution_rate = get_deductible_contribution_rate.ratio_4>
                <cfelseif get_hr_ssk.additional_score gte get_deductible_contribution_rate.min_payment_5 and get_hr_ssk.additional_score lt get_deductible_contribution_rate.max_payment_5>
                    <cfset deductible_contribution_rate = get_deductible_contribution_rate.ratio_5>
                <cfelseif get_hr_ssk.additional_score gte get_deductible_contribution_rate.min_payment_6 and get_hr_ssk.additional_score lt get_deductible_contribution_rate.max_payment_6>
                    <cfset deductible_contribution_rate = get_deductible_contribution_rate.ratio_6>
                <cfelseif get_hr_ssk.additional_score gte get_deductible_contribution_rate.min_payment_7 and get_hr_ssk.additional_score lt get_deductible_contribution_rate.max_payment_7>
                    <cfset deductible_contribution_rate = get_deductible_contribution_rate.ratio_7>
                </cfif>
            </cfif>
        </cfif>
        <!--- Katsayı Tablosu --->
        <cfset get_factor = this.get_factor_definition(
            start_month : start_month,
            end_month : end_month
        )>

        <!--- Çalışan açığa alınmış mı kontrolü --->
        <cfset get_suspension = this.get_suspension_date(
            start_month : start_month,
            end_month : end_month
        )>
        <cfif get_suspension.recordcount gt 0>
            <cfset suspension_factor = 2 / 3>
            <cfset suspension_factor_basis = 1 / 2>
        </cfif>
        <!--- Katsayı Tablosu Kontrol --->
        <cfif get_factor.recordcount eq 0>
            <cfsavecontent variable="factor_error"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'></cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: factor_error , in_out_id: attributes.in_out_id) />   
        <cfelse>
            <cfset factor = get_factor.salary_factor><!--- Aylık Katsayı --->
            <!--- Yan ödeme katsayısı kontrol --->
            <cfif not len(get_factor.benefit_factor)>
                <cfsavecontent variable="factor_error"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='59315.Yan Ödeme Katsayısı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: factor_error , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset benefit_factor = get_factor.benefit_factor>
            </cfif>
            <!--- Aile Yardımı Puanı --->
            <cfif not len(get_factor.family_allowance_point)>
                <cfsavecontent variable="factor_error"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='62934.Aile Yardımı Puanı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: factor_error , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset family_allowance_point = get_factor.family_allowance_point>
            </cfif>
            <!--- Çocuk Yardımı Puanı --->
            <cfif not (len(get_factor.child_benefit_first) or len(get_factor.child_benefit_second))>
                <cfsavecontent variable="factor_error"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: factor_error , in_out_id: attributes.in_out_id) />   
            </cfif> 
            <!--- Taban Aylık Katsayı Puanı --->
            <cfif not (len(get_factor.base_salary_factor) or len(get_factor.base_salary_factor))>
                <cfsavecontent variable="base_salary_factor"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='59314.Taban Aylık Katsayı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: base_salary_factor , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset base_salary_factor = get_factor.base_salary_factor>
            </cfif>      
            <!---  En Yüksek Devlet Memuru Aylığı --->
            <cfif not (len(get_factor.highest_civil_servant_salary) or len(get_factor.highest_civil_servant_salary))>
                <cfsavecontent variable="highest_civil_servant_salary"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='63763.En Yüksek Devlet Memuru Aylığı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: highest_civil_servant_salary , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset highest_civil_servant_salary = get_factor.highest_civil_servant_salary>
            </cfif>   
            <!--- Toplu Sözleşme İkramiyesi Tutarı --->
            <cfif not (len(get_factor.collective_agreement_bonus_amount) or len(get_factor.collective_agreement_bonus_amount))>
                <cfsavecontent variable="collective_agreement_bonus_amount"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='63761.Toplu Sözleşme İkramiyesi Tutarı'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: collective_agreement_bonus_amount , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset collective_agreement_bonus_amount = get_factor.collective_agreement_bonus_amount>
            </cfif>   
            <!--- Toplu Sözleşme İkramiyesi Ayları --->
            <cfif not (len(get_factor.collective_agreement_bonus_month) or len(get_factor.collective_agreement_bonus_month))>
                <cfsavecontent variable="collective_agreement_bonus_month"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='63762.Toplu Sözleşme İkramiyesi Ayları'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: collective_agreement_bonus_month , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset collective_agreement_bonus_month = get_factor.collective_agreement_bonus_month>
            </cfif>  
             <!--- Fazla Mesai Ücretleri --->
             <cfif not (len(get_factor.WEEKDAY_FEE) or len(get_factor.weekday_rate)) and attributes.statue_type eq 9>
                <cfsavecontent variable="weekday_rate"><cf_get_lang dictionary_id='63027.Belirtilen Tarihler Arasında Katsayı Tanımı Bulunmamaktadır!'>(<cf_get_lang dictionary_id='64845.Hafta Sonu Fazla Mesai Ücreti'> / <cf_get_lang dictionary_id='64844.Hafta İçi Fazla Mesai Ücreti'>)</cfsavecontent>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: weekday_rate , in_out_id: attributes.in_out_id) />   
            <cfelse>
                <cfset weekday_rate_value = get_factor.weekday_rate>
                <cfset weekday_fee_value = get_factor.WEEKDAY_FEE>
            </cfif>   

        </cfif>

        <!--- Arazi Tazminatı varsa --->
        <cfif attributes.statue_type eq 7 and len(get_hr_ssk.LAND_COMPENSATION_PERIOD) and len(get_hr_ssk.LAND_COMPENSATION_SCORE)>	
            <cfset get_period_factor = this.get_factor_definition(definition_id : get_hr_ssk.LAND_COMPENSATION_PERIOD)>
            <cfset period_factor = get_period_factor.salary_factor>
            <cfset land_compensation_amount = (highest_civil_servant_salary * get_hr_ssk.LAND_COMPENSATION_SCORE / 100) * period_factor><!--- aazi tazminatı = En yüksek devlet memuru maaşı katsayı (9.500) * Arazi tazminatı puanı / 100 * seçilen dönem katsayısı  --->
        </cfif>

        <!--- Akademik Teşvik Ödeneği Kadro Oranları --->
        <cfset get_academic_personnel_rate = get_academic_personnel.GET_SETUP_ACADEMIC_PERSONNEL(
            start_month : start_month,
            end_month : end_month
        )>
        <cfif get_academic_personnel_rate.recordcount eq 0>
            <cfsavecontent variable="get_academic_personnel_rate"><cf_get_lang dictionary_id='64064.Belirtilen Tarihler Arasında Akademik Teşvik Ödeneği Bulunmamaktadır. Lütfen Ücret Kuralları İçerisinden Tanımları Yapınız!'>)</cfsavecontent>
            <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: get_academic_personnel_rate , in_out_id: attributes.in_out_id) />   
        </cfif>

        <!--- Sanatçı Bordrosu --->
        <cfif attributes.statue_type eq 8>
            <cfset get_artist_salary = this.get_salary_history(start_month: last_month_1)>
            <cfif len(evaluate("get_artist_salary.M#month(last_month_1)#"))>
                <cfset artist_salary = evaluate("get_artist_salary.M#month(last_month_1)#")>
            <cfelse>
                <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: "#getLang('','Çalışanın Maaş Bilgileri Eksik','64707')#" , in_out_id: attributes.in_out_id) />   
            </cfif>
        </cfif>
        
        <!--- Tipi Maaş ise --->
        <cfif attributes.statue_type eq 1 or attributes.statue_type eq 8 or attributes.statue_type eq 11>
            <!--- Maaş Puantajı Hesap Fonksiyonu --->
            <cfset get_officer_payroll_wage = officer_payroll_wage()>

        <cfelseif attributes.statue_type eq 5><!--- Tipi Fark ise(katsayı farkı varsa) --->
            <!--- Bir önceki ay katsayı kontrolleri --->
            <cfset start_month_past = dateadd("m",1,start_month)>
			<cfset end_month_past = dateadd("m",1,end_month)>
            <!--- Katsayı Tablosu --->
            <cfset get_factor_past = this.get_factor_definition(
                start_month : start_month_past,
                end_month : end_month_past
            )>
            <cfif(isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0))>
                <cfset diff_day = get_program_parameters.LAST_DAY_MONTH>    
            <cfelse>
                <cfset diff_day = 14>    
            </cfif>

            <!--- Aylık Katsayı --->
            <cfset factor = (get_factor_past.salary_factor - get_factor.salary_factor) / 30 * diff_day>
            <cfset benefit_factor = (get_factor_past.benefit_factor - get_factor.benefit_factor)  / 30 * diff_day>
            <cfset base_salary_factor = (get_factor_past.base_salary_factor - get_factor.base_salary_factor)  / 30 * diff_day>
            <cfset collective_agreement_bonus_amount = (get_factor_past.collective_agreement_bonus_amount - get_factor.collective_agreement_bonus_amount) / 30 * diff_day>
            <!--- Emekli akademik ise maaşı kontrol ediliyor --->
            <cfif get_hr_ssk.administrative_academic eq 2>
                <cfset last_salary = this.get_salary_history(start_month: last_month_1)>
                <cfset last_salary_end = this.get_salary_history(start_month: last_month_30)>
                <cfif evaluate("last_salary.M#month(last_month_1)#") neq evaluate("last_salary_end.M#month(last_month_30)#")>
                    <cfset administrative_academic_diff = evaluate("last_salary_end.M#month(last_month_30)#") - evaluate("last_salary.M#month(last_month_1)#")>
                    <cfset administrative_academic_diff = administrative_academic_diff / 30 * diff_day>
                <cfelse>
                    <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: "#getLang('','Takip eden dönemde çalışan maaşında değişiklik sağlamamıştır','64671')#" , in_out_id: attributes.in_out_id) />
                </cfif>
            </cfif>
            <!--- Maaş Puantajı Hesap Fonksiyonu --->
            <cfset get_officer_payroll_wage = officer_payroll_wage()>
        </cfif>
        
    </cffunction>

    <!--- Maaş Puantajı --->
    <cffunction name="officer_payroll_wage" access="public" returntype="any">
        <!--- Maaş --->
        <cfset officer_salary = normal_indicator_score * factor><!--- Maaş (Maaş Göstergesi * Katsayı )--->
        
        <cfset additional_indicators = get_hr_ssk.additional_score_normal * factor ><!--- Ek Gösterge (Ekgösterge puanı * katsayı ) --->

        <cfset administrative_duty_allowance = ((officer_salary + additional_indicators) * (get_hr_ssk.administrative_function_allowance / 100)) * suspension_factor><!--- İdari Görev Ödeneği	((Maaş Göstergesi + Ek göstergesi) * Katsayı * Oran %) --->    
        <cfset officer_salary_retired = indicator_score * factor><!--- Emeklilik Maaş (Maaş Göstergesi * Katsayı )--->
        <cfset additional_indicators_retired = get_hr_ssk.additional_score * factor><!--- Emeklilik Ek Gösterge (Ekgösterge puanı * katsayı ) --->

        <!--- <cfset worked_year = dateDiff('yyyy',get_hr_ssk.KIDEM_DATE,end_month)><!--- Çalışılan yıl --->
        <cfset severance_pension = worked_year * 20 * factor>  ---><!--- Kıdem Aylığı(Çalışılan Yıl * 20 * Katsayı) --->
        <cfset severance_pension = get_hr_ssk.severance_pension_score * factor>
        <cfset base_salary = 1000 * base_salary_factor><!--- Taban Aylığı (1000 * Taban Kat Sayısı)  --->
        <!--- Ödenekler --->
        <cfset business_risk = get_hr_ssk.perquisite_score * benefit_factor * suspension_factor><!--- İş Güç /İş Riski(Yan ödeme puanı * Yan ödeme Katsayısı) --->
        <cfset university_allowance_payroll = highest_civil_servant_salary * factor * (get_hr_ssk.university_allowance / 100) > <!--- Üniversite Ödeneği(En yüksek devlet memuru maaşı katsayı (9.500) * Katsayı * Oran (Ünvana göre değişir Yrd.Doç. %165)) --->
        <cfset private_service_compensation = highest_civil_servant_salary * factor * (get_hr_ssk.private_service_score / 100)><!--- Özel Hizmet Tazminatı(En yüksek devlet memuru maaşı katsayı (9.500) * Katsayı * Oran ( %)) --->
        
        <cfloop index = "lang_indx" from = "1" to = "5"><!--- Yabancı Diller --->
            <cfif len(evaluate("get_hr_ssk.language_allowance_#lang_indx#"))>
                <cfset lang_val = get_component_lang.GET_SETUP_LANGUAGE_ALLOWANCE(language_allowance_id : evaluate("get_hr_ssk.language_allowance_#lang_indx#"))>
                <cfif lang_val.recordcount neq 0>
                    <cfset language_allowance = language_allowance + ( lang_val.LANGUAGE_AMOUNT * factor)><!--- Yabancı Dil Tazminatı (Düzey puanı * Katsayı) --->
                </cfif>
            </cfif>
        </cfloop>
        <cfset language_allowance = language_allowance * suspension_factor>
        <cfset high_education_compensation_payroll = highest_civil_servant_salary * (get_hr_ssk.high_education_compensation / 100) * factor * suspension_factor> <!--- Yüksek Öğrenim Tazminatı --->
        <cfset executive_indicator_compensation = get_hr_ssk.executive_indicator_score * factor><!--- Makam Tazminatı(Makam Tazminatı Göstergesi * Katsayı) --->
        <cfset administrative_compensation = get_hr_ssk.administrative_indicator_score * factor> <!--- Görev Tazminatı(Görev Tazminatı Göstergesi * Katsayı) --->
              
        <!--- Denetim tazminatı var olarak seçildiyse --->
        <cfif get_hr_ssk.is_audit_compensation eq 1>
            <cfset audit_compensation_amount = highest_civil_servant_salary * get_hr_ssk.audit_compensation / 100 ><!--- Denetim tazminatı (En Yüksek Devlet Memuru Maaşı * Tazminat oranı) --->
        </cfif>
        <!--- Ücret kartında Eğitim Öğretim Ödeneği var seçili ise ---->
        <cfif get_hr_ssk.is_education_allowance eq 1>
            <cfset education_allowance = ((highest_civil_servant_salary * factor) / 12)*suspension_factor><!--- Eğitim Öğretim Ödeneği (En yüksek devlet memuru maaşı katsayı (9.500) * Katsayı / 12) --->
        </cfif>

        <!--- Kadro Tipine Göre Oranlar --->
        <cfif isdefined("get_academic_personnel_rate.rate_#get_hr_ssk.additional_course_position#") and len(evaluate("get_academic_personnel_rate.rate_#get_hr_ssk.additional_course_position#"))>
            <cfset academic_position_rate = evaluate("get_academic_personnel_rate.rate_#get_hr_ssk.additional_course_position#") / 100>
        </cfif>
        <cfif academic_position_rate gt 0>
            <cfset academic_incentive_allowance_amount = highest_civil_servant_salary * academic_position_rate * (get_hr_ssk.academic_incentive_allowance / 100) * factor * suspension_factor><!--- Akademik Teşvik Ödeneği(En Yüksek Devlet Memuru Aylığı x Kadroya bağlı oran % x Akademik Teşvik Ödeneği Puanı % * kaysayı) --->
        </cfif>

        <!--- Ücret kartında kefalet Kesintisi var seçili ise ---->
        <cfif get_hr_ssk.is_penance_deduction eq 1>
            <cfquery name="get_penance_deduction_count" datasource="#dsn#">
                SELECT COUNT(PENANCE_DEDUCTION) AS PENANCE_DEDUCTION_COUNT FROM OFFICER_PAYROLL_ROW WHERE IN_OUT_ID = #get_hr_ssk.in_out_id# AND PENANCE_DEDUCTION > 0
            </cfquery>
            <!--- kefalet Kesintisi ilk 4 ay ise --->
            <cfif get_penance_deduction_count.penance_deduction_count lt 4>
                <cfset penance_deduction = (1500 * factor) / 4><!--- kefalet Kesintisi (1500 * Katsayı / 4) --->
            <cfelse>
                <cfset penance_deduction = (100  * factor)><!--- kefalet Kesintisi (100 * Katsayı) --->
            </cfif>
        </cfif>

        <cfset sgk_base = (officer_salary_retired + additional_indicators_retired + base_salary + severance_pension + (highest_civil_servant_salary * factor * (deductible_contribution_rate / 100)))><!--- SGK Matrahı (Emeklilik Maaş Gösterge+ Emeklilik Ek Gösterge Aylığı + Taban Aylığı + Kıdem Aylığı--->
        <cfset additional_indicator_compensation_ = (highest_civil_servant_salary * factor * (get_hr_ssk.additional_indicator_compensation / 100))*suspension_factor> <!--- Ek Ödenek Tazminatı (En yüksek devlet memuru maaşı katsayı (9.500) *  Ek gösterge tazminatı * Katsayı / 100) --->

        <!--- Eğer görev tazminatı ve ek ödeme tazminatı aynı anda alınıyorsa görev tazminatının %80 i yansıtılır --->
        <cfif len(administrative_compensation) and additional_indicator_compensation_ gt 0>
            <cfset administrative_compensation = (administrative_compensation * 80 / 100)><!--- görev tazminatı --->
        </cfif>

        <!--- Eğer toplu sözleşme ayı ise hesaplama yapar --->
        <cfif ListFindNoCase(collective_agreement_bonus_month,attributes.sal_mon) gt 0>
            <cfset collective_agreement_bonus = collective_agreement_bonus_amount * factor * suspension_factor><!--- Toplu Sözleşme İkramiyesi = Toplu Sözleşme İkramiyesi Tutarı * katsayı --->
        </cfif>
        <!--- Çalışan statüsü  5434 Sayılı Kanuna Tabi Çalışan ise --->
        <cfif get_hr_ssk.SSK_STATUTE eq 33>
            <!--- Emeklilik Ek Gösterge Puanı ve Ek Gösterge Puanı arasındaki fark --->
            <cfset additional_score_control = get_hr_ssk.additional_score - get_hr_ssk.additional_score_normal><!--- Emeklilik Ek Gösterge Puanı ve Ek Gösterge Puanı arasındaki fark --->
           
            <cfif attributes.statue_type eq 5>
                <cfset sgk_base = 0>
            <cfelse>
                <cfset sgk_base = sgk_base * suspension_factor_basis>
            </cfif>
            <!--- girişi ya da çıkışı varsa --->
            <cfif len(get_hr_ssk.finish_date) or datediff("h",last_month_1,get_hr_ssk.start_date) eq 0>
                <cfset sgk_base = sgk_base * month_work_day / 30>
            </cfif>

            <cfif additional_score_control gt 0>
                <!--- Ek göstergenin matrah için kesenek katkı oranı --->
                <cfif get_hr_ssk.additional_score_normal gte get_deductible_contribution_rate.min_payment_1 and get_hr_ssk.additional_score_normal lt get_deductible_contribution_rate.max_payment_1>
                    <cfset deductible_contribution_rate_normal = get_deductible_contribution_rate.ratio_1>
                <cfelseif get_hr_ssk.additional_score_normal gte get_deductible_contribution_rate.min_payment_2 and get_hr_ssk.additional_score_normal lt get_deductible_contribution_rate.max_payment_2>
                    <cfset deductible_contribution_rate_normal = get_deductible_contribution_rate.ratio_2>
                <cfelseif get_hr_ssk.additional_score_normal gte get_deductible_contribution_rate.min_payment_3 and get_hr_ssk.additional_score_normal lt get_deductible_contribution_rate.max_payment_3>
                    <cfset deductible_contribution_rate_normal = get_deductible_contribution_rate.ratio_3>
                <cfelseif get_hr_ssk.additional_score_normal gte get_deductible_contribution_rate.min_payment_4 and get_hr_ssk.additional_score_normal lt get_deductible_contribution_rate.max_payment_4>
                    <cfset deductible_contribution_rate_normal = get_deductible_contribution_rate.ratio_4>
                <cfelseif get_hr_ssk.additional_score_normal gte get_deductible_contribution_rate.min_payment_5 and get_hr_ssk.additional_score_normal lt get_deductible_contribution_rate.max_payment_5>
                    <cfset deductible_contribution_rate_normal = get_deductible_contribution_rate.ratio_5>
                <cfelseif get_hr_ssk.additional_score_normal gte get_deductible_contribution_rate.min_payment_6 and get_hr_ssk.additional_score_normal lt get_deductible_contribution_rate.max_payment_6>
                    <cfset deductible_contribution_rate_normal = get_deductible_contribution_rate.ratio_6>
                <cfelseif get_hr_ssk.additional_score_normal gte get_deductible_contribution_rate.min_payment_7 and get_hr_ssk.additional_score_normal lt get_deductible_contribution_rate.max_payment_7>
                    <cfset deductible_contribution_rate_normal = get_deductible_contribution_rate.ratio_7>
                </cfif>
                <!--- Ek göstergenin matrahı --->
                <cfset sgk_base_additional_score_normal = (officer_salary_retired + additional_indicators + base_salary + severance_pension + (highest_civil_servant_salary * factor * (deductible_contribution_rate_normal / 100)))><!--- SGK Matrahı (Emeklilik Maaş Gösterge+ Emeklilik Ek Gösterge Aylığı + Taban Aylığı + Kıdem Aylığı--->
                <!--- sgk matrah ve ek gösterge arasındaki farkın %20 si --->
                <cfset additional_score_base_control =  sgk_base - sgk_base_additional_score_normal> 
                <cfset additional_score_base_control = additional_score_base_control * 20 / 100> 
            </cfif>
            <cfset retirement_allowance = (sgk_base * 20 / 100) ><!--- Emekli Keseneği Devlet (Maaş Göstergesi + Ek Gösterge Puanı + Taban Aylık + Kıdem Aylığı + (En Yüksek Devlet Memuru Aylığı x Ek Göstergeye Bağlı Kesenek Katkı Oranı) x %20) --->
            <cfset retirement_allowance_personal = sgk_base * 16 / 100><!--- Emekli Keseneği Kişi (Maaş Göstergesi + Ek Gösterge Puanı + Taban Aylık + Kıdem Aylığı + (En Yüksek Devlet Memuru Aylığı x Ek Göstergeye Bağlı Kesenek Katkı Oranı) x %16)--->
            <!--- emeklilik Ek Gösterge Puanı ve Ek Gösterge Puanı arasındaki fark avrsa Emekli Keseneği Kişi kesintisine eklenir --->
            <cfset retirement_allowance_personal_interruption = retirement_allowance_personal + additional_score_base_control>
            <cfset general_health_insurance = (sgk_base * 12 / 100)><!--- Genel Sağlık Sgiortası (Maaş Göstergesi + Ek Gösterge Puanı + Taban Aylık + Kıdem Aylığı + (En Yüksek Devlet Memuru Aylığı x Ek Göstergeye Bağlı Kesenek Katkı Oranı) x %12)--->            
            <!--- Sanatçı Bordrosu --->
            <cfif attributes.statue_type eq 8>
                <cfset artist_salary = artist_salary + general_health_insurance + retirement_allowance><!--- Maaş + Genel Sağlık Sgiortası +  Emekli Keseneği Devlet--->
            </cfif>
        </cfif>
        <!--- Çalışan statüsü Normal ise --->
        <cfif get_hr_ssk.SSK_STATUTE eq 1>
            <cfset parameter_5510 = officer_salary + additional_indicators + base_salary + severance_pension + executive_indicator_compensation + administrative_compensation + university_allowance_payroll + private_service_compensation><!--- (Emeklilik Aylık Tutar + Ek Gösterge Tutarı + Taban Aylığı Tutarı + Kıdem Aylığı Tutarı + Makam Tazminatı Tutarı + Görev/Temsil Tazminatı Tutarı + Üniversite Ödeneği Tutarı + Özel Hizmet Tazminatı Tutarı) x 11 % --->
            <cfset sgk_base = parameter_5510 * suspension_factor_basis>
            <cfset parameter_5510 = parameter_5510 * suspension_factor_basis>

            <!--- girişi ya da çıkışı varsa --->
            <cfif len(get_hr_ssk.finish_date) or datediff("h",last_month_1,get_hr_ssk.start_date) eq 0>
                <cfset sgk_base = sgk_base * month_work_day / 30>
            </cfif>

            <cfset retirement_allowance_5510 = ((parameter_5510) * 11 / 100)><!--- Emekli Keseneği/Malul Yaşlı (Devlet) (5510): (Aylık Tutar + Ek Gösterge Tutarı + Taban Aylığı Tutarı + Kıdem Aylığı Tutarı + Makam Tazminatı Tutarı + Görev/Temsil Tazminatı Tutarı + Üniversite Ödeneği Tutarı + Özel Hizmet Tazminatı Tutarı) x 11 % --->
            <cfset retirement_allowance_personal_5510 = (parameter_5510) * 9 / 100><!--- Emekli Keseneği/Malul Yaşlı (Kişi) (5510): (Aylık Tutar + Ek Gösterge Tutarı + Taban Aylığı Tutarı + Kıdem Aylığı Tutarı + Makam Tazminatı Tutarı + Görev/Temsil Tazminatı Tutarı + Üniversite Ödeneği Tutarı + Özel Hizmet Tazminatı Tutarı) x 9 % --->
            <cfset health_insurance_premium_personal_5510 = (parameter_5510) * 5 / 100><!--- Sağlık Sigortası Primi (Kişi)(5510) : (Aylık Tutar + Ek Gösterge Tutarı + Taban Aylığı Tutarı + Kıdem Aylığı Tutarı + Makam Tazminatı Tutarı + Görev/Temsil Tazminatı Tutarı + Üniversite Ödeneği Tutarı + Özel Hizmet Tazminatı Tutarı) x 5 % --->
            
            <!--- Çalışan gazi ise --->
            <cfif get_hr_ssk.is_veteran eq 1>
                <cfset health_insurance_premium_5510 = 0><!--- Sağlık Sigortası Primi (Devlet) (5510) --->
            <cfelse>
                <cfset health_insurance_premium_5510 = ((parameter_5510) * 7.5 / 100)><!--- Sağlık Sigortası Primi (Devlet) (5510) : (Aylık Tutar + Ek Gösterge Tutarı + Taban Aylığı Tutarı + Kıdem Aylığı Tutarı + Makam Tazminatı Tutarı + Görev/Temsil Tazminatı Tutarı + Üniversite Ödeneği Tutarı + Özel Hizmet Tazminatı Tutarı) x 7.5 % --->
            </cfif>
            <!--- Sanatçı Brüt --->
            <cfif attributes.statue_type eq 8>
                <cfset artist_salary = artist_salary + health_insurance_premium_5510 + retirement_allowance_5510><!--- Maaş + ağlık Sigortası Primi (Devlet) +  Emekli Keseneği/Malul Yaşlı (Devlet)--->
            </cfif>
        </cfif>

        <cfset private_service_compensation = private_service_compensation * suspension_factor><!--- Özel Hizmet Tazminatı * açığa alma) --->
        <cfset university_allowance_payroll = university_allowance_payroll * suspension_factor> <!--- Üniversite Ödeneği * açığa alma) --->
        <cfset administrative_compensation = administrative_compensation * suspension_factor><!--- görev tazminatı * açığa alma --->
        <cfset executive_indicator_compensation = executive_indicator_compensation * suspension_factor><!--- Makam Tazminatı * açığa alma --->

        <!--- Eş Durumu (Eşi Çalışmıyorsa) --->
        <cfquery name="get_emp_family" dbtype="query">
			SELECT * FROM get_relatives WHERE RELATIVE_LEVEL = '3' AND WORK_STATUS = 0
		</cfquery>
        <cfif get_emp_family.recordcount gt 0>
            <cfif attributes.statue_type eq 5><!--- Tipi Fark ise(katsayı farkı varsa) --->
                <cfset family_allowance_point_past = get_factor_past.salary_factor * get_factor_past.family_allowance_point>
                <cfset family_allowance_point_now = get_factor.salary_factor * get_factor.family_allowance_point>
                <cfset family_assistance = ((family_allowance_point_past) - (family_allowance_point_now)) / 30 * diff_day><!--- Aile Yardımı fark bordrosu --->
            <cfelse>
                <cfset family_assistance = factor * family_allowance_point ><!--- Aile Yardımı (Katsayı * Puan (1500 - Değişebilir ) )--->
            </cfif>
        </cfif>
        <!--- Çocuk Sayısı (Çocuk indiriminden yararlanan)--->
        <cfquery name="get_emp_child" dbtype="query">
			SELECT * FROM get_relatives WHERE  (RELATIVE_LEVEL = '5' OR RELATIVE_LEVEL = '4') AND WORK_STATUS = 0 AND CHILD_HELP = 1
		</cfquery>

        <cfset first_child_factor = get_factor.child_benefit_first>
        <cfif get_emp_child.recordcount gt 0>
            <cfset child_count = get_emp_child.recordcount>
        <cfelse>
            <cfset child_count = 0>
        </cfif>
        <cfoutput query="get_emp_child">
            <cfset child_age = dateDiff('yyyy',get_emp_child.BIRTH_DATE,now())>
            <!--- 6 yaşından küçükse --->
            <cfif child_age lt 6>
                <cfset child_count += 1>
                <!--- engelli ise --->
                <cfif get_emp_child.use_tax eq 1>
                    <cfset child_count += 1>
                </cfif>
            <cfelse>
                <!--- engelli ise --->
                <cfif get_emp_child.use_tax eq 1>
                    <cfset child_count += 0.5>
                </cfif>
            </cfif>
            
        </cfoutput>
        <cfset child_assistance = factor * child_count * first_child_factor><!--- Çocuk Yardımı (Katsayı * Puan (1 çocuk 250 puan - Değişebilir))--->
        
        <!--- Ücret Kartı History --->
        <cfset get_history = get_in_out_history()>
        <cfif get_history.recordcount gt 0>
            
            <!--- Eğer kıdem ayıysa geçen ay ile arasındaki fark  alınır --->
            <cfif len(get_history.severance_pension) and severance_pension neq get_history.severance_pension>
                <cfset severance_pension_diff = (severance_pension / factor) - (get_history.severance_pension / factor)>
            </cfif>

            <!--- Eğer kıdem ayıysa geçen ay ile arasındaki fark  alınır --->
            <cfif len(get_history.additional_score) and get_hr_ssk.additional_score neq get_history.additional_score>
                <cfset additional_score_diff = get_hr_ssk.additional_score - get_history.additional_score>
            </cfif>

            <!--- Önceki kayıtta kademe veya derece faklı ise --->
            <cfset grade_history = get_history.grade>
            <cfset step_history = get_history.step>
            <cfif (grade_history neq get_hr_ssk.grade or step_history neq get_hr_ssk.step) and (len(grade_history) and len(step_history))>
                <cfset get_grade_step_history = cmp_grade_step_params.GET_EMPLOYEES_GRADE_STEP_PARAMS(
                    start_month : start_month,
                    end_month : end_month,
                    grade : grade_history,
                    step : step_history
                )>
                
                <!--- Memur Gösterge Tablosu Kontrolü --->
                <cfif get_grade_step_history.recordcount eq 0>
                    <cfsavecontent variable="table_error"><cf_get_lang dictionary_id='62929.Girilen Tarihler Arasında Memur Gösterge Tablosu Bulunmaktadır!'></cfsavecontent>
                    <cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: table_error , in_out_id: attributes.in_out_id) />   
                <cfelse>
                    <cfset get_history_val = evaluate("get_grade_step_history.step_#step_history#")><!--- Gösterge Puanı --->
                </cfif>
                <cfset diff_value = abs(get_history_val - indicator_score)>
            </cfif>
            <cfset promotion_difference = (diff_value + additional_score_diff + severance_pension_diff)><!--- Terfi Farkları toplamı (Bir önceki aya göre kademe ve derecesi değişmiş ise))--->
            <cfset plus_retired = promotion_difference * factor><!--- Artış  %100 --->
            <cfset plus_retired_person = promotion_difference * factor * 2><!--- Kişi Devlet %100 --->
        </cfif>
        <cfset extra_pay = highest_civil_servant_salary * factor * (get_hr_ssk.additional_score / 100) * suspension_factor><!--- Ek Ödeme (En yüksek devlet memuru maaş katsayısı (9.500) * Katsayı * Puan %) --->
        
        <!--- Açığa alınmışsa  --->
        <cfset base_salary = base_salary * suspension_factor><!--- Taban Aylığı * açığa alınma  --->
        <cfset severance_pension = severance_pension * suspension_factor>
        <cfset additional_indicators = additional_indicators * suspension_factor><!--- Ek Gösterge * açığa alma oranı --->


        <!--- Tüm Hesap Toplamı(Hakedişler Toplamı) --->
        <!--- Aylık Tutar! + Ek Gösterge Aylık! + Taban Aylık! + Kıdem Aylık! + Yan Ödeme Aylık! + Em.Kes./Malul Yaşlı. (D)(5510 ve normal)! + Artış %100 (Devlet)! + ?Giriş %25 (Devlet) + Aile Yardımı! + Çocuk Yardımı! + 
        Makam Tazminatı! + Görev / Temsil Tazminatı! + Dil Tazminatı! + Toplu Sözleş.İkr.! + Sağlık Sigorta Pir. (Dev.)! + Özel Hizmet Tazminatı! + Ek Ödeme Tazminatı! + ?Fark Tazminatı + İdari Görev Ödeneği!
        Üniversite Ödeneği! + Yüksek Öğretim Taz.! + Akademik Teşvik Ödeneği! + Eğitim Öğretim Ödeneği! + ?Geliştirme Ödeneği + Denetim Tazminatı! --->
        <cfset officer_total_salary = officer_salary + additional_indicators + base_salary + severance_pension + business_risk + retirement_allowance_5510 + retirement_allowance + plus_retired + family_assistance + child_assistance + 
        executive_indicator_compensation + administrative_compensation + language_allowance + collective_agreement_bonus + health_insurance_premium_5510 + general_health_insurance + private_service_compensation + additional_indicator_compensation_ + 
        administrative_duty_allowance + university_allowance_payroll + high_education_compensation_payroll + academic_incentive_allowance_amount + education_allowance + audit_compensation_amount>
        <cfset officer_salary = officer_salary * suspension_factor>
    </cffunction>

    <!--- Ekleme Queryleri --->
    <cffunction name="add_officer_payroll" access="public" returntype="any">
        <!--- Çalışan ücretsiz izinliyse ve tüm ay ücretsiz izinliyse (Detaylar 127239 IDli iş içerisinde)--->
        <cfif isdefined("unpaid_offtime") and unpaid_offtime gt 0 and unpaid_offtime / get_hours.ssk_work_hours eq aydaki_gun_sayisi>
            <!--- Çalışan statüsü  5434 Sayılı Kanuna Tabi Çalışan ise --->
            <cfif get_hr_ssk.SSK_STATUTE eq 33>
                <cfset general_health_insurance = sgk_base * 12 / 100><!--- Genel sağlık sigortası matrahın %12 si --->
                <cfset retirement_allowance_5510 = 0>
            <cfelseif get_hr_ssk.SSK_STATUTE eq 1>
                <cfset retirement_allowance_5510 = sgk_base * 12 / 100><!--- Emekli Keseneği/Malul Yaşlı (Devlet) matrahın %12 si --->
                <cfset general_health_insurance = 0>
            </cfif>
            <cfset additional_indicators = 0>
            <cfset severance_pension = 0>
            <cfset business_risk = 0>
            <cfset university_allowance_payroll = 0>
            <cfset private_service_compensation = 0>
            <cfset language_allowance = 0>
            <cfset executive_indicator_compensation = 0>
            <cfset administrative_compensation = 0>
            <cfset administrative_duty_allowance = 0>
            <cfset education_allowance = 0>
            <cfset family_assistance = 0>
            <cfset child_assistance = 0>
            <cfset promotion_difference = 0>
            <cfset extra_pay = 0>
            <cfset indicator_score = 0>
            <cfset base_salary = 0>
            <cfset retirement_allowance = 0>
            <cfset retirement_allowance_personal = 0>
            <cfset sgk_base = 0>
            <cfset collective_agreement_bonus = 0>
            <cfset plus_retired = 0>
            <cfset plus_retired_person = 0>
            <cfset additional_indicator_compensation_ = 0>
            <cfset retirement_allowance_personal_5510 = 0>
            <cfset health_insurance_premium_5510 = 0>
            <cfset health_insurance_premium_personal_5510 = 0>
            <cfset high_education_compensation_payroll = 0>
            <cfset penance_deduction = 0>
            <cfset academic_incentive_allowance_amount = 0>
            <cfset audit_compensation_amount = 0>
            <cfset retirement_allowance_personal_interruption = 0>
        </cfif>

        <cfquery name="add_officer_payroll" datasource="#dsn#">
            INSERT INTO 
            OFFICER_PAYROLL_ROW
            (
                PAYROLL_ID
                ,EMPLOYEE_PAYROLL_ID
                ,ADDITIONAL_INDICATORS
                ,SEVERANCE_PENSION
                ,BUSINESS_RISK
                ,UNIVERSITY_ALLOWANCE
                ,PRIVATE_SERVICE_COMPENSATION
                ,LANGUAGE_ALLOWANCE
                ,EXECUTIVE_INDICATOR_COMPENSATION
                ,ADMINISTRATIVE_COMPENSATION
                ,ADMINISTRATIVE_DUTY_ALLOWANCE
                ,EDUCATION_ALLOWANCE
                ,FAMILY_ASSISTANCE
                ,CHILD_ASSISTANCE
                ,PROMOTION_DIFFERENCE
                ,EXTRA_PAY
                ,GRADE
                ,STEP
                ,IN_OUT_ID
                ,INDICATOR_SCORE
                ,BASE_SALARY
                ,RETIREMENT_ALLOWANCE
                ,RETIREMENT_ALLOWANCE_PERSONAL
                ,RETIREMENT_ALLOWANCE_PERSONAL_INTERRUPTION
                ,GENERAL_HEALTH_INSURANCE
                ,SGK_BASE
                ,COLLECTIVE_AGREEMENT_BONUS
                ,ADDITIONAL_SCORE
                ,PLUS_RETIRED
                ,PLUS_RETIRED_PERSONAL
                ,ADDITIONAL_INDICATOR_COMPENSATION
                ,RETIREMENT_ALLOWANCE_5510
                ,RETIREMENT_ALLOWANCE_PERSONAL_5510
                ,HEALTH_INSURANCE_PREMIUM_5510
                ,HEALTH_INSURANCE_PREMIUM_PERSONAL_5510
                ,NORMAL_GRADE
                ,NORMAL_STEP
                ,NORMAL_ADDITIONAL_SCORE
                ,HIGH_EDUCATION_COMPENSATION_PAYROLL
                ,PENANCE_DEDUCTION
                ,ACADEMIC_INCENTIVE_ALLOWANCE_AMOUNT
                ,AUDIT_COMPENSATION_AMOUNT
                ,LAND_COMPENSATION_AMOUNT
                ,RETIRED_ACADEMIC
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#additional_indicators#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#severance_pension#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#business_risk#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#university_allowance_payroll#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#private_service_compensation#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#language_allowance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#executive_indicator_compensation#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#administrative_compensation#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#administrative_duty_allowance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#education_allowance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#family_assistance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#child_assistance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#promotion_difference#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#extra_pay#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#get_hr_ssk.grade#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#get_hr_ssk.step#">
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#indicator_score#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#base_salary#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#retirement_allowance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#retirement_allowance_personal#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#retirement_allowance_personal_interruption#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#general_health_insurance#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#sgk_base#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#collective_agreement_bonus#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#get_hr_ssk.additional_score#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#plus_retired#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#plus_retired_person#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#additional_indicator_compensation_#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#retirement_allowance_5510#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#retirement_allowance_personal_5510#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#health_insurance_premium_5510#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#health_insurance_premium_personal_5510#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#get_hr_ssk.grade_normal#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#get_hr_ssk.step_normal#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#get_hr_ssk.additional_score_normal#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#high_education_compensation_payroll#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#penance_deduction#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#academic_incentive_allowance_amount#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#audit_compensation_amount#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#land_compensation_amount#">
                ,<cfif get_hr_ssk.administrative_academic eq 2><cfqueryparam cfsqltype="cf_sql_float" value="#retired_academic#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="0"></cfif>
            )
        </cfquery>
        
        <!--- Net Ücret --->
        <!---  Hakedişler toplamı - (Gelir Vergisi! + Damga Vergisi! + Em.Kes./Malul Yaşlı.(D)(5510 ve normal)! + Em.Kes./Malul Yaşlı.(K)(5510 ve normal)! + Artış %100 (Devlet+Kişi)! + ?Giriş %25 (Devlet+Kişi) + 
        Sağlık Sigorta Pir. (Dev.)(5510 ve normal)! + Sağlık Sigorta Pir. (Kişi)(5510 ve normal)! + Sendika Aidatı? + Bes Kesintisi! + Kefalet Kesintisi! + Kefalet Giriş Aidatı? + İcra? + Nafaka? + Kişi Borçu? +
        Lojman Kesintisi? + Disiplin Cezası? + Gelir Toplamı? + Kesinti Toplamı? + Net Ödenen?) --->
        <!--- TODO:  KEsintiler ve icralar da eklenecek --->
        <cfif (get_hr_ssk.use_ssk eq 2 and get_hr_ssk.administrative_academic eq 2)>
            <cfset net_pay_officer = retired_academic - 
            (retirement_allowance_5510 + health_insurance_premium_personal_5510  + health_insurance_premium_5510 + general_health_insurance + retirement_allowance + gelir_vergisi + damga_vergisi + bes_isci_hissesi + ozel_kesinti + ozel_kesinti_2 + avans + vergi_istisna_total)>
        <cfelseif (get_hr_ssk.use_ssk eq 2 and get_hr_ssk.administrative_academic eq 3)>
            <cfset net_pay_officer = salary - (gelir_vergisi + damga_vergisi + retirement_allowance_5510  + retirement_allowance_personal_5510 + retirement_allowance + 
            retirement_allowance_personal + plus_retired + health_insurance_premium_5510 + general_health_insurance + health_insurance_premium_personal_5510 + bes_isci_hissesi + penance_deduction + ozel_kesinti + ozel_kesinti_2 + avans + vergi_istisna_total)>
        <cfelse>
            <cfset net_pay_officer = officer_total_salary - (gelir_vergisi + damga_vergisi + retirement_allowance_5510  + retirement_allowance_personal_5510 + retirement_allowance + 
            retirement_allowance_personal + plus_retired + health_insurance_premium_5510 + general_health_insurance + health_insurance_premium_personal_5510 + bes_isci_hissesi + penance_deduction + ozel_kesinti + ozel_kesinti_2 + avans + vergi_istisna_total)>
        </cfif>

        <!--- Çalışan ücretsiz izinliyse ve tüm ay ücretsiz izinliyse --->
        <cfif isdefined("unpaid_offtime") and unpaid_offtime gt 0 and unpaid_offtime / get_hours.ssk_work_hours eq aydaki_gun_sayisi>
            <cfset officer_total_salary = 0>
            <cfset officer_salary = 0>
            <cfset bes_isci_hissesi = 0>
            <cfset net_pay_officer = 0>
        </cfif>

        <cfquery name="upd_salary" datasource="#dsn#">
            UPDATE
                EMPLOYEES_PUANTAJ_ROWS
            SET
                TOTAL_SALARY = <cfqueryparam cfsqltype="cf_sql_FLOAT" value="#officer_total_salary#">,
                SALARY = <cfqueryparam cfsqltype="cf_sql_FLOAT" value="#officer_salary#">,
                BES_ISCI_HISSESI = <cfqueryparam cfsqltype="cf_sql_FLOAT" value="#bes_isci_hissesi#">,
                NET_UCRET = <cfqueryparam cfsqltype="cf_sql_FLOAT" value="#net_pay_officer#">
                <cfif attributes.statue_type eq 5>,VERGI_IADESI = <cfqueryparam cfsqltype="cf_sql_FLOAT" value="0"></cfif>
            WHERE
                EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
        </cfquery>
        
        <!--- PAYROLL_JOB tablosuna json --->
        <cfset data = structnew()>
        <cfset data.puantaj_id = puantaj_id>
        <cfset data.employee_id = employee_id>
        <cfset data.in_out_id = attributes.in_out_id>
        <cfset data.SOCIALSECURITY_NO = attributes.SOCIALSECURITY_NO>
        <cfset data.salary_type = get_hr_ssk.salary_type>     
        <cfset data.maas = salary>   
        <cfset data.ek_gosterge = additional_indicators>   
        <cfset data.kidem_ayligi = severance_pension>   
        <cfset data.is_riski = business_risk>   
        <cfset data.universite_odenegi = university_allowance>   
        <cfset data.ozel_hizmet_tazminati = private_service_compensation>   
        <cfset data.yabanci_dil_tazminati = language_allowance>   
        <cfset data.makam_tazminati = executive_indicator_compensation>   
        <cfset data.gorev_tazminati = administrative_compensation> 
        <cfset data.idari_gorev_tazminati = administrative_duty_allowance>
        <cfset data.egitim_odenegi = education_allowance>
        <cfset data.aile_yardimi = family_assistance>
        <cfset data.cocuk_yardimi = child_assistance>
        <cfset data.ek_odeme = extra_pay>
        <cfset data.terfi_farki = promotion_difference>
        <cfset serializedStr = Replace(SerializeJSON(data),'//','')>

        <cfif isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE)>
            <cfset branch_id = attributes.SSK_OFFICE>
        <cfelseif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)>
            <cfset branch_id = attributes.BRANCH_ID>
        <cfelse>
            <cfset branch_id = ''>
        </cfif>
        <cfif isDefined("ilk_sal_mon_") and len(ilk_sal_mon_)>
            <cfset sal_mon_ = ilk_sal_mon_>
        <cfelseif isDefined("attributes.sal_mon") and len(attributes.sal_mon)>
            <cfset sal_mon_ = attributes.sal_mon>
        </cfif>
        <cfif isDefined("ilk_sal_year_") and len(ilk_sal_year_)>
            <cfset sal_year_ = ilk_sal_year_>
        <cfelseif isDefined("attributes.sal_year") and len(attributes.sal_year)>
            <cfset sal_year_ = attributes.sal_year>
        </cfif>
        <cfquery name="upd_payrol_job" datasource="#dsn#">
            UPDATE
                PAYROLL_JOB   
            SET
                PERCENT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "1">,
                BRANCH_PAYROLL_ID = #attributes.puantaj_id#,
                PAYROLL_DRAFT = <cfqueryparam CFSQLType = "cf_sql_varchar" value = "#serializedStr#">,
                EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_varchar" value = "#MAX_ID.IDENTITYCOL#">
            WHERE 
                IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.in_out_id# " null = "no">
                AND BRANCH_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#branch_id#" null = "no">
                AND MONTH = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#sal_mon_#" null = "no">
                AND YEAR = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#sal_year_#" null = "no">
                AND PAYROLL_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.puantaj_type#" null = "no">
                AND STATUE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#" null = "no">
                AND STATUE_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type#" null = "no">
                AND STATUE_TYPE_INDIVIDUAL = <cfif isdefined("attributes.statue_type_individual")><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#" null = "no"><cfelse>0</cfif>
        </cfquery>

    </cffunction>

    <!--- Katsayılar --->
    <cffunction name="get_factor_definition" access="public" returntype="any">
        <cfargument  name="start_month">
        <cfargument  name="end_month">
        <cfargument  name="definition_id">
        <cfquery name="get_factor_definition" datasource="#dsn#">
            SELECT
                *
            FROM
                SALARY_FACTOR_DEFINITION
            WHERE
                1 = 1
                <cfif isdefined("arguments.start_month") and len(arguments.start_month)>
                    AND
                    (
                        (STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">) OR
                        (FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">) OR
                        (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">)
                    )
                </cfif>
                <cfif isdefined("arguments.definition_id") and len(arguments.definition_id)>
                    AND ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.definition_id#"> 
                </cfif>
        </cfquery>
        <cfreturn get_factor_definition>
    </cffunction>

    <!--- Çalışan Açığa alındıysa --->
    <cffunction name="get_suspension_date" access="public" returntype="any">
        <cfargument  name="start_month">
        <cfargument  name="end_month">
        <cfquery name="get_suspension_date" datasource="#dsn#">
            SELECT
                IS_SUSPENSION
            FROM
                EMPLOYEES_IN_OUT
            WHERE
                (
                    (SUSPENSION_STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">) OR
                    (SUSPENSION_FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">) OR
                    (SUSPENSION_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND SUSPENSION_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">)
                )
                AND
                    IS_SUSPENSION = 1
                AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
        </cfquery>
        <cfreturn get_suspension_date>
    </cffunction>
    
    <!--- Ücret Kartı History --->
    <cffunction name="get_in_out_history" access="public" returntype="any">
        <cfargument  name="start_month">
        <cfargument  name="end_month">
        <cfset start_month_ = dateadd("m",-1,start_month)>
        <cfset end_month_ = dateadd("m",-1,end_month)>
        
        <cfquery name="get_in_out_history" datasource="#dsn#">
            SELECT
                OPR.GRADE,
                OPR.STEP,
                OPR.SEVERANCE_PENSION,
                OPR.ADDITIONAL_SCORE
            FROM
                EMPLOYEES_PUANTAJ EP
                INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
                INNER JOIN OFFICER_PAYROLL_ROW OPR ON OPR.PAYROLL_ID = EP.PUANTAJ_ID AND EPR.EMPLOYEE_PUANTAJ_ID = OPR.EMPLOYEE_PAYROLL_ID
            WHERE
                PUANTAJ_TYPE = #attributes.puantaj_type# AND
                SAL_MON = #month(start_month_)# AND
                SAL_YEAR = #year(start_month_)# AND
                SSK_BRANCH_ID = #branch_id#
                <cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>
                    AND HIERARCHY = '#attributes.hierarchy_puantaj#'
                </cfif>
                AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
                <cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2>
                    AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
                    <cfif isdefined("attributes.statue_type_individual") and attributes.statue_type_individual neq 0>
                        AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#">
                    </cfif>
                </cfif>
                AND EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
        </cfquery>
        <cfreturn get_in_out_history>
    </cffunction>

    <!--- kayıt kontrol --->
    <cffunction name="get_payroll_control" access="remote" returntype="any" returnformat="JSON">
        <cfargument  name="puantaj_type">
        <cfargument  name="employee_id">
        <cfargument  name="in_out_id">
        <cfargument  name="puantaj_id">
        <cfargument  name="ssk_statue">
        <cfargument  name="ssk_type">
        <cfargument  name="statue_type_individual">
        <cfif len(arguments.in_out_id) and len(arguments.puantaj_id)>
            <cfquery name="get_id_" datasource="#dsn#">
                SELECT 
                    UPDATE_DATE,
                    SAL_MON,
                    SAL_YEAR,
                    EMPLOYEE_ID,
                    UPDATE_DATE,
                    IN_OUT_ID,
                    STATUE,
                    STATUE_TYPE,
                    STATUE_TYPE_INDIVIDUAL
                FROM 
                    EMPLOYEES_PUANTAJ_ROWS 
                    INNER JOIN EMPLOYEES_PUANTAJ ON  EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
                WHERE 
                    EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.puantaj_id#"> 
                    AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
            </cfquery>
            <cfif get_id_.recordcount neq 0>
                <cfquery name="get_payroll_control" datasource="#dsn#">
                    SELECT 
                        EMPLOYEE_PUANTAJ_ID 
                    FROM 
                        EMPLOYEES_PUANTAJ EP,
                        EMPLOYEES_PUANTAJ_ROWS EPR
                    WHERE 
                        EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND 
                        EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id_.employee_id#"> AND 
                        EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id_.sal_year#"> AND 
                        EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id_.sal_mon#"> AND
                        EPR.UPDATE_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_id_.update_date#"> AND
                        STATUE_TYPE <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id_.STATUE_TYPE#">
                        <cfif len(arguments.statue_type_individual)>
                            AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id_.statue_type_individual#">
                        </cfif>
                    ORDER BY 
                        EPR.EMPLOYEE_PUANTAJ_ID DESC 
                </cfquery>
                <cfif get_payroll_control.recordcount gt 0>
                    <cfset list_id = valuelist(get_payroll_control.EMPLOYEE_PUANTAJ_ID)>
                    <cfset list_id = valuelist(get_payroll_control.EMPLOYEE_PUANTAJ_ID)>
                <cfelse>
                    <cfset list_id = "">
                </cfif>
            <cfelse>
                <cfset list_id = "">
            </cfif>
        <cfelse>
            <cfset list_id = "">
        </cfif>
        
        <cfreturn Replace(SerializeJSON(list_id),"//","")>
    </cffunction>
    
    <cffunction name="delete_next_payroll" access="remote" returntype="any" returnformat="JSON">
        <cfargument  name="list_id">

        <cfquery name="get_id" datasource="#dsn#">
            DELETE
            FROM 
                EMPLOYEES_PUANTAJ_ROWS 
            WHERE 
                EMPLOYEE_PUANTAJ_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.list_id#" list="yes">)
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <!--- Maaş History --->
    <cffunction name="get_salary_history" access="public" returntype="any">
        <cfargument  name="start_month">
        <cfargument  name="in_out_id" default="#attributes.in_out_id#">
        <cfquery name="get_salary_history" datasource="#dsn#">
            SELECT
                *
            FROM
                EMPLOYEES_SALARY
            WHERE
                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND
                PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(arguments.start_month)#">
        </cfquery>
        <cfreturn get_salary_history>
    </cffunction>
</cfcomponent>