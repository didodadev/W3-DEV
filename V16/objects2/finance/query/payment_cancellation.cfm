<cfset result = StructNew()>
<cfset result.status = false>
<cfset result.error = "">
<cfset arguments_content = deserializeJSON(getHttpRequestData().content)> 
<cfscript>
    StructAppend(attributes,arguments_content,true);
</cfscript>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = 145
</cfquery>

<cfquery name="GET_PAYMENT" datasource="#DSN3#">
    SELECT 
        CCBP.CREDITCARD_PAYMENT_ID,
        CCBP.PAYMENT_TYPE_ID,
        CCBP.STORE_REPORT_DATE,
        CCBP.SALES_CREDIT,
        CCBP.CARD_NO,
        CCBP.OTHER_MONEY,
        CCBP.OTHER_CASH_ACT_VALUE,
        CCBP.ACTION_DETAIL,
        CCBP.ACTION_CURRENCY_ID,
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
        CCBP.SUBSCRIPTION_ID,
        CCBP.PAPER_NO,
        CCBP.UPD_STATUS,
        CCBP.TO_BRANCH_ID,
        CCBP.ASSETP_ID,
        CCBP.SPECIAL_DEFINITION_ID,
        CCBP.REVENUE_COLLECTOR_ID,
        <!---ISNULL(CCBP.WRK_ID,CCBP.WRK_ID_INVOICE) WRK_ID,--->
        CCBP.WRK_ID AS WRK_ID,
        CCBP.RECORD_DATE,        
        PRO_PROJECTS.PROJECT_HEAD
    FROM 
        CREDIT_CARD_BANK_PAYMENTS CCBP WITH (NOLOCK) 
        LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = CCBP.PROJECT_ID
    WHERE 
        CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
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
		<!--- COMPANY_ID, 6 aya siline FA22102013--->
        POS_TYPE,
        BANK_ACCOUNT
	FROM 
		CREDITCARD_PAYMENT_TYPE 
	WHERE 
		PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT.PAYMENT_TYPE_ID#">
</cfquery>

<cfset attributes.old_sales_credit = TLFormat(get_payment.sales_credit)>
<cfset attributes.sales_credit = TLFormat(get_payment.sales_credit)>
<cfset attributes.system_amount = filterNum(attributes.sales_credit)>
<cfset attributes.relation_action_date =  get_payment.store_report_date>
<cfset attributes.relation_wrk_id =  get_payment.WRK_ID>
<cfset wrk_id =  get_payment.WRK_ID>
<cfset branch_id_info = get_payment.TO_BRANCH_ID>
<cfset attributes.process_cat =  145>
<cfset attributes.payment_type_id = get_payment.PAYMENT_TYPE_ID>
<cfset attributes.ACCOUNT_ID = GET_CREDIT_PAYMENT.BANK_ACCOUNT>
<cfset attributes.ACTION_DETAIL = "#attributes.action_id# nolu Kredi Kartı Tahsilatı İade/İptal İşlemi">
<cfset attributes.currency_id = get_payment.ACTION_CURRENCY_ID>
<cfset attributes.ACTION_FROM_COMPANY_ID = get_payment.ACTION_FROM_COMPANY_ID> 
<cfset attributes.par_id = session_base.userid>
<cfset attributes.cons_id = ""> 
<cfset attributes.action_date = now()> 
<cfset attributes.due_start_date = now()> 
<cfset due_value_date = attributes.due_start_date>
<cfset attributes.MONEY_TYPE = get_payment.OTHER_MONEY> 
<cfset attributes.other_value_sales_credit = TLFormat(get_payment.other_cash_act_value)>
<cfset attributes.card_no = get_payment.card_no> 
<cfset attributes.card_owner = get_payment.card_owner> 
<cfset attributes.project_id = get_payment.project_id> 
<cfset attributes.cancel_type_id = "">
<cfset attributes.subscription_id = get_payment.subscription_id> 
<cfset attributes.paper_number = get_payment.PAPER_NO> 


<cfset process_type = get_process_type.process_type>
<cfset is_cari = get_process_type.is_cari>
<cfset is_account = get_process_type.is_account>

<cfset currency_multiplier = ''>
<cfset currency_multiplier_2 = ''>
<cfset currency_multiplier_other = ''>

<cfif not len(GET_CREDIT_PAYMENT.ACCOUNT_CODE) and is_account eq 1>
    <cfset result.status = false>
    <cfset result.error = "<cf_get_lang no ='396.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Seçilmemiş'>!>">
    <cfdump var='#replace(serializeJSON(result),"//","")#'>
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

<cf_papers paper_type="creditcard_revenue">

