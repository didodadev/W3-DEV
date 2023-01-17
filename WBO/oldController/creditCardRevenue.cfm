<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and not attributes.event is "del">
	<cfif attributes.event contains "upd">
    	<cfset attributes.active_period = attributes.action_period_id>
    </cfif>
	<cfif isdefined("attributes.active_period") and attributes.active_period neq session.ep.period_id>
        <script type="text/javascript">
			alertObject({message: "<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!"});
        </script>
        <cfabort>
    </cfif>
    <cfquery name="get_process_type" datasource="#dsn3#">
        SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#
    </cfquery>
    <cfif isdefined('attributes.event') and listFind('add,upd',attributes.event)> 
        <cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#"><!--- Seçilen ödeme yönteminin detay bilgileri --->
            SELECT 
                PAYMENT_TYPE_ID, 
                ISNULL(NUMBER_OF_INSTALMENT,0) AS NUMBER_OF_INSTALMENT, 
                P_TO_INSTALMENT_ACCOUNT,
                ACCOUNT_CODE,
                SERVICE_RATE,
                PAYMENT_RATE,
                PAYMENT_RATE_ACC,
                IS_PESIN,
                POS_TYPE,
                COMPANY_ID
            FROM 
                CREDITCARD_PAYMENT_TYPE 
            WHERE 
                PAYMENT_TYPE_ID = #attributes.payment_type_id#
        </cfquery>
		<cfif not len(GET_CREDIT_PAYMENT.ACCOUNT_CODE) and get_process_type.is_account eq 1>
            <cfif (attributes.event is "add" and not isdefined('xml_import')) or attributes.event is "upd">
                <script type="text/javascript">
					alertObject({message: "<cf_get_lang no ='396.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Seçilmemiş'>!"});
                </script>
            <cfelse>
                <cf_get_lang no ='396.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Seçilmemiş'>!<br/>
            </cfif>
            <cfabort>
        </cfif>
		<cfif len(attributes.action_from_company_id)>
            <cfset my_acc_result = get_company_period(attributes.action_from_company_id)>
            <cfquery name="get_comp_name" datasource="#dsn#">
                SELECT FULLNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID = #attributes.action_from_company_id#
            </cfquery>
            <cfset member_name_ = get_comp_name.FULLNAME>
            <cfset member_code = get_comp_name.member_code>
        <cfelse>
            <cfset my_acc_result = get_consumer_period(attributes.cons_id)>
            <cfquery name="get_cons_name" datasource="#dsn#">
                SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID = #attributes.cons_id#
            </cfquery>
            <cfset member_name_ = get_cons_name.FULLNAME>
            <cfset member_code = get_cons_name.member_code>
        </cfif>
		<cfif not len(my_acc_result)>
            <cfif (attributes.event is "add" and not isdefined('xml_import')) or attributes.event is "upd">
                <script type="text/javascript">
					alertObject({message: "<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!"});
                </script>
            <cfelse>
                <cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!<br/>
            </cfif>
            <cfabort>
        </cfif>
        <cf_date tarih='attributes.due_start_date'>
    <cfelseif isdefined('attributes.event') and attributes.event is "addPos">
		<cfif isDefined("attributes.subs_inv_id")>
            <cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
                SELECT IS_COLLECTED_PROVISION FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE INVOICE_ID = #attributes.subs_inv_id# AND PERIOD_ID = #attributes.period_id#
            </cfquery>
            <cfif GET_PROV_INFO.IS_COLLECTED_PROVISION neq 0>
                <script type="text/javascript">
                    alertObject({mesasage : "<cf_get_lang no ='416.Aynı Ödeme Planı Satırı İçin Provizyon İşlemi Yapılmıştır'>!"});
                </script>
                <cfabort>
            </cfif>
            <cfquery name="GET_PAID_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
                SELECT IS_PAID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE INVOICE_ID = #attributes.subs_inv_id# AND PERIOD_ID = #attributes.period_id# AND IS_PAID = 1
            </cfquery>
            <cfif GET_PAID_INFO.recordcount>
                <script type="text/javascript">
                    alertObject({message : "<cf_get_lang dictionary_id='54534.İlişkili fatura daha önceden tahsil edilmiştir! Tahsilat işlemi gerçekleşmeyecektir'>."});
                </script>
                <cfabort>
            </cfif>
        </cfif>
		<cfset my_acc_result = "">
        <cfif isdefined("attributes.member_card_id") and len(attributes.member_card_id)>
            <cfquery name="get_card_info" datasource="#dsn#">
                SELECT
                    <cfif isdefined("attributes.action_from_company_id") and len(attributes.action_from_company_id)>
                        CC.COMPANY_CC_ID MEMBER_CC_ID,
                        CC.COMPANY_ID MEMBER_ID,
                        CC.COMPANY_CC_TYPE MEMBER_CC_TYPE,
                        CC.COMPANY_CC_NUMBER MEMBER_CC_NUMBER,
                        CC.COMPANY_EX_MONTH MEMBER_EX_MONTH,
                        CC.COMPANY_EX_YEAR MEMBER_EX_YEAR,
                        CC.COMPANY_BANK_TYPE MEMBER_BANK_TYPE,
                        CC.COMPANY_CARD_OWNER MEMBER_CARD_OWNER,
                        CC.COMP_CVS MEMBER_CVS
                    <cfelse>
                        CC.CONSUMER_CC_ID MEMBER_CC_ID,
                        CC.CONSUMER_ID MEMBER_ID,
                        CC.CONSUMER_CC_TYPE MEMBER_CC_TYPE,
                        CC.CONSUMER_CC_NUMBER MEMBER_CC_NUMBER,
                        CC.CONSUMER_EX_MONTH MEMBER_EX_MONTH,
                        CC.CONSUMER_EX_YEAR MEMBER_EX_YEAR,
                        CC.CONSUMER_BANK_TYPE MEMBER_BANK_TYPE,
                        CC.CONSUMER_CARD_OWNER MEMBER_CARD_OWNER,
                        CC.CONS_CVS MEMBER_CVS
                    </cfif>
                FROM
                    <cfif isdefined("attributes.action_from_company_id") and len(attributes.action_from_company_id)>
                        COMPANY_CC CC
                    <cfelse>
                        CONSUMER_CC CC
                    </cfif>
                WHERE
                    <cfif isdefined("attributes.action_from_company_id") and len(attributes.action_from_company_id)>
                        CC.COMPANY_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_card_id#">
                    <cfelse>
                        CC.CONSUMER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_card_id#">
                    </cfif>
            </cfquery>
            <cfset attributes.bank_type = GET_CARD_INFO.MEMBER_BANK_TYPE>
            <cfset attributes.card_owner = GET_CARD_INFO.MEMBER_CARD_OWNER>
            <cfset attributes.exp_month = GET_CARD_INFO.MEMBER_EX_MONTH>
            <cfset attributes.exp_year = GET_CARD_INFO.MEMBER_EX_YEAR>
        </cfif>
		<cfscript>
            process_type = get_process_type.process_type;
            is_cari = get_process_type.is_cari;
            is_account = get_process_type.is_account;
            expire_month = RepeatString("0",2-Len(attributes.exp_month)) & attributes.exp_month;
            expire_year = Right(attributes.exp_year,2);
        </cfscript>
        <cfif is_account eq 1>
            <cfif len(attributes.action_from_company_id)>
                <cfset my_acc_result = get_company_period(action_from_company_id)>
            <cfelse>
                <cfset my_acc_result = get_consumer_period(attributes.cons_id)>
            </cfif>
            <cfif not len(my_acc_result)>
                <script type="text/javascript">
                    alertObject({message :"<cf_get_lang dictionary_id='49054.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>"});
                </script>
                <cfabort>
            </cfif>
        </cfif>
		<cfset payment_type_id = trim(ListGetAt(attributes.action_to_account_id,3,";"))>
        <cfquery name="GET_TAKS_METHOD" datasource="#DSN3#">
            SELECT NUMBER_OF_INSTALMENT,ACCOUNT_CODE,CARD_NO,VFT_CODE FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #payment_type_id#
        </cfquery>
        <cfif not len(GET_TAKS_METHOD.ACCOUNT_CODE)>
            <script type="text/javascript">
                alertObject({message : "<cf_get_lang dictionary_id='49056.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Secilmemiş'>"});
            </script>
            <cfabort>
        </cfif>
        <cfset vft_code = "">
        <cfif len(GET_TAKS_METHOD.VFT_CODE)>
            <cfset vft_code = GET_TAKS_METHOD.VFT_CODE>
        </cfif>
		<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#session.ep.userid#'&round(rand()*100)>
        <cfscript>
            attributes.sales_credit = filterNum(attributes.sales_credit);
            attributes.other_value_sales_credit = filterNum(attributes.other_value_sales_credit);
            form.other_value_sales_credit = filterNum(form.other_value_sales_credit);
            attributes.system_amount = filterNum(attributes.system_amount);
        </cfscript>
        <cfif isDefined("attributes.subs_inv_id")>
            <cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
                SELECT IS_COLLECTED_PROVISION FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE INVOICE_ID = #attributes.subs_inv_id# AND PERIOD_ID = #attributes.period_id#
            </cfquery>
            <cfif GET_PROV_INFO.IS_COLLECTED_PROVISION neq 0>
                <script type="text/javascript">
                    alertObject({message : "<cf_get_lang no ='416.Aynı Ödeme Planı Satırı İçin Provizyon İşlemi Yapılmıştır'>!"});
                </script>
                <cfabort>
            </cfif>
            <cfquery name="GET_PAID_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
                SELECT IS_PAID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE INVOICE_ID = #attributes.subs_inv_id# AND PERIOD_ID = #attributes.period_id# AND IS_PAID = 1
            </cfquery>
            <cfif GET_PAID_INFO.recordcount>
                <script type="text/javascript">
                    alertObject({message : "<cf_get_lang dictionary_id='54534.İlişkili fatura daha önceden tahsil edilmiştir! Tahsilat işlemi gerçekleşmeyecektir.'>"});
                </script>
                <cfabort>
            </cfif>
            <cfquery name="get_period_info" datasource="#dsn#">
                SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
            </cfquery>
            <cfset new_dsn2 = "#dsn#_#get_period_info.period_year#_#get_period_info.our_company_id#">
            <cfquery name="get_inv_wrk_id" datasource="#new_dsn2#">
                SELECT WRK_ID FROM INVOICE WHERE INVOICE_ID = #attributes.subs_inv_id#
            </cfquery>
            <cfset wrk_id_invoice = get_inv_wrk_id.wrk_id>
        <cfelse>
            <cfset wrk_id_invoice = wrk_id>	
        </cfif>
    </cfif>
</cfif>
<cf_get_lang_set module_name="bank">
<cfif not IsDefined("attributes.event")>
	<cfset attributes.event = "list">
</cfif>
<cfset process_cat = ''>
<cfset action_date = now()>
<cfif attributes.event is "add" or attributes.event is "addPos">
	<!--- 
        FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
        Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
    --->
    <cfscript>
        getCCNOKey = createObject("component", "settings.cfc.setupCcnoKey");
        getCCNOKey.dsn = dsn;
        getCCNOKey1 = getCCNOKey.getCCNOKey1();
        getCCNOKey2 = getCCNOKey.getCCNOKey2();
    </cfscript>
