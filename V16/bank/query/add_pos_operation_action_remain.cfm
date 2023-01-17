<cfif not isdefined("is_from_schedule")><cfset is_from_schedule = 0></cfif>
<cfsetting showdebugoutput="no">
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		PROCESS_CAT_ID
	 FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		<cfif session.ep.company_id eq 1>
			PROCESS_CAT_ID = 178
		<cfelse>
			PROCESS_CAT_ID = 8
		</cfif>
</cfquery>
<cfquery name="getPosOperation" datasource="#dsn3#">
	SELECT 
    	POS_OPERATION_ID, 
        POS_ID, 
        PAY_METHOD_IDS, 
        BANK_IDS, 
        VOLUME, 
        IS_ACTIVE, 
        PERIOD_ID, 
        START_DATE, 
        FINISH_DATE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP,
        ERROR_CODES, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP, 
        POS_OPERATION_NAME, 
        IS_FLAG
    FROM 
    	POS_OPERATION 
    	WITH (NOLOCK) 
    WHERE 
    	IS_ACTIVE = 1 AND POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfquery name="getSetupPeriod" datasource="#dsn3#">
	SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WITH (NOLOCK) WHERE PERIOD_ID = #getPosOperation.period_id#
</cfquery>
<cfset dsn2_alias_ = '#dsn#_#getSetupPeriod.period_year#_#session.ep.company_id#'>
<cfquery name="getSanalPos" datasource="#dsn3#">
	SELECT 
		POR.POS_OPERATION_ROW_HIST_ID,
		POR.POS_OPERATION_ID,
		POR.SUBSCRIPTION_PAYMENT_ROW_ID,
		POR.WRK_ID,
		PO.IS_FLAG,
		PO.POS_ID,
		I.NETTOTAL,
		I.OTHER_MONEY_VALUE,
		SC.SUBSCRIPTION_ID,
		SC.COMPANY_ID,
		SC.CONSUMER_ID,
		SC.MEMBER_CC_ID,
		I.INVOICE_ID,
		SPR.PERIOD_ID,
		SPR.CARD_PAYMETHOD_ID
	FROM 
		POS_OPERATION_ROW_HISTORY POR WITH (NOLOCK),
		POS_OPERATION PO WITH (NOLOCK),
		SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
		SUBSCRIPTION_CONTRACT SC WITH (NOLOCK),
		#dsn2_alias_#.INVOICE I WITH (NOLOCK)
	WHERE
		SC.SUBSCRIPTION_ID = SPR.SUBSCRIPTION_ID AND
		I.INVOICE_ID = SPR.INVOICE_ID AND
		SPR.SUBSCRIPTION_PAYMENT_ROW_ID = POR.SUBSCRIPTION_PAYMENT_ROW_ID AND
		SC.MEMBER_CC_ID IS NOT NULL AND
		PO.POS_OPERATION_ID = POR.POS_OPERATION_ID AND
		RESPONCE_CODE= '00' AND
		POR.IS_PAYMENT = 0 AND
		PO.POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfoutput query="getSanalPos">
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfset operation_row_id_ = getSanalPos.POS_OPERATION_ROW_HIST_ID>
			<cfset wrk_id_invoice = getSanalPos.WRK_ID>
			<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#POS_OPERATION_ROW_HIST_ID#'&round(rand()*100)>
			<!--- sistemin kredi karti bilgileri cekiliyor. --->
			<cfif len(getSanalPos.company_id)>
				<cfquery name="GET_CREDIT_CARD" datasource="#dsn3#">
					SELECT 
						1 AS MEMBER_TYPE,
						C.FULLNAME AS MEMBER_NAME,
						C.MEMBER_CODE AS MEMBER_CODE,
						C.MANAGER_PARTNER_ID AS MANAGER_PARTNER_ID,
						CC.COMPANY_ID MEMBER_ID,
						CC.COMPANY_CC_TYPE CARD_TYPE,
						CC.COMPANY_CC_NUMBER CARD_NO,
						CC.COMPANY_BANK_TYPE BANK_TYPE,
						CC.COMPANY_CARD_OWNER CARD_OWNER,
						CC.COMPANY_EX_MONTH EX_MONTH,
						CC.COMPANY_EX_YEAR EX_YEAR,
						CC.COMP_CVS CVS
					FROM 
						#dsn_alias#.COMPANY_CC CC WITH (NOLOCK),
						#dsn_alias#.COMPANY C WITH (NOLOCK)
					WHERE 
						C.COMPANY_ID = CC.COMPANY_ID AND
						COMPANY_CC_ID = #getSanalPos.member_cc_id#
				</cfquery>
			<cfelse>
				<cfquery name="GET_CREDIT_CARD" datasource="#dsn3#">
					SELECT 
						2 AS MEMBER_TYPE,
						C.CONSUMER_NAME +' '+ C.CONSUMER_SURNAME AS MEMBER_NAME,
						C.MEMBER_CODE AS MEMBER_CODE,
						'' AS MANAGER_PARTNER_ID
						CC.CONSUMER_ID MEMBER_ID,
						CC.CONSUMER_CC_TYPE CARD_TYPE,
						CC.CONSUMER_CC_NUMBER CARD_NO,
						CC.CONSUMER_BANK_TYPE BANK_TYPE,
						CC.CONSUMER_CARD_OWNER CARD_OWNER,
						CC.CONSUMER_EX_MONTH EX_MONTH,
						CC.CONSUMER_EX_YEAR EX_YEAR,
						CC.CONS_CVS CVS
					FROM 
						#dsn_alias#.CONSUMER_CC CC WITH (NOLOCK),
						#dsn_alias#.CONSUMER C WITH (NOLOCK)
					WHERE 
						C.CONSUMER_ID = CC.CONSUMER_ID AND
						CONSUMER_CC_ID = #getSanalPos.member_cc_id#
				</cfquery>
			</cfif>
			<cfscript>
				//subscription credit card of information.
				key_type = GET_CREDIT_CARD.member_id;
				/* FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi.Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir */
				/*getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
				getCCNOKey.dsn = dsn3;
				getCCNOKey1 = getCCNOKey.getCCNOKey1();
				getCCNOKey2 = getCCNOKey.getCCNOKey2();
				
				if (getCCNOKey1.recordcount and getCCNOKey2.recordcount)
				{
					// anahtarlar decode ediliyor 
					ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey);
					ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey);
					// kart no encode ediliyor
					content = contentEncryptingandDecodingAES(isEncode:0,content:GET_CREDIT_CARD.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2);
				}
				else
					content = Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex");
				*/
				
				content = GET_CREDIT_CARD.CARD_NO;
				
				expire_month = RepeatString("0",2-Len(GET_CREDIT_CARD.EX_MONTH)) & GET_CREDIT_CARD.EX_MONTH;
				expire_year = Right(GET_CREDIT_CARD.EX_YEAR,2);
				cvv_no = GET_CREDIT_CARD.CVS;
				card_owner = GET_CREDIT_CARD.card_owner;
			</cfscript>
			<!--- islem tipi, üye muhasebe kodu, odeme yontemi muhasebe kodu kontrolleri --->
			<cfset my_acc_result = "">
			<cfscript>
				process_cat = get_process_type.PROCESS_CAT_ID;
				form.process_cat = get_process_type.PROCESS_CAT_ID;
				process_type = get_process_type.process_type;
				is_cari = get_process_type.is_cari;
				is_account = get_process_type.is_account;
				if(GET_CREDIT_CARD.member_type eq 2) cons_id = GET_CREDIT_CARD.member_id; else cons_id = '';
				if(GET_CREDIT_CARD.member_type eq 1)
					{action_from_company_id = GET_CREDIT_CARD.member_id;
					par_id = GET_CREDIT_CARD.MANAGER_PARTNER_ID;}
				else
					{action_from_company_id = '';
					par_id = '';}
			</cfscript>
			<cfif is_account eq 1>
				<cfif len(action_from_company_id)>
					<cfquery name="GET_COMPANY_ACCOUNT_CODE" datasource="#dsn3#">
						SELECT
							ACCOUNT_CODE
						FROM
							#dsn_alias#.COMPANY_PERIOD WITH (NOLOCK)
						WHERE
							COMPANY_ID = #action_from_company_id#
							AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					</cfquery>
					<cfset my_acc_result = GET_COMPANY_ACCOUNT_CODE.ACCOUNT_CODE>
				<cfelse>
					<cfquery name="GET_COMPANY_ACCOUNT_CODE" datasource="#dsn3#">
						SELECT
							ACCOUNT_CODE
						FROM
							#dsn_alias#.COMPANY_PERIOD WITH (NOLOCK)
						WHERE
							COMPANY_ID = #cons_id#
							AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					</cfquery>
					<cfset my_acc_result = GET_COMPANY_ACCOUNT_CODE.ACCOUNT_CODE>
				</cfif>
			</cfif>
			<!--- ödeme yönteminin tanımları taksit sayısı vft_code vs... --->
			<cfquery name="GET_TAKS_METHOD" datasource="#DSN3#">
				SELECT NUMBER_OF_INSTALMENT,ACCOUNT_CODE,CARD_NO,VFT_CODE FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE PAYMENT_TYPE_ID = #getSanalPos.CARD_PAYMETHOD_ID#
			</cfquery>
			<!--- ödeme yöntemi bilgileri oluşturuluyor --->
			<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
				SELECT
					ACCOUNTS.ACCOUNT_ID,
					<cfif session.ep.period_year lt 2009>
						CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
					<cfelse>
						ACCOUNTS.ACCOUNT_CURRENCY_ID,
					</cfif>
					CPT.PAYMENT_TYPE_ID,
					CPT.PAYMENT_RATE,
					ISNULL(CPT.NUMBER_OF_INSTALMENT,0) NUMBER_OF_INSTALMENT,
					POS_TYPE
				FROM
					ACCOUNTS ACCOUNTS WITH (NOLOCK),
					CREDITCARD_PAYMENT_TYPE CPT WITH (NOLOCK)
				WHERE
					PAYMENT_TYPE_ID = #getSanalPos.POS_ID# AND
					<cfif session.ep.period_year lt 2009>
						ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL' AND<!--- toplu pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
					<cfelse>
						ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#' AND
					</cfif>
					ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
					CPT.IS_ACTIVE = 1 AND
					CPT.POS_TYPE IS NOT NULL<!---Sanal pos tipleri bilgisi--->
				ORDER BY
					ACCOUNTS.ACCOUNT_NAME
			</cfquery>
			<cfset action_to_account_id_ = '#GET_ACCOUNTS.ACCOUNT_ID#;#GET_ACCOUNTS.ACCOUNT_CURRENCY_ID#;#GET_ACCOUNTS.PAYMENT_TYPE_ID#;#GET_ACCOUNTS.POS_TYPE#;#GET_ACCOUNTS.NUMBER_OF_INSTALMENT#;#GET_ACCOUNTS.PAYMENT_RATE#'><!---eleman sırası değişmemeli--->
			<cfscript>
				//card paymethod of information..
				if (len(GET_TAKS_METHOD.NUMBER_OF_INSTALMENT) and GET_TAKS_METHOD.NUMBER_OF_INSTALMENT neq 0)
					taksit_sayisi = GET_TAKS_METHOD.NUMBER_OF_INSTALMENT;
				else
					taksit_sayisi = 0;
					
				if (len(GET_TAKS_METHOD.VFT_CODE)) vft_code = GET_TAKS_METHOD.VFT_CODE; else vft_code = '';
					
				//amount of information.
				tutar = getSanalPos.nettotal;
				//firma of information
				attributes.firma_info = GET_CREDIT_CARD.member_name;
				member_code ='';
				attributes.cons_id = cons_id;
				attributes.par_id= par_id;
				attributes.action_from_company_id = action_from_company_id;
				attributes.action_to_account_id = action_to_account_id_; 
				attributes.process_cat = process_cat;
				attributes.action_date = dateformat(now(),dateformat_style);
				attributes.sales_credit = getSanalPos.nettotal;
				attributes.system_amount = getSanalPos.nettotal; 
				attributes.other_value_sales_credit = getSanalPos.other_money_value; 
				form.other_value_sales_credit = getSanalPos.other_money_value; 
				if(GET_ACCOUNTS.NUMBER_OF_INSTALMENT eq 0)
					attributes.action_detail = 'Tek Çekim (OSP)';
				else
					attributes.action_detail = '#GET_ACCOUNTS.NUMBER_OF_INSTALMENT# Taksit (OSP)';
				attributes.process_type = process_type;
				attributes.is_cari = is_cari;
				attributes.is_account = is_account;
				attributes.expire_month = expire_month;
				attributes.expire_year = expire_year;
				attributes.my_acc_result = my_acc_result;
				attributes.card_owner = card_owner;
				
				//kur bilgileri ve rate'ler olusturuluyor.
				SQLStrRow="SELECT * FROM #dsn2_alias_#.INVOICE_MONEY WHERE ACTION_ID = #getSanalPos.invoice_id#";
				getInvoiceMoney = cfquery(SQLString : SQLStrRow, Datasource : dsn3);
				for (str_i=1; str_i lte getInvoiceMoney.recordcount; str_i = str_i+1)
				{
					"attributes.txt_rate1_#str_i#" = getInvoiceMoney.rate1[str_i];
					"attributes.txt_rate2_#str_i#" = getInvoiceMoney.rate2[str_i];
					"attributes.hidden_rd_money_#str_i#" = getInvoiceMoney.money_type[str_i];
					
					if(getInvoiceMoney.IS_SELECTED[str_i] eq 1)
					{
						attributes.money_type = getInvoiceMoney.money_type[str_i];
						money_type = getInvoiceMoney.money_type[str_i];
						form.money_type = getInvoiceMoney.money_type[str_i];
						rate2_ = getInvoiceMoney.rate2[str_i];
						rate1_ = getInvoiceMoney.rate1[str_i];
					}
				}
				attributes.kur_say = getInvoiceMoney.recordcount;
				attributes.subs_inv_id = getSanalPos.invoice_id;
				attributes.period_id = getSanalPos.period_id;
			</cfscript>
			<cfset credit_error = 0>
            <cfquery name="get_plan_info" datasource="#DSN3#">
                SELECT
                    IS_PAID,
                    SUBSCRIPTION_ID,
                    ISNULL(CARI_ACT_ID,0) AS CARI_ACT_ID
                FROM 
                    SUBSCRIPTION_PAYMENT_PLAN_ROW
                WHERE
                    SUBSCRIPTION_PAYMENT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#SUBSCRIPTION_PAYMENT_ROW_ID#">                      
            </cfquery>
			<cfif get_plan_info.CARI_ACT_ID is 0> 
                <cftry>
                    <cfinclude template="../../bank/query/add_creditcard_revenue_onlinepos_ic.cfm">
                    <cfcatch>
                        <cfset credit_error = 1>
                    </cfcatch>
                </cftry>
				<cfif credit_error eq 0>
                    <cfquery name="upd_row" datasource="#dsn3#">
                        UPDATE POS_OPERATION_ROW_HISTORY SET IS_PAYMENT = 1,RESPONCE_DETAIL = 'İşlem Onay aldı. Kredi kartı tahsilatı yapıldı.' WHERE POS_OPERATION_ROW_HIST_ID = #operation_row_id_#
                    </cfquery>
                </cfif>
            <cfelse>
                <script>
                    alert('İlgili Sistemlerin Ödeme Planı Satırları Ödenmiş Görünüyor:\n#get_plan_info.SUBSCRIPTION_ID#');
                </script>
				<cfabort>
            </cfif>
		</cftransaction>
	</cflock>
</cfoutput>
<cfif is_from_schedule eq 0>
	<cfoutput>
		<script language="javascript">
			eval('pos_operation_td_#attributes.row_no#').style.display = 'none';
			eval('pos_operation_td_2_#attributes.row_no#').style.display = 'none';
			eval('credit_card_td_#attributes.row_no#').style.display = 'none';
			document.getElementById('kontrol_function').value = 1;
		</script>
	</cfoutput>
</cfif>
İşlem Tamamlandı.
