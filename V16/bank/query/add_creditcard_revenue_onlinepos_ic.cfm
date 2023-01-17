<cfif isDefined("attributes.subs_inv_id")><!--- provizyon ilişkili işlemler için --->
	<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
		UPDATE
			SUBSCRIPTION_PAYMENT_PLAN_ROW
		SET
			IS_PAID = 1,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			INVOICE_ID = #attributes.subs_inv_id# AND
			PERIOD_ID = #attributes.period_id#
	</cfquery>
</cfif>
<cfscript>
	action_to_account_id_first = listfirst(attributes.action_to_account_id,';');
	account_currency_id = listgetat(attributes.action_to_account_id,2,';');
	payment_type_id = listgetat(attributes.action_to_account_id,3,';');

	currency_multiplier = '';
	currency_multiplier_2 = '';
	currency_multiplier_other = '';//komisyonlarda dekont eklemek için
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
	{
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
				currency_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');			
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.money_type)
				currency_multiplier_other = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');			
		}
	}
	if (not isdefined("attributes.project_id"))//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
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
		NUMBER_OF_INSTALMENT, 
		P_TO_INSTALMENT_ACCOUNT,
		ACCOUNT_CODE,
		SERVICE_RATE,
        PAYMENT_RATE,
        PAYMENT_RATE_ACC,
		IS_PESIN
	FROM 
		CREDITCARD_PAYMENT_TYPE 
	WHERE 
		PAYMENT_TYPE_ID = #payment_type_id#
</cfquery>
<cf_date tarih='attributes.action_date'>
<!--- Ödeme yöntemindeki hesaba geçiş gününe göre vade hesaplanıyor --->
<cfif get_credit_payment.recordcount and len(get_credit_payment.p_to_instalment_account)>
	<cfset due_date = dateadd("d",get_credit_payment.p_to_instalment_account,attributes.action_date)>
<cfelse>
	<cfset due_date = attributes.action_date>
</cfif> 
<cfif len(GET_CREDIT_PAYMENT.PAYMENT_RATE) and GET_CREDIT_PAYMENT.PAYMENT_RATE neq 0 and len(GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC)><!--- ödeme yönteminde komisyon varsa hesap seçilmişse komisyon kadar dekont kaydedilr --->
    <cfinclude template="add_debit_from_cc_revenue.cfm">
<cfelse>
	<cfset GET_MAX_CH.ACTION_ID = ''>
</cfif>
<cfif len(GET_CREDIT_PAYMENT.SERVICE_RATE) and GET_CREDIT_PAYMENT.SERVICE_RATE neq 0>
	<!--- ödeme yöntemindeki seçilen banka komisyon oranına göre komisyon oranı hesaplanır --->
	<cfset commission_multiplier_amount = wrk_round(attributes.sales_credit_comm * GET_CREDIT_PAYMENT.SERVICE_RATE /100)>
<cfelse>
	<cfset commission_multiplier_amount = 0>
</cfif>
<cfquery name="ADD_CREDIT_PAYMENT" datasource="#dsn3#" result="max_id">
	INSERT INTO
		CREDIT_CARD_BANK_PAYMENTS
		(
			PROCESS_CAT,
			ACTION_TYPE_ID,
			WRK_ID,
			PAYMENT_TYPE_ID,<!--- ödeme yöntemi --->
			NUMBER_OF_INSTALMENT,<!--- ödeme yöntemi taksit sayısı --->
			ACTION_TO_ACCOUNT_ID,<!--- ödeme yöntmiyle seçilen hesap --->
			ACTION_CURRENCY_ID,<!--- hesap para birimi --->
			ACTION_FROM_COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID,
			STORE_REPORT_DATE,<!--- işlem tarihi --->
			SALES_CREDIT,<!--- işlem tutarı --->
			COMMISSION_AMOUNT,<!--- ödeme yöntemindeki hizmet komisyon ORANIYLA yapılmış olan komsiyon tutarı--->
			OTHER_MONEY,
			OTHER_CASH_ACT_VALUE,
			ACTION_DETAIL,
			ACTION_TYPE,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			CARD_NO,
			CARD_OWNER,
			ACTION_PERIOD_ID,
            CARI_ACTION_ID,<!--- komisyondan kestiğimiz dekontun bilgisi --->
            CARI_ACTION_VALUE,
			PROJECT_ID,
            PAPER_NO,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			IS_ONLINE_POS<!---Sanal postandır bilgisi--->,
			TO_BRANCH_ID,
			WRK_ID_INVOICE,
            RETREFNUM
		)
		VALUES
		(
			#attributes.process_cat#,
			#process_type#,
			'#wrk_id#',
			#payment_type_id#,
			<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
			#action_to_account_id_first#,
			'#account_currency_id#',
			<cfif len(attributes.action_from_company_id)>#attributes.action_from_company_id#,<cfelse>NULL,</cfif>
			<cfif len(attributes.par_id)>#attributes.par_id#,<cfelse>NULL,</cfif>
			<cfif len(attributes.cons_id)>#attributes.cons_id#,<cfelse>NULL,</cfif>
			#attributes.action_date#,
			#attributes.sales_credit#,
			#commission_multiplier_amount#,
			<cfif len(money_type)>'#money_type#',<cfelse>NULL,</cfif>
			<cfif len(attributes.other_value_sales_credit)>#attributes.other_value_sales_credit#,<cfelse>NULL,</cfif>
			<cfif len(attributes.action_detail)>'#attributes.action_detail#',<cfelse>NULL,</cfif>
			'KREDİ KARTI TAHSİLAT (S.P)',
			<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
			<cfif isdefined('content') and len(content)>'#content#',<cfelse>NULL,</cfif>
			<cfif len(attributes.card_owner)>'#attributes.card_owner#',<cfelse>NULL,</cfif>
			#session.ep.period_id#,
            <cfif isDefined("GET_MAX_CH.ACTION_ID") and len(GET_MAX_CH.ACTION_ID)>#GET_MAX_CH.ACTION_ID#,<cfelse>NULL,</cfif>
            <cfif isDefined("GET_MAX_CH.ACTION_ID") and len(GET_MAX_CH.ACTION_ID)>#wrk_round(attributes.sales_credit - attributes.sales_credit_comm)#,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)>#attributes.project_id#,<cfelse>NULL,</cfif>
            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)>'#attributes.paper_number#',<cfelse>NULL,</cfif>
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#',
			1,
			#branch_id_info#,
			<cfif isdefined("wrk_id_invoice") and len(wrk_id_invoice)>'#wrk_id_invoice#'<cfelse>NULL</cfif>,
            <cfif isdefined("response_retrefnum") and len(response_retrefnum)>'#response_retrefnum#'<cfelse>NULL</cfif>
		)
