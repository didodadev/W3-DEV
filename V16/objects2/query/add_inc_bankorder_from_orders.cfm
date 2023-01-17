<cfquery name="GET_PROCESS_TYPE" datasource="#DSN3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
        ACTION_FILE_NAME,
        ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_talimat#">
</cfquery>
<cfquery name="GET_CREDIT_MONEY" datasource="#DSN#"><!--- üye risk bilgierlndeki seçili para birimine göre --->
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
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
						<cfelse>
							CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
						</cfif>
						OUR_COMPANY_ID = <cfif isDefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"></cfif>
					)
</cfquery>
<cfif len(get_credit_money.money_type)>
	<cfset process_money_type = get_credit_money.money_type>
<cfelse>
	<cfset process_money_type = session_base.money2>
</cfif>
<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
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
	process_type = get_process_type.process_type;
	account_currency_id = ListGetAt(attributes.account_id,2,'-');
	is_account = get_process_type.is_account;
	is_cari = get_process_type.is_cari;
	currency_multiplier = "";
	currency_multiplier_money2 = "";
</cfscript>
<cfoutput query="get_money_info">
	<cfif get_money_info.money eq process_money_type>
		<cfset currency_multiplier = wrk_round(get_money_info.rate2/get_money_info.rate1,4)>
	</cfif>
	<cfif get_money_info.money eq session_base.money2>
		<cfset currency_multiplier_money2 = wrk_round(get_money_info.rate2/get_money_info.rate1,4)>
	</cfif>
</cfoutput>

<cfif is_account>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		<cfset alacakli_hesap = get_company_period(attributes.company_id,session_base.period_id)>
	<cfelse>
		<cfset alacakli_hesap = get_consumer_period(attributes.consumer_id,session_base.period_id)>
	</cfif>
	<cfif not len(alacakli_hesap)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1295.Muhasebe Hesaplarınız Tanımlanmamıştır Lütfen Müşteri Hizmetlerine Başvurunuz'>!");
			window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_list_order</cfoutput>';
		</script>
		<cfabort>
	</cfif>
	<cfif len(listfirst(attributes.account_id,'-'))>
		<cfquery name="GET_BANK_ORDER_CODE" datasource="#DSN2#">
			SELECT ACCOUNT_ORDER_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.account_id,'-')#">
		</cfquery>
		<cfif not len(get_bank_order_code.account_order_code)>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1416.Seçtiğiniz Banka Hesabının Muhasebe Kodu Seçilmemiştir Lütfen Müşteri Hizmetlerine Başvurunuz'>!");
				window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_list_order</cfoutput>';
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<cfif len(attributes.company_id)>
	<cfquery name="GET_BANK" datasource="#DSN#">
		SELECT 
			COMPANY_BANK_ID MEMBER_BANK_ID
		 FROM 
			COMPANY_BANK
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			AND COMPANY_ACCOUNT_DEFAULT = 1
			AND COMPANY_BANK_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.account_id,2,'-')#">
	</cfquery>
<cfelse>
	<cfquery name="GET_BANK" datasource="#DSN#">
		SELECT 
			CONSUMER_BANK_ID MEMBER_BANK_ID
		 FROM 
			CONSUMER_BANK
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			AND CONSUMER_ACCOUNT_DEFAULT = 1
			AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.account_id,2,'-')#">
	</cfquery>