<!--- iade isleminde çitf işlem kontrolu yapiliyor --->
<cfquery name="getPaymentAmount" datasource="#dsn3#">
    SELECT ISNULL(SUM(SALES_CREDIT),0) AS PAYMENT_AMOUNT FROM CREDIT_CARD_BANK_PAYMENTS WHERE RELATION_CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfset total_amount = filterNum(attributes.old_sales_credit) - getPaymentAmount.PAYMENT_AMOUNT>
<cfif total_amount lte 0>
    <script language="javascript">
        İlişkili tahsilat için dahe önceden İptal/İade işlemi gerçekleştirilmiştir !
        history.back();
    </script>
    <cfabort>
</cfif>
<cfset difference_amount = filterNum(attributes.old_sales_credit) - filterNum(attributes.sales_credit)>
<!--- iade/iptal islemi aynı gün icerisindeki islemler iptal edilebilir (iptal icin tutarın tamamı gonderilmelidir) diger islemler iade olarak gonderilmelidir --->
<cfif getPaymentAmount.PAYMENT_AMOUNT eq 0 and difference_amount eq 0 and isdefined('attributes.relation_action_date') and dateformat(attributes.relation_action_date,'ddmmyyyy') eq dateformat(now(),'ddmmyyyy')>
    <cfset is_iptal = 1>
<cfelse>
    <cfset result.status = false>
    <cfset result.error = "iade/iptal islemi aynı gün icerisindeki islemler iptal edilebilir">
    <cfoutput>
        #replace(serializeJSON(result),"//","")#
    </cfoutput><cfabort>
    <cfoutput>
        #replace(serializeJSON(result),"//","")#
    </cfoutput><cfabort>
    <cfset is_iptal = 0>
</cfif>

<cfif is_iptal eq 1>
    <cfif get_process_type.process_type neq 245>
        <cfset result.status = false>
        <cfset result.error = "Sadece iptal işlemi gerçekleştirebilirsiniz. Lütfen işlem tipinizi kontrol ediniz!">
        <cfoutput>
            #replace(serializeJSON(result),"//","")#
        </cfoutput><cfabort>            
        <cfabort>
    </cfif>
    <cfset pos_id_ = GET_CREDIT_PAYMENT.pos_type>
    <cfset taksit_sayisi = GET_CREDIT_PAYMENT.number_of_instalment>
    <cfset response_code = 00>
    <cfinclude template="../../../add_options/query/online_pos_files.cfm">
    <!--- TODO <cflog text="#session.ep.name# #session.ep.surname#(#session.ep.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id# - kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)#  --- response_code:#response_code#" file="sanal_pos_iade_iptal" application="yes"> --->
    <cfif response_code eq 00>
        <cfset result.msg = "#response_code# - #response_detail#">
        <cfset result.status = true>
    <cfelse>
        <cfset result.status = false>
        <cfset result.error = "#response_code# - #response_detail#">
        <cfoutput>
            #replace(serializeJSON(result),"//","")#
        </cfoutput><cfabort>
    </cfif>
</cfif>
<cfif (isdefined('response_code') and response_code eq 00) or (not isdefined('response_code'))>
	<cflock name="#createUUID()#" timeout="20">
        <cftransaction>
            <cftry>            
                <cfinclude template="payment_cancellation_include.cfm">
                <!--- Belge No update ediliyor --->
                <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN3#">
                    UPDATE 
                        GENERAL_PAPERS
                    SET
                        CREDITCARD_REVENUE_NUMBER = #paper_number#
                    WHERE
                        CREDITCARD_REVENUE_NUMBER IS NOT NULL
                </cfquery>
                <!--- <!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
                <cf_workcube_process_cat 
                    process_cat="#attributes.process_cat#"
                    action_id = #MAX_ID.IDENTITYCOL#
                    is_action_file = 1
                    action_db_type = '#dsn3#'
                    action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue&event=upd&id=#MAX_ID.IDENTITYCOL#'
                    action_file_name='#get_process_type.action_file_name#'
                    is_template_action_file = '#get_process_type.action_file_from_template#'> --->
                    <!--- <cf_add_log employee_id="#session_base.userid#" log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name= "Kredi Kartı Tahsilatı" paper_no= "#attributes.paper_number#" period_id="#session_base.period_id#" process_type="#get_process_type.process_type#" data_source="#dsn3#"> --->
                <cfset result.status = true>
                <cfset result.msg2 = "Sanal pos iade/iptal işleminiz gerçekleşmiştir!">
                <cfoutput>
                    #replace(serializeJSON(result),"//","")#
                </cfoutput>
            <cfcatch type="exception">
                <cfset result.status = true>
                <cfset result.error = "Sanal pos iade/iptal işleminiz Yapıldı. Fakat Sisteme Kredi Kartı İptal Kaydı Yapılamamıştır. Lütfen Müşteri Hizmetlerine Başvurunuz!">
                <cfoutput>
                    #replace(serializeJSON(result),"//","")#
                </cfoutput>
            </cfcatch>
            </cftry>
        </cftransaction>
    </cflock>
</cfif>