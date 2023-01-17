<cf_get_lang_set module_name="bank">
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.process_type;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
	if(not isdefined('xml_import'))
	{
		attributes.sales_credit = filterNum(attributes.sales_credit);
		attributes.sales_credit_comm = filterNum(attributes.sales_credit_comm);
		attributes.other_value_sales_credit = filterNum(attributes.other_value_sales_credit);
		attributes.system_amount = filterNum(attributes.system_amount);
		for(y_yy=1; y_yy lte attributes.kur_say; y_yy=y_yy+1)
		{
			'attributes.txt_rate1_#y_yy#' = filterNum(evaluate('attributes.txt_rate1_#y_yy#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#y_yy#' = filterNum(evaluate('attributes.txt_rate2_#y_yy#'),session.ep.our_company_info.rate_round_num);
		}
	}
	
	/* FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi.Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir */
	if(len(attributes.card_no))
	{
		getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
		getCCNOKey.dsn = dsn;
		getCCNOKey1 = getCCNOKey.getCCNOKey1();
		getCCNOKey2 = getCCNOKey.getCCNOKey2();
		
		if (len(attributes.action_from_company_id))//kredi kart bilgileri
			key_type = attributes.action_from_company_id;
		else if (len(attributes.cons_id))
			key_type = attributes.cons_id;
		
		if (getCCNOKey1.recordcount and getCCNOKey2.recordcount)
		{
			// anahtarlar decode ediliyor 
			ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey);
			ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey);
			// kart no encode ediliyor
			content = contentEncryptingandDecodingAES(isEncode:1,content:attributes.card_no,accountKey:key_type,key1:ccno_key1,key2:ccno_key2);
		}
		else
			content = Encrypt(attributes.card_no,key_type,"CFMX_COMPAT","Hex");
	}
	currency_multiplier = '';
	currency_multiplier_2 = '';
	currency_multiplier_other = '';//komisyonlarda dekont eklemek için
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
				currency_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');			
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.money_type)
				currency_multiplier_other = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');			
		}
	if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
	{
		attributes.project_id = "";
		attributes.project_name = "";
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>

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
        POS_TYPE
	FROM 
		CREDITCARD_PAYMENT_TYPE 
	WHERE 
		PAYMENT_TYPE_ID = #attributes.payment_type_id#
</cfquery>

<cfif not len(GET_CREDIT_PAYMENT.ACCOUNT_CODE) and is_account eq 1>
	<cfif not isdefined('xml_import')>
		<script type="text/javascript">
			alert("<cf_get_lang no ='396.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
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

<cfif not len(my_acc_result) and is_account eq 1>
	<cfif not isdefined('xml_import')>
		<script type="text/javascript">
			alert("<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>");
			history.back();	
		</script>
	<cfelse>
		<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!<br/>
	</cfif>
	<cfabort>
</cfif>

<cf_date tarih='attributes.action_date'>
<cf_date tarih='attributes.due_start_date'>

<cfif get_credit_payment.recordcount and len(get_credit_payment.p_to_instalment_account)>
	<cfset due_value_date = dateadd("d",get_credit_payment.p_to_instalment_account,attributes.due_start_date)>
<cfelse>
	<cfset due_value_date = attributes.due_start_date>
</cfif> 

<cf_papers paper_type="creditcard_revenue">

<cfif isdefined('attributes.relation_payment_id') and len(attributes.relation_payment_id)>
	<!--- iade isleminde çitf işlem kontrolu yapiliyor --->
    <cfquery name="getPaymentAmount" datasource="#dsn3#">
        SELECT ISNULL(SUM(SALES_CREDIT),0) AS PAYMENT_AMOUNT FROM CREDIT_CARD_BANK_PAYMENTS WHERE RELATION_CREDITCARD_PAYMENT_ID = #attributes.relation_payment_id#
    </cfquery>
    <cfset total_amount = filterNum(attributes.old_sales_credit) - getPaymentAmount.PAYMENT_AMOUNT>
    <cfif total_amount lte 0>
        <script language="javascript">
            alert('İlişkili tahsilat için dahe önceden İptal/İade işlemi gerçekleştirilmiştir !');
            history.back();
        </script>
        <cfabort>
    </cfif>
	<cfset difference_amount = filterNum(attributes.old_sales_credit) - attributes.sales_credit>
	<cfset is_iptal = 0>
	<!--- TODO Xml olmalı gereklİ olabilir duruma göre açılacak iade/iptal islemi aynı gün icerisindeki islemler iptal edilebilir (iptal icin tutarın tamamı gonderilmelidir) diger islemler iade olarak gonderilmelidir --->
	<!--- <cfif getPaymentAmount.PAYMENT_AMOUNT eq 0 and difference_amount eq 0 and isdefined('attributes.relation_action_date') and dateformat(attributes.relation_action_date,'ddmmyyyy') eq dateformat(now(),'ddmmyyyy')>
        <cfset is_iptal = 1>
    <cfelse>
        <cfset is_iptal = 0>
    </cfif> --->
    
    <cfif isdefined('attributes.is_online_pos') and attributes.is_online_pos eq 1>
		<cfif get_process_type.process_type neq 245>
            <script language="javascript">
                alert('Sadece iptal işlemi gerçekleştirebilirsiniz. Lütfen işlem tipinizi kontrol ediniz!');
                history.back();
            </script>
            <cfabort>
        </cfif>
        <cfset pos_id_ = GET_CREDIT_PAYMENT.pos_type>
		<cfset taksit_sayisi = GET_CREDIT_PAYMENT.number_of_instalment>
		<cfset response_code = 00>
        <cfinclude template="../../add_options/query/online_pos_files.cfm">
        <cflog text="#session.ep.name# #session.ep.surname#(#session.ep.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id# - kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)#  --- response_code:#response_code#" file="sanal_pos_iade_iptal" application="yes">
		<cfif response_code eq 00>
			<script language="javascript">
                alert("Sanal pos iade/iptal işleminiz gerçekleşmiştir!");
            </script>
		<cfelse>
            <script language="javascript">
                alert("<cfoutput>#response_code# - #response_detail# !</cfoutput>");
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfif>
</cfif>

<cfif (isdefined('response_code') and response_code eq 00) or (not isdefined('response_code'))>
	<cflock name="#createUUID()#" timeout="20">
        <cftransaction>
            <cfinclude template="add_creditcard_revenue_ic.cfm">
            <cfif not isdefined('xml_import')>
                <!--- Belge No update ediliyor --->
                <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN3#">
                    UPDATE 
                        GENERAL_PAPERS
                    SET
                        CREDITCARD_REVENUE_NUMBER = #paper_number#
                    WHERE
                        CREDITCARD_REVENUE_NUMBER IS NOT NULL
                </cfquery>
            </cfif>
            <!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
            <cf_workcube_process_cat 
                process_cat="#attributes.process_cat#"
                action_id = #MAX_ID.IDENTITYCOL#
                is_action_file = 1
                action_db_type = '#dsn3#'
                action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue&event=upd&id=#MAX_ID.IDENTITYCOL#'
                action_file_name='#get_process_type.action_file_name#'
                is_template_action_file = '#get_process_type.action_file_from_template#'>
                <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name= "Kredi Kartı Tahsilatı" paper_no= "#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.process_type#" data_source="#dsn3#">
        </cftransaction>
    </cflock>
</cfif>
<cfif not isdefined('xml_import')>
	<script type="text/javascript">
		<cfif isdefined("attributes.is_from_payroll")>
			window.opener.payment_with_voucher.creditcard_revenue_id.value = <cfoutput>#MAX_ID.IDENTITYCOL#</cfoutput>;
			window.opener.payment_with_voucher.submit();
			window.close();
		<cfelseif isdefined("attributes.is_from_payroll_revenue")> 
			window.opener.add_voucher_action.creditcard_revenue_id.value = <cfoutput>#MAX_ID.IDENTITYCOL#</cfoutput>;
			window.opener.add_voucher_action.submit();
			window.close();
		<cfelseif isdefined("attributes.is_list_company_extre")>
			window.opener.opener.list_ekstre.submit();
			window.opener.close();
			window.close();
		<cfelse>
			<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.action_from_company_id) or len(attributes.cons_id))>
				window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
		        window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.action_from_company_id#&consumer_id=#attributes.cons_id#&money_type=#attributes.money_type#&row_action_id=#MAX_ID.IDENTITYCOL#&row_action_type=#process_type#</cfoutput>','page');
			<cfelse>
				window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
				//wrk_opener_reload();
			</cfif>	
			window.close();
		</cfif>
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