</cfquery>
<cftry>
	<cfcatch type="any">
		<cfquery name="GET_MAX_PAYMENT" datasource="#dsn3#">
			SELECT CREDITCARD_PAYMENT_ID AS MAX_ID FROM CREDIT_CARD_BANK_PAYMENTS WHERE WRK_ID = '#wrk_id#'
		</cfquery>
	</cfcatch>
</cftry>
<cfquery name="GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN3#">
	SELECT 
		SALES_CREDIT,
		COMMISSION_AMOUNT,
		PAYMENT_TYPE_ID,
		STORE_REPORT_DATE,
		CREDITCARD_PAYMENT_ID
	FROM 
		CREDIT_CARD_BANK_PAYMENTS 
	WHERE 
		CREDITCARD_PAYMENT_ID = #MAX_ID.IDENTITYCOL#
</cfquery>

<!--- işlem tarihi üstüne hesaba geçiş tarihi eklenerek rowlara yazılır --->
<cfset bank_action_date = dateadd("d", GET_CREDIT_PAYMENT.P_TO_INSTALMENT_ACCOUNT,GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)>
<cfif (GET_CREDIT_PAYMENT.IS_PESIN eq 1) or (not len(GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)) or (GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT eq 0)>
	<cfset satir_sayisi = 1>
	<cfset operation_type = 'Peşin Giriş'>
	<cfset tutar = GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT>
	<cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
		<cfset komsiyon_tutar = GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT>
	<cfelse>
		<cfset komsiyon_tutar = 0>
	</cfif>
