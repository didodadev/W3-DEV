<!---
Kredi Kartı tahsilat sanal pos sayfasıdır,
formdan gelen bilgilerle banka tipine göre online gerçek pos işlemi yapılır,
bankadan onay alınmış bir işlemse kredi kartı tahsilat hareketi yapıcak...
Ayşenur 20060310
Finans tek ödeme ekranındakine benzer bir sayfadır fakat burası dinamik oldugu için ayrıldı,son kullanıcı fiyatı vs bişeyler var
--->
<cfif isDefined("attributes.lim_action_to_account_id") and attributes.paymethod_type eq 4><!--- limit aşımını kredi kartıyla seçeneğinden gelen değişkenler standartlarla eşitleniyor --->
	<cfscript>
		attributes.action_to_account_id = attributes.lim_action_to_account_id;
		attributes.card_no = attributes.lim_card_no;
		attributes.card_owner = attributes.lim_card_owner;
		attributes.cvv_no = attributes.lim_cvv_no;
		attributes.exp_month = attributes.lim_exp_month;
		attributes.exp_year = attributes.lim_exp_year;
		attributes.sales_credit = attributes.lim_sales_credit;
		attributes.sales_credit_dsp = attributes.lim_sales_credit_dsp;
		if(isDefined("attributes.lim_joker_vada"))
			attributes.sales_credit_dsp = attributes.lim_sales_credit_dsp;
	</cfscript>
</cfif>
<cfquery name="get_process_type_rev" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT
	FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_rev#">
</cfquery>
<cfscript>
	process_type_rev = get_process_type_rev.process_type;
	is_cari_rev = get_process_type_rev.is_cari;
	is_account_rev = get_process_type_rev.is_account;
	expire_month = RepeatString("0",2-Len(attributes.exp_month)) & attributes.exp_month;
	expire_year = Right(attributes.exp_year,2);
</cfscript>
<cfif is_account_rev eq 1>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		<cfset my_acc_result = get_company_period(attributes.company_id,session_base.period_id)>
	<cfelse>
		<cfset my_acc_result = get_consumer_period(attributes.consumer_id,session_base.period_id)>
	</cfif>
	<cfif not len(my_acc_result)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1295.Muhasebe Hesaplarınız Tanımlanmamıştır Lütfen Müşteri Hizmetlerine Başvurunuz'>!");
			window.location.href='<cfoutput>http://#cgi.http_host#/#request.self#?fuseaction=objects2.welcome</cfoutput>';
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset payment_type_id = trim(ListGetAt(attributes.action_to_account_id,3,";"))>
<cfquery name="GET_TAKS_METHOD" datasource="#DSN3#">
	SELECT NUMBER_OF_INSTALMENT,ACCOUNT_CODE,CARD_NO,VFT_CODE,COMPANY_ID FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#payment_type_id#">
</cfquery>
<cfif not len(GET_TAKS_METHOD.ACCOUNT_CODE)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1296.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Seçilmemiştir Lütfen Müşteri Hizmetlerine Başvurunuz'>!");
		window.location.href='<cfoutput>http://#cgi.http_host#/#request.self#?fuseaction=objects2.popup_add_online_pos</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif len(get_taks_method.number_of_instalment) and get_taks_method.number_of_instalment neq 0>
	<cfset taksit_sayisi = get_taks_method.number_of_instalment>
<cfelse>
	<cfset taksit_sayisi = 0>
</cfif>
<cfset vft_code = ""><!--- yapıkredide vft(vade farklı taksitli satış) koda göre bankaya gönderimde kullanılıyor --->
<cfif len(GET_TAKS_METHOD.VFT_CODE)>
	<cfset vft_code = GET_TAKS_METHOD.VFT_CODE>
</cfif>
<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_COMPANY_INFO" datasource="#DSN#">
		SELECT NICKNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<cfset attributes.firma_info = GET_COMPANY_INFO.NICKNAME>
	<cfset member_code = GET_COMPANY_INFO.MEMBER_CODE>
<cfelse>
	<cfquery name="GET_CONSUMER_INFO" datasource="#DSN#">
		SELECT CONSUMER_NAME,CONSUMER_SURNAME,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	<cfset attributes.firma_info = GET_CONSUMER_INFO.CONSUMER_NAME & ' ' & GET_CONSUMER_INFO.CONSUMER_SURNAME>
	<cfset member_code = GET_CONSUMER_INFO.MEMBER_CODE>