</cfif>
<cf_date tarih='attributes.act_date'>
<cf_date tarih='attributes.paym_date'>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_BANK_ORDER" datasource="#DSN2#">
			INSERT INTO
				BANK_ORDERS
				(
					BANK_ORDER_TYPE,
					BANK_ORDER_TYPE_ID,
					ACTION_VALUE,
					ACTION_MONEY,
					ACCOUNT_ID,
					COMPANY_ID,
					CONSUMER_ID,
					TO_ACCOUNT_ID,
					OTHER_MONEY_VALUE,
					OTHER_MONEY,
					ACTION_DATE,
					PAYMENT_DATE,
					IS_PAID,
					RECORD_DATE,
					RECORD_PAR,
					RECORD_CONS,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#process_type#,
					#attributes.process_cat_talimat#,
					#attributes.order_amount#,
					'#ListGetAt(attributes.account_id,2,'-')#',
					#listfirst(attributes.account_id,'-')#,
					<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
					<cfif get_bank.recordcount>#get_bank.member_bank_id#,<cfelse>NULL,</cfif>		
					<cfif len(currency_multiplier)>#wrk_round(attributes.ORDER_AMOUNT/currency_multiplier)#,<cfelse>NULL,</cfif>
					<cfif len(process_money_type)>'#process_money_type#',<cfelse>NULL,</cfif>
					#attributes.act_date#,
					#attributes.paym_date#,
					0, <!---banka talimatından havale olusturulmadigini gosteriyor  --->
					#now()#,
					<cfif isDefined("session.pp")>#session.pp.userid#,<cfelse>NULL,</cfif>
					<cfif isDefined("session.ww")>#session.ww.userid#,<cfelse>NULL,</cfif>
					<cfif isDefined("session.ep")>#session.ep.userid#,<cfelse>NULL,</cfif>
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfquery name="GET_MAX" datasource="#DSN2#">
			SELECT MAX(BANK_ORDER_ID) AS MAX_ID FROM BANK_ORDERS
		</cfquery>	
		<cfscript>
			GET_RATE=cfquery(datasource: "#dsn2#", sqlstring: "SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY='#ListGetAt(attributes.account_id,2,'-')#'");
			if(is_account eq 1)
			{//session_base.money den yapılır işlemler sadece
				muhasebeci
				(
					action_id : get_max.MAX_ID,
					workcube_process_type : process_type,
					workcube_process_cat:attributes.process_cat_talimat,
					account_card_type : 13,
					islem_tarihi : attributes.ACT_DATE,
					fis_detay : 'GELEN BANKA TALİMATI',
					fis_satir_detay : 'Gelen Banka Talimatı',
					to_branch_id : listlast(attributes.account_id,'-'),
					action_currency : session_base.money,
					action_currency_2 : session_base.money2,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					borc_hesaplar : get_bank_order_code.account_order_code,
					borc_tutarlar : attributes.order_amount,
					alacak_hesaplar : alacakli_hesap,
					alacak_tutarlar : attributes.order_amount,
					other_amount_borc : iif(len(currency_multiplier),'#wrk_round(attributes.order_amount/currency_multiplier)#',de('')),
					other_currency_borc : process_money_type,
					other_amount_alacak : iif(len(currency_multiplier),'#wrk_round(attributes.order_amount/currency_multiplier)#',de('')),
					other_currency_alacak : process_money_type,
					currency_multiplier : currency_multiplier_money2,
					base_period_year : session_base.period_year
				);	
			}
			if(is_cari eq 1)
			{//session_base.money den yapılır işlemler sadece
				carici
					(
					action_id : get_max.MAX_ID,
					workcube_process_type : process_type,	
					action_table : 'BANK_ORDERS',			
					process_cat : attributes.process_cat_talimat,
					islem_tarihi : attributes.act_date,				
					due_date: attributes.paym_date,
					to_account_id : listfirst(attributes.account_id,'-'),
					to_branch_id : listlast(attributes.account_id,'-'),
					from_cmp_id : attributes.company_id,			
					from_consumer_id : attributes.consumer_id,			
					islem_tutari : attributes.order_amount,
					action_currency : session_base.money,
					action_currency_2 : session_base.money2,	
					other_money_value : iif(len(currency_multiplier),'#wrk_round(attributes.order_amount/currency_multiplier)#',de('')),
					other_money : process_money_type,
					islem_detay : 'Gelen Banka Talimatı',					
					account_card_type : 13,
					currency_multiplier : currency_multiplier_money2,
					period_is_integrated : 1,
					is_processed : 0, //banka talimatının havaleye çekilmedigini gösteriyor.
					rate2:currency_multiplier
					);
			}
		</cfscript>	
		<cfset fark = 8 - len(get_max.max_id)>
		<cfset seri_no = "#get_max.max_id#">
		<cfif fark gt 0>
			<cfloop from="1" to="#fark#" index="i">
				<cfset seri_no = '0' & '#seri_no#'>
			</cfloop>
		<cfelse>
			<cfset seri_no = "#get_max.max_id#">
		</cfif>
		<cfquery name="UPD_" datasource="#DSN2#">
			UPDATE BANK_ORDERS SET SERI_NO = '#seri_no#' WHERE BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_id#">
		</cfquery>
		<cfif get_money_info.recordcount>
			<cfoutput query="get_money_info">
				<cfquery name="INSERT_MONEY_INFO" datasource="#DSN2#">
					INSERT INTO BANK_ORDER_MONEY
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						 #get_max.max_id#,
						'#get_money_info.money#',
						 #get_money_info.rate2#,
						 #get_money_info.rate1#,
						<cfif get_money_info.money eq process_money_type>1<cfelse>0</cfif>
					)
				</cfquery>
			</cfoutput>
		</cfif>
	</cftransaction>
</cflock>
<cfset bank_order_id_info = get_max.max_id><!--- daha sonra sipariş bağlantısı için --->
