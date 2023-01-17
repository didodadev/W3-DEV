<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 01/04/2016			Dev Date	: 02/06/2016		
Description :
	Bu component Banka Talimatları sayfasına  ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn = "#dsn#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    
    <cfinclude template="../fbx_workcube_funcs.cfm">
    
    <!--- list--->
    <cffunction name="list" access="remote" returntype="query">
    	<cfargument name="company" default="" type="string" hint="Şirket">
        <cfargument name="company_id" default="0" type="numeric" hint="Şirket ID">
        <cfargument name="consumer_id" default="0" type="numeric" hint="Üye ID">
        <cfargument name="employee_id" default="0" type="numeric" hint="Çalışan ID">
        <cfargument name="acc_type_id" default="0" type="numeric" hint="Type">
        <cfargument name="account_id_list" default="0" type="numeric" hint="Hesap ID Liste">
        <cfargument name="keyword_list" default="" type="string" hint="Filtre">
        <cfargument name="is_havale" default="0" type="numeric" hint="Havaleden Mi">
        <cfargument name="file_status" default="-1" type="numeric" hint="Durum">
        <cfargument name="bank_order_type" default="0" type="numeric" hint="Talimat Tip">
        <cfargument name="start_date" default="0" type="date" hint="Ödeme Tarihi">
        <cfargument name="finish_date" default="0" type="date" hint="Ödeme Tarihi">
        <cfargument name="start_date2" default="0" type="date" hint="İşlem Tarihi">
        <cfargument name="finish_date2" default="0" type="date" hint="İşlem Tarihi">
        <cfargument name="bank_action_date" default="0" type="date" hint="Havale Tarihi">
        <cfargument name="project_id" default="0" type="numeric" hint="Proje ID">
        <cfargument name="project_head" default="" type="string" hint="Proje Başlık">
        <cfargument name="special_definition_id" default="0" type="numeric" hint="Tahsilat/Ödeme Tip ID" >
        <cfargument name="list_order_type" default="0" type="numeric" hint="Sıralama Tipi">
        <cfargument name="maxrows" default="0" type="numeric" hint="Sıralama Tipi">
        <cfargument name="page" default="0" type="numeric" hint="Sıralama Tipi">
        
        <!--- list --->
        <cfquery name="list" datasource="#DSN2#" >
            WITH CTE1 AS (
               SELECT 
                    BON.*,
                    <!--- company --->
                    C.MEMBER_CODE COMPANY_MEMBER_CODE,
                    ISNULL(COMPANY_REMAINDER.BAKIYE,0) COMPANY_BAKIYE,
                    CB.COMPANY_IBAN_CODE AS COMPANY_IBAN_CODE,
                    <!--- consumer --->
                    CR.MEMBER_CODE CONSUMER_MEMBER_CODE,
                    ISNULL(CONSUMER_REMAINDER.BAKIYE,0) CONSUMER_BAKIYE,
                    CNB.CONSUMER_IBAN_CODE AS CONSUMER_IBAN_CODE,
                    <!--- employee --->
                    EMP.MEMBER_CODE EMPLOYEE_MEMBER_CODE,
                    ISNULL(EMPLOYEE_REMAINDER.BAKIYE,0) EMPLOYEE_BAKIYE,
                    <!--- odeme yapan --->
                    R_CP.COMPANY_PARTNER_NAME +' '+ R_CP.COMPANY_PARTNER_SURNAME RECORD_COMP_NAME,
                    R_CR.CONSUMER_NAME +' '+ R_CR.CONSUMER_SURNAME RECORD_CONS_NAME,
                    R_EMP.EMPLOYEE_NAME +' '+ R_EMP.EMPLOYEE_SURNAME RECORD_EMP_NAME,
                    <!--- temsilci --->
                    EP.EMPLOYEE_NAME +' '+ EP.EMPLOYEE_SURNAME TEMSILCI,     
                    PRO_PROJECTS.PROJECT_HEAD,
                    A.ACCOUNT_NAME,
                    A.ACCOUNT_NO,
                    SD.SPECIAL_DEFINITION,
                    ROW_NUMBER() OVER (ORDER BY BON.PAYMENT_DATE) AS RowNumber
                    <cf_extendedFields type="1" controllerFileName="bankDirecton" selectClause="1" mainTableAlias="BON">
                FROM 
                    BANK_ORDERS BON
                        LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = BON.COMPANY_ID
                        LEFT JOIN #dsn#.COMPANY_BANK CB ON CB.COMPANY_ID = BON.COMPANY_ID AND BON.ACTION_BANK_ACCOUNT = CB.COMPANY_BANK_ID
                        LEFT JOIN #dsn#.CONSUMER_BANK CNB ON CNB.CONSUMER_ID = BON.CONSUMER_ID AND BON.ACTION_BANK_ACCOUNT = CNB.CONSUMER_BANK_ID
                        LEFT JOIN #dsn2#.COMPANY_REMAINDER ON COMPANY_REMAINDER.COMPANY_ID = BON.COMPANY_ID
                        LEFT JOIN #dsn#.CONSUMER CR ON CR.CONSUMER_ID = BON.CONSUMER_ID
                        LEFT JOIN #dsn2#.CONSUMER_REMAINDER ON CONSUMER_REMAINDER.CONSUMER_ID = BON.CONSUMER_ID
                        LEFT JOIN #dsn#.WORKGROUP_EMP_PAR WEP ON WEP.CONSUMER_ID IS NOT NULL AND WEP.CONSUMER_ID = CR.CONSUMER_ID AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                        LEFT JOIN #dsn#.EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = WEP.POSITION_CODE AND EP.POSITION_STATUS = 1
                        LEFT JOIN #dsn#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = BON.EMPLOYEE_ID
                        LEFT JOIN #dsn2#.EMPLOYEE_REMAINDER ON  EMPLOYEE_REMAINDER.EMPLOYEE_ID = BON.EMPLOYEE_ID AND EMPLOYEE_REMAINDER.ACC_TYPE_ID = BON.ACC_TYPE_ID
                        <!--- odeme yapan --->
                        LEFT JOIN #dsn#.COMPANY_PARTNER R_CP ON R_CP.COMPANY_ID = BON.RECORD_PAR
                        LEFT JOIN #dsn#.CONSUMER R_CR ON R_CR.CONSUMER_ID = BON.RECORD_CONS
                        LEFT JOIN #dsn#.EMPLOYEES R_EMP ON R_EMP.EMPLOYEE_ID = BON.RECORD_EMP
                        LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = BON.PROJECT_ID
                        LEFT JOIN #dsn#.SETUP_SPECIAL_DEFINITION SD ON BON.SPECIAL_DEFINITION_ID=SD.SPECIAL_DEFINITION_ID
                        LEFT JOIN #dsn3#.ACCOUNTS AS A ON A.ACCOUNT_ID = BON.ACCOUNT_ID
                WHERE 		
                    1=1 
                    <cfif len(arguments.company) and arguments.company_id neq 0>
                        AND BON.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                    <cfelseif len(arguments.company) and arguments.consumer_id neq 0>
                        AND BON.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                    <cfelseif len(arguments.company) and arguments.employee_id neq 0 >
                        AND BON.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    </cfif>
                    <cfif arguments.acc_type_id neq 0>
                        AND BON.ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_type_id#">
                    </cfif>
                    <cfif arguments.account_id_list neq 0>
                        AND A.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.account_id_list,';')#">
                    </cfif>
                    <cfif len(arguments.keyword_list)>
                        AND
                            (
                                BON.SERI_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword_list#%"> OR
                                A.ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="<cfif len(arguments.keyword_list) gte 3>%</cfif>#arguments.keyword_list#%"> OR
                                (BON.FILE_EXPORT_ID IN (SELECT FI.E_ID FROM FILE_EXPORTS FI WHERE FI.E_ID = BON.FILE_EXPORT_ID AND FI.FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword_list#%">))
                            )
                    </cfif>
                    <cfif arguments.is_havale eq 1 and arguments.is_havale neq 0>
                        AND	BON.IS_PAID = 1
                    <cfelseif arguments.is_havale eq 2 and arguments.is_havale neq 0>
                        AND	(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
                    </cfif>
                    <cfif arguments.file_status eq 1 and arguments.file_status neq -1>
                        AND	BON.FILE_EXPORT_ID IS NOT NULL
                    <cfelseif arguments.file_status eq 0 and arguments.file_status neq -1>
                        AND	BON.FILE_EXPORT_ID IS NULL
                    </cfif>
                    <cfif arguments.bank_order_type neq 0>
                        AND BON.BANK_ORDER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bank_order_type#">
                    </cfif>
                    <cfif isdate(arguments.start_date) and arguments.start_date neq 0>
                        AND BON.PAYMENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                    </cfif>
                    <cfif isdate(arguments.finish_date) and arguments.finish_date neq 0>
                        AND BON.PAYMENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    </cfif>
                    <cfif isdate(arguments.start_date2) and arguments.start_date2 neq 0>
                        AND BON.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date2#">
                    </cfif>
                    <cfif isdate(arguments.finish_date2) and arguments.finish_date2 neq 0>
                        AND BON.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date2#">
                    </cfif>
                    <cfif isdate(arguments.bank_action_date) and arguments.bank_action_date neq 0>
                        AND BON.BANK_ORDER_ID IN(SELECT BA.BANK_ORDER_ID FROM BANK_ACTIONS BA WHERE BA.ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bank_action_date#"> AND BA.BANK_ORDER_ID IS NOT NULL)
                    </cfif>
                    <cfif len(arguments.project_head) and arguments.project_id neq 0>
                        AND BON.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                    </cfif>
                    <cfif arguments.special_definition_id neq 0>
                        AND BON.SPECIAL_DEFINITION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_definition_id#">
                    </cfif>
                    <cf_extendedFields type="1" controllerFileName="bankDirecton" whereClause="1" mainTableAlias="BON">
        		)
                 SELECT
                    *,
                    (SELECT COUNT(*) FROM CTE1) AS TOTALROWS
                FROM
                    CTE1
                WHERE
                    1 = 1
                    AND RowNumber BETWEEN #(page-1) * maxrows + 1# AND #page * maxrows#
                ORDER BY
                    RowNumber
        </cfquery>
        
        <cfreturn list>
    </cffunction>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="id" default="0" type="numeric" hint="ID">
        <cfargument name="old_process_type" default="0" type="numeric" hint="İşlem Tipi">
        <cfargument name="event" default="" type="string" hint="attributesten gelen event">
        
        <cfquery name="get" datasource="#DSN2#" >
            SELECT 
                BON.*,
                BB.BANK_NAME,
                BB.BANK_BRANCH_NAME,
                A.ACCOUNT_NO
            FROM 
                #dsn2#.BANK_ORDERS BON
                LEFT JOIN #dsn3#.ACCOUNTS AS A ON A.ACCOUNT_ID = BON.ACCOUNT_ID
                LEFT JOIN #dsn3#.BANK_BRANCH AS BB ON A.ACCOUNT_BRANCH_ID=BB.BANK_BRANCH_ID
            WHERE 		
                 BON.BANK_ORDER_TYPE =<cfif arguments.old_process_type neq 0>#arguments.old_process_type#<cfelse><cfif arguments.event eq 'updin' >251<cfelse >250</cfif></cfif>
                AND BON.BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
        </cfquery>
        
        <cfreturn get>
 	</cffunction>
    
     <!--- ups seri_no--->
    <cffunction name="updSeriNo" access="public" returntype="numeric">
    	<cfargument name="seri_no" default="" type="string" hint="Seri No">
        <cfargument name="max_id" default="0" type="numeric" hint="Max ID">
        
        <cfquery name="updSeriNo" datasource="#dsn2#">
            UPDATE BANK_ORDERS SET SERI_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.seri_no#"> WHERE BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.max_id#">
        </cfquery>
        
        <cfreturn arguments.seri_no>
 	</cffunction>
    
    <!--- control payment --->
    <cffunction name="controlPayment" access="remote" returntype="query">
    	<cfargument name="id" default="0" type="numeric" hint="Talimat ID">
    
    	 <cfquery name="control_payment" datasource="#dsn2#">
            SELECT 
            	I.CAMPAIGN_ID 
            FROM 
            	INVOICE_MULTILEVEL_PAYMENT_ROWS IR,
                INVOICE_MULTILEVEL_PAYMENT I 
            WHERE 
            	I.INV_PAYMENT_ID = IR.INV_PAYMENT_ID AND 
                IR.BANK_ORDER_ID IS NOT NULL AND 
                IR.BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
        </cfquery>
        
        <cfreturn control_payment>
    </cffunction>
    
    <!--- add --->
    <cffunction name="add" access="public" returntype="numeric">
    	<cfargument name="process_type" default="0" type="numeric" hint="İşlem Tipi">
        <cfargument name="process_cat" default="0" type="numeric" hint="İşlem Kategorisi">
        <cfargument name="list_bank" default="0" type="numeric" hint="Carinin Banka Hesabı ID">
        <cfargument name="branch_id" default="0" type="numeric" hint="Şube">
        <cfargument name="ORDER_AMOUNT" default="0" type="numeric" hint="Tutar">
        <cfargument name="currency_id" default="" type="string" hint="Para Birimi">
        <cfargument name="account_id" default="0" type="numeric" hint="Banka Hesap">
        <cfargument name="company_id" default="0" type="numeric" hint="Şirket ID">
        <cfargument name="consumer_id" default="0" type="numeric" hint="Müşteri ID">
        <cfargument name="employee_id" default="0" type="numeric" hint="Çalışan ID">
        <cfargument name="acc_type_id" default="0" type="numeric" hint="">
        <cfargument name="MEMBER_BANK_ID" default="0" type="numeric" hint="">
        <cfargument name="project_name" default="" type="string" hint="Proje Ad">
        <cfargument name="project_id" default="0" type="numeric" hint="Proje ID">
        <cfargument name="OTHER_CASH_ACT_VALUE" default="0" type="numeric" hint="Döviz Tutar">
        <cfargument name="money_type" default="" type="string" hint="">
        <cfargument name="action_date" default="0" type="date" hint="İşlem Tarihi">
        <cfargument name="payment_date" default="0" type="date" hint="Ödeme/Tahsil Tarihi">
        <cfargument name="action_detail" default="" type="string" hint="Detay">
        <cfargument name="asset_id" default="0" type="numeric" hint="Fiziki Varlık ID">
        <cfargument name="asset_name" default="" type="string" hint="Fiziki Varlık Ad">
        <cfargument name="credit_limit" default="0" type="numeric" hint="Kredi Limit ID">
        <cfargument name="special_definition_id" default="0" type="numeric" hint="Ödeme/Tahsil Tarihi">
        <cfargument name="recordcount" default="0" type="numeric" hint="">
        <cfargument name="form_branch_id" default="0" type="numeric" hint="Şube">
        
    	<cfquery name="add" datasource="#DSN2#" result="MAX_ID">
            INSERT INTO
                BANK_ORDERS
                (
                    BANK_ORDER_TYPE,
                    BANK_ORDER_TYPE_ID,
                    ACTION_BANK_ACCOUNT,
                    TO_BRANCH_ID,
                    ACTION_VALUE,
                    ACTION_MONEY,
                    ACCOUNT_ID,
                    COMPANY_ID,
                    CONSUMER_ID,
                    EMPLOYEE_ID,
                    ACC_TYPE_ID,
                    TO_ACCOUNT_ID,
                    PROJECT_ID,
                    OTHER_MONEY_VALUE,
                    OTHER_MONEY,
                    ACTION_DATE,
                    PAYMENT_DATE,
                    IS_PAID,
                    ACTION_DETAIL,
                    ASSETP_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    CREDIT_LIMIT_ID,
                    SPECIAL_DEFINITION_ID,
                    FROM_BRANCH_ID
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_type#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.list_bank eq 0#" value="#arguments.list_bank#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.branch_id eq 0#" value="#arguments.branch_id#">,
                    <cfqueryparam cfsqltype="cf_sql_float" null="#arguments.order_amount eq 0#" value="#arguments.order_amount#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#arguments.currency_id eq 0#" value="#arguments.currency_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.account_id eq 0#" value="#arguments.account_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.company_id eq 0#"  value="#arguments.company_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.consumer_id eq 0#"  value="#arguments.consumer_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.employee_id eq 0#"  value="#arguments.employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.acc_type_id eq 0#"  value="#arguments.acc_type_id#">,
                    <cfif arguments.employee_id eq 0 and arguments.recordcount><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MEMBER_BANK_ID#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.project_name) and len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.project_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_float" null="#arguments.OTHER_CASH_ACT_VALUE eq 0#"  value="#arguments.OTHER_CASH_ACT_VALUE#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#len(arguments.money_type)#"  value="#arguments.money_type#">,
                    <cfqueryparam cfsqltype="cf_sql_date" null="#arguments.action_date eq 0#"  value="#arguments.action_date#">,
                    <cfqueryparam cfsqltype="cf_sql_date" null="#arguments.payment_date eq 0#"  value="#arguments.payment_date#">,
                    0, <!---banka talimatından havale olusturulmadigini gosteriyor  --->
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.ACTION_DETAIL)#"  value="#arguments.ACTION_DETAIL#">,
                    <cfif isdefined("arguments.asset_id") and len(arguments.asset_id) and len(arguments.asset_name)><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.asset_id#"><cfelse>NULL</cfif>,
                    #now()#,
                    #session.ep.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar"  value="#CGI.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.credit_limit eq 0#"  value="#arguments.credit_limit#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.special_definition_id eq 0#"  value="#arguments.special_definition_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.form_branch_id eq 0#"  value="#arguments.form_branch_id#">
                )
        </cfquery>
        
        <cfreturn MAX_ID.IDENTITYCOL>
    </cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="numeric">
    	<cfargument name="process_type" default="0" type="numeric" hint="İşlem Tipi">
        <cfargument name="process_cat" default="0" type="numeric" hint="İşlem Kategorisi">
        <cfargument name="list_bank" default="0" type="numeric" hint="Carinin Banka Hesabı ID">
        <cfargument name="branch_id" default="0" type="numeric" hint="Şube">
        <cfargument name="ORDER_AMOUNT" default="0" type="numeric" hint="Tutar">
        <cfargument name="currency_id" default="" type="string" hint="Para Birimi">
        <cfargument name="account_id" default="0" type="numeric" hint="Banka Hesap">
        <cfargument name="company_id" default="0" type="numeric" hint="Şirket ID">
        <cfargument name="consumer_id" default="0" type="numeric" hint="Müşteri ID">
        <cfargument name="employee_id" default="0" type="numeric" hint="Çalışan ID">
        <cfargument name="acc_type_id" default="0" type="numeric" hint="">
        <cfargument name="MEMBER_BANK_ID" default="0" type="numeric" hint="">
        <cfargument name="project_name" default="" type="string" hint="Proje Ad">
        <cfargument name="project_id" default="0" type="numeric" hint="Proje ID">
        <cfargument name="OTHER_CASH_ACT_VALUE" default="0" type="numeric" hint="Döviz Tutar">
        <cfargument name="money_type" default="" type="string" hint="">
        <cfargument name="action_date" default="0" type="date" hint="İşlem Tarihi">
        <cfargument name="payment_date" default="0" type="date" hint="Ödeme/Tahsil Tarihi">
        <cfargument name="action_detail" default="" type="string" hint="Detay">
        <cfargument name="asset_id" default="0" type="numeric" hint="Fiziki Varlık ID">
        <cfargument name="asset_name" default="" type="string" hint="Fiziki Varlık Ad">
        <cfargument name="credit_limit" default="0" type="numeric" hint="Kredi Limit ID">
        <cfargument name="special_definition_id" default="0" type="numeric" hint="Ödeme/Tahsil Tarihi">
        <cfargument name="recordcount" default="0" type="numeric" hint="">
        <cfargument name="from_branch_id" default="0" type="numeric" hint="Şube">
        <cfargument name="bank_order_type" default="0" type="numeric" hint="Talimat Tipi">
        <cfargument name="id" default="0" type="numeric" hint="">
    	<cfquery name="upd" datasource="#DSN2#">
            UPDATE
                BANK_ORDERS
            SET
                BANK_ORDER_TYPE_ID= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">,
                ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_float" null="#arguments.order_amount eq 0#" value="#arguments.order_amount#">,
                ACTION_MONEY =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#arguments.currency_id eq 0#" value="#arguments.currency_id#">,
                TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.branch_id eq 0#" value="#arguments.branch_id#">,
                FROM_BRANCH_ID =  <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.from_branch_id eq 0#" value="#arguments.from_branch_id#">,
                ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.account_id eq 0#" value="#arguments.account_id#">,
                ACTION_BANK_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.list_bank eq 0#" value="#arguments.list_bank#">,
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.company_id eq 0#"  value="#arguments.company_id#">,
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.consumer_id eq 0#"  value="#arguments.consumer_id#">,
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.employee_id eq 0#"  value="#arguments.employee_id#">,
                ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.acc_type_id eq 0#"  value="#arguments.acc_type_id#">,
                TO_ACCOUNT_ID =  <cfif arguments.employee_id eq 0 and arguments.recordcount><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MEMBER_BANK_ID#"><cfelse>NULL</cfif>,
                PROJECT_ID = <cfif len(arguments.project_name) and len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.project_id#"><cfelse>NULL</cfif>,
                OTHER_MONEY_VALUE= <cfqueryparam cfsqltype="cf_sql_float" null="#arguments.OTHER_CASH_ACT_VALUE eq 0#"  value="#arguments.OTHER_CASH_ACT_VALUE#">,
                OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" null="#len(arguments.money_type)#"  value="#arguments.money_type#">,
                ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_date" null="#arguments.action_date eq 0#"  value="#arguments.action_date#">,
                PAYMENT_DATE = <cfqueryparam cfsqltype="cf_sql_date" null="#arguments.payment_date eq 0#"  value="#arguments.payment_date#">,
                ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.ACTION_DETAIL)#"  value="#arguments.ACTION_DETAIL#">,
                ASSETP_ID = <cfif isdefined("arguments.asset_id") and len(arguments.asset_id) and len(arguments.asset_name)><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.asset_id#"><cfelse>NULL</cfif>,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                CREDIT_LIMIT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.credit_limit eq 0#"  value="#arguments.credit_limit#">,
                SPECIAL_DEFINITION_ID= <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.special_definition_id eq 0#"  value="#arguments.special_definition_id#">
            WHERE
                BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#"> 
                AND BANK_ORDER_TYPE = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#arguments.bank_order_type#">
        </cfquery>
        
        <cfreturn arguments.id>
    </cffunction>
    
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
    	<cfargument name="id" default="0" type="numeric" hint="Talimat ID">
        
    	<cfquery name="GET_BANK_ORDERS" datasource="#DSN2#">
            SELECT CLOSED_ID FROM BANK_ORDERS WHERE BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#"> 
        </cfquery>
        <cfif len(GET_BANK_ORDERS.CLOSED_ID)>
            <cfquery name="UPD_CLOSED" datasource="#DSN2#">
                UPDATE CARI_CLOSED SET IS_BANK_ORDER = 0 WHERE CLOSED_ID = #GET_BANK_ORDERS.CLOSED_ID#
            </cfquery>
        </cfif>
        <cfquery name="DEL_BANK_ORDER_MONEY" datasource="#dsn2#">
            DELETE FROM BANK_ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#"> 
        </cfquery>
        <cfquery name="DEL_FROM_CARI" datasource="#dsn2#">
            DELETE FROM BANK_ORDERS WHERE BANK_ORDER_ID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#"> 
        </cfquery>
        
        <cfreturn true>
    </cffunction>
    
    <!--- upd_closed_ --->
    <cffunction name="upd_closed_" access="public" returntype="numeric">
    	<cfargument name="id" default="0" type="numeric" hint="Kapama ID">
        
    	<cfquery name="UPD_CLOSED_" datasource="#DSN2#">
            UPDATE
                CARI_CLOSED
            SET
                IS_BANK_ORDER = 1
            WHERE
                CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        
        <cfreturn arguments.id>
    </cffunction>
    
    <!--- upd_closed--->
    <cffunction name="upd_closed" access="public" returntype="numeric">
    	<cfargument name="id" default="0" type="numeric" hint="Kapama ID">
        <cfargument name="row_id" default="0" type="numeric" hint="Kapama Satır ID">
        <cfargument name="action_id" default="0" type="numeric" hint="">
        <cfargument name="amount" default="0" type="numeric" hint="Tutat">
        <cfargument name="other_amount" default="0" type="numeric" hint="Dövizli Tutar">
        
    	<cfquery name="UPD_CLOSED" datasource="#DSN2#">
            UPDATE
                CARI_CLOSED_ROW
            SET
                RELATED_CLOSED_ROW_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.row_id#">,
                CLOSED_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount#">,
                OTHER_CLOSED_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.other_amount#">
                <cfif arguments.action_id neq 0>
                	,RELATED_CARI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.action_id#">
                </cfif>
            WHERE
				<cfif arguments.action_id neq 0>
                    CLOSED_ROW_ID IN (#arguments.row_id#) AND
                </cfif>
                CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">,
        </cfquery>
        
        <cfreturn arguments.id>
    </cffunction>
    
    <!--- get_cariInfo --->
    <cffunction name="GET_CARI_INFO" access="public" returntype="query">
    	<cfargument name="id" default="0" type="numeric" hint="">
        <cfargument name="process_type" default="0" type="numeric" hint="İşlem Tipi">
        
    	<cfquery name="GET_CARI_INFO" datasource="#DSN2#">
            SELECT 
                CARI_ACTION_ID 
            FROM 
                CARI_ROWS 
            WHERE 
                ACTION_ID = #arguments.id# AND 
                ACTION_TYPE_ID = #process_type#
        </cfquery>
        
        <cfreturn GET_CARI_INFO>
    </cffunction>
    
    <!--- add_closed --->
    <cffunction name="ADD_CLOSED_ROW" access="public" returntype="query">
    	<cfargument name="order_id" default="0" type="numeric" hint="Talimat ID">
        <cfargument name="CARI_ACTION_ID" default="0" type="numeric" hint="">
        <cfargument name="identitycol" default="0" type="numeric" hint="">
        <cfargument name="process_type" default="0" type="numeric" hint="İşlem Tipi">
        <cfargument name="system_amount" default="0" type="numeric" hint="Sistem Tutar">
        <cfargument name="other_cash_act_value" default="0" type="numeric" hint="Döviz Tutar">
        <cfargument name="money_type" default="" type="string" hint="">
        <cfargument name="temp_payment_date" default="0" type="numeric" hint="Ödeme tarihi">
    	<cfquery name="ADD_CLOSED_ROW" datasource="#DSN2#" result="CLOSED_MAX_ID">
            INSERT INTO
                CARI_CLOSED_ROW
            (
                CLOSED_ID,
                CARI_ACTION_ID,
                ACTION_ID,
                ACTION_TYPE_ID,
                ACTION_VALUE,
                CLOSED_AMOUNT,
                OTHER_CLOSED_AMOUNT,
                P_ORDER_VALUE,
                OTHER_P_ORDER_VALUE,							
                OTHER_MONEY,
                DUE_DATE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CARI_ACTION_ID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.identitycol#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_type#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.system_amount#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.system_amount#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.other_cash_act_value#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.system_amount#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.other_cash_act_value#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.money_type#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.temp_payment_date#">
            )
        </cfquery>
        
        <cfreturn CLOSED_MAX_ID.IDENTITYCOL>
    </cffunction>
    
    <!--- upd_cariClosed--->
    <cffunction name="UPD_CARI_CLOSED" access="public" returntype="query">
    	<cfargument name="id" default="0" type="numeric" hint="Kapama ID">
        <cfargument name="ORDER_DEBT_AMOUNT_VALUE" default="0" type="numeric" hint="Borç Tutar">
        <cfargument name="ORDER_CLAIM_AMOUNT_VALUE" default="0" type="numeric" hint="Alacak Tutar">
        
    	<cfquery name="UPD_CARI_CLOSED" datasource="#DSN2#">
            UPDATE
                CARI_CLOSED
            SET
                IS_CLOSED = 1,
            <cfif arguments.ORDER_DEBT_AMOUNT_VALUE neq 0>
                DEBT_AMOUNT_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ORDER_DEBT_AMOUNT_VALUE#">,
                CLAIM_AMOUNT_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ORDER_DEBT_AMOUNT_VALUE#">,
            <cfelse>
                DEBT_AMOUNT_VALUE =<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ORDER_CLAIM_AMOUNT_VALUE#">,
                CLAIM_AMOUNT_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ORDER_CLAIM_AMOUNT_VALUE#">,
            </cfif>
                DIFFERENCE_AMOUNT_VALUE = 0
            WHERE
                CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">,
        </cfquery>
        
        <cfreturn arguments.id>
    </cffunction>
    
    <!--- company_bank --->
    <cffunction name="company_bank" access="public" returntype="query">
    	<cfargument name="id" default="0" type="numeric" hint="Şirket ID">
        
    	<cfquery name="company_bank" datasource="#dsn#">
            SELECT
                COMPANY_BANK_ID as ID,
                COMPANY_ACCOUNT_NO as NO,
                COMPANY_BANK as BANK,
                COMPANY_BANK_BRANCH as BRANCH
            FROM
                COMPANY_BANK
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        
        <cfreturn company_bank>
    </cffunction>
    
    <!--- consumer_bank --->
    <cffunction name="consumer_bank" access="public" returntype="query">
    	<cfargument name="id" default="0" type="numeric" hint="Müşteri ID">
        
    	<cfquery name="consumer_bank" datasource="#dsn#">
            SELECT
                CONSUMER_BANK_ID as ID,
                CONSUMER_ACCOUNT_NO as NO,
                CONSUMER_BANK as BANK,
                CONSUMER_BANK_BRANCH as BRANCH
            FROM
                CONSUMER_BANK
            WHERE
                CONSUMER_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        
        <cfreturn consumer_bank>
    </cffunction>
</cfcomponent>