</cfif>
<cfif session_base.is_order_closed eq 0>
	<cfscript>
		wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'#session_base.userid#'&round(rand()*100);
		if(isDefined("attributes.is_price_standart"))//siparişte son kullanıcı fiyatı seçilmişse
			attributes.sales_credit = attributes.price_standart_last;
	</cfscript>

	<!---<cfinclude template="../../add_options/query/online_pos_files.cfm">--->
    <cfset response_code = 00>
	
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		<cflog text="#session_base.name# #session_base.surname#(#session_base.userid#)(Hızlı Sipariş:#attributes.company_id#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
	<cfelse>
		<cflog text="#session_base.name# #session_base.surname#(#session_base.userid#)(Hızlı Sipariş:#attributes.consumer_id#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
	</cfif>
	<cfif isDefined("ykb_inst_num")>
		<cfset attributes.action_detail = attributes.action_detail & ' ' & '(#ykb_inst_num# Taksit)'>
	</cfif>
	<cfif response_code eq 00><!--- onay almış ve para hesaba geçirilmiş bir işlemse--->
		<cftry>
			<cfinclude template="../finance/query/add_credit_card_revenue.cfm">
			<!--- 3. parti kurumlar üzerinden sanal pos çekiyor ise o firmaya ait dekont kaydı atıyor. 6 AYA SİLİNE 22102013
			<cfif action_to_account_id_first eq 0>
				<cf_papers paper_type="debit_claim">
				<cfquery name="GET_PROCESS_CAT_CLAIM_NOTE" datasource="#DSN3#">
					SELECT 
						PROCESS_CAT_ID,
						IS_CARI,
						IS_ACCOUNT,
						PROCESS_CAT,
						ACTION_FILE_NAME,
						ACTION_FILE_FROM_TEMPLATE 
					FROM 
						SETUP_PROCESS_CAT 
					WHERE 
						PROCESS_TYPE = 41 AND
						IS_ACCOUNT = 0
				</cfquery>
				<cfscript>
					process_type = 41;
					form.process_cat = GET_PROCESS_CAT_CLAIM_NOTE.PROCESS_CAT_ID;
					is_cari = GET_PROCESS_CAT_CLAIM_NOTE.is_cari;
					is_account = GET_PROCESS_CAT_CLAIM_NOTE.is_account;
					get_process_type.action_file_name = GET_PROCESS_CAT_CLAIM_NOTE.ACTION_FILE_NAME;
					get_process_type.action_file_from_template = GET_PROCESS_CAT_CLAIM_NOTE.ACTION_FILE_FROM_TEMPLATE;
					ACTION_CURRENCY_ID = session_base.money;
					attributes.action_value = attributes.sales_credit;
					attributes.money_type = process_money_type;
					form.money_type = process_money_type;
					attributes.project_name = '';
					attributes.project_id = '';
					if (len(currency_multiplier))
						attributes.other_cash_act_value = wrk_round(attributes.sales_credit/currency_multiplier);
					else
						attributes.other_cash_act_value = '';
					attributes.claim_company_id = GET_CREDIT_PAYMENT.company_id;
					attributes.action_detail = 'Kredi kartı tahsilatından gelen dekont.';
					attributes.action_account_code = GET_CREDIT_PAYMENT.ACCOUNT_CODE;
					attributes.action_date = attributes.action_date;
					attributes.paper_number = '#paper_code & '-' & paper_number#';
					attributes.system_amount = attributes.sales_credit;
					attributes.expense_center_1 = '';
					attributes.EXPENSE_CENTER_ID_1 = '';
					attributes.EXPENSE_ITEM_ID_1 = '';
					attributes.expense_item_name_1 = '';
					attributes.relation_action_type_id = 241;
					attributes.relation_action_id = GET_MAX_PAYMENT.max_id;
				</cfscript>
				<cfinclude template="../../ch/query/add_debit_claim_note_ic.cfm">
			</cfif>--->
			Tahsilat İşleminiz Yapılmıştır.<br/>
		<cfcatch>
			<cfset session_base.is_order_closed = 1>
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
				<cflog text="KK.Tah Kaydı Yapılamadı #session_base.name# #session_base.surname#(#session_base.userid#)(Hızlı Sipariş:#attributes.company_id#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
			<cfelse>
				<cflog text="KK.Tah Kaydı Yapılamadı #session_base.name# #session_base.surname#(#session_base.userid#)(Hızlı Sipariş:#attributes.consumer_id#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
			</cfif>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1431.Sanal POS İşleminiz Yapıldı!Fakat Sisteme Kredi Kartı Tahsilat Kaydı Yapılamamıştır,Lütfen Müşteri Hizmetlerine Başvurunuz'>!");
				<cfif isDefined("attributes.order_related")>//siparişten gelmiyorsa
					window.location.href='<cfoutput>http://#cgi.http_host#/#request.self#?fuseaction=objects2.view_list_order<cfif not isdefined("session.ep")>&zone=1</cfif>&form_submitted=1</cfoutput>';
				<cfelse>
					window.close();
				</cfif>
			</script>
		</cfcatch>
		</cftry>
	<cfelse>
		<cfset attributes.response_code = response_code>
		<cfinclude template="../finance/display/dsp_response_code.cfm">
	</cfif>
<cfelse>	
	<script type="text/javascript">
		alert("<cf_get_lang no ='1433.Sayfayı Yenileyemezsiniz'>!");
		window.location.href='<cfoutput>http://#cgi.http_host#/#request.self#?fuseaction=objects2.view_list_order<cfif not isdefined("session.ep")>&zone=1</cfif>&form_submitted=1</cfoutput>';
	</script>
</cfif>
