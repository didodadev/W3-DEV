<!---
    File: V16\report\cfc\wai_settings.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-11-09
    Description: Wai tanımları
--->
<cfcomponent extends="WMO.functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn2_alias = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3_alias = '#dsn#_#session.ep.company_id#'>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset fusebox.use_period = application.systemParam.systemParam().fusebox.use_period>
    <cfset fusebox.dynamic_hierarchy = application.systemParam.systemParam().fusebox.dynamic_hierarchy>
    <cfset dateformat_style = session.ep.dateformat_style>
    <cffunction name="GET_WAI_SETTINGS" access="public" returntype="any">
        <cfquery name="GET_WAI_SETTINGS" datasource="#DSN#">
            SELECT
                *              
            FROM
                WAI_SETTINGS
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        </cfquery>
        <cfreturn GET_WAI_SETTINGS>
    </cffunction>

    <cffunction name="ADD_WAI_SETTINGS" access="remote" returntype="any">
        <cfargument  name="name" type="any" default="" required="yes">
        <cfargument  name="period" type="any" default="" required="yes">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="ADD_WAI_SETTINGS" datasource="#dsn#">
                INSERT INTO WAI_SETTINGS
                (
                    NAME
                    ,EMPLOYEE_ID
                    ,PERIOD
                    ,RECORD_DATE
                    ,RECORD_EMP
                    ,RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
                    ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="UPD_WAI_SETTINGS" access="remote" returntype="any">
        <cfargument  name="name" type="any" default="" required="yes">
        <cfargument  name="period" type="any" default="" required="yes">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="UPD_WAI_SETTINGS" datasource="#dsn#">
                UPDATE 
                    WAI_SETTINGS
                SET 
                    NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
                    ,PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#">
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE 
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="GET_WAI_QUESTIONS" access="remote" returntype="string" returnFormat="json">

        <cfargument  name="speech_text" type="any" default="" required="yes">
        <cfargument  name="start_date" type="any" default="" required="yes">
        <cfargument  name="finish_date" type="any" default="" required="yes">

        <cfset arguments.speech_text = replace(arguments.speech_text,"Luna","","All")> 
        <cfset arguments.speech_text = replace(arguments.speech_text," Luna","","All")> 
        <cfset arguments.speech_text = replace(arguments.speech_text,"Luna ","","All")> 
        <cfset arguments.speech_text = Trim(arguments.speech_text)> 

        <cfquery name="GET_WAI_QUESTIONS" datasource="#DSN#">
            SELECT
                WAI_ANSWERS,
                WA.FUNCTION_NAME        
            FROM
                WAI_QUESTIONS WQ
                INNER JOIN WAI_QUESTIONS_ANSWERS WQA ON WQA.WAI_QUESTION_ID = WQ.WAI_QUESTION_ID
                INNER JOIN WAI_ANSWERS WA ON WA.WAI_ANSWER_ID = WQA.WAI_ANSWER_ID
            WHERE
                WQ.WAI_QUESTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.speech_text#%">
        </cfquery>
        
        <cfif len(GET_WAI_QUESTIONS.FUNCTION_NAME)>
            <cfset fnc_name = GET_WAI_QUESTIONS.FUNCTION_NAME> 
            <cfset get_function = evaluate("#fnc_name#(start_date: '#start_date#', finish_date: '#finish_date#',wai_answers: '#GET_WAI_QUESTIONS.wai_answers#')")>
            <cfset return_result = get_function>
        <cfelse>
            <cfset return_result = GET_WAI_QUESTIONS>
        </cfif>

        <cfreturn Replace(serializeJSON(return_result),'//','')>
    </cffunction>

    <cffunction name="GET_WAI_DATE" access="remote" returntype="string" returnFormat="json">
        <cfargument  name="speech_text" type="any" default="" required="yes">
        <cfquery name="GET_WAI_DATE" datasource="#dsn#">
            SELECT 
                DATEADD(day, -7, GETDATE()) START_DATE,
                GETDATE() FINISH_DATE
            WHERE 
                '#arguments.speech_text#' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hafta%">
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_WAI_DATE),'//','')>
    </cffunction>

    <cffunction name="get_week_summary" access="public"  returntype="any">
        <cfargument  name="speech_text" type="any" default="" required="yes">
        <cfargument  name="start_date" type="any" default="" required="yes">
        <cfargument  name="wai_answers" type="any" default="" required="yes">

        <cfinclude template="/V16/myhome/query/get_summary.cfm">

        <!--- Alış --->
        <cfset attributes.purchase_sales = 1> 
        <cfinclude template="/V16/myhome/includes/get_money_total.cfm"> 
        <cfset wai_answers = replace(wai_answers, '&&sales&&', TlFormat(MONEY_SALES))>
        <cfset wai_answers = replace(wai_answers, '&&currency&&', session.ep.money,'all')>

        <!--- Satış --->
        <cfset attributes.purchase_sales = 0>
        <cfinclude template="/V16/myhome/includes/get_money_total.cfm"> 
        <cfset wai_answers = replace(wai_answers, '&&purchase&&', TlFormat(MONEY_PURCHASE))>

        <!--- Ödeme --->
        <cfset attributes.BA = 32>
		<cfset attributes.BA1 = 34>
        <cfinclude template="/V16/myhome/includes/get_acc_money.cfm"> 
        <cfset wai_answers = replace(wai_answers, '&&payments&&', TlFormat(get_acc_money.amount_money))>

        <!--- Tahsilat --->
        <cfset attributes.BA = 31> 
        <cfset attributes.BA1 = 35> 
		<cfinclude template="/V16/myhome/includes/get_acc_money.cfm">
        <cfset wai_answers = replace(wai_answers, '&&collection&&', TlFormat(get_acc_money.amount_money))>

        <!--- Kasa --->
        <cfset toplam_kasa_para_tutari=0>
        
        <cfloop query="get_cash_total">
            <cfif len(cash_total)><cfset toplam_kasa_para_tutari=toplam_kasa_para_tutari+cash_total></cfif>
        </cfloop>
        <cfif toplam_kasa_para_tutari gt 0>
            <cfset toplam_kasa_para_tutari = TlFormat(toplam_kasa_para_tutari)>
        <cfelse>
            <cfset toplam_kasa_para_tutari = 0>
        </cfif>
        <cfset wai_answers = replace(wai_answers, '&&cash_one&&', toplam_kasa_para_tutari)>
        <cfset wai_answers = replace(wai_answers, '&&currency_one&&', session.ep.money)>

        <!--- Banka --->
        <cfif account_bakiye gt 0>
            <cfset account_bakiye = TlFormat(account_bakiye)>
        </cfif>
        <cfset wai_answers = replace(wai_answers, '&&bank_one&&', account_bakiye)>
        <cfset wai_answers = replace(wai_answers, '&&currency_bank_one&&', session.ep.money)>

        <cfset set_result = {"COLUMNS":["WAI_ANSWERS"],"DATA":[['#wai_answers#']]}>
       
        <cfreturn set_result>
    </cffunction>

</cfcomponent>