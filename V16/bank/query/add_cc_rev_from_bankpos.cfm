<!---select ifadeleri düzenlendi e.a 23.07.2012--->
<cf_date tarih='attributes.action_date'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
</cfquery>
<cfscript>
	process_type = get_process_type.process_type;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
	action_to_account_id_first = listfirst(attributes.action_to_account_id,';');
	payment_type_id = listgetat(attributes.action_to_account_id,3,';');
	account_currency_id = listgetat(attributes.action_to_account_id,2,';');
	branch_id = listgetat(attributes.action_to_account_id,4,';');
</cfscript>
<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#"><!--- Seçilen ödeme yönteminin detay bilgileri --->
	SELECT 
		PAYMENT_TYPE_ID, 
		NUMBER_OF_INSTALMENT, 
		P_TO_INSTALMENT_ACCOUNT,
		ACCOUNT_CODE,
		SERVICE_RATE,
		IS_PESIN
	FROM 
		CREDITCARD_PAYMENT_TYPE 
	WHERE 
		PAYMENT_TYPE_ID = #payment_type_id#
</cfquery>
<cfif not len(GET_CREDIT_PAYMENT.ACCOUNT_CODE)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='394.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Secilmemiş'>!");
		history.back();	
	</script>
	<cfabort>
</cfif>
<!--- Ödeme yöntemindeki hesaba geçiş gününe göre vade hesaplanıyor --->
<cfif get_credit_payment.recordcount and len(get_credit_payment.p_to_instalment_account)>
	<cfset due_date = dateadd("d",get_credit_payment.p_to_instalment_account,attributes.action_date)>
<cfelse>
	<cfset due_date = attributes.action_date>
