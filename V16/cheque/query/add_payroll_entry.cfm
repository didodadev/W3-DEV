<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="cheque">
<cf_date tarih="attributes.PAYROLL_REVENUE_DATE">
<cf_date tarih='attributes.pyrll_avg_duedate'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION,
		IS_CHEQUE_BASED_ACC_ACTION,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		ACCOUNT_TYPE_ID
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari =get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_cheque_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	is_cheque_based_acc = get_process_type.IS_CHEQUE_BASED_ACC_ACTION;
	is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
	if(not isdefined('xml_import'))
	{
		attributes.payroll_total = filterNum(attributes.payroll_total);
		attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
		for(ff=1; ff lte attributes.record_num; ff=ff+1)
		{
			if (evaluate("attributes.row_kontrol#ff#"))
			{
				'attributes.cheque_system_currency_value#ff#' = filterNum(evaluate("attributes.cheque_system_currency_value#ff#"));
				'attributes.cheque_value#ff#' = filterNum(evaluate("attributes.cheque_value#ff#"));
			}
		}
		for(rt = 1; rt lte attributes.kur_say; rt = rt + 1)
		{
			'attributes.txt_rate1_#rt#' = filterNum(evaluate('attributes.txt_rate1_#rt#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#rt#' = filterNum(evaluate('attributes.txt_rate2_#rt#'),session.ep.our_company_info.rate_round_num);
		}
	}
	branch_id_info = listgetat(form.cash_id,2,';');
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : ""></cfif>
<cfquery name="CONTROL_NO" datasource="#dsn2#">
	SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#"> 
</cfquery>
<cfif control_no.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='125.Aynı Bordro No ya Ait Kayıt Var !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif is_account eq 1>
	<cfif attributes.member_type eq "partner" and len(attributes.company_id)>
		<cfset acc = get_company_period(company_id:attributes.company_id,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	<cfelseif attributes.member_type eq "consumer" and len(attributes.consumer_id)>
		<cfset acc = get_consumer_period(consumer_id:attributes.consumer_id,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	<cfelseif attributes.member_type eq "employee" and len(attributes.employee_id)>
		<cfset acc = get_employee_period(attributes.employee_id,attributes.acc_type_id)>
	</cfif>
	<cfif not len(acc)>
		<script type="text/javascript">
			alert("<cf_get_lang no='126.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<!--- Önce bordro tablosuna kaydediliyor--->
		<cfquery name="ADD_PAYROLL" datasource="#dsn2#">
			INSERT INTO
				PAYROLL
				(
					PROCESS_CAT,
					PAYROLL_TYPE,
					COMPANY_ID,
					CONSUMER_ID,
					EMPLOYEE_ID,
					PAYROLL_AVG_DUEDATE,
					PAYROLL_TOTAL_VALUE,
					PAYROLL_OTHER_MONEY,
					PAYROLL_OTHER_MONEY_VALUE,
					PAYROLL_AVG_AGE,
					NUMBER_OF_CHEQUE,
					PROJECT_ID,
					PAYROLL_CASH_ID,
					CURRENCY_ID,
					PAYROLL_REVENUE_DATE,
					PAYROLL_NO,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,		
					REVENUE_COLLECTOR_ID,
					CHEQUE_BASED_ACC_CARI,
					ACTION_DETAIL,
					BRANCH_ID,
					SPECIAL_DEFINITION_ID,
					ASSETP_ID,
					CONTRACT_ID,
					ACC_TYPE_ID
				)
				VALUES
				(
					#form.process_cat#,
					#process_type#,
					<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
					#attributes.pyrll_avg_duedate#,
					#attributes.payroll_total#,
					<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
					<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
					#attributes.cheque_num#,
					<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					#listfirst(form.cash_id,';')#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					#attributes.payroll_revenue_date#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					#attributes.REVENUE_COLLECTOR_ID#,
					<cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
					<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
					#branch_id_info#,
					<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.contract_id") and len(attributes.contract_id) and len(attributes.contract_head)>#attributes.contract_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM PAYROLL
		</cfquery>
		<cfset p_id=get_bordro_id.P_ID>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.cheque_duedate#i#'>
				<cfquery name="ADD_CHEQUE" datasource="#dsn2#" result="MAX_ID">
					INSERT INTO
						CHEQUE
					(
						CHEQUE_PAYROLL_ID,
						COMPANY_ID,
						CONSUMER_ID,
						EMPLOYEE_ID,
						OWNER_COMPANY_ID,
						OWNER_CONSUMER_ID,
						OWNER_EMPLOYEE_ID,
						CHEQUE_CODE,
						CHEQUE_DUEDATE,
						CHEQUE_NO,
						CHEQUE_VALUE,
						OTHER_MONEY_VALUE,
						OTHER_MONEY,
						OTHER_MONEY_VALUE2,
						OTHER_MONEY2,
						DEBTOR_NAME,
						CHEQUE_STATUS_ID,
						BANK_NAME,
						BANK_BRANCH_NAME,
						ACCOUNT_NO,
						ACCOUNT_ID,
						CHEQUE_CITY,
						TAX_NO,
						TAX_PLACE,
						CHEQUE_PURSE_NO,
						CURRENCY_ID,
						SELF_CHEQUE,
						ENDORSEMENT_MEMBER,
						CASH_ID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						CH_OTHER_MONEY_VALUE,
						CH_OTHER_MONEY,
						ENTRY_DATE		
					)
					VALUES
					(
						#P_ID#,
						<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.cheque_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_code#i#")#'>,<cfelse>NULL,</cfif>
						#evaluate("attributes.cheque_duedate#i#")#,
						<cfif len(evaluate("attributes.cheque_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_no#i#")#'>,<cfelse>NULL,</cfif>
						#evaluate("attributes.cheque_value#i#")#,
						<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.system_money_info#i#')#">,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.other_money2#i#')#">,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.debtor_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.debtor_name#i#')#">,<cfelse>NULL,</cfif>
						1,
						<cfif len(evaluate("attributes.bank_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.bank_name#i#')#">,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.bank_branch_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_branch_name#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.account_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.account_no#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.account_id#i#"))>#wrk_eval("attributes.account_id#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.cheque_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_city#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.tax_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tax_no#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.tax_place#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tax_place#i#")#'>,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#portfoy_no#'>,
						<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.from_cheque_info#i#"))>#evaluate("attributes.from_cheque_info#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.endorsement_member#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#evaluate("attributes.endorsement_member#i#")#'>,<cfelse>NULL,</cfif>
						 #listfirst(form.cash_id,';')#,
						 #session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>,
						#now()#,
						#wrk_round((evaluate("attributes.cheque_system_currency_value#i#")/attributes.basket_money_rate),4)#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
						#attributes.payroll_revenue_date#
					)
				</cfquery>
				<cfif len(evaluate("attributes.money_list#i#"))>
					<cfloop from="1" to="#ListGetAt(evaluate("attributes.money_list#i#"),1,'-')#" index="j">
						<cfset money = ListGetAt(evaluate("attributes.money_list#i#"),j+1,'-')>
						<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
							INSERT INTO CHEQUE_MONEY 
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
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(money,1,',')#">,
								#ListGetAt(money,3,',')#,					
								#ListGetAt(money,2,',')#,
								<cfif ListGetAt(money,1,',') is evaluate("attributes.currency_id#i#")>1<cfelse>0</cfif>
							)
						</cfquery>
					</cfloop>
				</cfif>
				<cfset portfoy_no = portfoy_no+1>
			</cfif>
		</cfloop>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque',belge_no:portfoy_no)>
		<!--- Bu bordroya girilen çekler cheque tablosundan alınıyor,işlem türü ne olursa olsun çekin son durumu history ye kaydedilebilecek--->
		<cfquery name="GET_LAST_CHEQUES" datasource="#dsn2#">
			SELECT * FROM CHEQUE WHERE CHEQUE_PAYROLL_ID=#P_ID#
		</cfquery>
		<!--- Bordroya girilen çekler için cheque_history tablosuna giriþ yapılıyor...--->
		<cfoutput query="get_last_cheques">
			<cfquery name="ADD_CHEQUE_HISTORY" datasource="#dsn2#">
				INSERT INTO
					CHEQUE_HISTORY
						(
							CHEQUE_ID,
							PAYROLL_ID,
							COMPANY_ID,
							CONSUMER_ID,
							EMPLOYEE_ID,
							STATUS,
							ACT_DATE,
							SELF_CHEQUE,
							OTHER_MONEY_VALUE,
							OTHER_MONEY,
							OTHER_MONEY_VALUE2,
							OTHER_MONEY2,
							RECORD_DATE
						)
					VALUES
						(
							#CHEQUE_ID#,
							#CHEQUE_PAYROLL_ID#,
							<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
							#CHEQUE_STATUS_ID#,
							#attributes.PAYROLL_REVENUE_DATE#,
							#SELF_CHEQUE#,
							<cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
							<cfif len(OTHER_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#OTHER_MONEY#">,<cfelse>NULL,</cfif>
							<cfif len(OTHER_MONEY_VALUE2)>#OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
							<cfif len(OTHER_MONEY2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#OTHER_MONEY2#">,<cfelse>NULL,</cfif>
							#NOW()#
						)
			</cfquery>
		</cfoutput>
		<cfscript>
			currency_multiplier = ''; //sistem ikinci para biriminin kurunu sayfadan alıyor
			paper_currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.basket_money)
						paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			if(is_cari eq 1)
			{
				if(is_cheque_based eq 1) /*cari hareket cek bazında yapılıyor.cek bazında carici calıstırılırken ACTION_TABLE parametresine dikkat plz...*/
				{				
					for(ind_cari=1; ind_cari lte get_last_cheques.recordcount; ind_cari=ind_cari+1)
					{
						if(get_last_cheques.CURRENCY_ID[ind_cari] is not session.ep.money)
						{
							other_money =get_last_cheques.CURRENCY_ID[ind_cari];
							other_money_value =get_last_cheques.CHEQUE_VALUE[ind_cari];
						}
						else if(len(attributes.basket_money) and len(attributes.basket_money_rate))
						{
							other_money = attributes.basket_money;
							other_money_value = wrk_round(get_last_cheques.OTHER_MONEY_VALUE[ind_cari]/attributes.basket_money_rate);
						}
						else if(len(get_last_cheques.OTHER_MONEY_VALUE2[ind_cari]) and len(get_last_cheques.OTHER_MONEY2[ind_cari]))
						{
							other_money =get_last_cheques.OTHER_MONEY2[ind_cari];
							other_money_value =get_last_cheques.OTHER_MONEY_VALUE2[ind_cari];
						}
						else
						{
							other_money =get_last_cheques.OTHER_MONEY[ind_cari];
							other_money_value =get_last_cheques.OTHER_MONEY_VALUE[ind_cari];
						}
						paper_currency_multiplier = '';
						if(isDefined('attributes.kur_say') and len(attributes.kur_say))
							for(mon=1;mon lte attributes.kur_say;mon=mon+1)
							{
								if(evaluate("attributes.hidden_rd_money_#mon#") is other_money)
									paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
							}
						carici(
							action_id :get_last_cheques.CHEQUE_ID[ind_cari],
							workcube_process_type :process_type,		
							process_cat : form.process_cat,
							account_card_type :13,
							action_table :'CHEQUE',
							islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
							islem_tutari :get_last_cheques.OTHER_MONEY_VALUE[ind_cari],
							other_money_value : iif(isdefined('other_money_value'),'other_money_value',de('')),
							other_money :iif(isdefined('other_money'),'other_money',de('')),
							islem_belge_no : get_last_cheques.CHEQUE_NO[ind_cari],
							action_currency :session.ep.money,
							to_cash_id : listfirst(form.cash_id,';'),
							due_date :iif(len(get_last_cheques.CHEQUE_DUEDATE[ind_cari]),'createodbcdatetime(get_last_cheques.CHEQUE_DUEDATE[ind_cari])','attributes.pyrll_avg_duedate'),
							from_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
							from_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
							from_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
							currency_multiplier : currency_multiplier,
							islem_detay : 'ÇEK GİRİŞ BORDROSU(Çek Bazında)',
							acc_type_id : attributes.acc_type_id,
							action_detail : attributes.action_detail,
							project_id : attributes.project_id,
							to_branch_id : branch_id_info,
							payroll_id :P_ID,
							special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
							assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
							rate2:paper_currency_multiplier
							);
					}
				}
				else
				{
					carici(
						action_id :P_ID,
						workcube_process_type :process_type,		
						process_cat : form.process_cat,
						account_card_type :13,
						action_table :'PAYROLL',
						islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
						islem_tutari :attributes.payroll_total,
						other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_money :iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						islem_belge_no : attributes.PAYROLL_NO,
						action_currency :session.ep.money,
						to_cash_id :listfirst(form.cash_id,';'),
						due_date : attributes.pyrll_avg_duedate,
						from_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						from_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						from_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						currency_multiplier : currency_multiplier,
						islem_detay : 'ÇEK GİRİŞ BORDROSU',
						acc_type_id : attributes.acc_type_id,
						action_detail : attributes.action_detail,
						project_id : attributes.project_id,
						to_branch_id : branch_id_info,
						special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
						assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
						rate2:paper_currency_multiplier
						);
				}
			}
			/*kullanicinin muhasebe hesabi entegre mi diye kontrol edildikten sonra
			account_card ve account_card_rows tablosuna kayit yapilacak. burada kasa "borçlu", firma
			"alacakli" olacak*/
			if(is_account eq 1)
			{	
				if(is_cheque_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
				{
					GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					borc_tutarlar = '';
					borc_hesaplar = '';
					other_currency_borc_list= '';
					other_amount_borc_list= '';
					satir_detay_list = ArrayNew(2);
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") neq session.ep.money)
								borc_tutarlar = listappend(borc_tutarlar,evaluate("attributes.cheque_system_currency_value#i#"),',');
							else
								borc_tutarlar=listappend(borc_tutarlar,evaluate("attributes.cheque_value#i#"),',');
								
							other_currency_borc_list = listappend(other_currency_borc_list,listgetat(form.cash_id,3,';'),',');
							other_amount_borc_list =  listappend(other_amount_borc_list,evaluate("attributes.cheque_value#i#"),',');
							borc_hesaplar=listappend(borc_hesaplar,GET_ACC_CODE.A_CHEQUE_ACC_CODE,',');
							
							if (is_account_group neq 1)
							{
								if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
									satir_detay_list[1][listlen(borc_tutarlar)]='Ç.G.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
								else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[1][listlen(borc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
								else
									satir_detay_list[1][listlen(borc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';					
							}
							else
							{
								if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
									satir_detay_list[1][listlen(borc_tutarlar)]='Ç.G.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
								else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[1][listlen(borc_tutarlar)] = ' #attributes.company_name# - #attributes.action_detail#';
								else
									satir_detay_list[1][listlen(borc_tutarlar)] = ' #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';					
							}
						}
					}
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						satir_detay_list[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
					else
						satir_detay_list[2][1] = ' #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';					
					muhasebeci (
						action_id:P_ID,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'PAYROLL',
						islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
						company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						borc_hesaplar: borc_hesaplar,
						borc_tutarlar: borc_tutarlar,
						other_amount_borc : other_amount_borc_list,
						other_currency_borc :other_currency_borc_list,
						alacak_hesaplar: acc,
						alacak_tutarlar: attributes.payroll_total,
						other_amount_alacak : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_currency_alacak : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						fis_detay:'ÇEK GİRİŞ İŞLEMİ',
						fis_satir_detay: satir_detay_list,
						currency_multiplier : currency_multiplier,
						belge_no : form.payroll_no,
						to_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						acc_project_id : attributes.project_id,
						is_account_group : is_account_group
					);	
				}
				else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
				{
					GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					satir_detay_list = ArrayNew(2);
					for(kk=1; kk lte get_last_cheques.recordcount; kk=kk+1)
					{
						if(get_last_cheques.CURRENCY_ID[kk] neq session.ep.money)
							borc_tutar = get_last_cheques.OTHER_MONEY_VALUE[kk];
						else
							borc_tutar = get_last_cheques.CHEQUE_VALUE[kk];
						
						if (is_account_group neq 1)
						{
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[1][1] = ' #get_last_cheques.cheque_no[kk]# - #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[1][1] = ' #get_last_cheques.cheque_no[kk]# - #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';					
						}
						else
						{
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[1][1] = ' #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';					
						}
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
							satir_detay_list[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
						else
							satir_detay_list[2][1] = ' #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';	
												
						muhasebeci (
							action_id : P_ID,
							action_row_id : get_last_cheques.CHEQUE_ID[kk],
							due_date :iif(len(get_last_cheques.CHEQUE_DUEDATE[kk]),'createodbcdatetime(get_last_cheques.CHEQUE_DUEDATE[kk])','attributes.pyrll_avg_duedate'),
							workcube_process_type:process_type,
							account_card_type:13,
							action_table :'PAYROLL',
							islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
							company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
							consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
							employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
							borc_hesaplar: GET_ACC_CODE.A_CHEQUE_ACC_CODE,
							borc_tutarlar: borc_tutar,
							other_amount_borc : get_last_cheques.CHEQUE_VALUE[kk],
							other_currency_borc : listgetat(form.cash_id,3,';'),
							alacak_hesaplar: acc,
							alacak_tutarlar: borc_tutar,
							other_amount_alacak : get_last_cheques.OTHER_MONEY_VALUE[kk]/paper_currency_multiplier,
							other_currency_alacak : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
							fis_detay:'ÇEK GİRİŞ İŞLEMİ',
							fis_satir_detay: satir_detay_list,
							currency_multiplier : currency_multiplier,
							belge_no : get_last_cheques.CHEQUE_NO[kk],
							to_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat,
							acc_project_id : attributes.project_id,
							is_account_group : is_account_group
						);
					}
				}
			}
			basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:11,process_type:0);
		</cfscript>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #p_id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_entry&event=upd&id=#p_id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
            <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#p_id#" action_name="#PAYROLL_NO# Eklendi" paper_no="#PAYROLL_NO#" period_id="#session.ep.period_id#" process_type="#process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock> 
<script type="text/javascript">
<cfset attributes.actionId=p_id>
	<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.company_id) or len(attributes.consumer_id) or len(attributes.employee_id))>
		window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.company_id#&consumer_id=#attributes.consumer_id#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#attributes.basket_money#&row_action_id=#p_id#&row_action_type=#process_type#</cfoutput>','page');
	</cfif>	
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_entry&event=upd&id=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
