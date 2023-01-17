<cf_get_lang_set module_name="objects2"><!--- sayfanin en altinda kapanisi var --->
<!--- Kredi kartı tahsilat kayıt sayfasıdır, sanal pos tan yapılan kayıtlar için...Aysenur 20060401--->
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_rev#">
</cfquery>
<cfquery name="GET_CREDIT_MONEY" datasource="#dsn#"><!--- üye risk bilgierlndeki seçili para birimine göre --->
	SELECT
	<cfif session_base.period_year lt 2009>
		CASE WHEN(MONEY_TYPE = 'TL') THEN 'YTL' ELSE MONEY_TYPE END AS MONEY_TYPE
	<cfelse>
		CASE WHEN(MONEY_TYPE = 'YTL') THEN 'TL' ELSE MONEY_TYPE END AS MONEY_TYPE
	</cfif>	
	FROM
		COMPANY_CREDIT_MONEY
	WHERE
		IS_SELECTED = 1 AND
		ACTION_ID = (SELECT
						COMPANY_CREDIT_ID
					FROM
						COMPANY_CREDIT
					WHERE
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
						<cfelse>
							CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
						</cfif>
						OUR_COMPANY_ID = <cfif isDefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"></cfif>
					)
</cfquery>
<cfif len(GET_CREDIT_MONEY.MONEY_TYPE)>
	<cfset process_money_type = GET_CREDIT_MONEY.MONEY_TYPE>
<cfelse>
	<cfset process_money_type = session_base.money2>
</cfif>
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT 
		MONEY,
		RATE1,
	<cfif isDefined("session.pp")>
		RATEPP2 RATE2
	<cfelseif isDefined("session.ww")>
		RATEWW2 RATE2
	<cfelse>
		RATE2
	</cfif>
	FROM
		SETUP_MONEY
