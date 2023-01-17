<cfif not isdefined("is_from_schedule")><cfset is_from_schedule = 0></cfif>
<cfsetting showdebugoutput="no">
<cfquery name="get_process_type" datasource="#dsn3#" timeout="500">
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
<cfquery name="getPosInfo" datasource="#dsn3#" timeout="500">
	SELECT 
		SP.PERIOD_YEAR ,
		(SELECT POS_TYPE FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = PO.POS_ID) POS_TYPE
	FROM 
		POS_OPERATION PO WITH (NOLOCK),
		#dsn_alias#.SETUP_PERIOD SP
	WHERE 
		PO.PERIOD_ID = SP.PERIOD_ID AND
		PO.POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfquery name="addPosOperationAction" datasource="#dsn3#" timeout="500" result="MAX_ID">
	INSERT INTO
		POS_OPERATION_ACTIONS
		(
			POS_OPERATION_ID,
			SCHEDULE_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			#attributes.pos_operation_id#,
			<cfif isdefined("attributes.schedule_id")>#attributes.schedule_id#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cfset operation_act_id = MAX_ID.IDENTITYCOL>
<cfquery name="getPosOperation" datasource="#dsn3#" timeout="500">
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
<cfquery name="getSetupPeriod" datasource="#dsn3#" timeout="500">
	SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WITH (NOLOCK) WHERE PERIOD_ID = #getPosOperation.period_id#
</cfquery>
<cfset dsn2_alias_ = '#dsn#_#getSetupPeriod.period_year#_#session.ep.company_id#'>
<cfquery name="getSanalPosMain" datasource="#dsn3#" timeout="500">
	SELECT 
		POR.POS_OPERATION_ROW_ID,
		POR.POS_OPERATION_ID,
		POR.SUBSCRIPTION_PAYMENT_ROW_ID,
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
		POS_OPERATION_ROW POR WITH (NOLOCK),
		POS_OPERATION PO WITH (NOLOCK),
		SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
		SUBSCRIPTION_CONTRACT SC WITH (NOLOCK),
		#dsn2_alias_#.INVOICE I WITH (NOLOCK)
	WHERE
		SC.SUBSCRIPTION_ID = SPR.SUBSCRIPTION_ID AND
		I.INVOICE_ID = SPR.INVOICE_ID AND
		SPR.SUBSCRIPTION_PAYMENT_ROW_ID = POR.SUBSCRIPTION_PAYMENT_ROW_ID AND
		SPR.PERIOD_ID = #getPosOperation.period_id# AND
		SC.MEMBER_CC_ID IS NOT NULL AND
		PO.POS_OPERATION_ID = POR.POS_OPERATION_ID AND
		PO.IS_FLAG = 0 AND
		PO.POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfset count_row_act = 1><!--- Burada girilen değere göre blok halinde oluşturulur --->
<!--- <cfif isdefined("session.ep.auto_pos_action_pause_#attributes.pos_operation_id#")><cfset "session.ep.auto_pos_action_pause_#attributes.pos_operation_id#" = 0></cfif> --->
<cfset loopcount = Int(getSanalPosMain.recordcount/count_row_act)+1>
<cfloop from="1" to="#loopcount#" index="loop_index">
    <cflock name="#CREATEUUID()#" timeout="60">
        <cftransaction>
			<cfquery name="pos_status_kontrol" datasource="#dsn3#">
				SELECT POS_STATUS FROM POS_OPERATION_STATUS WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
			</cfquery>
			<cfif pos_status_kontrol.recordcount eq 0 or pos_status_kontrol.pos_status eq 0>
				<cfset pos_status_kontrol = 0>
			<cfelse>
				<cfset pos_status_kontrol = 1>
			</cfif>
            <cfquery name="updPosOperationRow" datasource="#dsn3#" timeout="500">
                UPDATE POS_OPERATION SET IS_FLAG = 1 WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
            </cfquery>
			<cfif pos_status_kontrol eq 0 ><!--- Eğer işlem durdurulursa session de değer set ediyoruz  , 1 ise durdurulmuş demektir işleme devam etmeyecek --->
				<cfquery name="getSanalPos" datasource="#dsn3#" maxrows="#count_row_act#" timeout="500">
					SELECT 
						POR.POS_OPERATION_ROW_ID,
						POR.POS_OPERATION_ID,
						POR.SUBSCRIPTION_PAYMENT_ROW_ID,
						PO.IS_FLAG,
						PO.POS_ID,
						I.NETTOTAL,
						I.OTHER_MONEY_VALUE,
						I.WRK_ID WRK_ID_,
						SC.SUBSCRIPTION_ID,
						SC.COMPANY_ID,
						SC.CONSUMER_ID,
						SC.MEMBER_CC_ID,
						I.INVOICE_ID,
						SPR.PERIOD_ID,
						SPR.CARD_PAYMETHOD_ID
					FROM 
						POS_OPERATION_ROW POR WITH (NOLOCK),
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
						PO.POS_OPERATION_ID = #attributes.pos_operation_id#
					ORDER BY
						POS_OPERATION_ROW_ID
				</cfquery>
				<cfoutput query="getSanalPos">
					<cfset operation_row_id_ = getSanalPos.POS_OPERATION_ROW_ID>
					<cfset wrk_id_invoice = getSanalPos.WRK_ID_>
					<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#POS_OPERATION_ROW_ID#'&round(rand()*100)>
					<!--- sistemin kredi karti bilgileri cekiliyor. --->
					<cfif len(getSanalPos.company_id)>
						<cfquery name="GET_CREDIT_CARD" datasource="#dsn3#" timeout="500">
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
						<cfquery name="GET_CREDIT_CARD" datasource="#dsn3#" timeout="500">
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
						/* FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir */
						getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
						getCCNOKey.dsn = dsn3;
						getCCNOKey1 = getCCNOKey.getCCNOKey1();
						getCCNOKey2 = getCCNOKey.getCCNOKey2();
						
						if (getCCNOKey1.recordcount and getCCNOKey2.recordcount)
						{
							// anahtarlar decode ediliyor 
							ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey);
							ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey);
							// kart no encode ediliyor
							attributes.card_no = contentEncryptingandDecodingAES(isEncode:0,content:GET_CREDIT_CARD.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2);
						}
						else
							attributes.card_no = Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex");
							
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
							<cfquery name="GET_COMPANY_ACCOUNT_CODE" datasource="#dsn3#" timeout="500">
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
							<cfquery name="GET_COMPANY_ACCOUNT_CODE" datasource="#dsn3#" timeout="500">
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
						<cfif not len(my_acc_result)>
							<cfset memberMakingProcess = 0>
						<cfelse>
							<cfset memberMakingProcess = 1>
						</cfif>
					<cfelse>
						<cfset memberMakingProcess = 1>
					</cfif>
					<!--- ödeme yönteminin tanımları taksit sayısı vft_code vs... --->
					<cfquery name="GET_TAKS_METHOD" datasource="#DSN3#" timeout="500">
						SELECT NUMBER_OF_INSTALMENT,ACCOUNT_CODE,CARD_NO,VFT_CODE FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE PAYMENT_TYPE_ID = #getSanalPos.CARD_PAYMETHOD_ID#
					</cfquery>
					<cfif not len(GET_TAKS_METHOD.ACCOUNT_CODE)>
						<cfset paymentMakingProcess = 0>
					<cfelse>
						<cfset paymentMakingProcess = 1>
					</cfif>
					<!--- üyemuhasebe kodu veya ödeme yöntemi muhasebe kodu tanımlanmamışsa ödeme satiri işleme girmez. --->
					<cfif memberMakingProcess eq 0 or paymentMakingProcess eq 0>
						<cfquery name="addPosOperationHistory" datasource="#dsn3#" timeout="500">
							INSERT INTO
								POS_OPERATION_ROW_HISTORY
								(
									POS_OPERATION_ACTION_ID,
									POS_OPERATION_ID,
									SUBSCRIPTION_PAYMENT_ROW_ID,
									INVOICE_NET_TOTAL,
									MONEY_TYPE,
									IS_PAID,
									IS_PAYMENT,
									RESPONCE_CODE,
									RESPONCE_DETAIL,
									SUBSCRIPTION_CREDIT_CARD_ID,
									INVOICE_ID,
									RECORD_DATE,
									RECORD_EMP,
									RECORD_IP
								)
								VALUES
								(
									#operation_act_id#,
									#getSanalPos.POS_OPERATION_ID#,
									#getSanalPos.SUBSCRIPTION_PAYMENT_ROW_ID#,
									NULL,
									'#session.ep.money#',
									0,
									0,
									NULL,
									<cfif memberMakingProcess eq 0>
										'Üye muhasebe tanımları yapılmadığı için işlem gerçekleştirilemedi',
									<cfelse>
										'Ödeme yöntemi muhasebe tanımları yapılmadığı için işlem gerçekleştirilemedi',
									</cfif>
									#getSanalPos.MEMBER_CC_ID#,
									#getSanalPos.invoice_id#,
									#now()#,
									#session.ep.userid#,
									'#CGI.REMOTE_ADDR#'
								)
						</cfquery>
						<cfquery name="updSubsCollectedProv" datasource="#dsn3#" timeout="500">
							UPDATE 
								SUBSCRIPTION_PAYMENT_PLAN_ROW 
							SET 
								IS_COLLECTED_PROVISION = 0 ,
                                UPDATE_DATE = #now()#,
                                UPDATE_IP = '#cgi.remote_addr#',
                                UPDATE_EMP = #session.ep.userid#
							WHERE 
								INVOICE_ID = #getSanalPos.invoice_id# AND
								PERIOD_ID = #getSanalPos.period_id#
						</cfquery>
					<cfelse>
						<!--- ödeme yöntemi bilgileri oluşturuluyor --->
						<cfquery name="GET_ACCOUNTS" datasource="#DSN3#" timeout="500">
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
						<cfset pos_type = getPosInfo.pos_type>
						<cfscript>
							//card paymethod of information..
							if (len(GET_TAKS_METHOD.NUMBER_OF_INSTALMENT) and GET_TAKS_METHOD.NUMBER_OF_INSTALMENT neq 0)
								taksit_sayisi = GET_TAKS_METHOD.NUMBER_OF_INSTALMENT;
							else
								taksit_sayisi = 0;
								
							if (len(GET_TAKS_METHOD.VFT_CODE)) vft_code = GET_TAKS_METHOD.VFT_CODE; else vft_code = '';
								
							//amount of information.
							tutar = getSanalPos.nettotal;
							if (listfind("7,8,9,23",pos_type,','))//Vakıfbank,YKB
								tutar = wrk_round(tutar,2) * 100;
							else
							{
								if(int(tutar) eq tutar)tutar = tutar & "." & "00";
								else tutar = tutar;
							}
									
							//firma of information
							attributes.firma_info = GET_CREDIT_CARD.member_name;
							member_code =GET_CREDIT_CARD.member_code;
							attributes.cons_id = cons_id;
							attributes.par_id= par_id;
							attributes.action_from_company_id = action_from_company_id;
							attributes.action_to_account_id = action_to_account_id_; 
							attributes.process_cat = process_cat;
							attributes.action_date = dateformat(now(),dateformat_style);
							attributes.sales_credit = getSanalPos.nettotal;
							attributes.other_value_sales_credit = getSanalPos.other_money_value; 
							form.other_value_sales_credit = getSanalPos.other_money_value; 
							attributes.system_amount = getSanalPos.nettotal; 
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
						<!--- sanal pos islemi gerceklesiyor. <cfset response_code = '00'> --->
						
						<cftry>
							<cfif listfind("1,3,4,5,6,8,16,14,17,19,20,21,22,24,25",pos_type,',')><!--- Sanal pos tipi garanti,Akbank,Finansbank,HSBC ise --->
								<cfscript>
									if(pos_type is 20)pos_type = 1;//waternet akbank
									else if(pos_type is 21)pos_type = 3; //waternet işbank
									else if(pos_type is 22)pos_type = 5; //waternet finansbank
									else if(pos_type is 24)pos_type = 14;//waternet teb
									else if(pos_type is 25)pos_type = 8;//waternet garanti
									my_doc = XmlNew();
									my_doc.xmlRoot = XmlElemNew(my_doc,"CC5Request");
									if(pos_type eq 1)//Akbank
									{			
										if(session.ep.company_id eq 1){
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
										}
										else if(session.ep.company_id eq 3){
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
										}
									}
									else if(pos_type eq 3)//iş Bankası
									{
										if(session.ep.company_id eq 1)
										{
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
										}
										else if(session.ep.company_id eq 3)
										{
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
										}
									}
									else if(pos_type eq 4)//Denizbank
									{
										pos_user_name = "";
										pos_user_password = "";
										pos_client_id = "";
									}
									else if(pos_type eq 5)//Finansbank
									{
										if(session.ep.company_id eq 1){
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
										}else if(session.ep.company_id eq 3){
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";				
										}
									}
									else if(pos_type eq 6)//HSBC
									{
										pos_user_name = "";
										pos_user_password = "";
										pos_client_id = "";
									}
									else if(pos_type eq 8)//Garanti
									{
										if(session.ep.company_id eq 1){
											pos_terminal_no = ; // terminal no
											pos_client_id =  ; //ISYERI NO
											pos_user_name = "";
											pos_user_password = "";
										}else if(session.ep.company_id eq 3){
											pos_terminal_no = ; // terminal no
											pos_client_id =  ; //ISYERI NO
											pos_user_name = "";
											pos_user_password = "";				
										}
									}
									else if(pos_type eq 14)//teb
									{
										if(session.ep.company_id eq 1)
										{
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
										}else if(session.ep.company_id eq 3){
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
										}
									}
									else if(pos_type eq 16)//ING
									{
										pos_user_name = "";
										pos_user_password = "";
										pos_client_id = "";
									}
									else if(pos_type eq 17 or pos_type eq 19)//odea
									{
										if(session.ep.company_id eq 1)
										{
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
											pos_terminal_no = "";
										}
										else if(session.ep.company_id eq 3)
										{
											pos_user_name = "";
											pos_user_password = "";
											pos_client_id = "";
											pos_terminal_no = "";
										}
									}									
									
									if (pos_type eq 8)
									{
										if (len(pos_terminal_no) lt 9)
											terminalNo = repeatString("0",9-len(pos_terminal_no)) & "#pos_terminal_no#";
										else
											terminalNo = pos_terminal_no;
										
										hashpass = hash("#pos_user_password##terminalNo#",'sha-1');
										hashdata = hash("#wrk_id_invoice##pos_terminal_no##attributes.card_no##tutar##hashpass#",'sha-1');
										
										my_doc = XmlNew();
										my_doc.xmlRoot = XmlElemNew(my_doc,"GVPSRequest");
										
										my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Mode");
										my_doc.xmlRoot.XmlChildren[1].XmlText = "PROD";
										
										my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Version");
										my_doc.xmlRoot.XmlChildren[2].XmlText = "v0.01";
										
										my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"ChannelCode");
										my_doc.xmlRoot.XmlChildren[3].XmlText = "";
										
										my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"Terminal");
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[1] = XmlElemNew(my_doc,"ProvUserID");//Terminale ait provizyon kullanici kodunun  gönderildigi alandir. Burada Prov kullanicisi, Iptal iade kullanicisi veya OOS  kullanicisi bulunabilir
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[1].XmlText = pos_user_name;
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[2] = XmlElemNew(my_doc,"HashData");
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[2].XmlText = hashdata;//Has Data Gelecek
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[3] = XmlElemNew(my_doc,"UserID");//Islemi yapan kullanicinin (Agent - Satis Temsilcisi) yollandigi alandir. 
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[3].XmlText = pos_user_name;
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[4] = XmlElemNew(my_doc,"ID");
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[4].XmlText = pos_terminal_no;//terminal no
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[5] = XmlElemNew(my_doc,"MerchantID");
										my_doc.xmlRoot.XmlChildren[4].XmlChildren[5].XmlText = pos_client_id;//isyeri no.
										
										my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"Customer");
										my_doc.xmlRoot.XmlChildren[5].XmlChildren[1] = XmlElemNew(my_doc,"IPAddress");
										my_doc.xmlRoot.XmlChildren[5].XmlChildren[1].XmlText = cgi.REMOTE_ADDR;
										my_doc.xmlRoot.XmlChildren[5].XmlChildren[2] = XmlElemNew(my_doc,"EmailAddress");
										my_doc.xmlRoot.XmlChildren[5].XmlChildren[2].XmlText = "info@pronet.com.tr"; //üyenin maili gelecek
										
										my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Card");
										my_doc.xmlRoot.XmlChildren[6].XmlChildren[1] = XmlElemNew(my_doc,"Number");
										my_doc.xmlRoot.XmlChildren[6].XmlChildren[1].XmlText = attributes.card_no;
										my_doc.xmlRoot.XmlChildren[6].XmlChildren[2] = XmlElemNew(my_doc,"ExpireDate");
										my_doc.xmlRoot.XmlChildren[6].XmlChildren[2].XmlText = "#expire_month##expire_year#";
										my_doc.xmlRoot.XmlChildren[6].XmlChildren[3] = XmlElemNew(my_doc,"CVV2");
										my_doc.xmlRoot.XmlChildren[6].XmlChildren[3].XmlText = cvv_no;
										
										my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"Order");
										my_doc.xmlRoot.XmlChildren[7].XmlChildren[1] = XmlElemNew(my_doc,"OrderID");
										my_doc.xmlRoot.XmlChildren[7].XmlChildren[1].XmlText = wrk_id_invoice;
										my_doc.xmlRoot.XmlChildren[7].XmlChildren[2] = XmlElemNew(my_doc,"GroupID");
										my_doc.xmlRoot.XmlChildren[7].XmlChildren[2].XmlText = "";
										
										my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"Transaction");
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[1] = XmlElemNew(my_doc,"Type");
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[1].XmlText = "sales";
										if(taksit_sayisi neq 0)
										{
											my_doc.xmlRoot.XmlChildren[8].XmlChildren[2] = XmlElemNew(my_doc,"InstallmentCnt");//taksit sayisi
											my_doc.xmlRoot.XmlChildren[8].XmlChildren[2].XmlText = taksit_sayisi;
										}
										else
										{
											my_doc.xmlRoot.XmlChildren[8].XmlChildren[2] = XmlElemNew(my_doc,"InstallmentCnt");//taksit sayisi
											my_doc.xmlRoot.XmlChildren[8].XmlChildren[2].XmlText = '';
										}
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[3] = XmlElemNew(my_doc,"Amount");
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[3].XmlText = tutar;
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[4] = XmlElemNew(my_doc,"CurrencyCode");
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[4].XmlText = 949;
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[5] = XmlElemNew(my_doc,"CardholderPresentCode");//normal islemler için 0, 3D islemler için 13 girilmesi gerekmektedir.
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[5].XmlText = 0;
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[6] = XmlElemNew(my_doc,"MotoInd");//Y ve N degerlerini alir. Ecommerce islemler için N gönderilir. Moto islem statüsündeki islemler için Y gönderilir.
										my_doc.xmlRoot.XmlChildren[8].XmlChildren[6].XmlText = "N";
									}
									else if(pos_type eq 17 or pos_type eq 19)
									{
										my_doc = XmlNew();
										my_doc.xmlRoot = XmlElemNew(my_doc,"PayforRequest");
										
										my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"MbrId");//Kurum no
										my_doc.xmlRoot.XmlChildren[1].XmlText = 0;
										my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"PurchAmount");//tutar
										my_doc.xmlRoot.XmlChildren[2].XmlText = wrk_round(tutar,2);
										my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"Currency");//Para birimi - TL
										my_doc.xmlRoot.XmlChildren[3].XmlText = "949";
										my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"OrderId");//Siparis numarasi
										my_doc.xmlRoot.XmlChildren[4].XmlText = wrk_id_invoice;
										my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"InstallmentCount");
										my_doc.xmlRoot.XmlChildren[5].XmlText = taksit_sayisi;//Taksit Sayisi
										my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"TxnType");//Islem tipi(Provizyon  ve isyeri onayi islemlerini ayni anda yapar)
										my_doc.xmlRoot.XmlChildren[6].XmlText = "Auth";
										my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"UserCode");//Kullanici adi-banka tarafindan üye isyerine verilir
										my_doc.xmlRoot.XmlChildren[7].XmlText = pos_user_name;
										my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"UserPass");//Sifre-banka tarafindan üye isyerine verilir
										my_doc.xmlRoot.XmlChildren[8].XmlText = pos_user_password;
										my_doc.xmlRoot.XmlChildren[9] = XmlElemNew(my_doc,"OrgOrderId");//Siparis numarasi
										my_doc.xmlRoot.XmlChildren[9].XmlText = "";
										my_doc.xmlRoot.XmlChildren[10] = XmlElemNew(my_doc,"Pan");//Kredi karti numarasi
										my_doc.xmlRoot.XmlChildren[10].XmlText = attributes.card_no;
										my_doc.xmlRoot.XmlChildren[11] = XmlElemNew(my_doc,"Expiry");//Son kullanma tarihi MM/YY
										my_doc.xmlRoot.XmlChildren[11].XmlText = "#expire_month##expire_year#";
										my_doc.xmlRoot.XmlChildren[12] = XmlElemNew(my_doc,"Cvv2");//Güvenlik numarasi CVV No
										my_doc.xmlRoot.XmlChildren[12].XmlText = "";
										my_doc.xmlRoot.XmlChildren[13] = XmlElemNew(my_doc,"Lang");//Dil
										my_doc.xmlRoot.XmlChildren[13].XmlText = "TR";
										my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"MOTO");//Sabit
										my_doc.xmlRoot.XmlChildren[14].XmlText = 1;
										my_doc.xmlRoot.XmlChildren[15] = XmlElemNew(my_doc,"MerchantId");//Üye İşyeri Numarası
										my_doc.xmlRoot.XmlChildren[15].XmlText = pos_client_id;
										my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"SecureType");//Sabit
										my_doc.xmlRoot.XmlChildren[14].XmlText = "NonSecure";
									}
									else
									{
										my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Name");//Kullanıcı adı-banka tarafından üye işyerine verilir
										my_doc.xmlRoot.XmlChildren[1].XmlText = pos_user_name;
										my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Password");//Şifre-banka tarafından üye işyerine verilir
										my_doc.xmlRoot.XmlChildren[2].XmlText = pos_user_password;
										my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"ClientId");//Mağaza numarası-banka tarafından üye işyerine verilir
										my_doc.xmlRoot.XmlChildren[3].XmlText = pos_client_id;
										my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"Mode");//Sabit
										my_doc.xmlRoot.XmlChildren[4].XmlText = "P";
										my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"OrderId");//Sipariş numarası
										my_doc.xmlRoot.XmlChildren[5].XmlText = wrk_id_invoice;
										my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Type");//İşlem tipi(Provizyon  ve işyeri onayı işlemlerini aynı anda yapar)
										my_doc.xmlRoot.XmlChildren[6].XmlText = "Auth";
										my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"IPAddress");//Alışveriş yapan müşterinin ip adresi
										my_doc.xmlRoot.XmlChildren[7].XmlText = "#cgi.remote_addr#";
										my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"Number");//Kredi kartı numarası
										my_doc.xmlRoot.XmlChildren[8].XmlText = attributes.card_no;
										my_doc.xmlRoot.XmlChildren[9] = XmlElemNew(my_doc,"Expires");//Son kullanma tarihi MM/YY
										my_doc.xmlRoot.XmlChildren[9].XmlText = expire_month & "/" & expire_year;
										my_doc.xmlRoot.XmlChildren[10] = XmlElemNew(my_doc,"Cvv2Val");//Güvenlik numarası CVV No
										if(pos_type eq 14 or pos_type eq 6 or pos_type eq 5 or pos_type eq 16 or pos_type eq 4)// teb ise cvv göndermiyoruz
											my_doc.xmlRoot.XmlChildren[10].XmlText = '';
										else
											my_doc.xmlRoot.XmlChildren[10].XmlText = cvv_no;
										my_doc.xmlRoot.XmlChildren[11] = XmlElemNew(my_doc,"Total");//İşlem yapılacak toplam tutar
										my_doc.xmlRoot.XmlChildren[11].XmlText = tutar;
										my_doc.xmlRoot.XmlChildren[12] = XmlElemNew(my_doc,"Currency");//Para birimi - YTL
										my_doc.xmlRoot.XmlChildren[12].XmlText = "949";
										if (taksit_sayisi neq 0)
										{
											my_doc.xmlRoot.XmlChildren[13] = XmlElemNew(my_doc,"Taksit");//Taksit Sayısı
											my_doc.xmlRoot.XmlChildren[13].XmlText = taksit_sayisi;
											my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"UserId");//Müşteri kodu - Referans alanı olarakda kullanılabilir
											my_doc.xmlRoot.XmlChildren[14].XmlText = "";
											my_doc.xmlRoot.XmlChildren[15] = XmlElemNew(my_doc,"email");//Müşterinin e-mail adresi
											my_doc.xmlRoot.XmlChildren[15].XmlText = "Serpil.Gumus@pronet.com.tr";
											my_doc.xmlRoot.XmlChildren[16] = XmlElemNew(my_doc,"BillTo");//Müşteri
											my_doc.xmlRoot.XmlChildren[16].XmlChildren[1] = XmlElemNew(my_doc,"Name");
											my_doc.xmlRoot.XmlChildren[16].XmlChildren[1].XmlText = attributes.firma_info;
											if (pos_type eq 1 and session.ep.company_id eq 1)
											{
												my_doc.xmlRoot.XmlChildren[17] = XmlElemNew(my_doc,"Extra");
												my_doc.xmlRoot.XmlChildren[17].XmlChildren[1] = XmlElemNew(my_doc,"MAILORDER");
												my_doc.xmlRoot.XmlChildren[17].XmlChildren[1].XmlText = "TRUE";
											}
										}
										else//Eğer peşinse bu parametre gönderilmemelidir
										{
											my_doc.xmlRoot.XmlChildren[13] = XmlElemNew(my_doc,"UserId");//Müşteri kodu - Referans alanı olarakda kullanılabilir
											my_doc.xmlRoot.XmlChildren[13].XmlText = "";
											my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"email");//Müşterinin e-mail adresi
											my_doc.xmlRoot.XmlChildren[14].XmlText = "Serpil.Gumus@pronet.com.tr";
											my_doc.xmlRoot.XmlChildren[15] = XmlElemNew(my_doc,"BillTo");//Müşteri
											my_doc.xmlRoot.XmlChildren[15].XmlChildren[1] = XmlElemNew(my_doc,"Name");
											my_doc.xmlRoot.XmlChildren[15].XmlChildren[1].XmlText = attributes.firma_info;
											if (pos_type eq 1 and session.ep.company_id eq 1)
											{
												my_doc.xmlRoot.XmlChildren[16] = XmlElemNew(my_doc,"Extra");
												my_doc.xmlRoot.XmlChildren[16].XmlChildren[1] = XmlElemNew(my_doc,"MAILORDER");
												my_doc.xmlRoot.XmlChildren[16].XmlChildren[1].XmlText = "TRUE";
											}
											if(pos_type eq 5 and session.ep.company_id eq 3)
											{
												my_doc.xmlRoot.XmlChildren[16] = XmlElemNew(my_doc,"Extra");
												my_doc.xmlRoot.XmlChildren[16].XmlChildren[1] = XmlElemNew(my_doc,"MAILORDER");
												my_doc.xmlRoot.XmlChildren[16].XmlChildren[1].XmlText = "TRUE";
											}
										}
									}
									if(pos_type eq 1)//Akbank
										post_adress = "https://www.sanalakpos.com/servlet/cc5ApiServer";
										//post_adress = "https://vpos.est.com.tr/servlet/cc5ApiServer";
									else if(pos_type eq 3)//iş bankası
										post_adress = "https://spos.isbank.com.tr/servlet/cc5ApiServer";
									else if(pos_type eq 5)//Finansbank
										post_adress = "https://www.fbwebpos.com/servlet/cc5ApiServer";
									else if(pos_type eq 4)//Denizbank
										post_adress = "https://sanalpos.denizbank.com.tr/servlet/cc5ApiServer";
									else if(pos_type eq 6)//HSBC
										post_adress = "https://vpos.advantage.com.tr/servlet/cc5ApiServer";
									else if(pos_type eq 8)//Garanti
										post_adress = "https://sanalposprov.garanti.com.tr/VPServlet";
									else if(pos_type eq 16)//ING
										post_adress = "https://sanalpos.ingbank.com.tr/servlet/cc5ApiServer";
									else if(pos_type eq 14)//teb
										post_adress = "https://vpos.est.com.tr/servlet/cc5ApiServer";
									else if(pos_type eq 17 or pos_type eq 19)//odea
										post_adress = "https://vpos.odeabank.com.tr/MPI/XMLGate.aspx";
										
									if(pos_type eq 17 or pos_type eq 19)
									{
										get_approved_info_3();
										xml_response_node = XmlParse(cfhttp.FileContent);
										response_detail = xml_response_node.PayforResponse.ErrMsg.XmlText;
										response_code = xml_response_node.PayforResponse.ProcReturnCode.XmlText;	
									}
									else
									{
										get_approved_info_1();
										xml_response_node = XmlParse(cfhttp.FileContent);
										if(pos_type eq 8)
										{
											response_detail = xml_response_node.GVPSResponse.Transaction.Response.ErrorMsg.XmlText;
											response_code = xml_response_node.GVPSResponse.Transaction.Response.ReasonCode.XmlText;
										}
										else
										{
											response_detail = xml_response_node.CC5Response.Response.XmlText;
											response_code = xml_response_node.CC5Response.ProcReturnCode.XmlText;
										}
									}
								</cfscript>
							<cfelseif listfind("9,23",pos_type,',')><!--- Sanal pos tipi yapı kredi ise ise --->
								<cfscript>
									my_doc = XmlNew();
									my_doc.xmlRoot = XmlElemNew(my_doc,"posnetRequest");
									if(isdefined('session.ep') and session.ep.company_id eq 1){
										if (taksit_sayisi neq 0)
										{
											my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"mid");
											my_doc.xmlRoot.XmlChildren[1].XmlText = "";
											my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"tid");
											my_doc.xmlRoot.XmlChildren[2].XmlText = "";
										}
										else
										{
											my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"mid");
											my_doc.xmlRoot.XmlChildren[1].XmlText = "";
											my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"tid");
											my_doc.xmlRoot.XmlChildren[2].XmlText = "";
										}
									}else{
										my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"mid");
										my_doc.xmlRoot.XmlChildren[1].XmlText = "";
										my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"tid");
										my_doc.xmlRoot.XmlChildren[2].XmlText = "";
									}
									my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"sale");
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"amount");
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[1].XmlText = tutar;
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[2] = XmlElemNew(my_doc,"ccno");
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[2].XmlText = attributes.card_no;
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[3] = XmlElemNew(my_doc,"currencyCode");
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[3].XmlText = "YT";
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[4] = XmlElemNew(my_doc,"cvc");
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[4].XmlText = 000;
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[5] = XmlElemNew(my_doc,"expDate");
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[5].XmlText = expire_year & expire_month;
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[6] = XmlElemNew(my_doc,"orderID");
									my_doc.xmlRoot.XmlChildren[3].XmlChildren[6].XmlText = trim(member_code & "_" & left(wrk_id_invoice,23 - len(member_code))) & RepeatString("0",24-len(trim(member_code & "_" & left(wrk_id_invoice,23 - len(member_code))))) ;
									
									if (taksit_sayisi neq 0)
									{
										my_doc.xmlRoot.XmlChildren[3].XmlChildren[7] = XmlElemNew(my_doc,"installment");//Taksitli işlemse
										my_doc.xmlRoot.XmlChildren[3].XmlChildren[7].XmlText = taksit_sayisi;
										if(isDefined("attributes.joker_options_value"))//Joker vada seçimi yapılmışsa
										{
											my_doc.xmlRoot.XmlChildren[3].XmlChildren[8] = XmlElemNew(my_doc,"koiCode");
											my_doc.xmlRoot.XmlChildren[3].XmlChildren[8].XmlText = attributes.joker_options_value;
										}
									}
									else
									{
										if(isDefined("attributes.joker_options_value"))//Joker vada seçimi yapılmışsa
										{
											my_doc.xmlRoot.XmlChildren[3].XmlChildren[7] = XmlElemNew(my_doc,"koiCode");
											my_doc.xmlRoot.XmlChildren[3].XmlChildren[7].XmlText = attributes.joker_options_value;
										}
									}		
									post_adress = "https://www.posnet.ykb.com/PosnetWebService/XML?";
									get_approved_info_2();
									xml_response_node = XmlParse(cfhttp.FileContent);
									response_appr = xml_response_node.posnetResponse.approved.XmlText;
									if (response_appr eq 1)
									{
										response_code = "00";
										ykb_inst_num = xml_response_node.posnetResponse.instInfo.inst1.XmlText;
										response_detail = '';
									}
									else
									{
										response_code = xml_response_node.posnetResponse.respCode.XmlText;
										response_detail = xml_response_node.posnetResponse.respText.XmlText;
									}
								</cfscript>							
							</cfif>
                            
							<cfcatch type="any">
								<cfset operation_error = 1>
								Sistem yoğunluğundan dolayı işlem durduruldu.Operasyon Satırları Silindi.
								<cfquery name="GET_ADMIN" datasource="#dsn3#">
									SELECT ADMIN_MAIL FROM #dsn_alias#.OUR_COMPANY WHERE ADMIN_MAIL IS NOT NULL
								</cfquery>
								<cfif get_admin.recordcount and len(get_admin.admin_mail)>
									<cfmail from="#listlast(server_detail)#<#listfirst(server_detail)#>" to="#get_admin.admin_mail#" subject="Otomatik Sanal Pos Hata Bildirimi" type="html">
										#cfcatch.Message#
									</cfmail>
								</cfif>
								<!--- Satırlar önce history tablosuna yazılıyor sonra tablodan siliniyor --->
								<cfquery name="addPosOperationHistory" datasource="#dsn3#" timeout="500">
									INSERT INTO
										POS_OPERATION_ROW_HISTORY
										(
											POS_OPERATION_ACTION_ID,
											POS_OPERATION_ID,
											SUBSCRIPTION_PAYMENT_ROW_ID,
											INVOICE_NET_TOTAL,
											MONEY_TYPE,
											IS_PAID,
											IS_PAYMENT,
											RESPONCE_CODE,
											RESPONCE_DETAIL,
											SUBSCRIPTION_CREDIT_CARD_ID,
											INVOICE_ID,
											RECORD_DATE,
											RECORD_EMP,
											RECORD_IP
										)
										SELECT
											#operation_act_id#,
											POS_OPERATION_ID,
											SUBSCRIPTION_PAYMENT_ROW_ID,
											0,
											'#session.ep.money#',
											0,
											0,
											-3,
											'Sistem yoğunluğundan dolayı işlem durduruldu. Operasyon Satırı Silindi',
											NULL,
											NULL,
											#now()#,
											#session.ep.userid#,
											'#CGI.REMOTE_ADDR#'
										FROM
											POS_OPERATION_ROW
										WHERE
											POS_OPERATION_ID = #attributes.pos_operation_id#
								</cfquery>
								 <cfquery name="upd_rows" datasource="#dsn3#" timeout="500">
									UPDATE
										SUBSCRIPTION_PAYMENT_PLAN_ROW
									SET
										IS_COLLECTED_PROVISION = 0,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										IS_COLLECTED_PROVISION = 1 AND
										IS_PAID = 0 AND
										INVOICE_ID IN(
														SELECT
															SPPR2.INVOICE_ID
														FROM
															SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR,
															SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR2,
															POS_OPERATION_ROW PO
														WHERE
															SPPR.SUBSCRIPTION_PAYMENT_ROW_ID = PO.SUBSCRIPTION_PAYMENT_ROW_ID
															AND PO.POS_OPERATION_ID = #attributes.pos_operation_id#
															AND SPPR.INVOICE_ID = SPPR2.INVOICE_ID
															AND SPPR.PERIOD_ID = SPPR2.PERIOD_ID
														)
								</cfquery>
								<cfquery name="delPosOperationRow" datasource="#dsn3#" timeout="500">
									DELETE FROM POS_OPERATION_ROW WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
								</cfquery>
								<cfabort>
							</cfcatch>
						</cftry>
						<cflog text="#session.ep.name# #session.ep.surname#(#session.ep.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id_invoice#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
						<!--- onay almış ve para hesaba geçirilmiş bir işlemse--->
						<cfif response_code eq 00>
							<cfset credit_error = 0>
							<cftry>
								<cfinclude template="../../bank/query/add_creditcard_revenue_onlinepos_ic.cfm">
								<cfcatch>
									<cfset operation_error = 1>
									<cfset credit_error = 1>
									<cflog text="KK.Tah Kaydı Yapılamadı #session.ep.name# #session.ep.surname#(#session.ep.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id_invoice#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
									<cfquery name="GET_ADMIN" datasource="#dsn3#">
										SELECT ADMIN_MAIL FROM #dsn_alias#.OUR_COMPANY WHERE ADMIN_MAIL IS NOT NULL
									</cfquery>
									<cfif get_admin.recordcount and len(get_admin.admin_mail)>
										<cfmail from="#listlast(server_detail)#<#listfirst(server_detail)#>" to="#get_admin.admin_mail#" subject="Otomatik Sanal Pos Hata Bildirimi" type="html">
											ErrorCode:<cfdump var="#cfcatch.TagContext[1]#"><br>
											Hata : <cfdump var="#cfcatch.message#"><br>
											Detay : <cfdump var="#cfcatch.detail#"><br>
										</cfmail>
									</cfif>
								</cfcatch>
							</cftry>
							<cfquery name="addPosOperationHistory" datasource="#dsn3#" timeout="500">
								INSERT INTO
									POS_OPERATION_ROW_HISTORY
									(
										POS_OPERATION_ACTION_ID,
										POS_OPERATION_ID,
										SUBSCRIPTION_PAYMENT_ROW_ID,
										INVOICE_NET_TOTAL,
										MONEY_TYPE,
										IS_PAID,
										IS_PAYMENT,
										RESPONCE_CODE,
										RESPONCE_DETAIL,
										SUBSCRIPTION_CREDIT_CARD_ID,
										INVOICE_ID,
										WRK_ID,
										RECORD_DATE,
										RECORD_EMP,
										RECORD_IP
									)
									VALUES
									(
										#operation_act_id#,
										#getSanalPos.POS_OPERATION_ID#,
										#getSanalPos.SUBSCRIPTION_PAYMENT_ROW_ID#,
										#attributes.sales_credit#,
										'#session.ep.money#',
										1,
										<cfif credit_error eq 0>1<cfelse>0</cfif>,
										'#response_code#',
										<cfif credit_error eq 0>
											'İşlem Onay aldı. Kredi kartı tahsilatı yapıldı.',
										<cfelse>
											'İşlem Onay aldı. Kredi kartı tahsilatı yapılamadı.',
										</cfif>
										#getSanalPos.MEMBER_CC_ID#,
										#getSanalPos.invoice_id#,
										'#wrk_id_invoice#',
										#now()#,
										#session.ep.userid#,
										'#CGI.REMOTE_ADDR#'
									)
							</cfquery>
                            <cfif len(getSanalPos.company_id)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn3#" timeout="500">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #getSanalPos.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn3#" timeout="500">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #getSanalPos.MEMBER_CC_ID#
								</cfquery>
							</cfif>
						<cfelse>
							<cfquery name="addPosOperationHistory" datasource="#dsn3#" timeout="500">
								INSERT INTO
									POS_OPERATION_ROW_HISTORY
									(
										POS_OPERATION_ACTION_ID,
										POS_OPERATION_ID,
										SUBSCRIPTION_PAYMENT_ROW_ID,
										INVOICE_NET_TOTAL,
										MONEY_TYPE,
										IS_PAID,
										IS_PAYMENT,
										RESPONCE_CODE,
										RESPONCE_DETAIL,
										SUBSCRIPTION_CREDIT_CARD_ID,
										INVOICE_ID,
										RECORD_DATE,
										RECORD_EMP,
										RECORD_IP
									)
									VALUES
									(
										#operation_act_id#,
										#getSanalPos.POS_OPERATION_ID#,
										#getSanalPos.SUBSCRIPTION_PAYMENT_ROW_ID#,
										#attributes.sales_credit#,
										'#session.ep.money#',
										0,
										0,
										'#response_code#',
										<cfif len(response_detail)>'#response_detail#'<cfelse>'Kredi kartı tahsilatı yapılamadı.'</cfif>,
										#getSanalPos.MEMBER_CC_ID#,
										#getSanalPos.invoice_id#,
										#now()#,
										#session.ep.userid#,
										'#CGI.REMOTE_ADDR#'
									)
							</cfquery>
							<cfquery name="updSubsCollectedProv" datasource="#dsn3#" timeout="500">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW 
								SET 
									IS_COLLECTED_PROVISION = 0 ,
                                    UPDATE_DATE = #now()#,
                                    UPDATE_IP = '#cgi.remote_addr#',
                                    UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #getSanalPos.invoice_id# AND
									PERIOD_ID = #getSanalPos.period_id#
							</cfquery>
							<cfif len(getSanalPos.company_id)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn3#" timeout="500">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#response_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #getSanalPos.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn3#" timeout="500">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#response_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #getSanalPos.MEMBER_CC_ID#
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
					<!--- Satırlar önce history tablosuna yazılıyor sonra tablodan siliniyor --->
					<cfquery name="addPosOperationHistory" datasource="#dsn3#" timeout="500">
						INSERT INTO
							POS_OPERATION_ROW_HISTORY
							(
								POS_OPERATION_ACTION_ID,
								POS_OPERATION_ID,
								SUBSCRIPTION_PAYMENT_ROW_ID,
								INVOICE_NET_TOTAL,
								MONEY_TYPE,
								IS_PAID,
								IS_PAYMENT,
								RESPONCE_CODE,
								RESPONCE_DETAIL,
								SUBSCRIPTION_CREDIT_CARD_ID,
								INVOICE_ID,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							SELECT
								#operation_act_id#,
								POS_OPERATION_ID,
								SUBSCRIPTION_PAYMENT_ROW_ID,
								0,
								'#session.ep.money#',
								0,
								0,
								-2,
								'Operasyon Satırı Silindi',
								NULL,
								NULL,
								#now()#,
								#session.ep.userid#,
								'#CGI.REMOTE_ADDR#'
							FROM
								POS_OPERATION_ROW
							WHERE
								POS_OPERATION_ROW_ID = #operation_row_id_#
					</cfquery>
					<cfquery name="delPosOperationRow" datasource="#dsn3#" timeout="500">
						DELETE FROM POS_OPERATION_ROW WHERE POS_OPERATION_ROW_ID = #operation_row_id_#
					</cfquery>
				</cfoutput>
			</cfif>
            <cfquery name="updPosOperationRow" datasource="#dsn3#" timeout="500">
                UPDATE POS_OPERATION SET IS_FLAG = 0 WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
            </cfquery>
        </cftransaction>
    </cflock>
</cfloop>
<cfif is_from_schedule eq 0>
	<cfoutput>
        <script language="javascript">
            eval('pos_operation_td_#attributes.row_no#').style.display = 'none';
            eval('pos_operation_td_2_#attributes.row_no#').style.display = 'none';
			document.getElementById('kontrol_function').value = 1;
        </script>
    </cfoutput>
</cfif>
<cfif pos_status_kontrol eq 0>
	<cfif isdefined("credit_error") and credit_error eq 1>
        <font color="FF0000">Kredi kartı çekimi yapılmış, tahsilat kaydı yapılamayan işlemler mevcut ! Lütfen kontrol ediniz.</font><br />
        <cfif is_from_schedule eq 0>
			<script language="javascript">
                eval('credit_card_td_<cfoutput>#attributes.row_no#</cfoutput>').style.display = '';
            </script>
        </cfif>
	</cfif>
	<cfquery name="del_row" datasource="#dsn3#">
		DELETE FROM POS_OPERATION_STATUS WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>
	İşlem Tamamlandı.
<cfelse>
	<cfif is_from_schedule eq 0 and isdefined("credit_error") and credit_error eq 1>
        <font color="FF0000">Kredi kartı çekimi yapılmış, tahsilat kaydı yapılamayan işlemler mevcut ! Lütfen kontrol ediniz.</font><br />
        <script language="javascript">
            eval('credit_card_td_<cfoutput>#attributes.row_no#</cfoutput>').style.display = '';
        </script>
	</cfif>
	<!--- Satırlar önce history tablosuna yazılıyor sonra tablodan siliniyor --->
	<cfquery name="addPosOperationHistory" datasource="#dsn3#" timeout="500">
		INSERT INTO
			POS_OPERATION_ROW_HISTORY
			(
				POS_OPERATION_ACTION_ID,
				POS_OPERATION_ID,
				SUBSCRIPTION_PAYMENT_ROW_ID,
				INVOICE_NET_TOTAL,
				MONEY_TYPE,
				IS_PAID,
				IS_PAYMENT,
				RESPONCE_CODE,
				RESPONCE_DETAIL,
				SUBSCRIPTION_CREDIT_CARD_ID,
				INVOICE_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			SELECT
				#operation_act_id#,
				POS_OPERATION_ID,
				SUBSCRIPTION_PAYMENT_ROW_ID,
				0,
				'#session.ep.money#',
				0,
				0,
				-3,
				'İşlem Durduruldu. Operasyon Satırı Silindi',
				NULL,
				NULL,
				#now()#,
				#session.ep.userid#,
				'#CGI.REMOTE_ADDR#'
			FROM
				POS_OPERATION_ROW
			WHERE
				POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>
	 <cfquery name="upd_rows" datasource="#dsn3#" timeout="500">
    	UPDATE
        	SUBSCRIPTION_PAYMENT_PLAN_ROW
        SET
        	IS_COLLECTED_PROVISION = 0,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_EMP = #session.ep.userid#
        WHERE
        	IS_COLLECTED_PROVISION = 1 AND
            IS_PAID = 0 AND
        	INVOICE_ID IN(
                            SELECT
                                SPPR2.INVOICE_ID
                            FROM
                                SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR,
                                SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR2,
                                POS_OPERATION_ROW PO
                            WHERE
                                SPPR.SUBSCRIPTION_PAYMENT_ROW_ID = PO.SUBSCRIPTION_PAYMENT_ROW_ID
                                AND PO.POS_OPERATION_ID = #attributes.pos_operation_id#
                                AND SPPR.INVOICE_ID = SPPR2.INVOICE_ID
                                AND SPPR.PERIOD_ID = SPPR2.PERIOD_ID
                            )
    </cfquery>
	<cfquery name="delPosOperationRow" datasource="#dsn3#" timeout="500">
		DELETE FROM POS_OPERATION_ROW WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>
	<cfquery name="del_row" datasource="#dsn3#">
		DELETE FROM POS_OPERATION_STATUS WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>
	İşlem Durduruldu.
</cfif>