</cfif>
<cfif attributes.event eq 'list'>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
    <cfset process_cat = ''>
	<cfif use_https>
        <cfset url_link = https_domain>
    <cfelse>
        <cfset url_link = "">
    </cfif>
    <cf_xml_page_edit fuseact="bank.list_creditcard_revenue">
    <cfquery name="GET_BRANCH" datasource="#dsn#">
        SELECT 
            BRANCH_ID, 
            BRANCH_NAME 
        FROM 
            BRANCH 
        WHERE
            BRANCH_STATUS=1
            <cfif session.ep.isBranchAuthorization eq 1>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
        ORDER BY 
            BRANCH_NAME
    </cfquery>
    <cfquery name="GET_CREDIT_PAYMENTS" datasource="#dsn3#">
        SELECT CARD_NO, PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE ORDER BY CARD_NO
    </cfquery>
    <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
        SELECT 
            ACCOUNT_ID, 
            ACCOUNT_NAME
        FROM 
            ACCOUNTS
        WHERE
        <cfif session.ep.period_year lt 2009>
            ACCOUNT_CURRENCY_ID = 'TL'<!--- tüm pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
        <cfelse>
            ACCOUNT_CURRENCY_ID = '#session.ep.money#'
        </cfif>
        <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
            AND ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
        </cfif>
        ORDER BY 
            ACCOUNT_NAME
    </cfquery>
    
    <cfif isdefined("attributes.is_submitted")>
        <cfquery name="GET_CREDIT_MAIN" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
            WITH CTE1 AS(
            SELECT
                CREDIT_CARD_BANK_PAYMENTS.RECORD_EMP,
                CREDIT_CARD_BANK_PAYMENTS.RECORD_PAR,
                CREDIT_CARD_BANK_PAYMENTS.RECORD_CONS,
                CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE_ID,
                CREDIT_CARD_BANK_PAYMENTS.PROCESS_CAT,
                CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE,
                CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID,
                CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_DATE,
                ISNULL(CREDIT_CARD_BANK_PAYMENTS.SALES_CREDIT,0) SALES_CREDIT,
                CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID,
                CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID,
                CREDIT_CARD_BANK_PAYMENTS.FILE_IMPORT_ID,
                ISNULL(CREDIT_CARD_BANK_PAYMENTS.WRK_ID_INVOICE,CREDIT_CARD_BANK_PAYMENTS.WRK_ID) WRK_ID,
                CREDIT_CARD_BANK_PAYMENTS.ORDER_ID,
                ISNULL(CREDIT_CARD_BANK_PAYMENTS.COMMISSION_AMOUNT,0) COMMISSION_AMOUNT,
                CREDIT_CARD_BANK_PAYMENTS.OTHER_CASH_ACT_VALUE,
                CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY,
                CREDIT_CARD_BANK_PAYMENTS.PAPER_NO,
                CREDIT_CARD_BANK_PAYMENTS.REVENUE_COLLECTOR_ID,
                <cfif database_type is "MSSQL">
                    SUBSTRING(CREDIT_CARD_BANK_PAYMENTS.ACTION_DETAIL,1,50) ACTION_DETAIL,
                <cfelseif database_type is "DB2">
                    SUBSTR(CREDIT_CARD_BANK_PAYMENTS.ACTION_DETAIL,1,50) ACTION_DETAIL,
                </cfif>
                CREDITCARD_PAYMENT_TYPE.CARD_NO,
                CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID AS ACCOUNT_ID,
                CREDIT_CARD_BANK_PAYMENTS.IS_ONLINE_POS,
                ISNULL(CREDIT_CARD_BANK_PAYMENTS.IS_VOID,0) IS_VOID,
                C.NICKNAME, 
                C.MEMBER_CODE AS COMPANY_MEMBER_CODE,
                CN.CONSUMER_NAME,
                CN.CONSUMER_SURNAME, 
                CN.MEMBER_CODE AS CONSUMER_MEMBER_CODE,
                O.ORDER_NUMBER
                <cfif xml_show_record_emp_info eq 1>
                    ,E.EMPLOYEE_NAME
                    ,E.EMPLOYEE_SURNAME
                    ,CP.COMPANY_PARTNER_NAME
                    ,CP.COMPANY_PARTNER_SURNAME
                    ,CONS.CONSUMER_NAME AS CONS_CONSUMER_NAME
                    ,CONS.CONSUMER_SURNAME AS CONS_CONSUMER_SURNAME
                </cfif>
                ,AC.ACCOUNT_NAME,
                CREDIT_CARD_BANK_PAYMENTS.MULTI_ACTION_ID,
                SPC.PROCESS_CAT PROCESS_CAT_NAME,
                SPC.PROCESS_TYPE
            FROM
                CREDIT_CARD_BANK_PAYMENTS WITH (NOLOCK) 
                    LEFT JOIN #DSN_ALIAS#.COMPANY C ON C.COMPANY_ID = CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID
                    LEFT JOIN #DSN_ALIAS#.CONSUMER CN ON CN.CONSUMER_ID = CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID 
                    LEFT JOIN #DSN3_ALIAS#.ORDERS O ON O.ORDER_ID = CREDIT_CARD_BANK_PAYMENTS.ORDER_ID         
                    <cfif xml_show_record_emp_info eq 1>
                        LEFT JOIN #DSN_ALIAS#.EMPLOYEES E ON E.EMPLOYEE_ID = CREDIT_CARD_BANK_PAYMENTS.RECORD_EMP
                        LEFT JOIN #DSN_ALIAS#.COMPANY_PARTNER CP ON CP.PARTNER_ID = CREDIT_CARD_BANK_PAYMENTS.RECORD_PAR
                        LEFT JOIN #DSN_ALIAS#.CONSUMER CONS ON CONS.CONSUMER_ID = CREDIT_CARD_BANK_PAYMENTS.RECORD_CONS   
                    </cfif>	
                    LEFT JOIN #DSN3_ALIAS#.ACCOUNTS AC ON AC.ACCOUNT_ID = CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID
                    LEFT JOIN #DSN3_ALIAS#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = CREDIT_CARD_BANK_PAYMENTS.PROCESS_CAT
                ,CREDITCARD_PAYMENT_TYPE
            WHERE
                CREDIT_CARD_BANK_PAYMENTS.PAYMENT_TYPE_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID AND
                CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_ID IS NULL
                <cfif Len(attributes.record_member_name) and Len(attributes.record_member_id)>
                    <cfif attributes.record_member_type is 'employee'>
                        AND CREDIT_CARD_BANK_PAYMENTS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_member_id#">
                    <cfelseif attributes.record_member_type is 'partner'>
                        AND CREDIT_CARD_BANK_PAYMENTS.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_member_id#">
                    <cfelseif attributes.record_member_type is 'consumer'>
                        AND CREDIT_CARD_BANK_PAYMENTS.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_member_id#">
                    </cfif>
                </cfif>
                <cfif len(attributes.keyword)>
                    AND
                    (
                        CREDITCARD_PAYMENT_TYPE.CARD_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        OR ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        OR ISNULL(CREDIT_CARD_BANK_PAYMENTS.WRK_ID_INVOICE,CREDIT_CARD_BANK_PAYMENTS.WRK_ID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                        OR PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                        OR CREDIT_CARD_BANK_PAYMENTS.ORDER_ID = (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS WHERE ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)<!--- partner dan yapılan sipariş ödemeleri için --->
                    )
                </cfif>
                <cfif len(attributes.start_date)>AND CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
                <cfif len(attributes.finish_date)>AND CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.finish_date)#"></cfif>
                <cfif len(attributes.credit_payment_type)>AND CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_payment_type#"></cfif>
                <cfif len(attributes.bank_account)>AND CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_account#"></cfif>
                <cfif len(attributes.company_id) and len(attributes.member_name)>
                    AND CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                <cfelseif len(attributes.cons_id) and len(attributes.member_name)>
                    AND CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">
                </cfif>
                <cfif len(attributes.order_info) and attributes.order_info eq 1>
                    AND CREDIT_CARD_BANK_PAYMENTS.ORDER_ID IS NOT NULL
                </cfif>
                <cfif len(attributes.order_info) and attributes.order_info eq 0>
                    AND CREDIT_CARD_BANK_PAYMENTS.ORDER_ID IS NULL
                </cfif>
                <cfif len(attributes.order_info) and attributes.order_info eq 2>
                    AND CREDIT_CARD_BANK_PAYMENTS.CAMPAIGN_ID IS NOT NULL
                </cfif>
                <cfif len(attributes.order_info) and attributes.order_info eq 3>
                    AND CREDIT_CARD_BANK_PAYMENTS.CAMPAIGN_ID IS NULL
                </cfif>
                <cfif (listgetat(attributes.fuseaction,1,'.') is 'store') or (isdefined('attributes.branch_id') and len(attributes.branch_id))>
                    AND CREDIT_CARD_BANK_PAYMENTS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#">
                </cfif>
                <cfif len(attributes.cc_action_type)>
                    <cfif listlen(attributes.cc_action_type,'-') eq 1 or (listlen(attributes.cc_action_type,'-') gt 1 and listlast(attributes.cc_action_type,'-') eq 0)>
                        AND CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE_ID = #listfirst(attributes.cc_action_type,'-')#
                    <cfelse>
                        AND CREDIT_CARD_BANK_PAYMENTS.PROCESS_CAT = #listlast(attributes.cc_action_type,'-')#
                    </cfif>
                </cfif>
                <cfif len(attributes.revenue_collector_id) and len(attributes.revenue_collector)>
                    AND CREDIT_CARD_BANK_PAYMENTS.REVENUE_COLLECTOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.revenue_collector_id#">
                </cfif>
                <cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
                    AND CREDIT_CARD_BANK_PAYMENTS.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
                <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
                    AND CREDIT_CARD_BANK_PAYMENTS.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
                <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
                    AND CREDIT_CARD_BANK_PAYMENTS.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
                </cfif>
            
             ),
             CTE2 AS (
                    SELECT
                        CTE1.*,
                            ROW_NUMBER() OVER (ORDER BY
                                        <cfif attributes.bank_action_date eq 1>
                                            STORE_REPORT_DATE,
                                        <cfelseif attributes.bank_action_date eq 2>
                                            STORE_REPORT_DATE DESC,
                                        </cfif>
                                        CREDITCARD_PAYMENT_ID DESC
                        ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    ISNULL(( SELECT SUM(SALES_CREDIT) FROM CTE2 WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1) AND ACTION_TYPE_ID IN(52,69,241,2410) ),0) SUM_SALES_CREDIT,
                    ISNULL(( SELECT SUM(COMMISSION_AMOUNT) FROM CTE2 WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1) AND ACTION_TYPE_ID IN(52,69,241,2410) ),0) SUM_COMMISSION_AMOUNT,
                    ISNULL(( SELECT SUM(SALES_CREDIT) FROM CTE2 WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1) AND ACTION_TYPE_ID = 245 ),0) SUM_SALES_CREDIT_IPTAL,
                    ISNULL(( SELECT SUM(COMMISSION_AMOUNT) FROM CTE2 WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1) AND ACTION_TYPE_ID = 245 ),0) SUM_COMMISSION_AMOUNT_IPTAL,
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
        </cfquery>
    </cfif>
    <script type="text/javascript">
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
			formName = 'search_form',
			form = $('form[name="'+ formName +'"]');
		});
        function kontrol()
		{
			if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			return true;
		}
        
        function control_update(cc_paymnt_id)
        {
            var get_inv_number = wrk_safe_query("bnk_get_inv_number",'dsn2',0,cc_paymnt_id);
			alertObject({message: "<cf_get_lang no ='350.Bu İşlemi İlgili Olduğu'>" + get_inv_number.INVOICE_NUMBER +"<cf_get_lang no ='354.Nolu Perakende Faturasından Güncelleyebilirsiniz'>!"});
            return false;
        }
        function control_update_2(cc_paymnt_id)
        {
            var get_ord_number = wrk_safe_query('bnk_get_ord_number','dsn3',0,cc_paymnt_id);
            if(get_ord_number.recordcount >0)
				alertObject({message: "<cf_get_lang no ='350.Bu İşlemi İlgili Olduğu'>" + get_ord_number.ORDER_NUMBER +" <cf_get_lang no ='353.Nolu Siparişin Ödeme Planından Güncelleyebilirsiniz'>!"});
            else
            {
                var get_ord_number_1 = wrk_safe_query('bnk_get_ord_number_p','dsn3',0,cc_paymnt_id);
				alertObject({message: "<cf_get_lang no ='350.Bu İşlemi İlgili Olduğu'>" + get_ord_number_1.PAPER_NO +"<cf_get_lang no ='352.Nolu Senet Tahsilat İşleminden Güncelleyebilirsiniz'> !"});
            }
            return false;
        }
        function control_update_4(cc_paymnt_id)
        {
            var get_inv_number = wrk_safe_query("bnk_get_inv_number",'dsn2',0,cc_paymnt_id);
			alertObject({message: "<cf_get_lang no ='350.Bu İşlemi İlgili Olduğu'>" + get_inv_number.INVOICE_NUMBER +"<cf_get_lang no ='351.Nolu Z Raporundan Güncelleyebilirsiniz'> !"});
            return false;
        }
    </script>