</cfquery>
<cfscript>
	action_to_account_id_first = listfirst(attributes.action_to_account_id,';');
	account_currency_id = listgetat(attributes.action_to_account_id,2,';');
	payment_type_id = listgetat(attributes.action_to_account_id,3,';');
	branch_id = listgetat(attributes.action_to_account_id,5,';');

	if(isDefined("attributes.company_id") and len(attributes.company_id))
		key_type = attributes.company_id;
	else if (len(attributes.consumer_id))
		key_type = attributes.consumer_id;
	
	if(len(attributes.card_no))
	{
		/* FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi.Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir */
		getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
		getCCNOKey.dsn = dsn;
		getCCNOKey1 = getCCNOKey.getCCNOKey1();
		getCCNOKey2 = getCCNOKey.getCCNOKey2();
		
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
	currency_multiplier = "";
	currency_multiplier_money2 = "";	
	//attributes.sales_credit = filterNum(attributes.sales_credit);
</cfscript>

<cfoutput query="GET_MONEY_INFO">
	<cfif GET_MONEY_INFO.MONEY eq process_money_type>
		<cfset currency_multiplier = wrk_round(GET_MONEY_INFO.RATE2/GET_MONEY_INFO.RATE1,4)>
	</cfif>
	<cfif GET_MONEY_INFO.MONEY eq session_base.money2>
		<cfset currency_multiplier_money2 = wrk_round(GET_MONEY_INFO.RATE2/GET_MONEY_INFO.RATE1,4)>
	</cfif>
</cfoutput>

<cfif isDefined("attributes.campaign_id")><!--- kampanya ödeme yöntemi bilgileri --->
	<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#">
		SELECT 
			CPT.PAYMENT_TYPE_ID, 
			CPT.NUMBER_OF_INSTALMENT, 
			CP.DAY_TO_ACC P_TO_INSTALMENT_ACCOUNT,
			CPT.ACCOUNT_CODE,
			CP.COMMISSION_RATE SERVICE_RATE,
			CPT.IS_PESIN,
			CPT.COMPANY_ID
		FROM 
			CREDITCARD_PAYMENT_TYPE CPT,
			CAMPAIGN_PAYMETHODS CP
		WHERE 
			CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND
			CP.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#"> AND
			CPT.PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#payment_type_id#">
	</cfquery>
<cfelse>
	<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#">
		SELECT 
			PAYMENT_TYPE_ID, 
			NUMBER_OF_INSTALMENT, 
			P_TO_INSTALMENT_ACCOUNT,
			ACCOUNT_CODE,
			SERVICE_RATE,
			IS_PESIN,
			COMPANY_ID
		FROM 
			CREDITCARD_PAYMENT_TYPE
		WHERE 
			PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#payment_type_id#">
	</cfquery>
</cfif>

<cf_date tarih='attributes.action_date'>
<!--- Ödeme yöntemindeki hesaba geçiş gününe göre vade hesaplanıyor --->
<cfif get_credit_payment.recordcount and len(get_credit_payment.p_to_instalment_account)>
	<cfset due_date = date_add("d",get_credit_payment.p_to_instalment_account,attributes.action_date)>
<cfelse>
	<cfset due_date = attributes.action_date>
</cfif> 
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfif len(get_credit_payment.service_rate) and get_credit_payment.service_rate neq 0>
			<!--- ödeme yöntemindeki seçilen hizmet komisyon oranına göre komisyon oranı hesaplanır --->
			<cfset commission_multiplier_amount = wrk_round(attributes.sales_credit * get_credit_payment.service_rate /100)>
		<cfelse>
			<cfset commission_multiplier_amount = 0>
		</cfif>
		<cfquery name="ADD_CREDIT_PAYMENT" datasource="#dsn2#">
			INSERT INTO
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					WRK_ID,
					PAYMENT_TYPE_ID,<!--- ödeme yöntemi --->
					NUMBER_OF_INSTALMENT,<!--- ödeme yöntemi taksit sayısı --->
					ACTION_TO_ACCOUNT_ID,<!--- ödeme yöntmiyle seçilen hesap --->
					ACTION_CURRENCY_ID,<!--- hesap para birimi --->
					ACTION_FROM_COMPANY_ID,
					CONSUMER_ID,
					STORE_REPORT_DATE,<!--- işlem tarihi --->
					SALES_CREDIT,<!--- işlem tutarı --->
					COMMISSION_AMOUNT,<!--- ödeme yöntemindeki hizmet komisyon ORANIYLA yapılmış olan komsiyon tutarı--->
					OTHER_MONEY,
					CARD_NO,
					CARD_OWNER,
					OTHER_CASH_ACT_VALUE,
					ACTION_DETAIL,
					ACTION_TYPE,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					ACTION_PERIOD_ID,
					RECORD_PAR,
					RECORD_CONS,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP,
					IS_ONLINE_POS,<!---Sanal postandır bilgisi--->
					CAMPAIGN_ID,<!--- kampanyadan ödeme --->
                    RETREFNUM
				)
				VALUES
				(
					#attributes.process_cat_rev#,
					#process_type_rev#,
					'#wrk_id#',
					#payment_type_id#,
					<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
					#action_to_account_id_first#,
					'#account_currency_id#',
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
					<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
					#attributes.action_date#,
					#attributes.sales_credit#,
					#commission_multiplier_amount#,
					<cfif len(process_money_type)>'#process_money_type#',<cfelse>NULL,</cfif>
					<cfif len(attributes.card_no)>'#content#',<cfelse>NULL,</cfif>
					<cfif len(attributes.card_owner)>'#attributes.card_owner#',<cfelse>NULL,</cfif>
					<cfif len(currency_multiplier)>#wrk_round(attributes.sales_credit/currency_multiplier)#,<cfelse>NULL,</cfif>
					<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)>'#attributes.action_detail#',<cfelse>NULL,</cfif>
					'KREDİ KARTI TAHSİLAT',
					<cfif is_account_rev eq 1>1,13,<cfelse>0,13,</cfif>
					#session_base.period_id#,
					<cfif isDefined("session.pp.userid")>#session.pp.userid#,<cfelseif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
					<cfif isDefined("session.ww.userid")>#session.ww.userid#,<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
					<cfif isDefined("session.ep")>#session.ep.userid#,<cfelse>NULL,</cfif>
					#now()#,
					'#cgi.remote_addr#',
					1,
					<cfif isDefined("attributes.campaign_id")>#attributes.campaign_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("response_retrefnum") and len(response_retrefnum)>'#response_retrefnum#'<cfelse>NULL</cfif>
				)
        </cfquery>
		<cfquery name="GET_MAX_PAYMENT" datasource="#dsn2#">
			SELECT MAX(CREDITCARD_PAYMENT_ID) AS MAX_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
		</cfquery>
		<cfquery name="GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN2#">
			SELECT 
				SALES_CREDIT,
				COMMISSION_AMOUNT,
				PAYMENT_TYPE_ID,
				STORE_REPORT_DATE,
				CREDITCARD_PAYMENT_ID
			FROM 
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
			WHERE 
				CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_payment.max_id#">
		</cfquery>
		
		<!--- işlem tarihi üstüne hesaba geçiş tarihi eklenerek rowlara yazılır --->
		<cfset bank_action_date = date_add("d", GET_CREDIT_PAYMENT.P_TO_INSTALMENT_ACCOUNT,GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)>
		<cfif (GET_CREDIT_PAYMENT.IS_PESIN eq 1) or (not len(GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)) or (GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT eq 0)>
			<cfset satir_sayisi = 1>
			<cfset operation_type = 'Peşin Giriş'>
			<cfset tutar = GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT>
			<cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
				<cfset komisyon_tutar = GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT>
			<cfelse>
				<cfset komisyon_tutar = 0>
			</cfif>
		<cfelse>
			<cfset satir_sayisi = GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT>
			<cfset tutar = (GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
			<cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
				<cfset komisyon_tutar = (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
			<cfelse>
				<cfset komisyon_tutar = 0>
			</cfif>
		</cfif>
		
		<cfloop from="1" to="#satir_sayisi#" index="i">
			<cfquery name="ADD_CREDIT_CARD_BANK_PAYMENT_ROWS" datasource="#dsn2#">
				INSERT
				INTO
					#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
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
						#komisyon_tutar#
					)
			</cfquery>
			<cfset bank_action_date = date_add("m",1,bank_action_date)>
		</cfloop>
	<!--- cari muhasebe işlemleri --->
	
	<cfscript>
		if (is_cari_rev)//Sadece sistem para birimi işlemi yapıck
		{
			if(isdefined('is_comission_total_amount_') and is_comission_total_amount_ eq 1)
				islem_tutari_ = attributes.cari_sales_credit;
			else
				islem_tutari_ = attributes.sales_credit;
				
			carici(
				action_id : GET_MAX_PAYMENT.max_id,
				action_table : 'CREDIT_CARD_BANK_PAYMENTS',
				workcube_process_type : process_type_rev,
				process_cat : attributes.process_cat_rev,
				islem_tarihi : attributes.action_date,
				due_date : due_date,
				to_account_id : action_to_account_id_first,
				to_branch_id : branch_id,
				islem_tutari : islem_tutari_,
				action_currency : session_base.money,
				action_currency_2 : session_base.money2,
				other_money_value : iif(len(currency_multiplier),'#wrk_round(islem_tutari_/currency_multiplier)#',de('')),
				other_money : process_money_type,
				islem_detay : 'KREDİ KARTI TAHSİLAT',
				action_detail : attributes.action_detail,
				account_card_type : 13,
				from_cmp_id : attributes.company_id,
				from_consumer_id : attributes.consumer_id,
				currency_multiplier : currency_multiplier_money2,
				period_is_integrated : 1,
				rate2:currency_multiplier
				);
				
		}
		if (is_account_rev)
		{
			if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.ACTION_DETAIL#';
			else
				str_card_detail = 'KREDİ KARTI TAHSİLAT';
			
			muhasebeci (
					wrk_id : wrk_id,
					action_id: GET_MAX_PAYMENT.max_id,
					workcube_process_type: process_type_rev,
					workcube_process_cat:attributes.process_cat_rev,
					account_card_type: 13,
					islem_tarihi: attributes.ACTION_DATE,
					fis_satir_detay: str_card_detail,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					to_branch_id : branch_id,
					borc_hesaplar: GET_CREDIT_PAYMENT.account_code,
					borc_tutarlar: attributes.sales_credit,
					alacak_hesaplar: MY_ACC_RESULT,
					alacak_tutarlar: attributes.sales_credit,
					action_currency : session_base.money,
					action_currency_2 : session_base.money2,
					other_amount_borc : attributes.sales_credit,
					other_currency_borc : session_base.money,
					other_amount_alacak : iif(len(currency_multiplier),'#wrk_round(attributes.sales_credit/currency_multiplier)#',de('')),
					other_currency_alacak : process_money_type,
					currency_multiplier : currency_multiplier_money2,
					fis_detay: 'KREDİ KARTI TAHSİLAT',
					base_period_year : session_base.period_year,
					base_period_year_start :session_base.period_year,
					base_period_year_finish :session_base.period_year
				);
		}
		</cfscript>
		
		<cfif GET_MONEY_INFO.recordcount>
			<cfoutput query="GET_MONEY_INFO">
				<cfquery name="INSERT_MONEY_INFO" datasource="#dsn2#">
					INSERT INTO #dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						 #GET_MAX_PAYMENT.max_id#,
						'#GET_MONEY_INFO.MONEY#',
						 #GET_MONEY_INFO.RATE2#,
						 #GET_MONEY_INFO.RATE1#,
						<cfif GET_MONEY_INFO.MONEY eq process_money_type>1<cfelse>0</cfif>
					)
				</cfquery>
			</cfoutput>
		</cfif>
	</cftransaction>
</cflock>

<cfset cc_paym_id_info = GET_MAX_PAYMENT.max_id><!--- sipariş bilgisini set etmek için --->
<cfset session_base.is_order_closed = 1>

<form name="pop_gonder" action="" method="post">
	<cfoutput>
		<input type="hidden" name="cc_id" id="cc_id" value="#GET_MAX_PAYMENT.max_id#">
		<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
		<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
	</cfoutput>
</form>

<script type="text/javascript">
	alert("<cf_get_lang no ='1495.Tahsilat İşleminiz Yapıldı'>!");
	<cfif isDefined("attributes.is_view_pos_print") and attributes.is_view_pos_print eq 1><!--- tahsilat printi göster gösterme --->
		pop_gonder.action='<cfoutput>http://#cgi.http_host#/#request.self#?fuseaction=objects2.popup_add_online_pos_print</cfoutput>';
		pop_gonder.target='kredi_window_2';
		pop_gonder.submit();
	</cfif>
	<cfif not isDefined("attributes.order_related")>//siparişten gelmiyorsa
		window.close();
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->