<cfelse>
	<cfset satir_sayisi = GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT>
	<cfset tutar = (GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
	<cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
		<cfset komsiyon_tutar = (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
	<cfelse>
		<cfset komsiyon_tutar = 0>
	</cfif>
</cfif>

<cfset average_day = 0><!--- vade gun hesaplama taksitlere gore ortalama vade hesapliyor --->
<cfloop from="1" to="#satir_sayisi#" index="i">
    <cfset average_day = average_day+datediff("d",due_date,bank_action_date)>
	<cfquery name="ADD_CREDIT_CARD_BANK_PAYMENT_ROWS" datasource="#dsn3#">
		INSERT
		INTO
			CREDIT_CARD_BANK_PAYMENTS_ROWS
			(
				STORE_REPORT_DATE,<!--- tahsilat işlem tarihi --->
				BANK_ACTION_DATE,<!--- hesaba geçiş tarihi --->
				CREDITCARD_PAYMENT_ID,<!--- tahsilat id si --->
				PAYMENT_TYPE_ID,<!--- ödeme yöntemi id si --->
				OPERATION_NAME,
				AMOUNT,<!--- işlem tutarı --->
				COMMISSION_AMOUNT<!--- komsiyon tutarı --->
			)
		VALUES
			(
				#CreateODBCDateTime(GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)#,
				#bank_action_date#,
				#GET_CREDIT_CARD_BANK_PAYMENT.CREDITCARD_PAYMENT_ID#,
				#GET_CREDIT_CARD_BANK_PAYMENT.PAYMENT_TYPE_ID#,
				<cfif isDefined("operation_type")>'#operation_type#'<cfelse>'#i#. Taksit'</cfif>,
				#tutar#,
				#komsiyon_tutar#
			)
	</cfquery>
	<cfset bank_action_date = dateadd("m",1,bank_action_date)>
</cfloop>

<cfset average_day = ceiling(average_day/satir_sayisi)>

<!--- cari muhasebe işlemleri --->
<cfscript>
	currency_multiplier = '';
	paper_currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if( evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	if (is_cari eq 1)
	{        
		average_due_date = dateadd("d",average_day,due_date);//ortalama vade tarihi taksitlere gore hesaplanir
		
		if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name))
			project_id_info = attributes.project_id;
		else
			project_id_info = '';
		carici(
			action_id : MAX_ID.IDENTITYCOL,
			action_table : 'CREDIT_CARD_BANK_PAYMENTS',
			workcube_process_type : process_type,
			process_cat : form.process_cat,
			islem_tarihi : attributes.action_date,
			islem_belge_no : attributes.paper_number,
			due_date : average_due_date,
			to_account_id : action_to_account_id_first,
			islem_tutari : attributes.system_amount,
			action_currency : session.ep.money,
			other_money_value : iif(len(form.other_value_sales_credit),'form.other_value_sales_credit',de('')),
			other_money : form.money_type,
			currency_multiplier : currency_multiplier,
			islem_detay : 'KREDİ KARTI TAHSİLAT (S.P)',
			action_detail : attributes.action_detail,
			account_card_type : 13,
			project_id : project_id_info,
			cari_db : dsn3,
			from_cmp_id : ACTION_FROM_COMPANY_ID,
			from_consumer_id : attributes.cons_id,
			to_branch_id : branch_id_info,
			rate2:paper_currency_multiplier
			);
	}
	if (is_account eq 1)
	{
			if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.ACTION_DETAIL#';
			else
				str_card_detail = 'KREDİ KARTI TAHSİLAT';
		
		muhasebeci (
			wrk_id : wrk_id,
			action_id: MAX_ID.IDENTITYCOL,
			workcube_process_type: process_type,
			workcube_process_cat:form.process_cat,
			account_card_type: 13,
			islem_tarihi: attributes.ACTION_DATE,
			fis_satir_detay: str_card_detail,
			company_id : ACTION_FROM_COMPANY_ID,
			consumer_id : attributes.cons_id,
			borc_hesaplar: GET_CREDIT_PAYMENT.account_code,
			borc_tutarlar: attributes.system_amount,
			other_amount_borc : attributes.system_amount,
			other_currency_borc : session.ep.money,
			alacak_hesaplar: MY_ACC_RESULT,
			alacak_tutarlar: attributes.system_amount,
			other_amount_alacak : iif(len(form.other_value_sales_credit),'form.other_value_sales_credit',de('')),
			other_currency_alacak : form.money_type,
			currency_multiplier : currency_multiplier,
			muhasebe_db : dsn3,
			fis_detay: 'KREDİ KARTI TAHSİLAT (S.P)',
			to_branch_id : branch_id_info,
			acc_project_id : project_id_info
		);
	}
	f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'CREDIT_CARD_BANK_PAYMENT_MONEY',action_table_dsn:'#dsn3#');	
</cfscript>
<cfif isDefined("attributes.subs_inv_id")><!--- provizyon ilişkili işlemler için --->
	<cfquery name="get_cari_rows" datasource="#dsn3#">
		SELECT CARI_ACTION_ID,ACTION_TYPE_ID,ACTION_ID,ACTION_TABLE FROM #dsn2_alias#.CARI_ROWS WHERE ACTION_ID = #MAX_ID.IDENTITYCOL# AND ACTION_TYPE_ID = #process_type#
	</cfquery>
	<cfif get_cari_rows.recordcount>
		<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
			UPDATE
				SUBSCRIPTION_PAYMENT_PLAN_ROW
			SET
				CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
				CARI_PERIOD_ID = #session.ep.period_id#,
				CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
				CARI_ACT_ID = #get_cari_rows.action_id#,
				CARI_ACT_TABLE = '#get_cari_rows.action_table#'
			WHERE
				INVOICE_ID = #attributes.subs_inv_id# AND
				PERIOD_ID = #attributes.period_id#
		</cfquery>
	</cfif>
	<!--- fatura ile kredi karti tahsilati arasindaki iliski tutuluyor, CREDITCARD_PAYMENT_ID kredi karti tahsilati ilskisini faturada tutuyor --->
    <cfif isdefined("new_dsn2")>
    	<cfset dsn_new2_alias = '#new_dsn2#'>
    <cfelseif isdefined("dsn2_alias_")>
    	<cfset dsn_new2_alias = dsn2_alias_>
    </cfif>  
    <cfif len(dsn_new2_alias)>  
        <cfquery name="upd_invoice" datasource="#dsn3#">
            UPDATE #dsn_new2_alias#.INVOICE SET CREDITCARD_PAYMENT_ID = #GET_CREDIT_CARD_BANK_PAYMENT.CREDITCARD_PAYMENT_ID# WHERE INVOICE_ID = #attributes.subs_inv_id#
        </cfquery>
    </cfif>
    <!--- fatura ile kredi karti tahsilati arasindaki iliski tutuluyor --->
</cfif>