<cfelseif IsDefined("attributes.event")>
	<cfset controlStatus = 1>
    <cfset isUpd = 0>
    <cfset isActive = 1>
    <cfset cancelId = ''>
    <cfset toBranchId = ''>
    <cfset isDefault = 1>
    <cfset dueStartDate = now()>
    <cfset revenueCollectorId = session.ep.userid>
    <cfset revenueCollector = get_emp_info(session.ep.userid,0,0)>
    <cfif (attributes.event is "add" and isdefined('attributes.payment_id') and len(attributes.payment_id)) or attributes.event is 'upd'>
        <cfquery name="GET_PAYMENT" datasource="#DSN3#">
            SELECT 
                CCBP.CREDITCARD_PAYMENT_ID,
                CCBP.PAYMENT_TYPE_ID,
                CCBP.STORE_REPORT_DATE,
                CCBP.DUE_START_DATE,
                CCBP.SALES_CREDIT,
                CCBP.CARD_NO,
                CCBP.OTHER_MONEY,
                CCBP.OTHER_CASH_ACT_VALUE,
                CCBP.ACTION_DETAIL,
                CCBP.ACTION_FROM_COMPANY_ID,
                CCBP.ACTION_TYPE,
                CCBP.PROCESS_CAT,
                CCBP.ACTION_TYPE_ID,
                CCBP.PARTNER_ID,
                CCBP.CONSUMER_ID,
                CCBP.ORDER_ID,
                CCBP.IS_ONLINE_POS,
                CCBP.CARD_OWNER,
                CCBP.ACTION_PERIOD_ID,
                CCBP.CARI_ACTION_ID,
                CCBP.CARI_ACTION_VALUE,
                CCBP.PROJECT_ID,
                CCBP.PAPER_NO,
                CCBP.UPD_STATUS,
                CCBP.TO_BRANCH_ID,
                CCBP.ASSETP_ID,
                CCBP.SPECIAL_DEFINITION_ID,
                CCBP.RECORD_CONS,
                CCBP.RECORD_PAR,
                CCBP.RECORD_EMP,
                CCBP.RECORD_DATE,
                CCBP.UPDATE_DATE,
                CCBP.UPDATE_EMP,
                CCBP.REVENUE_COLLECTOR_ID,
                CCBP.IS_VOID,
                CCBP.RELATION_CREDITCARD_PAYMENT_ID,
                CCBP.CANCEL_TYPE_ID,
                CCBP.WRK_ID_INVOICE AS WRK_ID,
                CCBP.PROCESS_STAGE,
                PRO_PROJECTS.PROJECT_HEAD
            FROM 
                CREDIT_CARD_BANK_PAYMENTS CCBP WITH (NOLOCK) 
                LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = CCBP.PROJECT_ID
            WHERE 
                CREDITCARD_PAYMENT_ID = <cfif attributes.event is "add">
                							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_id#">
										<cfelseif attributes.event is "upd">
                                        	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                                        </cfif>
        </cfquery>
    </cfif>
	<cfif attributes.event is 'upd'> 
        <cf_xml_page_edit fuseact="bank.popup_add_creditcard_revenue">
        <cfparam name="attributes.comp_name" default="">
        <cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
        <cfset controlStatus = 0>
        <cfset isUpd = 1>
        <cfset isActive = 0>
        <cfset action_date = get_payment.store_report_date>
        <cfset process_cat = get_payment.process_cat>
        <cfset cancelId = get_payment.cancel_type_id>
        <cfset toBranchId = get_payment.to_branch_id>
        <cfset paper_num = get_payment.paper_no>
		<cfif len(toBranchId)>
            <cfset isDefault = 0>
        </cfif>
        <cfset cons_id = get_payment.consumer_id>
        <cfset comp_id = get_payment.action_from_company_id>
        <cfif len(cons_id)>
        	<cfset member_name = get_cons_info(cons_id,0,0)>
        </cfif>
        <cfif len(comp_id)>
        	<cfset member_name = get_par_info(comp_id,1,0,0)>
        </cfif>
        <cfif len(get_payment.due_start_date)>
        	<cfset dueStartDate = get_payment.due_start_date>
        <cfelse>
        	<cfset dueStartDate = get_payment.store_report_date>
        </cfif>
        <cfset paperNo = get_payment.paper_no>
		<cfif isdefined("attributes.is_from_payroll")>
        	<cfset totalAmount = attributes.total_amount>
        <cfelseif len(get_payment.cari_action_value)>
        	<cfset totalAmount = get_payment.sales_credit-get_payment.cari_action_value>
        <cfelse>
        	<cfset totalAmount = get_payment.sales_credit>
        </cfif>
        <cfset newSalesCredit = get_payment.sales_credit>
		<cfset revenueCollectorId = get_payment.revenue_collector_id>
        <cfset revenueCollector = get_emp_info(get_payment.revenue_collector_id,0,0)>
        <cfquery name="GET_CC_PAY_ROWS" datasource="#dsn3#">
            SELECT BANK_ACTION_DATE FROM CREDIT_CARD_BANK_PAYMENTS_ROWS WITH (NOLOCK) WHERE CREDITCARD_PAYMENT_ID = #attributes.id#
        </cfquery>
        <cfquery name="CONTROL" datasource="#dsn3#" maxrows="1">
            SELECT BANK_ACTION_ID FROM CREDIT_CARD_BANK_PAYMENTS_ROWS WITH (NOLOCK) WHERE CREDITCARD_PAYMENT_ID = #attributes.id# AND BANK_ACTION_ID IS NOT NULL
        </cfquery>
		<cfif len(get_payment.order_id)><!---Siparişten yapılmış tahsilatsa--->
            <cfquery name="GET_ORDER_INFO" datasource="#dsn3#">
                SELECT ORDER_NUMBER,IS_ENDUSER_PRICE,PURCHASE_SALES FROM ORDERS WHERE ORDER_ID = #GET_PAYMENT.ORDER_ID#
            </cfquery>
            <cfsavecontent variable="extra_">
                <cfif len(get_order_info.order_number)>
                	<cf_get_lang_main no='799.Sipariş No'>: 
					<cfoutput>
                        <cfif GET_ORDER_INFO.PURCHASE_SALES eq 0>
                            <a onclick="javascript://" target="_blank" class="tableyazi" href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#GET_PAYMENT.ORDER_ID#">#get_order_info.order_number#</a>
                        <cfelse>
                            <a onclick="javascript://" target="_blank" class="tableyazi" href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#GET_PAYMENT.ORDER_ID#">#get_order_info.order_number#</a>
                        </cfif>
                    </cfoutput>
                </cfif>
                <cfif get_order_info.is_enduser_price eq 1><cf_get_lang no ='275.Son Kullanıcı Fiyatı ile İşlem Yapılmıştır'>!</cfif>
            </cfsavecontent>
		</cfif>
	<cfelseif  attributes.event eq 'add'>
		<cf_xml_page_edit fuseact="bank.popup_add_creditcard_revenue">
        <cfparam name="attributes.active_period" default="">
		<cfif isdefined('attributes.payment_id') and len(attributes.payment_id)>
            <cfif isdefined("attributes.total_amount")>
            	<cfset totalAmount = attributes.total_amount>
            <cfelse>
            	<cfset totalAmount = 0>
            </cfif>
            <cfquery name="getPaymentAmount" datasource="#dsn3#"><!--- iade isleminde toplam odenen tutar --->
                SELECT ISNULL(SUM(SALES_CREDIT),0) AS PAYMENT_AMOUNT FROM CREDIT_CARD_BANK_PAYMENTS WHERE RELATION_CREDITCARD_PAYMENT_ID = #attributes.payment_id#
            </cfquery>
            <cfset totalAmount = totalAmount - getPaymentAmount.PAYMENT_AMOUNT>
            <cfset newSalesCredit = get_payment.sales_credit - getPaymentAmount.PAYMENT_AMOUNT>>
			<cfset attributes.consumer_id = get_payment.consumer_id>
            <cfset attributes.company_id = get_payment.action_from_company_id>
            <cfset toBranchId = get_payment.to_branch_id>
            <cfif len(toBranchId)>
            	<cfset isDefault = 0>
            </cfif>
            <cfif len(get_payment.cari_action_value)>
                <cfset attributes.total_amount = get_payment.sales_credit-get_payment.cari_action_value>
            <cfelse>
                <cfset attributes.total_amount = get_payment.sales_credit>
            </cfif>
            <cfquery name="getProcessCat" datasource="#dsn3#">
                SELECT TOP 1 PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 245
            </cfquery>
            <cfset process_cat = getProcessCat.PROCESS_CAT_ID>
            <cfif len(get_payment.paper_no)>
                <cfset get_payment.action_detail = "#get_payment.paper_no# nolu Kredi Kartı Tahsilatı İade/İptal İşlemi">
            <cfelse>
                <cfset get_payment.action_detail = "#attributes.payment_id# nolu Kredi Kartı Tahsilatı İade/İptal İşlemi">
            </cfif>
            <cfset header_ = "#lang_array_main.item [424]# (Sanal Pos)">
            
			<cfif len(GET_PAYMENT.CARD_NO)>
				<cfif len(attributes.company_id)>
                    <cfset key_type = attributes.company_id>
                <cfelse>
                    <cfset key_type = attributes.consumer_id>
                </cfif>
                <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
                <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                    <!--- anahtarlar decode ediliyor --->
                    <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                    <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                    <!--- kart no encode ediliyor --->
                    <cfset card_no_ = contentEncryptingandDecodingAES(isEncode:0,content:get_payment.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                    <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_payment.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                    <cfset relation_card_no_ = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                <cfelse>
                    <cfset card_no_ = Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex")>
                    <cfset relation_card_no_ = '#mid(Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex")))#'>
                </cfif>
            </cfif>
        <cfelse>
            <cfset get_payment.PAYMENT_TYPE_ID = "">
            <cfset get_payment.to_branch_id = "">
            <cfset get_payment.special_definition_id = "">
            <cfset attributes.consumer_id = "">
            <cfset attributes.company_id = "">
            <cfset get_payment.project_id = "">
            <cfset get_payment.project_head = "">
            <cfset get_payment.assetp_id = "">
            <cfset GET_PAYMENT.CARD_NO = "">
            <cfset get_payment.CREDITCARD_PAYMENT_ID = "">
            <cfset get_payment.card_owner = "">
            <cfset get_payment.other_cash_act_value = "">
            <cfset get_payment.sales_credit = "">
            <cfset get_payment.action_detail = "">
            <cfset process_cat = "">
            <cfset header_ = "#lang_array_main.item [424]#">
            <cfif isdefined("attributes.total_amount")>
            	<cfset totalAmount = attributes.total_amount>
            <cfelse>
            	<cfset totalAmount = ''>
            </cfif>
            <cfset newSalesCredit = get_payment.sales_credit>
 		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			<cfset cons_id = attributes.consumer_id>
            <cfset comp_id = ''>
            <cfset member_name = get_cons_info(attributes.consumer_id,0,0)>
        <cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfset comp_id = attributes.company_id>
            <cfset cons_id = ''>
            <cfset member_name = get_par_info(attributes.company_id,1,0,0)>
        <cfelse>
			<cfset comp_id = ''>
            <cfset cons_id = ''>
            <cfset member_name =''>
        </cfif>
    <cfelseif attributes.event is "addPos">
        <cf_xml_page_edit fuseact="bank.popup_add_online_pos">
        <cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
            SELECT
                ACCOUNTS.ACCOUNT_ID,
                ACCOUNTS.ACCOUNT_NAME,
                <cfif session.ep.period_year lt 2009>
                    CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
                <cfelse>
                    ACCOUNTS.ACCOUNT_CURRENCY_ID,
                </cfif>
                CPT.PAYMENT_TYPE_ID,
                CPT.CARD_NO,
                CPT.PAYMENT_RATE,
                CPT.NUMBER_OF_INSTALMENT,
                OCPR.POS_ID POS_TYPE,
                OCPR.POS_TYPE POS_TYPE_ <!--- sanal pos tipi --->
            FROM
                ACCOUNTS ACCOUNTS,
                CREDITCARD_PAYMENT_TYPE CPT,
                #dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
            WHERE
                <cfif session.ep.period_year lt 2009>
                    ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL' AND<!--- toplu pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
                <cfelse>
                    ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#' AND
                </cfif>
                ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
                OCPR.POS_ID = CPT.POS_TYPE AND
                CPT.IS_ACTIVE = 1 AND
                CPT.POS_TYPE IS NOT NULL<!---Sanal pos tipleri bilgisi--->
            <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
                AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
            </cfif>
            UNION ALL
            SELECT
                0 AS ACCOUNT_ID,
                OCPR.POS_NAME AS ACCOUNT_NAME,
                '#session.ep.money#' AS ACCOUNT_CURRENCY_ID,
                CPT.PAYMENT_TYPE_ID,
                CPT.CARD_NO,
                CPT.PAYMENT_RATE,
                CPT.NUMBER_OF_INSTALMENT,
                OCPR.POS_ID POS_TYPE,
                OCPR.POS_TYPE POS_TYPE_ <!--- sanal pos tipi --->
            FROM
                CREDITCARD_PAYMENT_TYPE CPT,
                #dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
            WHERE
                OCPR.POS_ID = CPT.POS_TYPE AND
                CPT.IS_ACTIVE = 1 AND
                CPT.COMPANY_ID IS NOT NULL AND
                CPT.POS_TYPE IS NOT NULL
            ORDER BY
                ACCOUNTS.ACCOUNT_NAME
        </cfquery>
        <cfquery name="get_bank_type" datasource="#dsn#">
            SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
        </cfquery>
        <!--- provizyon ekranlarından sanal pos ekranına geçiş durumları içindir --->
        <cfif isDefined("attributes.member_type") and attributes.member_type eq "0"><!--- company --->
            <cfquery name="GET_COMP_INFO" datasource="#dsn#">
                SELECT NICKNAME,MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #attributes.member_id#
            </cfquery>
            <cfset comp_id = attributes.member_id>
            <cfset par_id = GET_COMP_INFO.MANAGER_PARTNER_ID>
            <cfset cons_id = "">
            <cfset member_name = GET_COMP_INFO.NICKNAME>
            <cfset main_act_value = attributes.action_value>
            <cfif IsDefined("attributes.card_id_info") and len(attributes.card_id_info)>
                <cfquery name="GET_CARD_INFO" datasource="#dsn#"><!--- 2 query birleştirilmedi çünkü kart bilgilrinde bideğişiklik olabilir,üye bilgilerini etkilemesin --->
                    SELECT COMPANY_CC_NUMBER,COMPANY_BANK_TYPE,COMPANY_CARD_OWNER,COMPANY_EX_MONTH,COMPANY_EX_YEAR,COMP_CVS FROM COMPANY_CC WHERE COMPANY_CC_ID = #attributes.card_id_info#
                </cfquery>
                <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
                <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                    <!--- anahtarlar decode ediliyor --->
                    <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                    <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                    <!--- kart no encode ediliyor --->
                    <cfset cc_number = contentEncryptingandDecodingAES(isEncode:0,content:GET_CARD_INFO.COMPANY_CC_NUMBER,accountKey:comp_id,key1:ccno_key1,key2:ccno_key2) />
                <cfelse>
                    <cfset cc_number = Decrypt(GET_CARD_INFO.COMPANY_CC_NUMBER,comp_id,"CFMX_COMPAT","Hex")>
                </cfif>
                <cfset c_bank_type = GET_CARD_INFO.COMPANY_BANK_TYPE>
                <cfset cc_owner = GET_CARD_INFO.COMPANY_CARD_OWNER>
                <cfset c_ex_m = GET_CARD_INFO.COMPANY_EX_MONTH>
                <cfset c_ex_y = GET_CARD_INFO.COMPANY_EX_YEAR>
                <cfset c_cvs = GET_CARD_INFO.COMP_CVS>
            <cfelse>
                <cfset cc_number = "">
                <cfset c_bank_type = "">
                <cfset cc_owner = "">
                <cfset c_ex_m = "">
                <cfset c_ex_y = dateFormat(now(),'yyyy')>
                <cfset c_cvs = "">
            </cfif>
            <cfif x_readonly_info eq 1>
                <cfset readonly_info ="yes">
            <cfelse>
                <cfset readonly_info ="no">
            </cfif>
        <cfelseif isDefined("attributes.member_type") and attributes.member_type eq "1">
            <cfquery name="GET_COMP_INFO" datasource="#dsn#">
                SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.member_id#
            </cfquery>
            <cfset comp_id = "">
            <cfset par_id = "">
            <cfset cons_id = attributes.member_id>
            <cfset member_name = GET_COMP_INFO.CONSUMER_NAME & " " & GET_COMP_INFO.CONSUMER_SURNAME>
            <cfset main_act_value = attributes.action_value>
            <cfif len(attributes.card_id_info)>
                <cfquery name="GET_CARD_INFO" datasource="#dsn#"><!--- 2 query birleştirilmedi çünkü kart bilgilrinde bideğişiklik olabilir,üye bilgilerini etkilemesin --->
                    SELECT CONSUMER_CC_NUMBER,CONSUMER_BANK_TYPE,CONSUMER_CARD_OWNER,CONSUMER_EX_MONTH,CONSUMER_EX_YEAR,CONS_CVS FROM CONSUMER_CC WHERE CONSUMER_CC_ID = #attributes.card_id_info#
                </cfquery>
                <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
                <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                    <!--- anahtarlar decode ediliyor --->
                    <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                    <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                    <!--- kart no encode ediliyor --->
                    <cfset cc_number = contentEncryptingandDecodingAES(isEncode:0,content:GET_CARD_INFO.CONSUMER_CC_NUMBER,accountKey:cons_id,key1:ccno_key1,key2:ccno_key2) />
                <cfelse>
                    <cfset cc_number = Decrypt(GET_CARD_INFO.CONSUMER_CC_NUMBER,cons_id,"CFMX_COMPAT","Hex")>
                </cfif>
                <cfset c_bank_type = GET_CARD_INFO.CONSUMER_BANK_TYPE>
                <cfset cc_owner = GET_CARD_INFO.CONSUMER_CARD_OWNER>
                <cfset c_ex_m = GET_CARD_INFO.CONSUMER_EX_MONTH>
                <cfset c_ex_y = GET_CARD_INFO.CONSUMER_EX_YEAR>
                <cfset c_cvs = GET_CARD_INFO.CONS_CVS>
            <cfelse>
                <cfset cc_number = "">
                <cfset c_bank_type = "">
                <cfset cc_owner = "">
                <cfset c_ex_m = "">
                <cfset c_ex_y = dateFormat(now(),'yyyy')>
                <cfset c_cvs = "">
            </cfif>
            <cfif x_readonly_info eq 1>
                <cfset readonly_info ="yes">
            <cfelse>
                <cfset readonly_info ="no">
            </cfif>
        <cfelse>
            <cfset comp_id = "">
            <cfset par_id = "">
            <cfset cons_id = "">
            <cfset member_name = "">
            <cfset cc_number = "">
            <cfset c_bank_type = "">
            <cfset cc_owner = "">
            <cfset c_ex_m = "">
            <cfset c_ex_y = dateFormat(now(),'yyyy')>
            <cfset c_cvs = "">
            <cfset main_act_value = "">
            <cfset readonly_info ="no">
        </cfif>
		<cfif isdefined('attributes.invoice_id') and len(attributes.invoice_id)>
            <cfquery name="get_invoice_payment_id" datasource="#dsn2#">
                SELECT ISNULL(CREDITCARD_PAYMENT_ID,0) CREDITCARD_PAYMENT_ID FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
            </cfquery>
        </cfif>
    <cfelseif attributes.event is "addmulti" or attributes.event is "updmulti">
        <cf_papers paper_type="creditcard_revenue">
        <cfset select_input = 'account_id'>
        <cfset to_branch_id = ''>
        <cfset process_cat = ''>
        <cfset recordNum = 0>
        <cfparam name="attributes.money_type_control" default="">
        <cfparam name="attributes.currency_id_info" default="">
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT
                MONEY,
                RATE2,
                RATE1,
                0 AS IS_SELECTED
            FROM
                SETUP_MONEY
            WHERE
                PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
                MONEY_STATUS = 1
                <cfif isDefined('attributes.money') and len(attributes.money)>
                    AND MONEY_ID = #attributes.money#
                </cfif>
            ORDER BY 
                MONEY_ID
        </cfquery>
            <cfif attributes.event eq 'updmulti'>
                <cfquery name="get_payment" datasource="#dsn3#">
                    SELECT
                        CBPM.ACTION_TYPE_ID,
                        CBPM.ACTION_DATE,
                        CBPM.PROCESS_CAT,
                        CBPM.ACC_BRANCH_ID,
                        CBPM.RECORD_DATE,
                        CBPM.RECORD_EMP,
                        CBPM.UPDATE_DATE,
                        CBPM.UPDATE_EMP,
                        CBPM.ACTION_PERIOD_ID,
                        CBPM.PROCESS_STAGE,
                        CBP.*
                    FROM
                        CREDIT_CARD_BANK_PAYMENTS_MULTI CBPM
                        LEFT JOIN CREDIT_CARD_BANK_PAYMENTS CBP ON CBPM.MULTI_ACTION_ID = CBP.MULTI_ACTION_ID 
                        LEFT JOIN CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID=CBP.PAYMENT_TYPE_ID
                        LEFT JOIN ACCOUNTS ON ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT 
                    WHERE
                        CBPM.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#">
                </cfquery>
                <cfif not get_payment.recordcount>
                    <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
                    <cfexit method="exittemplate">
                </cfif>
                <cfquery name="get_money" datasource="#dsn3#">
                    SELECT MONEY_TYPE MONEY,ACTION_ID,RATE2,RATE1,IS_SELECTED FROM CREDIT_CARD_BANK_PAYMENTS_MULTI_MONEY WHERE ACTION_ID = #get_payment.multi_action_id#
                </cfquery>
                <cfset action_date = get_payment.action_date>
                <cfset process_cat = get_payment.process_cat>
                <cfset to_branch_id = get_payment.acc_branch_id>
                <cfset recordNum = get_payment.recordcount>
            </cfif>
            <cfquery name="GET_SPECIAL_DEFINITION" datasource="#dsn#">
                SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1
            </cfquery>
            <cfquery name="getCreditCards" datasource="#dsn3#">
                SELECT
                    ACCOUNTS.ACCOUNT_ID,
                    ACCOUNTS.ACCOUNT_NAME,
                    ACCOUNTS.ACCOUNT_CURRENCY_ID,
                    ACCOUNTS.ACCOUNT_ACC_CODE,
                    PAYMENT_RATE,
                    PAYMENT_RATE_ACC,
                    CPT.PAYMENT_TYPE_ID,
                    CPT.CARD_NO
                FROM
                    ACCOUNTS ACCOUNTS WITH (NOLOCK),
                    CREDITCARD_PAYMENT_TYPE CPT WITH (NOLOCK)
                WHERE
                    ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"> AND
                    ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT
                    AND CPT.IS_ACTIVE = 1
                    AND ACCOUNT_STATUS = 1
                UNION ALL
                    SELECT
                        0 AS ACCOUNT_ID,
                        '' AS ACCOUNT_NAME,
                        '#session.ep.money#' AS ACCOUNT_CURRENCY_ID,
                        '' AS ACCOUNT_ACC_CODE,
                        PAYMENT_RATE,
                        PAYMENT_RATE_ACC,
                        CPT.PAYMENT_TYPE_ID,
                        CPT.CARD_NO
                    FROM
                        CREDITCARD_PAYMENT_TYPE CPT WITH (NOLOCK)
                    WHERE
                        CPT.COMPANY_ID IS NOT NULL 
                        AND CPT.IS_ACTIVE = 1
                ORDER BY
                    ACCOUNTS.ACCOUNT_NAME
            </cfquery>
	</cfif>
</cfif>
<cfif attributes.event is "add" or attributes.event is "upd">
	<script type="text/javascript">
        $(document).ready(function(){
            kur_ekle_f_hesapla('account_id');
			$('#process_cat').change(function(){
				if($('#process_cat').val() != '')
					cancel_type_();	
			});
			formName = 'cc_revenue',
			form = $('form[name="'+ formName +'"]');
        });
        function change_comm_value()
        {
            if(form.find('input#payment_rate_acc').val() != "" && form.find('input#payment_rate').val() && form.find('input#payment_rate').val() != 0 && form.find('input#sales_credit_comm').val() != "" && form.find('input#currency_idpayment_rate_acc').val() != "")
                form.find('input#sales_credit').val(commaSplit(parseFloat(filterNum(form.find('input#sales_credit_comm').val())) + (parseFloat(filterNum(form.find('input#sales_credit_comm').val())) * (parseFloat(form.find('input#payment_rate').val())/100))));
            else
                form.find('input#sales_credit').val(form.find('input#sales_credit_comm').val());
        }
        function cancel_type_()
        {
            if(form.find('div#item-setup_cancel_type') != undefined)
            {
                if (form.find('select#process_cat').val() != '' && form.find('input#ct_process_type_'+ form.find('select#process_cat').val()).val() == 245)
					form.find('div#item-setup_cancel_type').show();
                else
					form.find('div#item-setup_cancel_type').hide();
            }
        }
        <cfif attributes.event is "upd">
            function del_kontrol()
            {
                control_account_process(<cfoutput>'#attributes.id#','#get_payment.action_type_id#'</cfoutput>);
                if(!chk_period(document.cc_revenue.action_date, 'İşlem')) return false;
                return true;
            }
        </cfif>
        function kontrol()
        {
            <cfif attributes.event is "add">
                //if(!paper_control(cc_revenue.paper_number,'CREDITCARD_REVENUE','1','','','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
            <cfelseif attributes.event is "upd">
                control_account_process(<cfoutput>'#attributes.id#','#get_payment.action_type_id#'</cfoutput>);
                //if(!paper_control(cc_revenue.paper_number,'CREDITCARD_REVENUE','1',<cfoutput>'#attributes.id#','#get_payment.paper_no#'</cfoutput>,'','','','<cfoutput>#dsn3#</cfoutput>')) return false;
            </cfif>
            if(!chk_process_cat('cc_revenue')) return false;
            if(!check_display_files('cc_revenue')) return false;
            if(!chk_period(document.cc_revenue.action_date, 'İşlem')) return false;
            if(!acc_control()) return false;
            kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
            <cfif attributes.event is "add">
                <cfif isdefined("attributes.payment_id") and len(attributes.payment_id)>
                    x = parseFloat(filterNum(form.find('input#sales_credit').val()));
                    y = parseFloat(filterNum(form.find('input#new_sales_credit').val()));
                    if(x > y)
                    {
						alertObject({message: "Toplam tutar " +form.find('input#new_sales_credit').val()+ " den büyük olamaz !"});
                        return false;
                    }
                </cfif>
                var get_paper_no = wrk_safe_query('bnk_get_paper_no_pymnt','dsn3',0,document.cc_revenue.paper_number.value);
            <cfelseif attributes.event is "upd">
                var listParam = document.cc_revenue.id.value + "*" + document.cc_revenue.paper_number.value;
                var get_paper_no = wrk_safe_query("bnk_get_paper_no",'dsn3',0,listParam);
            </cfif>
            if(get_paper_no.recordcount)
            {
				alertObject({message: "<cf_get_lang no='348.Girdiğiniz Belge Numarası Kullanılmaktadır'> !"});
                return false;
            }
            if(form.find("div#item-setup_cancel_type").css('display') != 'none')
            {
                if(form.find('select#cancel_type_id').val() == "" && form.find('input#ct_process_type_'+ form.find('select#process_cat').val()).val() == 245)
                {
					validateMessage('notValid',form.find('select#cancel_type_id') );
                    return false;
                }
				else
					validateMessage('valid', form.find('select#expense_item_name') );
            }
            return true;
        }
    </script>
<cfelseif attributes.event is "addPos">
	<script type="text/javascript">
		$(document).ready(function(){
			kur_ekle_f_hesapla('action_to_account_id');
			<cfif use_https>
				window.defaultStatus="<cf_get_lang no ='362.Bu sayfada SSL Kullanılmaktadır'>."
			</cfif>
			formName = 'add_online_pos',
			form = $('form[name="'+ formName +'"]');
		});
        function get_member_card()
        {
            <cfif x_select_credit_card eq 1>
                if(form.find('input#member_card_id').val() != undefined && (form.find('input#comp_name').val() != ''&& (form.find('input#action_from_company_id').val() != '' || form.find('input#cons_id').val()))
                {
                    if(form.find('input#action_from_company_id').val() != '')
                        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=bank.emptypopup_get_credit_card&x_select_active_cards=#x_select_active_cards#</cfoutput>&company_id='+document.getElementById('action_from_company_id').value ,'bank_list',1);	
                    else
                        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=bank.emptypopup_get_credit_card&x_select_active_cards=#x_select_active_cards#</cfoutput>&consumer_id='+document.getElementById('cons_id').value ,'bank_list',1);	
                }
            </cfif>
        }
        function gizle_goster(joker_inf)
        {
            pos_type = joker_inf.split(';')[6];//pos type i alır,Yapıkredide işlem olur sadece
            if(pos_type == 9 && joker_inf.split(';')[4] != undefined && joker_inf.split(';')[4] > 0)//ve taksitli işlemse
            {
				$('#item-joker_vada').show();
            }
            else
            {
				$('#item-joker_vada').hide();
            }
        }
        function kontrol()
        {	
            if(!chk_process_cat('add_online_pos')) return false;
            if(!check_display_files('add_online_pos')) return false;
            if(!chk_period(document.getElementById('action_date'), 'İşlem')) return false;
            
            if(form.find('select#member_card_id') != undefined && form.find('select#member_card_id').val() == '')
			{
				validateMessage('notValid',form.find('select#member_card_id'));
				return false;
			}
			else
				validateMessage('valid', form.find('select#member_card_id'));
            
            d = new Date();
            if(form.find('select#exp_year').val() < d.getFullYear())
			{
				validateMessage('notValid',form.find('select#exp_year'));
				return false;
			}
			else
				validateMessage('valid', form.find('select#exp_year'));
				
            return true;
        }
		function showJokerVada(joker)
		{
			if(joker.checked)
			{
				if(form.find('input#card_no') != undefined)
				{
					if(form.find('input#card_no').val() != "")
					{
						url_= '/V16/bank/cfc/onlinePosJokerVada.cfc?method=jokerVada';
						
						$.ajax({
							type: "get",
							url: url_,
							data: {cardNo: form.find('input#card_no').val()},
							cache: false,
							async: false,
							success: function(read_data){
								form.find('div#jokerInfo').html(read_data);
							}
						});
						form.find('input#card_no').prop('readonly',true);
						validateMessage('valid',form.find('input#card_no'));
					}
					else
					{
						form.find("input#joker_vada").prop('checked', false);
						validateMessage('notValid',form.find('input#card_no'));
						return false;
					}
				}
			}
			else
			{
				form.find('div#jokerInfo').empty();
				form.find('input#card_no').prop('readonly',false);
			}
		}
    </script>
<cfelseif attributes.event is "addmulti" or attributes.event is "updmulti">
	<script type="text/javascript">
		<cfoutput>
			<cfif not (len(paper_code) and len(paper_number))>
				var auto_paper_code = "";
				var auto_paper_number = "";
			<cfelse>
				var auto_paper_code = "#paper_code#-";
				var auto_paper_number = "#paper_number#";
			</cfif>
		<cfif  IsDefined("attributes.event") and attributes.event eq 'updmulti'>	
			row_count=#get_payment.recordcount#;
		</cfif>
		</cfoutput>
		<cfif attributes.event eq 'addmulti'>
			row_count=0;
		</cfif>
		record_exist=0;
		
		function sil(sy)
		{
			var my_element=document.getElementById('row_kontrol'+sy);	
			my_element.value=0;		
			var my_element=eval("frm_row"+sy);	
			my_element.style.display="none";
			toplam_hesapla();		
		}
						
		function add_row(action_company_id,action_consumer_id,action_par_id,comp_name,paper_no,amount,system_amount,commission_amount,other_amount,other_money,action_date,due_start_date,special_definition_id,employee_id,employee_name,payment_type_id,currency_id,account_acc_code,account_id,payment_rate,payment_rate_acc)
		{
			if(action_company_id == undefined) action_company_id = '';
			if(action_consumer_id == undefined) action_consumer_id = '';
			if(action_par_id == undefined) action_par_id = '';
			if(comp_name == undefined) comp_name = '';
			if(paper_no == undefined) paper_no = '';
			if(amount == undefined) amount = 0;
			if(system_amount == undefined) system_amount = 0;
			if(commission_amount == undefined) commission_amount = 0;	
			if(other_amount == undefined) other_amount = 0;	
			if(other_money == undefined) other_money = '<cfoutput>#session.ep.money#</cfoutput>';
			if(action_date == undefined) action_date = "<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>";
			if(due_start_date == undefined) due_start_date = "<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>";
			if(special_definition_id == undefined) special_definition_id = '';
			if(employee_id == undefined) employee_id = '<cfoutput>#session.ep.userid#</cfoutput>';
			if(employee_name == undefined) employee_name = '<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>';
			if(payment_type_id == undefined) payment_type_id = '';
			if(currency_id == undefined) currency_id = '';
			if(account_acc_code == undefined) account_acc_code = '';
			if(account_id == undefined) account_id = '';
			if(payment_rate == undefined) payment_rate = '';
			if(payment_rate_acc == undefined) payment_rate_acc = '';
			
			row_count++;
			var newRow;
			var newCell;	
			document.getElementById('record_num').value=row_count;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			newRow.setAttribute("class","nohover");
			newRow.id = "frm_row" + row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="row_' + row_count +'" id="row_' + row_count +'" value="'+row_count+'" readonly="readonly" style="text-align:left; width:25px;" class="box">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0" align="absmiddle"></a>';
			//cari hesap
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML += '<input type="hidden" name="action_company_id' + row_count +'" id="action_company_id' + row_count +'"  value="'+action_company_id+'"><input type="hidden" name="action_consumer_id' + row_count +'" id="action_consumer_id' + row_count +'"  value="'+action_consumer_id+'"><input type="hidden" name="action_par_id' + row_count +'" id="action_par_id' + row_count +'"  value="'+action_par_id+'"><input type="text" name="comp_name' + row_count +'" id="comp_name' + row_count +'" onFocus="autocomp('+row_count+');"  value="'+comp_name+'" style="width:162px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
			//belge no
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+auto_paper_code + auto_paper_number+'" class="boxtext">';
			if(auto_paper_number != '')
				auto_paper_number++;
			//hesap/odeme yontemi
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			c = '<select name="payment_type_id' + row_count  +'" id="payment_type_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="get_acc_info('+row_count+'); change_comm_value('+row_count+'); kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
			<cfoutput query="getCreditCards">
				if('#payment_type_id#' == payment_type_id)
					c += '<option value="#payment_type_id#" selected><cfif len(account_name)>#account_name#/</cfif>#card_no#</option>';
				else
					c += '<option value="#payment_type_id#"><cfif len(account_name)>#account_name#/</cfif>#card_no#</option>';
			</cfoutput>
			newCell.innerHTML =c+ '<input type="hidden" name="currency_id' + row_count +'" id="currency_id' + row_count +'" value="'+currency_id+'"><input type="hidden" name="account_acc_code' + row_count +'" id="account_acc_code' + row_count +'" value="'+account_acc_code+'"><input type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="hidden" name="payment_rate' + row_count +'" id="payment_rate' + row_count +'" value="'+payment_rate+'"><input type="hidden" name="payment_rate_acc'+row_count+'" id="payment_rate_acc'+row_count+'" value="'+payment_rate_acc+'"></select>';
			newCell.innerHTML =c+ '</select><input type="hidden" name="currency_id' + row_count +'" id="currency_id' + row_count +'" value="'+currency_id+'"><input type="hidden" name="account_acc_code' + row_count +'" id="account_acc_code' + row_count +'" value="'+account_acc_code+'"><input type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="hidden" name="payment_rate' + row_count +'" id="payment_rate' + row_count +'" value="'+payment_rate+'"><input type="hidden" name="payment_rate_acc'+row_count+'" id="payment_rate_acc'+row_count+'" value="'+payment_rate_acc+'">';
			//tutar
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="system_amount' + row_count +'" id="system_amount'+ row_count + '" value="'+commaSplit(system_amount)+'"><input type="text" name="amount' + row_count +'" id="amount' + row_count + '" value="'+commaSplit(amount)+'" onkeyup="return(FormatCurrency(this,event));" onBlur="change_comm_value('+row_count+'); kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');" float:right;" class="box">';
			// komisyon tutari
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="commission_amount' + row_count +'" id="commission_amount' + row_count +'" value="'+commaSplit(commission_amount)+'" onkeyup="return(FormatCurrency(this,event));" style="width:100px; float:right;" class="box">';
			//doviz tutar
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="other_amount' + row_count +'" id="other_amount' + row_count + '" value="'+commaSplit(other_amount)+'" readonly="readonly" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',true,'+row_count+');">';
			//para birimi
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<select name="money_id' + row_count  +'" id="money_id' + row_count + '" style="width:100%;" class="boxtext" onChange="kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');">';
			<cfoutput query="get_money">
				if('#money#' == other_money)
					a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#" selected>#money#</option>';
	
				else
					a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#">#money#</option>';
			</cfoutput>
			newCell.innerHTML =a+ '</select>';
			//tarih
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.setAttribute("id","action_date" + row_count + "_td");
			newCell.innerHTML = '<input type="text" id="action_date' + row_count +'" name="action_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' + action_date +'"> ';
			wrk_date_image('action_date' + row_count);
			//vade baslangic tarih
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.setAttribute("id","due_start_date" + row_count + "_td");
			newCell.innerHTML = '<input type="text" id="due_start_date' + row_count +'" name="due_start_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' + due_start_date +'"> ';
			wrk_date_image('due_start_date' + row_count);
			//tahsilat tipi
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			b = '<select name="special_definition_id' + row_count  +'" id="special_definition_id' + row_count  +'" style="width:100%;" class="boxtext"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
			<cfoutput query="GET_SPECIAL_DEFINITION">
				if('#SPECIAL_DEFINITION_ID#' == special_definition_id)
					b += '<option value="#SPECIAL_DEFINITION_ID#" selected>#SPECIAL_DEFINITION#</option>';
				else
					b += '<option value="#SPECIAL_DEFINITION_ID#">#SPECIAL_DEFINITION#</option>';
			</cfoutput>
			newCell.innerHTML =b+ '</select>';
			//tahsil eden
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value="'+employee_id+'"><input type="text" style="width:133px;" name="employee_name'+ row_count +'" id="employee_name'+ row_count +'" onFocus="autocomp_employee('+row_count+');" value="'+employee_name+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_employee('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
			
			kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',true,row_count);
			<cfif attributes.event eq 'updmulti'>
				toplam_hesapla();
			</cfif>
		}
		
		function copy_row(no_info)
		{
			action_company_id = document.getElementById('action_company_id' + no_info).value; 
			action_consumer_id = document.getElementById('action_consumer_id' + no_info).value; 	
			action_par_id = document.getElementById('action_par_id' + no_info).value;
			comp_name = document.getElementById('comp_name' + no_info).value;
			paper_number = document.getElementById('paper_number' + no_info).value;
			amount = document.getElementById('amount' + no_info).value;
			system_amount = document.getElementById('system_amount' + no_info).value;
			commission_amount = document.getElementById('commission_amount' + no_info).value;
			amount = document.getElementById('amount' + no_info).value;
			other_amount = document.getElementById('other_amount' + no_info).value;
			money_id = list_getat(document.getElementById('money_id' + no_info).value,1,';');
			action_date = document.getElementById('action_date' + no_info).value;
			due_start_date = document.getElementById('due_start_date' + no_info).value;
			special_definition_id = document.getElementById('special_definition_id' + no_info).value;
			employee_id = document.getElementById('employee_id' + no_info).value;
			employee_name = document.getElementById('employee_name' + no_info).value;
			payment_type_id = document.getElementById('payment_type_id' + no_info).value;
			currency_id = document.getElementById('currency_id' + no_info).value;
			account_acc_code = document.getElementById('account_acc_code' + no_info).value;
			account_id = document.getElementById('account_id' + no_info).value;
			payment_rate = document.getElementById('payment_rate' + no_info).value;
			payment_rate_acc = document.getElementById('payment_rate_acc' + no_info).value;
			
			add_row(action_company_id,action_consumer_id,action_par_id,comp_name,paper_number,amount,system_amount,commission_amount,other_amount,money_id,action_date,due_start_date,special_definition_id,employee_id,employee_name,payment_type_id,currency_id,account_acc_code,account_id,payment_rate,payment_rate_acc);
		}
		
		function autocomp(no)
		{
			AutoComplete_Create("comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME","MEMBER_NAME,MEMBER_PARTNER_NAME","get_member_autocomplete","\'1,2\'","COMPANY_ID,PARTNER_ID,CONSUMER_ID","action_company_id"+no+",action_par_id"+no+",action_consumer_id"+no+"","",3,250,"");
		}
		function autocomp_employee(no)
		{
			AutoComplete_Create("employee_name"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","3","EMPLOYEE_ID","employee_id"+no,"",3,140);
		}
		
		function pencere_ac_company(sira_no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&row_no='+ sira_no +'&select_list=2,3&field_comp_id=add_process.action_company_id'+ sira_no +'&field_member_name=add_process.comp_name'+ sira_no +'&field_name=add_process.comp_name' + sira_no +'&field_partner=add_process.action_par_id'+ sira_no +'&field_consumer=add_process.action_consumer_id'+ sira_no,'list');
		}
		function pencere_ac_employee(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_process.employee_id' + no +'&field_name=add_process.employee_name' + no +'&select_list=1,9','list');
		}
		
		
		function toplam_hesapla()
		{ 
			rate2_value = 0;
			deger_diger_para = '<cfoutput>#session.ep.money#</cfoutput>';
			for (var t=1; t<=document.getElementById('kur_say').value; t++)
			{
				if(document.add_process.rd_money[t-1].checked == true)
				{
					for(k=1; k<=document.getElementById('record_num').value; k++)
					{
						rate2_value = filterNum(document.getElementById('txt_rate2_'+t).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						deger_diger_para = list_getat(document.add_process.rd_money[t-1].value,1,',');
					}
				}
			}
			var total_amount = 0;
			var rate_ = 1;
			for(j=1; j<=document.getElementById('record_num').value; j++)
			{
				if(document.getElementById('row_kontrol'+j).value==1)
				{
					url_= '/V16/bank/cfc/bankInfo.cfc?method=getCurrencyInfo';
					
					$.ajax({
						type: "get",
						url: url_,
						data: {money: list_getat(document.getElementById('money_id'+j).value,1,';'),period: document.getElementById('active_period').value,company: document.getElementById('active_company').value},
						cache: false,
						async: false,
						success: function(read_data){
							data_ = jQuery.parseJSON(read_data.replace('//',''));
							if(data_.DATA.length != 0)
							{
								$.each(data_.DATA,function(i){
									get_rate_ = data_.DATA[i][0];
									});
							}
						}
					});
					if(get_rate_.recordcount)
						var rate_ = get_rate_.RATE2;
					total_amount += parseFloat(filterNum(document.getElementById('amount'+j).value)*rate_);
					var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
					if (selected_ptype != '')
						eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
					else
						var proc_control = '';
				}
			}
			document.getElementById('total_amount').value = commaSplit(total_amount);
		}
		
		function kontrol()
		{
			if(!chk_process_cat('add_process')) return false;
			if(!check_display_files('add_process')) return false;
			
			paper_num_list = '';
			
			for(j=1; j<=document.getElementById('record_num').value; j++)
			{
				if(document.getElementById('row_kontrol'+j).value==1)
				{
					record_exist=1;
					//belge no kontrolü----
					<cfif attributes.event eq 'addmulti'>
						if(document.getElementById('paper_number'+j).value != "")
						{
							//if(!paper_control(document.getElementById('paper_number'+j),'CREDITCARD_REVENUE','1','','','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
							kontrol_no = list_getat(document.getElementById('paper_number'+j).value,1,'-');
							kontrol_number = list_getat(document.getElementById('paper_number'+j).value,2,'-');
						}
						else
						{
							if(kontrol_number != undefined && kontrol_number != '')
							{
								if(document.getElementById('paper_number'+j).value == "")
								{
									kontrol_number++;
									document.getElementById('paper_number'+j).value = kontrol_no+'-'+kontrol_number;
								}
							}
						}
					</cfif>
					<cfif  attributes.event eq 'updmulti'>
						if(document.getElementById('id'+j) != undefined)
						{
							if(document.getElementById('paper_number'+j).value != "")
							{
								//if(!paper_control(document.getElementById('paper_number'+j),'CREDITCARD_REVENUE','1',document.getElementById('id'+j).value,document.getElementById('paper_number'+j).value,'','','','<cfoutput>#dsn3#</cfoutput>')) return false;
								kontrol_no = list_getat(document.getElementById('paper_number'+j).value,1,'-');
								kontrol_number = list_getat(document.getElementById('paper_number'+j).value,2,'-');
							}
							else
							{
								if(kontrol_number != undefined && kontrol_number != '')
								{
									if(document.getElementById('paper_number'+j).value == "")
									{
										kontrol_number++;
										document.getElementById('paper_number'+j).value = kontrol_no+'-'+kontrol_number;
									}
								}
							}
						}
					</cfif>
					if(document.getElementById('paper_number'+j).value != "" )
					{
						paper = document.getElementById('paper_number'+j).value;
						paper = "'"+paper+"'";
						if(list_find(paper_num_list,paper,','))
						{
							alert("<cf_get_lang dictionary_id='33815.Aynı Belge Numarası İle Eklenen İki Farklı Satır Var'>:"+ paper);
							return false;
						}
						else
						{
							if(list_len(paper_num_list,',') == 0)
								paper_num_list+=paper;
							else
								paper_num_list+=","+paper;
						}
					}
				}
			}
			//Satirda eksik bilgi kontrolleri
			for(var n=1; n<=add_process.record_num.value;n++)
			{
				if(document.getElementById("row_kontrol"+n).value == 1)
				{
					//Satirda cari hesap kontrolu
					if((document.getElementById("action_company_id"+n).value=="" || document.getElementById("action_consumer_id"+n).value=="" || document.getElementById("action_par_id"+n).value=="") && document.getElementById("comp_name"+n).value=="")
					{
						alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='107.Cari Hesap'>! <cf_get_lang_main no='818.Satır No'>: "+ document.getElementById("row_"+n).value);
						return false;
					}
					//Satirda tutar kontrolu
					if(document.getElementById("amount"+n).value == "")
					{
						alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='261.Tutar'>! <cf_get_lang_main no='818.Satır No'>: "+ document.getElementById("row_"+n).value);
						return false;
					}
					//Satirda komisyonlu tutar kontrolu
					if(document.getElementById("commission_amount"+n).value == "")
					{
						alert("<cf_get_lang_main no='59.Eksik Veri'> : Komisyonlu <cf_get_lang_main no ='261.Tutar'>! <cf_get_lang_main no='818.Satır No'>: "+ document.getElementById("row_"+n).value);
						return false;
					}
					//Satirda hesap-odeme yontemi kontrolu
					if(document.getElementById("payment_type_id"+n).value == "")
					{
						alert("<cf_get_lang_main no='59.Eksik Veri'> : Hesap/Ödeme Yöntemi! <cf_get_lang_main no='818.Satır No'>: "+ document.getElementById("row_"+n).value);
						return false;
					}
				}
			}
				
			if (record_exist == 0) 
			{
				alertObject({message: "<cf_get_lang no ='3.Lütfen Satır Ekleyiniz'>!"});
				return false;
			}
			return true;
		}
		<cfoutput>
			function get_acc_info(row_no)
			{
				var acc_info = document.getElementById('payment_type_id'+row_no).value;
				if(acc_info != '')
				{
					url_= '/V16/bank/cfc/bankInfo.cfc?method=paymentTypeAccount';
					
					$.ajax({
						type: "get",
						url: url_,
						data: {paymentType: acc_info},
						cache: false,
						async: false,
						success: function(read_data){
							data_ = jQuery.parseJSON(read_data.replace('//',''));
							if(data_.DATA.length != 0)
							{
								$.each(data_.DATA,function(i){
									document.getElementById('currency_id'+row_no).value = data_.DATA[i][0];
									document.getElementById('account_acc_code'+row_no).value = data_.DATA[i][1];
									document.getElementById('account_id'+row_no).value = data_.DATA[i][2];
									document.getElementById('payment_rate'+row_no).value = data_.DATA[i][3];
									document.getElementById('payment_rate_acc'+row_no).value = data_.DATA[i][4];
									});
							}
							else
							{
								$.ajax({
									type: "get",
									url: '/V16/bank/cfc/bankInfo.cfc?method=paymentTypeInfo',
									data: {paymentType: acc_info},
									cache: false,
									async: false,
									success: function(read_data){
										data_ = jQuery.parseJSON(read_data.replace('//',''));
										if(data_.DATA.length != 0)
										{
											$.each(data_.DATA,function(i){
												document.getElementById('currency_id'+row_no).value = "#session.ep.money#";
												document.getElementById('account_acc_code'+row_no).value = '';
												document.getElementById('account_id'+row_no).value = 0;
												document.getElementById('payment_rate'+row_no).value = data_.DATA[i][0];
												document.getElementById('payment_rate_acc'+row_no).value = data_.DATA[i][1];
												});
										}
									}
								});
							}
						}
					});				
				}
				else
				{
					document.getElementById('currency_id'+row_no).value = '';
					document.getElementById('account_acc_code'+row_no).value = '';
					document.getElementById('account_id'+row_no).value = '';
					document.getElementById('payment_rate'+row_no).value = '';
					document.getElementById('payment_rate_acc'+row_no).value = '';
				}
			}
		</cfoutput>
		
		function kur_ekle_f_hesapla(select_input,doviz_tutar,satir)
		{
			if(satir != undefined)
			{
				if(!doviz_tutar) doviz_tutar=false;
				var currency_type = document.getElementById('<cfoutput>#select_input#</cfoutput>'+satir).value;
				if(document.getElementById('currency_id'+satir) != undefined)
					currency_type = document.getElementById('currency_id'+satir).value;
				else
					currency_type = list_getat(currency_type,2,';');
				row_currency = list_getat(eval("document.add_process.money_id"+satir).value,1,';');
				var other_money_value_eleman=eval("document.add_process.other_amount"+satir);
				var temp_act,rate1_eleman,rate2_eleman;
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{
					other_money_value_eleman.value = '';
					return false;
				}
				if(!doviz_tutar && eval("document.add_process.commission_amount"+satir) != "" && currency_type != "")
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if( eval('add_process.hidden_rd_money_'+i).value == currency_type)
						{
							temp_act=filterNum(eval("document.add_process.commission_amount"+satir).value)*rate2_eleman/rate1_eleman;
							eval("document.add_process.system_amount"+satir).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
						}
					}
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value)*rate1_eleman/rate2_eleman);
							eval("document.add_process.system_amount"+satir).value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value));
						}
					}
				}
				else if(doviz_tutar)
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>' && filterNum(eval("document.add_process.system_amount"+satir).value) > 0)
								eval('add_process.txt_rate2_' + i).value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value)/filterNum(other_money_value_eleman.value),'<cfoutput>#rate_round_num_info#</cfoutput>');
							else
								for(var t=1;t<=add_process.kur_say.value;t++)
									if( eval('add_process.hidden_rd_money_'+t).value == currency_type && eval("document.add_process.commission_amount"+satir).value > 0  && eval('add_process.hidden_rd_money_'+t).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
										eval('add_process.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(eval("document.add_process.commission_amount"+satir).value),'<cfoutput>#rate_round_num_info#</cfoutput>');
						}
					}					
					eval("document.add_process.commission_amount"+satir).value = commaSplit(filterNum(eval("document.add_process.commission_amount"+satir).value));
				}
			}
			else
			{
				if(!doviz_tutar) doviz_tutar=false;
				
				for(var kk=1;kk<=add_process.record_num.value;kk++)
				{
					var currency_type = document.getElementById('<cfoutput>#select_input#</cfoutput>'+kk).value;
					if(document.getElementById('currency_id'+kk) != undefined)
						currency_type = document.getElementById('currency_id'+kk).value;
					else
						currency_type = list_getat(currency_type,2,';');
						
					document.getElementById('total_amount_currency').value = currency_type;
					var other_money_value_eleman=eval("document.add_process.other_amount"+kk);
					var temp_act,rate1_eleman,rate2_eleman;
					row_currency = list_getat(eval("document.add_process.money_id"+kk).value,1,';');						
					if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
					{
						other_money_value_eleman.value = '';
						return false;
					}if(currency_type != "")
					if(!doviz_tutar && eval("document.add_process.commission_amount"+kk) != "" && currency_type != "")
					{
						for(var i=1;i<=add_process.kur_say.value;i++)
						{
							rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							if(eval('add_process.hidden_rd_money_'+i).value == currency_type)
							{
								temp_act=filterNum(eval("document.add_process.commission_amount"+kk).value)*rate2_eleman/rate1_eleman;
								eval("document.add_process.system_amount"+kk).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
							}
						}
						for(var i=1;i<=add_process.kur_say.value;i++)
						{
							rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
							{
								other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value)*rate1_eleman/rate2_eleman);
								eval("document.add_process.system_amount"+kk).value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value));
							}
						}
					}
					else if(doviz_tutar)
					{
						for(var i=1;i<=add_process.kur_say.value;i++)
							if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
							{
								if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
									eval('add_process.txt_rate2_' + i).value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value)/filterNum(other_money_value_eleman.value),'<cfoutput>#rate_round_num_info#</cfoutput>');
								else
									for(var t=1;t<=add_process.kur_say.value;t++)
										if( eval('add_process.hidden_rd_money_'+t).value == currency_type && eval('add_process.hidden_rd_money_'+t).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
											eval('add_process.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(eval("document.add_process.commission_amount"+kk).value),'<cfoutput>#rate_round_num_info#</cfoutput>');
								if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
									for(var k=1;k<=add_process.kur_say.value;k++)
									{
										rate1_eleman = filterNum(eval('add_process.txt_rate1_' + k).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
										rate2_eleman = filterNum(eval('add_process.txt_rate2_' + k).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
										if( eval('add_process.hidden_rd_money_'+k).value == currency_type)
										{
											temp_act=filterNum(eval("document.add_process.commission_amount"+kk).value)*rate2_eleman/rate1_eleman;
											eval("document.add_process.system_amount"+kk).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
										}
									}
								else
									eval("document.add_process.system_amount"+kk).value = other_money_value_eleman.value;
							}
						eval("document.add_process.commission_amount"+kk).value = commaSplit(filterNum(eval("document.add_process.commission_amount"+kk).value));
					}
				}
			}	
			toplam_hesapla();
			return true;
		}
		
		
		function change_comm_value(row_no)
		{
			if(document.getElementById('payment_rate_acc'+row_no).value != "" && document.getElementById('payment_rate'+row_no).value != "" && document.getElementById('payment_rate'+row_no).value != 0 && document.getElementById('amount'+row_no).value != "" && document.getElementById('currency_id'+row_no).value != "")
				document.getElementById('commission_amount'+row_no).value = commaSplit(parseFloat(filterNum(document.getElementById('amount'+row_no).value)) + (parseFloat(filterNum(document.getElementById('amount'+row_no).value )) * (parseFloat(document.getElementById('payment_rate'+row_no).value)/100)));
			else
				document.getElementById('commission_amount'+row_no).value = document.getElementById('amount'+row_no).value;
		}
		<cfif  attributes.event eq 'updmulti'>
			$(document).ready(function(){
				toplam_hesapla();	
			});
		</cfif>
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 241;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;

	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	if(attributes.event contains 'upd')
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_payment.process_stage;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';

	if(not attributes.event contains 'multi'){
	   WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
	   WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'creditcard_revenue';
	}	

	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn3; // Transaction icin yapildi.
	
	if(attributes.event is "add" or attributes.event is "upd" or attributes.event is "addPos")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDIT_CARD_BANK_PAYMENTS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CREDITCARD_PAYMENT_ID';
		if(attributes.event is "addPos")
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-process_stage','item-paymentType','item-comp_name','item-action_date','item-sales_credit']";
		else
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-process_stage','item-paymentType','item-comp_name','item-action_date','item-due_start_date','item-sales_credit_comm','item-sales_credit']";
	}
	else if(attributes.event is "addmulti" or attributes.event is "updmulti")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addmulti,updmulti';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDIT_CARD_BANK_PAYMENTS_MULTI';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-action_date','item-process_cat','item-process_stage']";
	}
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_creditcard_revenue.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.popup_add_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/form_add_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/add_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_creditcard_revenue&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'cc_revenue';
		
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.popup_add_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/form_add_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/query/upd_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.list_creditcard_revenue&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_payment';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'cc_revenue';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryIsConsumer'] = '1';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	
	if(attributes.event is "upd" and control.recordcount)
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['info'] = '#lang_array.item[274]# !';//Hesaba Geçişi Yapılmış İşlemler Güncellenemez
	else
	{
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';
		if(attributes.event is "upd" and len(get_payment.order_id))
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['extraInfo'] = '#extra_#';
	}	

	WOStruct['#attributes.fuseaction#']['addPos'] = structNew();
	WOStruct['#attributes.fuseaction#']['addPos']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addPos']['fuseaction'] = 'bank.popup_add_online_pos';
	WOStruct['#attributes.fuseaction#']['addPos']['filePath'] = 'bank/form/add_online_pos.cfm';
	WOStruct['#attributes.fuseaction#']['addPos']['queryPath'] = 'bank/query/add_online_pos.cfm';
	WOStruct['#attributes.fuseaction#']['addPos']['nextEvent'] = 'bank.list_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['addPos']['formName'] = 'add_online_pos';
	
	WOStruct['#attributes.fuseaction#']['addPos']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addPos']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addPos']['buttons']['insertAlert'] = '#lang_array.item[361]#';
	WOStruct['#attributes.fuseaction#']['addPos']['buttons']['saveFunction'] = 'kontrol() && validate().check()';

	WOStruct['#attributes.fuseaction#']['addmulti'] = structNew();
	WOStruct['#attributes.fuseaction#']['addmulti']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addmulti']['fuseaction'] = 'bank.add_collacted_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['addmulti']['filePath'] = 'bank/form/form_collacted_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['addmulti']['queryPath'] = 'bank/query/add_collacted_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['addmulti']['nextEvent'] = 'bank.list_creditcard_revenue&event=updmulti&multi_id=';
	WOStruct['#attributes.fuseaction#']['addmulti']['js'] = "javascript:gizle_goster_ikili('collacted_creditcard','collacted_creditcard_sepet')";
	WOStruct['#attributes.fuseaction#']['addmulti']['formName'] = 'add_process';

	WOStruct['#attributes.fuseaction#']['addmulti']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addmulti']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addmulti']['buttons']['saveFunction'] = 'kontrol() && validate()';

	WOStruct['#attributes.fuseaction#']['updmulti'] = structNew();
	WOStruct['#attributes.fuseaction#']['updmulti']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updmulti']['fuseaction'] = 'bank.add_collacted_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['updmulti']['filePath'] = 'bank/form/form_collacted_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['updmulti']['queryPath'] = 'bank/query/upd_collacted_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['updmulti']['nextEvent'] = 'bank.list_creditcard_revenue&event=updmulti&multi_id=';
	WOStruct['#attributes.fuseaction#']['updmulti']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['updmulti']['Identity'] = '##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['updmulti']['js'] = "javascript:gizle_goster_ikili('collacted_creditcard','collacted_creditcard_sepet')";
	WOStruct['#attributes.fuseaction#']['updmulti']['formName'] = 'add_process';
	WOStruct['#attributes.fuseaction#']['updmulti']['recordQuery'] = 'get_payment';

	WOStruct['#attributes.fuseaction#']['updmulti']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['updateFunction'] = 'kontrol()';
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteEvent'] = 'del';
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteUrl'] = '#request.self#?fuseaction=bank.list_creditcard_revenue&event=del';
	
	if(attributes.event is "upd" or attributes.event is "updmulti" or attributes.event is "del")
	{
		if(isdefined("attributes.multi_id"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(not isdefined('attributes.formSubmittedController'))
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.emptypopup_del_collacted_creditcard_revenue&multi_id=#attributes.multi_id#&active_period=#get_payment.action_period_id#&old_process_type=#get_payment.action_type_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_collacted_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_collacted_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_creditcard_revenue';
		}
		else if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(not isdefined('attributes.formSubmittedController'))
			{
				if(len(get_payment.order_id))
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.emptypopup_del_creditcard_revenue&id=#attributes.id#&comp=#attributes.comp_name#&old_process_type=#get_payment.action_type_id#&order_id=#get_payment.order_id#&action_date=#get_payment.store_report_date#&active_period=#get_payment.action_period_id#&cari_action_id=#get_payment.cari_action_id#';
				else
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.emptypopup_del_creditcard_revenue&id=#attributes.id#&comp=#attributes.comp_name#&old_process_type=#get_payment.action_type_id#&action_date=#get_payment.store_report_date#&active_period=#get_payment.action_period_id#&cari_action_id=#get_payment.cari_action_id#&relation_creditcard_payment_id=#get_payment.relation_creditcard_payment_id#';
			}
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_creditcard_revenue';
		}
	}
		   
	WOStruct['#attributes.fuseaction#']['dsp'] = structNew();
	WOStruct['#attributes.fuseaction#']['dsp']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['dsp']['fuseaction'] = 'bank.list_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['dsp']['filePath'] = 'bank/display/list_payment_plans.cfm';
	WOStruct['#attributes.fuseaction#']['dsp']['queryPath'] = 'bank/display/list_payment_plans.cfm';
	WOStruct['#attributes.fuseaction#']['dsp']['nextEvent'] = 'bank.list_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['dsp']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['dsp']['formName'] = '';

	if(attributes.event is 'add')
	{
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[620]# #lang_array_main.item[280]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue&event=addmulti";
	   tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}	
	else if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="CREDITCARD_PAYMENT_ID" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=finance.popup_add_payment_for_member&cc_payment_type_id=#attributes.id#','list','popup_member_schema');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[35]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#GET_PAYMENT.ACTION_TYPE_ID#&period_id=#GET_PAYMENT.ACTION_PERIOD_ID#','list','popup_member_schema');";
		
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue&event=add";
		
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=152&action_type=#GET_PAYMENT.action_type_id#','page')";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'addmulti')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][0]['text'] = '#lang_array_main.item[1998]# #lang_array_main.item[280]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][0]['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue&event=add"; 
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is "updmulti")
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][0]['text'] = '#lang_array_main.item[35]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=2410','wide','add_process');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue&event=addmulti";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