</cfif> 
<cfif isDefined("attributes.checked_value") and len(attributes.checked_value)>
	<cfquery name="GET_BANK_POS_ROWS" datasource="#dsn2#">
		SELECT 
			FILE_IMPORT_BANK_POS_ROW_ID,
			FILE_IMPORT_ID,
			SELLER_CODE,
			TERMINAL_NO,
			VALOR_DATE,
			NUMBER_OF_INSTALMENT,
			COMMISSION,
			CARI_TUTAR,
			CC_REVENUE_ID,
			CC_REVENUE_PERIOD_ID,
			MONEY2_MULTIPLIER,
			IS_CANCEL
		FROM 
			FILE_IMPORT_BANK_POS_ROWS 
		WHERE 
			FILE_IMPORT_BANK_POS_ROW_ID IN (#attributes.checked_value#) AND 
			CC_REVENUE_ID IS NULL
	</cfquery>
	<cfoutput query="GET_BANK_POS_ROWS">
		<cfquery name="GET_POS_INFO" datasource="#dsn3#">
			SELECT COMPANY_ID,EQUIPMENT FROM POS_EQUIPMENT_BANK WHERE SELLER_CODE = '#GET_BANK_POS_ROWS.SELLER_CODE#'<!---  AND POS_CODE = '#GET_BANK_POS_ROWS.TERMINAL_NO#' --->
		</cfquery>
		<cfif is_account eq 1>
			<cfset my_acc_result = get_company_period(GET_POS_INFO.COMPANY_ID)>
			<cfif not len(my_acc_result)>
				<script type="text/javascript">
					alert("<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>");
					history.back();	
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfif len(GET_CREDIT_PAYMENT.SERVICE_RATE) and GET_CREDIT_PAYMENT.SERVICE_RATE neq 0><!--- ödeme yöntemindeki seçilen banka komisyon çarpanına göre komisyon oranı hesaplanır --->
			<cfset commission_multiplier_amount = wrk_round(GET_BANK_POS_ROWS.CARI_TUTAR * GET_CREDIT_PAYMENT.SERVICE_RATE /100)>
		<cfelse>
			<cfset commission_multiplier_amount = 0>
		</cfif>
		<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
		<cfset currency_multiplier = GET_BANK_POS_ROWS.MONEY2_MULTIPLIER>
		<cftry>
			<cflock name="#CreateUUID()#" timeout="60">
				<cftransaction>
					<cfquery name="ADD_CC_BANK_PAY" datasource="#dsn2#" result="MAX_ID">
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
								STORE_REPORT_DATE,<!--- işlem tarihi --->
								SALES_CREDIT,<!--- işlem tutarı --->
								COMMISSION_AMOUNT,<!--- ödeme yöntemindeki hizmet komisyon ORANIYLA yapılmış olan komsiyon tutarı--->
								OTHER_MONEY,
								OTHER_CASH_ACT_VALUE,
								ACTION_DETAIL,
								ACTION_TYPE,
								IS_ACCOUNT,
								IS_ACCOUNT_TYPE,
								FILE_IMPORT_ID,
								ACTION_PERIOD_ID,
								RECORD_EMP,
								RECORD_DATE,
								RECORD_IP,
								TO_BRANCH_ID
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
								#GET_POS_INFO.COMPANY_ID#,
								#attributes.action_date#,
								#GET_BANK_POS_ROWS.CARI_TUTAR#,
								#commission_multiplier_amount#,
								'#session.ep.money2#',
								#wrk_round(GET_BANK_POS_ROWS.CARI_TUTAR/currency_multiplier)#,
								'#GET_POS_INFO.EQUIPMENT#',
								<cfif process_type eq 241>'KREDİ KARTI TAHSİLAT(F.P)',<cfelse>'KREDİ KARTI TAHSİLAT İPTAL(F.P)',</cfif>
								<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
								#GET_BANK_POS_ROWS.FILE_IMPORT_ID#,
								#session.ep.period_id#,
								#session.ep.userid#,
								#now()#,
								'#cgi.remote_addr#',
								#ListGetAt(session.ep.user_location,2,"-")#
							)
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
							CREDITCARD_PAYMENT_ID = #MAX_ID.IDENTITYCOL#
					</cfquery>
					<!--- işlem tarihi üstüne hesaba geçiş tarihi eklenerek rowlara yazılır ,burda belgedeki valor tarihinden hesaplama yapılmaktadır
					<cfset bank_action_date = dateadd("d", GET_CREDIT_PAYMENT.P_TO_INSTALMENT_ACCOUNT,GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)>--->
					<cfset bank_action_date = GET_BANK_POS_ROWS.VALOR_DATE>
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
									#CreateODBCDateTime(bank_action_date)#,
									#GET_CREDIT_CARD_BANK_PAYMENT.CREDITCARD_PAYMENT_ID#,
									#GET_CREDIT_CARD_BANK_PAYMENT.PAYMENT_TYPE_ID#,
									<cfif isDefined("operation_type")>'#operation_type#'<cfelse>'#i#. Taksit'</cfif>,
									#tutar#,
									#komisyon_tutar#
								)
						</cfquery>
						<cfset bank_action_date = dateadd("m",1,bank_action_date)>
					</cfloop>
					<!--- cari muhasebe işlemleri --->
					<cfscript>
						if (is_cari eq 1)//Sadece sistem para birimi işlemi yapıck
						{
							if (process_type eq 241)//kredi kartı tahsilat
							{
								carici(
									action_id : MAX_ID.IDENTITYCOL,
									action_table : 'CREDIT_CARD_BANK_PAYMENTS',
									workcube_process_type : process_type,
									process_cat : attributes.process_cat,
									islem_tarihi : attributes.action_date,
									due_date : due_date,
									to_account_id : action_to_account_id_first,
									to_branch_id : branch_id,
									islem_tutari : GET_BANK_POS_ROWS.CARI_TUTAR,
									action_currency : session.ep.money,
									other_money_value : wrk_round(GET_BANK_POS_ROWS.CARI_TUTAR/currency_multiplier),
									other_money : session.ep.money2,
									islem_detay : 'KREDİ KARTI TAHSİLAT(F.P)',
									action_detail : GET_POS_INFO.EQUIPMENT,
									account_card_type : 13,
									from_cmp_id : GET_POS_INFO.COMPANY_ID,
									currency_multiplier : currency_multiplier,
									rate2:currency_multiplier
									);
							}
							else//kredi kartı tahsilat iptal
							{
								carici(
									action_id : MAX_ID.IDENTITYCOL,
									action_table : 'CREDIT_CARD_BANK_PAYMENTS',
									workcube_process_type : process_type,
									process_cat : attributes.process_cat,
									islem_tarihi : attributes.action_date,
									due_date : due_date,
									from_account_id : action_to_account_id_first,
									from_branch_id : branch_id,
									islem_tutari : GET_BANK_POS_ROWS.CARI_TUTAR,
									action_currency : session.ep.money,
									other_money_value : wrk_round(GET_BANK_POS_ROWS.CARI_TUTAR/currency_multiplier),
									other_money : session.ep.money2,
									islem_detay : 'KREDİ KARTI TAHSİLAT İPTAL(F.P)',
									action_detail : GET_POS_INFO.EQUIPMENT,
									account_card_type : 13,
									to_cmp_id : GET_POS_INFO.COMPANY_ID,
									currency_multiplier : currency_multiplier,
									rate2:currency_multiplier
									);
							}
						}
						if (is_account eq 1)
						{							
							if (process_type eq 241)//kredi kartı tahsilat
							{
								muhasebeci (
									wrk_id : wrk_id,
									action_id: MAX_ID.IDENTITYCOL,
									workcube_process_type: process_type,
									workcube_process_cat:attributes.process_cat,
									account_card_type: 13,
									islem_tarihi: attributes.action_date,
									fis_satir_detay: GET_POS_INFO.EQUIPMENT,
									company_id : GET_POS_INFO.COMPANY_ID,
									borc_hesaplar: GET_CREDIT_PAYMENT.ACCOUNT_CODE,
									borc_tutarlar: GET_BANK_POS_ROWS.CARI_TUTAR,
									alacak_hesaplar: MY_ACC_RESULT,
									alacak_tutarlar: GET_BANK_POS_ROWS.CARI_TUTAR,
									action_currency : session.ep.money,
									other_amount_borc : GET_BANK_POS_ROWS.CARI_TUTAR,
									other_currency_borc : session.ep.money,
									other_amount_alacak : wrk_round(GET_BANK_POS_ROWS.CARI_TUTAR/currency_multiplier),
									other_currency_alacak : session.ep.money2,
									currency_multiplier : currency_multiplier,
									to_branch_id : branch_id,
									fis_detay : 'KREDİ KARTI TAHSİLAT(F.P)'
									);
							}
							else//kredi kartı tahsilat iptal
							{
								muhasebeci (
									wrk_id : wrk_id,
									action_id: MAX_ID.IDENTITYCOL,
									workcube_process_type: process_type,
									workcube_process_cat: attributes.process_cat,
									account_card_type: 13,
									islem_tarihi: attributes.action_date,
									fis_satir_detay: GET_POS_INFO.EQUIPMENT,
									company_id : GET_POS_INFO.COMPANY_ID,
									borc_hesaplar: MY_ACC_RESULT,
									borc_tutarlar: GET_BANK_POS_ROWS.CARI_TUTAR,
									alacak_hesaplar: GET_CREDIT_PAYMENT.ACCOUNT_CODE,
									alacak_tutarlar: GET_BANK_POS_ROWS.CARI_TUTAR,
									action_currency : session.ep.money,
									other_amount_borc : wrk_round(GET_BANK_POS_ROWS.CARI_TUTAR/currency_multiplier),
									other_currency_borc : session.ep.money2,
									other_amount_alacak : GET_BANK_POS_ROWS.CARI_TUTAR,
									other_currency_alacak : session.ep.money,
									currency_multiplier : currency_multiplier,
									from_branch_id : branch_id,
									fis_detay : 'KREDİ KARTI TAHSİLAT İPTAL(F.P)'
									);
							}
						}
					</cfscript>
					<cfif GET_MONEY_INFO.recordcount>
						<cfloop query="GET_MONEY_INFO">
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
									#MAX_ID.IDENTITYCOL#,
									'#GET_MONEY_INFO.MONEY#',
									<cfif GET_MONEY_INFO.MONEY eq session.ep.money2>#GET_BANK_POS_ROWS.MONEY2_MULTIPLIER#,<cfelse>#GET_MONEY_INFO.RATE2#,</cfif>
									#GET_MONEY_INFO.RATE1#,
									<cfif GET_MONEY_INFO.MONEY eq session.ep.money2>1<cfelse>0</cfif>
								)
							</cfquery>
						</cfloop>
					</cfif>
					<cfquery name="UPD_BANK_POS_ROW" datasource="#dsn2#">
						UPDATE
							FILE_IMPORT_BANK_POS_ROWS
						SET
							CC_REVENUE_ID = #MAX_ID.IDENTITYCOL#,
							CC_REVENUE_PERIOD_ID = #session.ep.period_id#
						WHERE
							FILE_IMPORT_BANK_POS_ROW_ID = #GET_BANK_POS_ROWS.FILE_IMPORT_BANK_POS_ROW_ID#
					</cfquery>
				</cftransaction>
			</cflock>
			<cfcatch>
				İşyeri No : #GET_BANK_POS_ROWS.SELLER_CODE#&nbsp; Terminal No : #GET_BANK_POS_ROWS.TERMINAL_NO# Satır Yazılamadı!
			</cfcatch>
		</cftry>
	</cfoutput>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
