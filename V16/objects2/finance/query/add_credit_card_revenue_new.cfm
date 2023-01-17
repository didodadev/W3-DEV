<cfquery name="GET_PROCESS_CAT_TAHSILAT" datasource="#DSN3#">
    SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE <cfif isDefined("session.pp")>IS_PARTNER = 1<cfelse>IS_PUBLIC = 1</cfif> AND PROCESS_TYPE = 241
</cfquery>

<cfquery name="GET_PROCESS_TYPE_REV" datasource="#DSN3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT
	FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PROCESS_CAT_TAHSILAT.PROCESS_CAT_ID#">
</cfquery>

<cfset process_type_rev = get_process_type_rev.process_type>
<cfset is_cari_rev = get_process_type_rev.is_cari>
<cfset is_account_rev = get_process_type_rev.is_account>


<cfquery name="GET_CREDIT_MONEY" datasource="#dsn#">
	SELECT
        MONEY_TYPE
	FROM
		COMPANY_CREDIT_MONEY
	WHERE
		IS_SELECTED = 1 AND
		ACTION_ID = (SELECT
						COMPANY_CREDIT_ID
					FROM
						COMPANY_CREDIT
					WHERE
						<cfif isDefined("session.pp.userid")>
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
						<cfelse>
							CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.company_id#"> AND
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

<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
    SELECT DISTINCT OCPR.POS_ID,
        ACCOUNTS.ACCOUNT_ID,
        ACCOUNTS.ACCOUNT_NAME,
        ACCOUNTS.ACCOUNT_CURRENCY_ID,
        CPT.PAYMENT_TYPE_ID,
        CPT.FIRST_INTEREST_RATE,
        CPT.CARD_NO,
        CPT.CARD_IMAGE,
        CPT.CARD_IMAGE_SERVER_ID,
        OCPR.POS_ID POS_TYPE,
        CPT.SERVICE_RATE,
        CPT.NUMBER_OF_INSTALMENT, 
        <cfif isdefined("session.pp.company_id")>
            CPT.COMMISSION_MULTIPLIER,
            CPT.COMMISSION_MULTIPLIER_DSP,
        <cfelse>
            CPT.PUBLIC_COMMISSION_MULTIPLIER COMMISSION_MULTIPLIER,
            CPT.PUBLIC_COM_MULTIPLIER_DSP COMMISSION_MULTIPLIER_DSP,
        </cfif>
        CPT.DUEDATE,
        CPT.VFT_CODE,
        CPT.VFT_RATE,
        OCPR.IS_SECURE
    FROM
        ACCOUNTS ACCOUNTS,
        CREDITCARD_PAYMENT_TYPE CPT,
        #dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
    WHERE
        (ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#"> OR ACCOUNT_CURRENCY_ID = 'TL') AND
        ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
        OCPR.POS_ID = CPT.POS_TYPE AND
        CPT.IS_ACTIVE = 1 AND
        ISNULL(CPT.IS_SPECIAL,0) <> 1 AND
        <cfif isdefined("session.pp.company_id")>
            CPT.IS_PARTNER = 1 AND
        <cfelse>
            CPT.IS_PUBLIC = 1 AND
        </cfif>
            CPT.POS_TYPE IS NOT NULL AND
            CPT.POS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_id#">
</cfquery>

<cfset action_to_account_id_first = GET_ACCOUNTS.ACCOUNT_ID>
<cfset account_currency_id = GET_ACCOUNTS.ACCOUNT_CURRENCY_ID>
<cfset payment_type_id = GET_ACCOUNTS.PAYMENT_TYPE_ID>
<cfset branch_id = 0>

<cfset currency_multiplier = "">
<cfset currency_multiplier_money2 = "">	

<cfoutput query="GET_MONEY_INFO">
	<cfif GET_MONEY_INFO.MONEY eq process_money_type>
		<cfset currency_multiplier = wrk_round(GET_MONEY_INFO.RATE2/GET_MONEY_INFO.RATE1,4)>
	</cfif>
	<cfif GET_MONEY_INFO.MONEY eq session_base.money2>
		<cfset currency_multiplier_money2 = wrk_round(GET_MONEY_INFO.RATE2/GET_MONEY_INFO.RATE1,4)>
	</cfif>
</cfoutput>

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

<cfset attributes.action_date = now()>

<!--- <cf_date tarih='attributes.action_date'> --->
<!--- Ödeme yöntemindeki hesaba geçiş gününe göre vade hesaplanıyor --->
<cfif get_credit_payment.recordcount and len(get_credit_payment.p_to_instalment_account)>
	<cfset due_date = date_add("d",get_credit_payment.p_to_instalment_account,attributes.action_date)>
<cfelse>
	<cfset due_date = attributes.action_date>
</cfif> 


<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
    <cfset my_acc_result = get_company_period(session.pp.company_id,session_base.period_id)>
        <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'#session_base.userid#'&round(rand()*100)>
		<cfif len(get_credit_payment.service_rate) and get_credit_payment.service_rate neq 0>
			<!--- ödeme yöntemindeki seçilen hizmet komisyon oranına göre komisyon oranı hesaplanır --->
			<cfset commission_multiplier_amount = wrk_round(net_total_ * get_credit_payment.service_rate /100)>
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
					#GET_PROCESS_CAT_TAHSILAT.PROCESS_CAT_ID#,
					#process_type_rev#,
					'#wrk_id#',
					#payment_type_id#,
					<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
					#action_to_account_id_first#,
					'#account_currency_id#',
					<cfif isDefined("session.pp.company_id") and len(session.pp.company_id)>#session.pp.company_id#,<cfelse>NULL,</cfif>
					<cfif isDefined("session.ww") and len(session.ww.userid)>#session.ww.userid#,<cfelse>NULL,</cfif>
					#attributes.action_date#,
					#net_total_#,
					#commission_multiplier_amount#,
					<cfif len(process_money_type)>'#process_money_type#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.card_no") and len(attributes.card_no)>'#content#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.card_owner") and len(attributes.card_owner)>'#attributes.card_owner#',<cfelse>NULL,</cfif>
					<cfif len(currency_multiplier)>#wrk_round(net_total_/currency_multiplier)#,<cfelse>NULL,</cfif>
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
				islem_tutari_ = net_total_;
				
			carici(
				action_id : GET_MAX_PAYMENT.max_id,
				action_table : 'CREDIT_CARD_BANK_PAYMENTS',
				workcube_process_type : process_type_rev,
				process_cat : GET_PROCESS_CAT_TAHSILAT.PROCESS_CAT_ID,
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
				action_detail : 'Portal Tahsilat',
				account_card_type : 13,
				from_cmp_id : session.pp.company_id,
				//from_consumer_id : attributes.consumer_id,
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
					workcube_process_cat: GET_PROCESS_CAT_TAHSILAT.PROCESS_CAT_ID,
					account_card_type: 13,
					islem_tarihi: attributes.ACTION_DATE,
					fis_satir_detay: str_card_detail,
					company_id : session.pp.company_id,
					//consumer_id : attributes.consumer_id,
					to_branch_id : branch_id,
					borc_hesaplar: GET_CREDIT_PAYMENT.account_code,
					borc_tutarlar: net_total_,
					alacak_hesaplar: MY_ACC_RESULT,
					alacak_tutarlar: net_total_,
					action_currency : session_base.money,
					action_currency_2 : session_base.money2,
					other_amount_borc : net_total_,
					other_currency_borc : session_base.money,
					other_amount_alacak : iif(len(currency_multiplier),'#wrk_round(net_total_/currency_multiplier)#',de('')),
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