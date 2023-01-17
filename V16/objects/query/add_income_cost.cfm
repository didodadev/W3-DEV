<cf_get_lang_set module_name="objects"><!--- sayfanin en altinda kapanisi var --->
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cf_date tarih = 'attributes.expense_date'>
<cf_date tarih = "attributes.basket_due_value_date_">
<cfif isDefined("attributes.basket_due_value_date_") and len(attributes.basket_due_value_date_)>
	<cfset income_due_date = attributes.basket_due_value_date_>
<cfelse>
	<cfset income_due_date = attributes.expense_date>
</cfif>
<cfif not isdefined("form.belge_no")>
	<cfif isdefined('form.serial_number') and len(form.serial_number)>
		<cfset attributes.belge_no = "#form.serial_number#-#form.serial_no#">
	<cfelse>
		<cfset attributes.belge_no = "#form.serial_no#">
	</cfif>
</cfif>
<cfscript>
	//Proses Tipleri İçin İşlemler
	get_process_type = cfquery(datasource : "#dsn3#", sqlstring : "SELECT PROFILE_ID,ISNULL(IS_ROW_PROJECT_BASED_CARI,0) IS_ROW_PROJECT_BASED_CARI,IS_PROJECT_BASED_ACC,PROCESS_TYPE, IS_CARI, IS_ACCOUNT,ACTION_FILE_SERVER_ID,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_ACCOUNT_GROUP,IS_EXP_BASED_ACC,IS_PAYMETHOD_BASED_CARI,IS_EXPENSING_TAX FROM SETUP_PROCESS_CAT WHERE  PROCESS_CAT_ID = #attributes.process_cat#");
	is_expensing_tax = get_process_type.IS_EXPENSING_TAX;
	process_type = get_process_type.process_type;
	inv_profile_id = get_process_type.PROFILE_ID;
	is_project_based_acc = get_process_type.IS_PROJECT_BASED_ACC;
	is_row_project_based_cari = get_process_type.IS_ROW_PROJECT_BASED_CARI;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
	account_group=get_process_type.is_account_group;
	is_exp_based_acc = get_process_type.is_exp_based_acc;
	is_paymethod_based_cari=get_process_type.is_paymethod_based_cari;
	is_cari_islem=0;
	str_alacak_tutar_list="";
	str_alacak_kod_list="";
	str_borc_tutar_list="";
	str_borc_kod_list="";
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
	str_alacak_miktar = ArrayNew(1);
	//float_tax_value = attributes.other_kdv_total_amount;
	//cash_action_value = attributes.other_net_total_amount;
	rd_money_value = listfirst(attributes.rd_money, ',');
	acc = '';
	rate_round_info_=session.ep.our_company_info.rate_round_num;
	str_other_alacak_tutar_list = "";
	str_other_borc_tutar_list = "";
	str_other_borc_currency_list = "";
	str_other_alacak_currency_list = "";
	acc_project_list_alacak='';
	acc_project_list_borc='';
	//Kasa Seçili İse Kasanın Para Birimi ve Muhasebe Kodu 
	attributes.acc_type_id = '';
	if(listlen(attributes.emp_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.emp_id,'_');
		attributes.emp_id = listfirst(attributes.emp_id,'_');
	}
	if((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))//cari seçilmiş ise
	{
		is_cari_islem=1;
		if(attributes.ch_member_type eq "partner")
			string_acc_code = GET_COMPANY_PERIOD(attributes.ch_company_id);
		else if(attributes.ch_member_type eq "consumer")
			string_acc_code = GET_CONSUMER_PERIOD(attributes.ch_partner_id);
		else
			string_acc_code = GET_EMPLOYEE_PERIOD(attributes.emp_id,attributes.acc_type_id);

		string_currency_id = session.ep.money;
	}
	else if(isdefined("attributes.cash"))
	{
		get_cash_ = cfquery(datasource : "#dsn2#", sqlstring : "SELECT CASH_CURRENCY_ID, CASH_ACC_CODE FROM CASH WHERE CASH_ID = #ListFirst(attributes.kasa,";")#");
		//get_money = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_950, RATE1, RATE2 FROM #dsn_alias#.SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY='#get_cash_.cash_currency_id#'");
		string_acc_code = get_cash_.cash_acc_code;
		string_currency_id = get_cash_.cash_currency_id;
	}
	else if(isdefined("attributes.bank"))//Banka Seçili İse Bankanın Para Birimi ve Muhasebe Kodu
	{
		string_acc_code = attributes.account_acc_code;
		string_currency_id = attributes.currency_id;
	}
	//float_tax_value = attributes.kdv_total_amount;
	//float_action_value = attributes.net_total_amount;
	currency_multiplier = 1;
	currency_multiplier_banka = 1;
	currency_multiplier_money2 = 1;
	rd_money_rate=1;
	if(isDefined('attributes.kur_say') and len(attributes.kur_say)){
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(isdefined('attributes.cash') and evaluate("attributes.hidden_rd_money_#mon#") is ListGetAt(attributes.kasa,2,";"))
					currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(isdefined('attributes.bank') and evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
					currency_multiplier_banka = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
					currency_multiplier_money2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
					rd_money_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				"last_rate_1_#evaluate("attributes.hidden_rd_money_#mon#")#" = evaluate('attributes.txt_rate1_#mon#');
			}
		}
	if (isdefined("attributes.ch_company_id") and len(attributes.ch_company_id) and isdefined("attributes.ch_company") and len(attributes.ch_company) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner')
	{
		to_company_id = attributes.ch_company_id;
		to_consumer_id = '';
		to_employee_id= '';
	}
	else if (isdefined("attributes.ch_partner_id") and len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer')
	{
		to_consumer_id = attributes.ch_partner_id;
		to_company_id = '';
		to_employee_id= '';
	}
	else if (isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee')
	{
		to_employee_id = attributes.emp_id;
		to_company_id = '';
		to_consumer_id= '';
	}
	if (isdefined("attributes.cash"))
		branch_id_info = ListGetAt(attributes.kasa,3,";");
	else if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)) main_project_id = attributes.project_id; else main_project_id = 0;
	if(isdefined("attributes.project_id")  and len(attributes.project_id) and len(attributes.project_head))
		project_id_info = attributes.project_id;
	else
		project_id_info = '';
	/* satir aciklamalari */
	if(len(attributes.detail))
		detail_ = '- #attributes.detail#';
	else
		detail_ = '';	
	fis_satir_row_detail = '#attributes.belge_no# #detail_# - ' & UCase(getLang('main',653));
</cfscript>
<cfif isdefined("attributes.ch_company_id") and len(attributes.ch_company_id) and isdefined("attributes.ch_company") and len(attributes.ch_company) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner'>
	<cfquery name="get_customer_info" datasource="#DSN2#">
		SELECT
			PROFILE_ID
		FROM
			#dsn_alias#.COMPANY
		WHERE
			COMPANY_ID=#attributes.ch_company_id#
	</cfquery>
	<cfif len(get_customer_info.profile_id)><cfset inv_profile_id = get_customer_info.profile_id></cfif>
<cfelseif isdefined("attributes.ch_partner_id") and len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer'>
	<cfquery name="get_customer_info" datasource="#DSN2#">
		SELECT
			PROFILE_ID
		FROM
			#dsn_alias#.CONSUMER
		WHERE
			CONSUMER_ID=#attributes.ch_partner_id#
	</cfquery>
	<cfif len(get_customer_info.profile_id)><cfset inv_profile_id = get_customer_info.profile_id></cfif>
</cfif>
<cf_papers paper_type="income_cost">
<cflock timeout="60" name="#CreateUUID()#">
	<cftransaction>	
		<cfquery name="ADD_EXPENSE_TOTAL_COST" datasource="#dsn2#">
			INSERT INTO
				EXPENSE_ITEM_PLANS
				(
					WRK_ID,
					IS_BANK,
					IS_CASH,
					EXPENSE_CASH_ID,
					EXPENSE_COST_TYPE,<!--- masraf tipi nerden geldiği --->
					OTHER_MONEY_AMOUNT,<!--- döviz toplam --->
					OTHER_MONEY_KDV,<!--- döviz kdv toplam --->
					OTHER_MONEY_OTV,
					OTHER_MONEY_NET_TOTAL,<!--- döviz kdvli toplam --->
					OTHER_MONEY,<!--- döviz birimi --->
					PAYMETHOD_ID,<!--- ödeme yöntemi --->
					SERIAL_NUMBER,<!--- seri number --->
					SERIAL_NO,<!--- seri no --->
					PAPER_NO,<!--- belge no --->
					PROCESS_CAT,<!--- işlem kategorisi idsi --->
					ACTION_TYPE,<!--- işlem kat tipi --->
					EMP_ID,<!--- masraf ödeme yapan tipi --->
					EXPENSE_DATE,<!--- masraf fişi tarihi --->
					PAPER_TYPE,<!--- masraf belge türü --->
					SYSTEM_RELATION,<!--- ref no sistem ilişkisi--->
					DETAIL,<!--- açıklama --->
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					TOTAL_AMOUNT,<!--- toplam --->
					KDV_TOTAL,<!--- kdv toplam --->
					OTV_TOTAL,
					BSMV_TOTAL,
					OIV_TOTAL,
					TOTAL_AMOUNT_KDVLI,<!--- kdvli toplam --->
					CH_COMPANY_ID,
					CH_PARTNER_ID,
					CH_CONSUMER_ID,
					CH_EMPLOYEE_ID,
					DUE_DATE,<!--- Vade Tarihi --->
					BRANCH_ID,
					PROJECT_ID,
                    ACC_TYPE_ID,
                	SHIP_ADDRESS_ID,
                	SHIP_ADDRESS,
					PROFILE_ID,
                    STOPAJ,
                    STOPAJ_ORAN,
                    STOPAJ_RATE_ID ,
					TEVKIFAT,
					TEVKIFAT_ORAN,
					TEVKIFAT_ID,
					IS_IPTAL
					<cfif IsDefined("attributes.law_request_id") and len(attributes.law_request_id)>,LAW_REQUEST_ID</cfif>
					<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>,PROCESS_STAGE</cfif>            
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
					<cfif isdefined("attributes.bank")>1,<cfelse>0,</cfif>
					<cfif isdefined("attributes.cash")>1,<cfelse>0,</cfif>
					<cfif isdefined("attributes.cash")>#ListFirst(attributes.kasa,";")#<cfelseif isdefined("attributes.bank")>#attributes.account_id#<cfelse>NULL</cfif>,
					121,<!--- gelir fişi işlem tipi --->
					<cfif len(attributes.other_total_amount)>#attributes.other_total_amount#<cfelse>NULL</cfif>,
					<cfif len(attributes.other_kdv_total_amount)>#attributes.other_kdv_total_amount#<cfelse>NULL</cfif>,
					<cfif len(attributes.other_otv_total_amount)>#attributes.other_otv_total_amount#<cfelse>0</cfif>,
					<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#<cfelse>NULL</cfif>,
					<cfif len(rd_money_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#rd_money_value#"><cfelse>NULL</cfif>,
					<cfif len(attributes.paymethod) and len(attributes.paymethod_name)>#attributes.paymethod#<cfelse>NULL</cfif>,
					<cfif len(attributes.serial_number)>#sql_unicode()#'#attributes.serial_number#',<cfelse>NULL,</cfif>
					<cfif len(attributes.serial_no)>#sql_unicode()#'#attributes.serial_no#'<cfelse>NULL</cfif>,
					<cfif len(attributes.belge_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.belge_no#"><cfelse>NULL</cfif>,
					#attributes.process_cat#,
					#process_type#,
					<cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.expense_date)>#attributes.expense_date#,<cfelse>NULL,</cfif>
					<cfif len(attributes.expense_paper_type)>#attributes.expense_paper_type#,<cfelse>NULL,</cfif>
					<cfif len(attributes.system_relation)>#sql_unicode()#'#attributes.system_relation#',<cfelse>NULL,</cfif>
					<cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#',<cfelse>NULL,</cfif>
					#now()#,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					#attributes.total_amount#,
					#attributes.kdv_total_amount#,
					<cfif len(attributes.otv_total_amount)>#attributes.otv_total_amount#<cfelse>0</cfif>,
					<cfif len(attributes.bsmv_total_amount)>#attributes.bsmv_total_amount#<cfelse>0</cfif>,
					<cfif len(attributes.oiv_total_amount)>#attributes.oiv_total_amount#<cfelse>0</cfif>,
					#attributes.net_total_amount#,
					<cfif len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner'> 
						<cfif len(attributes.ch_company) and len(attributes.ch_company_id)>#attributes.ch_company_id#,<cfelse>NULL,</cfif>
						<cfif len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#,<cfelse>NULL,</cfif>
						NULL,
						NULL,
					<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer'>
						NULL,
						NULL,
						<cfif len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
						NULL,
					<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee'>
						NULL,
						NULL,
						NULL,
						<cfif len(attributes.ch_member_type) and len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
					<cfelse>
						NULL,
						NULL,
						NULL,
						NULL,
					</cfif>
					#income_due_date#,
					#branch_id_info#,
					<cfif len(project_id_info)>#project_id_info#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
                	<cfif isdefined("attributes.ship_address_id") and isdefined("attributes.adres") and  len(attributes.ship_address_id) and len(attributes.adres)>'#attributes.ship_address_id#'<cfelse>NULL</cfif>,
                	<cfif isdefined("attributes.ship_address_id") and isdefined("attributes.adres") and  len(attributes.ship_address_id) and len(attributes.adres)>'#attributes.adres#'<cfelse>NULL</cfif>,
					<cfif isdefined("inv_profile_id") and len(inv_profile_id)>'#inv_profile_id#'<cfelse>NULL</cfif>,
                    <cfif isdefined("form.stopaj") and len(form.stopaj)>#form.stopaj#<cfelse>0</cfif>,
					<cfif isdefined("form.stopaj_yuzde") and len(form.stopaj_yuzde)>#form.stopaj_yuzde#<cfelse>0</cfif>,
                    <cfif isdefined("form.stopaj_rate_id") and len(form.stopaj_rate_id)>#form.stopaj_rate_id#<cfelse>0</cfif>,
					<cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
					0
					<cfif IsDefined("attributes.law_request_id") and len(attributes.law_request_id)>,<cfqueryparam value = "#attributes.law_request_id#" CFSQLType = "cf_sql_integer" ></cfif>
					<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"></cfif>
				)
				SELECT @@IDENTITY AS MAX_EXPENSE_ID
		</cfquery>

		<cfset attributes.expense_id = ADD_EXPENSE_TOTAL_COST.MAX_EXPENSE_ID>
		<!--- 20120322 ENV Gelir Fisinin hesaplanmasinda guncelleme yapildi. --->
		<!--- Kasa Seçili İse Kasaya Hareket Yapacak --->
	 	<cfif isdefined("attributes.cash")>
			<cfinclude template="add_income_cash_action.cfm">
		</cfif>
		<!--- Banka Seçili İse Bankaya Hareket Yapacak --->
		<cfif isdefined("attributes.bank")>
			<cfinclude template="add_income_bank_action.cfm">
		</cfif>	
		
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<cfset form_money_1 = listgetat(evaluate("attributes.money_id#i#"), 1, ',')>
					<cfset form_other_value = evaluate("attributes.other_net_total#i#")>
					<cfset form_value = evaluate("attributes.net_total#i#")>
					<cfset vergiler_ = 0>
					<cfif len(form_other_value) and form_other_value gt 0>
						<cfset rate1_row_ = evaluate("last_rate_1_#form_money_1#")>
						<cfset money_value = wrk_round(((form_value/form_other_value*rate1_row_)),session.ep.our_company_info.rate_round_num)>
						<cfset money_value = money_value/rate1_row_>
						<cfif isDefined("attributes.tax_rate#i#") and Len(evaluate("attributes.tax_rate#i#"))><cfset vergiler_ = vergiler_ + evaluate("attributes.tax_rate#i#")></cfif>
						<cfset form_other_kdvsiz_value = wrk_round(form_other_value/((vergiler_+100)/100))>
					<cfelse>
						<cfset money_value = 1>
						<cfset form_other_kdvsiz_value = 0>
					</cfif>
                    
                    <cfif isdefined('attributes.reason_code#i#') and len(evaluate('attributes.reason_code#i#'))>
						<cfset reasonCode = Replace(evaluate('attributes.reason_code#i#'),'--','*')>
                    <cfelse>
                        <cfset reasonCode = ''>
                    </cfif>
                    
					<cfif isdefined("attributes.expense_date#i#") and isdefined("attributes.expense_date#i#")>
						<cf_date tarih="attributes.expense_date#i#">
					</cfif>
					<cfif isdefined("attributes.receipt_date#i#") and len(evaluate("attributes.receipt_date#i#"))>
						<cf_date tarih="attributes.receipt_date#i#">
					</cfif>
					<cfquery name="ADD_EXPENSE_ROWS" datasource="#dsn2#">
						INSERT
							INTO
							EXPENSE_ITEMS_ROWS
							(
								EXPENSE_ID,<!--- masraf fişi idsi --->
								EXPENSE_DATE,<!--- masraf fişi tarihi --->
								RECEIPT_DATE,
								EXPENSE_CENTER_ID,<!--- masraf merkezi --->
								EXPENSE_ITEM_ID,<!--- gider kalemi --->
								EXPENSE_COST_TYPE,<!--- masraf tipi nerden geldiği --->
								PAPER_TYPE,<!--- masraf velge tipi --->
								DETAIL,<!--- masraf satır açıklaması--->
								SYSTEM_RELATION,<!--- masraf ref no --->
								IS_INCOME,<!--- gelir gider kalemi bilgisi --->
								ACTION_ID,<!--- banka kasa vs işleminin ilişkili oldugu id --->
								EXPENSE_EMPLOYEE,<!--- nasraf fişinin ödeme yapanı --->
								COMPANY_ID,<!--- cari --->
								COMPANY_PARTNER_ID,<!---harcama yapan partner veya consumer veya çalışan --->
								MEMBER_TYPE,<!--- harcama yapanın tipi --->
								PYSCHICAL_ASSET_ID,<!--- fiziki varlık --->
								PROJECT_ID,<!--- proje --->
								ACTIVITY_TYPE,<!--- aktivite tipi --->
								AMOUNT,<!--- tutar --->
								KDV_RATE,<!--- kdv oranı --->
								OTV_RATE,
								AMOUNT_KDV,<!--- kdv tutarı --->
								AMOUNT_OTV,
								TOTAL_AMOUNT,<!--- kdvli toplam --->
								MONEY_CURRENCY_ID,<!--- satırdaki para birimi --->
								OTHER_MONEY_VALUE,<!--- satırdaki kdvsiz döviz tutarı --->
								OTHER_MONEY_GROSS_TOTAL,<!--- satırdaki kdvli döviz tutarı --->
								OTHER_MONEY_VALUE_2,<!--- sistem 2. para biriminden değeri --->
								MONEY_CURRENCY_ID_2,<!--- sistem 2. para birimi --->
								QUANTITY,
								PRODUCT_ID,
								STOCK_ID_2,
								PRODUCT_NAME,
                                UNIT_ID,
								UNIT,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								BRANCH_ID,
								WORK_ID,
								OPP_ID,
								SUBSCRIPTION_ID,
								EXPENSE_ACCOUNT_CODE,
								TAX_CODE <!--- vergi kodu --->
								<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
                                <cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,AMOUNT_BSMV</cfif>
                                <cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_CURRENCY</cfif>
                                <cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
                                <cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,AMOUNT_OIV</cfif>
                                <cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
                                <cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,AMOUNT_TEVKIFAT</cfif>
                                ,REASON_CODE
                                ,REASON_NAME
							)
							VALUES
							(
								#add_expense_total_cost.max_expense_id#,
								<cfif isdefined("attributes.expense_date#i#") and len(evaluate("attributes.expense_date#i#"))>#evaluate("attributes.expense_date#i#")#<cfelseif len(attributes.expense_date)>#attributes.expense_date#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.receipt_date#i#") and len(evaluate("attributes.receipt_date#i#"))>#evaluate("attributes.receipt_date#i#")#<cfelseif isdefined("attributes.expense_date#i#") and len(evaluate("attributes.expense_date#i#"))>#evaluate("attributes.expense_date#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_center_id#i#") and Len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_item_id#i#") and Len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
								121,<!--- gelir fişi işlem tipi --->
								<cfif isDefined("attributes.expense_paper_type") and len(attributes.expense_paper_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_paper_type#"><cfelse>NULL</cfif>,
								<cfif isDefined("attributes.row_detail#i#") and Len(wrk_eval("attributes.row_detail#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.row_detail#i#')#"><cfelse>NULL</cfif>,
								<cfif isDefined("attributes.system_relation") and len(attributes.system_relation)>#sql_unicode()#'#attributes.system_relation#'<cfelse>NULL</cfif>,
								1,
								0,
								<cfif isDefined("attributes.expense_employee_id") and len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.company_id#i#") and len(evaluate("attributes.company#i#")) and len(evaluate("attributes.company_id#i#"))>#evaluate("attributes.company_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.authorized#i#") and len(evaluate("attributes.authorized#i#")) and len(evaluate("attributes.member_id#i#"))>#evaluate("attributes.member_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.member_type#i#") and len(evaluate("attributes.member_type#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.member_type#i#')#"><cfelse>NULL</cfif>,
								<cfif isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.project_id#i#") and len(evaluate("attributes.project#i#")) and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.activity_type#i#") and len(evaluate("attributes.activity_type#i#"))>#evaluate("attributes.activity_type#i#")#<cfelse>NULL</cfif>,
								#evaluate("attributes.total#i#")#,
								<cfif isDefined("attributes.tax_rate#i#") and Len(evaluate("attributes.tax_rate#i#"))>#evaluate("attributes.tax_rate#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.otv_rate#i#") and Len(evaluate("attributes.otv_rate#i#"))>#evaluate("attributes.otv_rate#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.kdv_total#i#") and Len(evaluate("attributes.kdv_total#i#"))>#evaluate("attributes.kdv_total#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.otv_total#i#") and Len(evaluate("attributes.otv_total#i#"))>#evaluate("attributes.otv_total#i#")#<cfelse>0</cfif>,
								#evaluate("attributes.net_total#i#")#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(evaluate('attributes.money_id#i#'), 1, ',')#">,
								#form_other_kdvsiz_value#,
								<cfif len(evaluate("attributes.other_net_total#i#"))>#evaluate("attributes.other_net_total#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("currency_multiplier_money2") and len(currency_multiplier_money2)>#wrk_round(evaluate("attributes.net_total#i#")/currency_multiplier_money2,session.ep.our_company_info.rate_round_num)#<cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
								<cfif isdefined("attributes.quantity#i#") and len(evaluate("attributes.quantity#i#"))>#evaluate("attributes.quantity#i#")#<cfelse>1</cfif>,
								<cfif isdefined("attributes.product_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.product_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.stock_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name#i#'),50)#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.product_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#")) and isdefined("attributes.stock_unit_id#i#") and len(evaluate("attributes.stock_unit_id#i#"))>#evaluate("attributes.stock_unit_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.product_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#")) and isdefined("attributes.stock_unit#i#") and len(evaluate("attributes.stock_unit#i#"))>#sql_unicode()#'#wrk_eval("attributes.stock_unit#i#")#'<cfelse>NULL</cfif>,
                                #session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								#now()#,
								#branch_id_info#,
								<cfif isdefined("attributes.work_id#i#") and len(evaluate("attributes.work_id#i#"))>#evaluate("attributes.work_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.opp_id#i#") and len(evaluate("attributes.opp_id#i#"))>#evaluate("attributes.opp_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.subscription_name#i#") and isdefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_name#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#,<cfelse>NULL,</cfif>
								<cfif isdefined("attributes.account_code#i#") and len(evaluate("attributes.account_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.account_code#i#")#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.tax_code#i#") and len(evaluate("attributes.tax_code#i#"))>'#evaluate("attributes.tax_code#i#")#'<cfelse>NULL</cfif>
								<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
								<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
								<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
								<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
								<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
								<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
								<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
                                <cfif len(reasonCode) and reasonCode contains '*'>
                                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(reasonCode,'*')#">
                                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">
                                <cfelse>
                                    ,NULL
                                    ,NULL
                                </cfif>
							)
					</cfquery>
					<cfscript>
						if(isdefined("attributes.cash") or isdefined("attributes.bank") or is_cari_islem)
						{
							temp_tax_tutar = evaluate("form.kdv_total#i#");
							if( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_oran))
								{//tevkifat
									tevkifat_acc_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT 
										ST_ROW.TEVKIFAT_BEYAN_CODE,ST_ROW.TAX
									FROM 
										#dsn3_alias#.SETUP_TEVKIFAT S_TEV,#dsn3_alias#.SETUP_TEVKIFAT_ROW ST_ROW 
									WHERE
										S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
										AND S_TEV.TEVKIFAT_ID = #attributes.tevkifat_id#
										AND ST_ROW.TAX = #evaluate("form.tax_rate#i#")#
									ORDER BY ST_ROW.TAX");
								temp_tax_tutar = wrk_round((temp_tax_tutar*attributes.tevkifat_oran),session.ep.our_company_info.rate_round_num);
								}

							if(isDefined("attributes.tax_rate#i#") and len(evaluate("attributes.tax_rate#i#")))
								get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT SALE_CODE,DIRECT_EXPENSE_CODE FROM SETUP_TAX WHERE TAX = #evaluate("attributes.tax_rate#i#")#");
							if(is_account eq 1)
							{
								if (is_project_based_acc eq 1 and isdefined("attributes.project#i#") and len(evaluate("attributes.project#i#")) and isdefined("attributes.project_id#i#") and len(Evaluate("attributes.project_id#i#")))
									get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT INCOME_PROGRESS_CODE ACCOUNT_CODE FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("attributes.project_id#i#")# AND PERIOD_ID = #session.ep.period_id#");
								else if (is_exp_based_acc eq 1 and isdefined("attributes.product_id#i#") and len(evaluate("attributes.product_id#i#")) and isdefined("attributes.product_name#i#") and len(Evaluate("attributes.product_name#i#")))
									get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM #dsn3_alias#.PRODUCT_PERIOD WHERE PRODUCT_ID = #evaluate("attributes.product_id#i#")# AND PERIOD_ID = #session.ep.period_id#");
								else if(isDefined("attributes.account_code#i#") and Len(evaluate("attributes.account_code#i#")))
									get_expense_item_account_code.account_code = evaluate("attributes.account_code#i#");
								else if(isDefined("attributes.expense_item_id#i#") and Len(evaluate("attributes.expense_item_id#i#")))
									get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #evaluate("attributes.expense_item_id#i#")#");
								if(isDefined("attributes.otv_rate#i#") and len(evaluate("attributes.otv_rate#i#")) and evaluate("attributes.otv_rate#i#") gt 0)//varsa ötv hesaplar çekiliyor
								get_otv_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE FROM #dsn3_alias#.SETUP_OTV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND TAX = #evaluate("attributes.otv_rate#i#")#");
								
							
								if(form_money_1 neq session.ep.money)
								{
									muhasebe_value = wrk_round(evaluate("attributes.total#i#") / money_value);
									if(isDefined("attributes.tax_rate#i#") and len(evaluate("attributes.tax_rate#i#")) and evaluate("attributes.tax_rate#i#") gt 0)
										muhasebe_tax_value = wrk_round(evaluate("attributes.kdv_total#i#") / money_value);
									if(isDefined("attributes.otv_rate#i#") and len(evaluate("attributes.otv_rate#i#")) and evaluate("attributes.otv_rate#i#") gt 0)
										muhasebe_otv_value = wrk_round((evaluate("attributes.otv_total#i#") / money_value),session.ep.our_company_info.rate_round_num);
								
									form_net_total_doviz = wrk_round(evaluate("attributes.net_total#i#") / money_value);
								}else
								{
									muhasebe_value = wrk_round(evaluate("attributes.total#i#")*evaluate("attributes.quantity#i#"));
									if(isDefined("attributes.tax_rate#i#") and len(evaluate("attributes.tax_rate#i#")) and evaluate("attributes.tax_rate#i#") gt 0)
										muhasebe_tax_value = wrk_round(evaluate("attributes.kdv_total#i#"));
									if(isDefined("attributes.otv_rate#i#") and len(evaluate("attributes.otv_rate#i#")) and evaluate("attributes.otv_rate#i#") gt 0)
										muhasebe_otv_value =  wrk_round(evaluate("attributes.otv_total#i#"),session.ep.our_company_info.rate_round_num);
								
									form_net_total_doviz = wrk_round(evaluate("attributes.net_total#i#"));
								}

								if(isDefined("attributes.expense_item_id#i#") and Len(evaluate("attributes.expense_item_id#i#")))
									acc = listappend(acc,get_expense_item_account_code.account_code,',');
								str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(evaluate("attributes.total#i#")*evaluate("attributes.quantity#i#")),",");
								str_alacak_miktar[listlen(str_alacak_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
								str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,muhasebe_value,",");
								str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,form_money_1,",");
								/*satir_detay_list array nın set edildigi satırların yerlerini degistirmeyin ,
								 her yeni borc tutarı eklendikten sonra açıklaması set ediliyor*/
								if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
								{	
									satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
								}
								else
								{
									satir_detay_list[2][listlen(str_alacak_tutar_list)]=fis_satir_row_detail;
								}
								if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
									acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),",");
								else
									acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
								if(isDefined("attributes.expense_item_id#i#") and Len(evaluate("attributes.expense_item_id#i#")))
									str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_expense_item_account_code.account_code,",");
								if(isDefined("attributes.tax_rate#i#") and len(evaluate("attributes.tax_rate#i#")) and evaluate("attributes.tax_rate#i#") gt 0)//kdv hesapları varsa ekleniyor
								{

									str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,temp_tax_tutar, ",");
									str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, muhasebe_tax_value, ",");
									str_alacak_miktar[listlen(str_alacak_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
									if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
									{	
										satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
									}
									else
									{
										satir_detay_list[2][listlen(str_alacak_tutar_list)]=fis_satir_row_detail;
									}
									if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),",");
									else
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
									
									if( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_oran)){
										str_alacak_kod_list = ListAppend(str_alacak_kod_list,tevkifat_acc_codes.tevkifat_beyan_code, ",");
									}	
									else{
										if( is_expensing_tax eq 1 )
										{
											str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_tax_acc_code.DIRECT_EXPENSE_CODE,",");
										}
										else 
										{
											str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_tax_acc_code.SALE_CODE,",");
										}
									}
									str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,form_money_1,",");

								}
								if(isDefined("attributes.otv_rate#i#") and len(evaluate("attributes.otv_rate#i#")) and evaluate("attributes.otv_rate#i#") gt 0)//ötv hesapları varsa ekleniyor
								{
									str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(evaluate("attributes.otv_total#i#"),rate_round_info_),",");
									str_alacak_miktar[listlen(str_alacak_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
									if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
										satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
									else
										satir_detay_list[2][listlen(str_alacak_tutar_list)]=fis_satir_row_detail;
									str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_otv_acc_code.purchase_code,",");
									str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,muhasebe_otv_value,",");
									str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,form_money_1,",");
									if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),",");
									else
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
								}
								//bsmv bloğu
								if(isDefined("attributes.row_bsmv_amount#i#") and len(evaluate("attributes.row_bsmv_amount#i#")) and evaluate("attributes.row_bsmv_amount#i#") gt 0)//ötv hesapları varsa ekleniyor
								{
									get_bsmv_row=cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_BSMV WHERE TAX = #evaluate("form.row_bsmv_rate#i#")#");
									str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(evaluate("attributes.row_bsmv_amount#i#"),rate_round_info_),",");
									str_alacak_miktar[listlen(str_alacak_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
									if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
										satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
									else
										satir_detay_list[2][listlen(str_alacak_tutar_list)]=fis_satir_row_detail;
									str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_bsmv_row.purchase_code,",");
									bsmv2 = wrk_round((evaluate("attributes.row_bsmv_amount#i#") / money_value),session.ep.our_company_info.rate_round_num);
									str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,bsmv2,",");
									str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,form_money_1,",");
									if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),",");
									else
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
								}
								//oiv bloğu
								if(isDefined("attributes.row_oiv_amount#i#") and len(evaluate("attributes.row_oiv_amount#i#")) and evaluate("attributes.row_oiv_amount#i#") gt 0)//ötv hesapları varsa ekleniyor
								{
									get_oiv_row=cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_OIV WHERE TAX = #evaluate("form.row_oiv_rate#i#")#");
									str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(evaluate("attributes.row_oiv_amount#i#"),rate_round_info_),",");
									str_alacak_miktar[listlen(str_alacak_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
									if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
										satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
									else
										satir_detay_list[2][listlen(str_alacak_tutar_list)]=fis_satir_row_detail;
									str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_oiv_row.purchase_code,",");
									oiv2 = wrk_round((evaluate("attributes.row_oiv_amount#i#") / money_value),session.ep.our_company_info.rate_round_num);
									str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,oiv2,",");
									str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,form_money_1,",");
									if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),",");
									else
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
								}
							}
						}
					</cfscript>
				</cfif>
			</cfloop>
		</cfif>
		<cfscript>
			if(isdefined("attributes.cash") or isdefined("attributes.bank") or is_cari_islem)
			{
				if(is_account eq 1)
				{
					str_borc_tutar_list = listappend(str_borc_tutar_list,wrk_round(attributes.net_total_amount),",");
					str_borc_kod_list = listappend(str_borc_kod_list,string_acc_code,",");
					satir_detay_list[1][listlen(str_borc_tutar_list)]= fis_satir_row_detail;
					if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
						acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
					else
						acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
					if((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))//cari seçilmiş ise
					{
						multiplier_ = rd_money_rate;
						string_currency_id_ = rd_money_value;
					}
					else if (isdefined("attributes.cash"))
					{
						multiplier_ = currency_multiplier;
						string_currency_id_ = string_currency_id;
					}
					else if(isdefined("attributes.bank"))
					{
						multiplier_ = currency_multiplier_banka;	
						string_currency_id_ = string_currency_id;
					}
					
					str_other_borc_tutar_list = listappend(str_other_borc_tutar_list,wrk_round(attributes.net_total_amount/multiplier_),",");
					str_other_borc_currency_list = listappend(str_other_borc_currency_list,string_currency_id_,",");
				}
			}

			action_id = add_expense_total_cost.max_expense_id;
			if (is_cari and is_cari_islem eq 1)
			{
				if(attributes.ch_member_type eq 'consumer')
					attributes.consumer_id=attributes.ch_partner_id; 
				else 
					attributes.consumer_id='';//consumer_id partner_id degiskeni ile formdan geliyor
				if(attributes.ch_member_type eq 'employee')
					attributes.emp_id=attributes.emp_id; 
				else 
					attributes.emp_id='';
					
					//odeme yöntemine göre parçalı carileştirme
					if(is_paymethod_based_cari eq 1 and isdefined('attributes.paymethod') and len(attributes.paymethod) and isdefined('attributes.paymethod_name') and len(attributes.paymethod_name)) //Ödeme Yöntemi Bazında Cari İşlem yapılıyorsa ve odeme yontemi secilmisse
					{
						row_duedate_list='';
						total_cash_price=0;
						get_paymethod_detail=cfquery(datasource:'#dsn2#',sqlstring:'SELECT DUE_MONTH,IN_ADVANCE,DUE_START_DAY FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID =#attributes.paymethod#');
						if(get_paymethod_detail.recordcount neq 0)
						{
							if(len(get_paymethod_detail.IN_ADVANCE) and get_paymethod_detail.IN_ADVANCE gt 0)
							{
								row_duedate = date_add("d",0,income_due_date); //pesinat belge tarihine ekleniyor
								row_duedate_list = listappend(row_duedate_list,row_duedate);
								total_cash_price=((attributes.net_total_amount*get_paymethod_detail.IN_ADVANCE)/100);
								row_no=listlen(row_duedate_list);
								'row_amount_total_#row_no#' = wrk_round(total_cash_price,session.ep.our_company_info.rate_round_num); //pesinatta vade sıfır
								'row_other_amount_total_#row_no#' = wrk_round((total_cash_price/rd_money_rate),session.ep.our_company_info.rate_round_num);
							}
							
							get_row_paymethod_detail_new=cfquery(datasource:'#dsn2#',sqlstring:'SELECT SPD.FIXED_DATE FROM #dsn_alias#.SETUP_PAYMETHOD SP,#dsn_alias#.SETUP_PAYMETHOD_FIXED_DATE SPD WHERE SPD.FIXED_DATE IS NOT NULL AND SP.PAYMETHOD_ID = SPD.PAYMETHOD_ID AND SP.PAYMETHOD_ID =#attributes.paymethod# ORDER BY FIXED_DATE');
							if(get_row_paymethod_detail_new.recordcount)
							{
								installment_price=wrk_round((attributes.net_total_amount-total_cash_price)/get_paymethod_detail.DUE_MONTH,session.ep.our_company_info.rate_round_num);
								for(kk=1;kk lte get_row_paymethod_detail_new.recordcount;kk=kk+1)
								{
									row_duedate_list = listappend(row_duedate_list,createodbcdatetime(get_row_paymethod_detail_new.FIXED_DATE[kk]));
									row_no=listlen(row_duedate_list);
									'row_amount_total_#row_no#' = wrk_round(installment_price,session.ep.our_company_info.rate_round_num);
									'row_other_amount_total_#row_no#' = wrk_round((installment_price/rd_money_rate),session.ep.our_company_info.rate_round_num);
								}
							}
							else if(wrk_round((attributes.net_total_amount-total_cash_price),session.ep.our_company_info.rate_round_num) gt 0) //peşinattan sonra kalan bakiye varsa
							{
								 if(len(get_paymethod_detail.DUE_MONTH) and get_paymethod_detail.DUE_MONTH neq 0) //odeme yonteminde taksit sayısı girilmisse
								 {
									new_expense_date=income_due_date;
									installment_price=wrk_round((attributes.net_total_amount-total_cash_price)/get_paymethod_detail.DUE_MONTH,session.ep.our_company_info.rate_round_num);
									for(ind_m=1; ind_m lte get_paymethod_detail.DUE_MONTH; ind_m=ind_m+1)
									{
										if(ind_m eq 1 and len(get_paymethod_detail.DUE_START_DAY) and get_paymethod_detail.DUE_START_DAY neq 0)//vade baslangıc tarihi belirtilmisse ilk taksitte bu deger islem tarihine eklenir
											new_expense_date=date_add("d",get_paymethod_detail.DUE_START_DAY,new_expense_date);
										else if(ind_m neq 1)
											new_expense_date=date_add("m",1,new_expense_date);
											
										row_duedate_list = listappend(row_duedate_list,new_expense_date);
										row_no=listlen(row_duedate_list);
										'row_amount_total_#row_no#' = wrk_round(installment_price,session.ep.our_company_info.rate_round_num);
										'row_other_amount_total_#row_no#' = wrk_round((installment_price/rd_money_rate),session.ep.our_company_info.rate_round_num);
									}
								 }
							}
						}
						for(ind_t=1;ind_t lte listlen(row_duedate_list); ind_t=ind_t+1)
						{
							cari_row_duedate=listgetat(row_duedate_list,ind_t);
							carici(
								action_id :action_id,  
								action_table : 'EXPENSE_ITEM_PLANS',
								workcube_process_type : process_type,
								due_date : cari_row_duedate,
								account_card_type : 13,
								islem_tarihi : attributes.expense_date,
								islem_tutari : evaluate('row_amount_total_#ind_t#'),
								islem_belge_no : attributes.belge_no,
								to_cmp_id : to_company_id,
								to_consumer_id : to_consumer_id,
								to_employee_id : to_employee_id,
								acc_type_id : attributes.acc_type_id,
								to_branch_id : branch_id_info,
								islem_detay : UCase(getLang('main',653)),
								action_detail : attributes.detail,
								other_money_value : evaluate('row_other_amount_total_#ind_t#'),
								other_money : rd_money_value,
								action_currency : SESSION.EP.MONEY,
								currency_multiplier : currency_multiplier_money2,
								process_cat : form.process_cat,
								project_id:project_id_info,
								rate2:rd_money_rate
								 );
						}
					}
					else if(is_row_project_based_cari eq 1)
						{
							row_project_list='';
							total_cash_price=0;
							total_other_cash_price=0;
							row_number = 0;
							row_all_total = 0;
							for(j=1;j lte attributes.record_num;j=j+1)
							{
								if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
								{
									row_all_total = row_all_total + evaluate("attributes.net_total#j#");
								}
							}
							for(j=1;j lte attributes.record_num;j=j+1)
							{
								if(row_all_total gt 0)
									row_total_ = attributes.net_total_amount*evaluate("attributes.net_total#j#")/row_all_total;
								else
									row_total_ = 0;
								if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") and isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")))
								{
									
									if(not listfind(row_project_list,evaluate("attributes.project_id#j#")))
									{	
										row_number = row_number + 1;
										row_project_list = listappend(row_project_list,evaluate("attributes.project_id#j#"));
										'row_amount_total_#row_number#' = evaluate("attributes.net_total#j#");
										'row_other_amount_total_#row_number#' = evaluate("attributes.net_total#j#")/rd_money_rate;
									}
									else
									{
										row_number_ = listfind(row_project_list,evaluate("attributes.project_id#j#"));
										'row_amount_total_#row_number_#' =evaluate("row_amount_total_#row_number_#")+evaluate("attributes.net_total#j#");
										'row_other_amount_total_#row_number_#' = evaluate("row_other_amount_total_#row_number_#")+(evaluate("attributes.net_total#j#")/rd_money_rate);
									}
								}
								else if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
								{
									total_cash_price = total_cash_price + evaluate("attributes.net_total#j#");
									total_other_cash_price = total_other_cash_price + evaluate("attributes.net_total#j#")/rd_money_rate;
								}	
							}
						for(ind_t=1;ind_t lte listlen(row_project_list); ind_t=ind_t+1)
						{
							cari_row_project=listgetat(row_project_list,ind_t);
							carici(
								action_id :attributes.expense_id,
								action_table : 'EXPENSE_ITEM_PLANS',
								workcube_process_type : process_type,
								account_card_type : 13,
								islem_tarihi : attributes.expense_date,
								due_date : iif(len(income_due_date),de('#income_due_date#'),de('')),
								islem_tutari : evaluate('row_amount_total_#ind_t#'),
								islem_belge_no : attributes.belge_no,
								to_cmp_id : to_company_id,
								to_consumer_id : to_consumer_id,
								to_employee_id : to_employee_id,
								acc_type_id : attributes.acc_type_id,
								to_branch_id : branch_id_info,
								islem_detay : UCase(getLang('main',653)),
								action_detail : attributes.detail,
								other_money_value : evaluate('row_other_amount_total_#ind_t#'),
								other_money : rd_money_value,
								action_currency : SESSION.EP.MONEY,
								currency_multiplier : currency_multiplier_money2,
								process_cat : form.process_cat,
								project_id : cari_row_project,
								rate2:rd_money_rate
								);
						}
						if(total_cash_price gt 0)
						{
							carici(
								action_id :attributes.expense_id,
								action_table : 'EXPENSE_ITEM_PLANS',
								workcube_process_type : process_type,
								account_card_type : 13,
								islem_tarihi : attributes.expense_date,
								due_date : iif(len(income_due_date),de('#income_due_date#'),de('')),
								islem_tutari : total_cash_price,
								islem_belge_no : attributes.belge_no,
								to_cmp_id : to_company_id,
								to_consumer_id : to_consumer_id,
								to_employee_id : to_employee_id,
								acc_type_id : attributes.acc_type_id,
								to_branch_id : branch_id_info,
								islem_detay : UCase(getLang('main',653)),
								action_detail : attributes.detail,
								other_money_value : total_other_cash_price,
								other_money : rd_money_value,
								action_currency : SESSION.EP.MONEY,
								currency_multiplier : currency_multiplier_money2,
								process_cat : form.process_cat,
								project_id : project_id_info,
								rate2:rd_money_rate
								);
						}
					}
					else
					{
						carici(
							action_id :action_id,  
							action_table : 'EXPENSE_ITEM_PLANS',
							workcube_process_type : process_type,
							due_date : iif(len(income_due_date),de('#income_due_date#'),de('')),
							account_card_type : 13,
							islem_tarihi : attributes.expense_date,
							islem_tutari : attributes.net_total_amount,
							islem_belge_no : attributes.belge_no,
							to_cmp_id : to_company_id,
							to_consumer_id : to_consumer_id,
							to_employee_id : to_employee_id,
							acc_type_id : attributes.acc_type_id,
							to_branch_id : branch_id_info,
							islem_detay : UCase(getLang('main',653)),
							action_detail : attributes.detail,
							other_money_value : attributes.other_net_total_amount,
							other_money : rd_money_value,
							action_currency : SESSION.EP.MONEY,
							currency_multiplier : currency_multiplier_money2,
							process_cat : form.process_cat,
							project_id:project_id_info,
							rate2:rd_money_rate
							 );
						}
			}
			if (isdefined("attributes.cash") or isdefined("attributes.bank") or is_cari_islem)
			{
					document_type_ = '';
					payment_type_ = '';
					str_card_detail = UCase(getLang('main',653)) & ' - #attributes.detail#';
					string_action_number = 13;
						
					if(isdefined("attributes.cash") and not(((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))))
					{
						//kasa odeme islemine ait belge tipi ve odeme sekli cekiliyor
						CASH_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 DOCUMENT_TYPE,PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 31 ORDER BY PROCESS_CAT_ID");
						payment_type_ = CASH_INFO_.PAYMENT_TYPE;
						DOCUMENT_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT DOCUMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#");
						document_type_ = DOCUMENT_INFO_.DOCUMENT_TYPE;
						
						str_card_detail = UCase(getLang('main',2741)) & ' - #attributes.detail#';
						string_action_number = 11;
					}
					else if(isdefined("attributes.bank") and not(((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))))
					{	
						//banka islemine ait belge tipi ve odeme sekli cekiliyor
						BANK_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 DOCUMENT_TYPE,PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 24 ORDER BY PROCESS_CAT_ID");
						payment_type_ = BANK_INFO_.PAYMENT_TYPE;
						DOCUMENT_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT DOCUMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#");
						document_type_ = DOCUMENT_INFO_.DOCUMENT_TYPE;
						
						str_card_detail = UCase(getLang('main',2738)) & ' - #attributes.detail#';
						string_action_number = 13;
					}
					
					if (isDefined('form.stopaj_rate_id') and len(form.stopaj_rate_id))//stopaj popuptan seçilmişse
						GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #form.stopaj_rate_id#");
					else
						GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE = #form.stopaj_yuzde#");
					if(isdefined("GET_SETUP_STOPPAGE_RATES") and len(form.stopaj) and form.stopaj neq 0)
					{
						str_borc_kod_list = ListAppend(str_borc_kod_list, GET_SETUP_STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE, ",");
						str_borc_tutar_list = ListAppend(str_borc_tutar_list, form.stopaj, ",");
						str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,(form.stopaj/money_value),",");
						str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
						satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
						if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
							acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
						else
							acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
					}
					
				if(is_account eq 1)
				{
				//BORC-ALACAK FARKI ICIN YUVARLAMA TUTARLARI EKLENIYOR
					temp_total_alacak = 0;
					for(i=1;i <= ListLen(str_alacak_tutar_list);i++)
					{
						temp_total_alacak += WRK_ROUND(ListGetAt(str_alacak_tutar_list,i));
					}

					temp_total_borc = 0;
					for(i=1;i <= ListLen(str_borc_tutar_list);i++)
					{
						temp_total_borc += WRK_ROUND(ListGetAt(str_borc_tutar_list,i));
					}
					temp_fark = round((temp_total_alacak-temp_total_borc)*100);
					if(temp_fark neq 0)
						FARK_HESAP = cfquery(datasource:"#dsn2#",sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					
					if( temp_fark gte -10 and temp_fark lt 0 )
						{/* gelir hesabi alacaklilara eklenmeli, borc bakiye gelmis */
						str_alacak_kod_list = ListAppend(str_alacak_kod_list, FARK_HESAP.FARK_GELIR, ",");
						str_alacak_tutar_list = ListAppend(str_alacak_tutar_list, abs(temp_fark/100), ",");
						satir_detay_list[2][listlen(str_alacak_tutar_list)]= fis_satir_row_detail;
						str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, abs(temp_fark/100),",");
						str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,session.ep.money,",");
						if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
							acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
						else
							acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
						}
					else if( temp_fark lte 10 and temp_fark gt 0 )
						{/* gider hesabi borclulara eklenmeli, alacak bakiye gelmis */
						str_borc_kod_list = ListAppend(str_borc_kod_list, FARK_HESAP.FARK_GIDER, ",");
						str_borc_tutar_list = ListAppend(str_borc_tutar_list, abs(temp_fark/100), ",");
						satir_detay_list[1][listlen(str_borc_tutar_list)]= fis_satir_row_detail;
						str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, abs(temp_fark/100),",");
						str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,session.ep.money,",");
						if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
							acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
						else
							acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
						}
					muhasebeci (
						action_id:action_id,
						workcube_process_type : process_type,
						workcube_process_cat : attributes.process_cat,
						account_card_type : string_action_number,
						company_id : attributes.ch_company_id,
						consumer_id : attributes.ch_partner_id,
						islem_tarihi : attributes.expense_date,
						borc_hesaplar : str_borc_kod_list,
						borc_tutarlar : str_borc_tutar_list,
						alacak_hesaplar : str_alacak_kod_list,
						alacak_tutarlar : str_alacak_tutar_list,
						alacak_miktarlar : str_alacak_miktar,
						fis_satir_detay: satir_detay_list,
						fis_detay : str_card_detail,
						belge_no : attributes.belge_no,
						to_branch_id : branch_id_info,
						other_amount_borc : str_other_borc_tutar_list,
						other_currency_borc : str_other_borc_currency_list,
						other_amount_alacak : str_other_alacak_tutar_list,
						other_currency_alacak : str_other_alacak_currency_list,
						currency_multiplier : currency_multiplier_money2,
						is_account_group : account_group,
						acc_project_id : main_project_id,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc,
						document_type : document_type_,
						payment_method : payment_type_
					);		
				}
			}
		</cfscript>
		<!--- money kayıtları --->
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO EXPENSE_ITEM_PLANS_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#add_expense_total_cost.max_expense_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#i#')#">,
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
				<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
		<!--- Belge No update ediliyor --->
		<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
			UPDATE 
				#dsn3_alias#.GENERAL_PAPERS
			SET
				INCOME_COST_NUMBER = #paper_number#
			WHERE
				INCOME_COST_NUMBER IS NOT NULL
		</cfquery>	
		<!---<cfif len(get_process_type.action_file_name)>--->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #add_expense_total_cost.max_expense_id#
				is_action_file = 1
                action_table="EXPENSE_ITEM_PLANS"
				action_column="EXPENSE_ID"
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_income_cost&expense_id=#add_expense_total_cost.max_expense_id#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		<!---</cfif>--->
	</cftransaction>
</cflock>
<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
	<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn2#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='EXPENSE_ITEM_PLANS'
			action_column='EXPENSE_ID'
			action_id='#add_expense_total_cost.max_expense_id#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_income_cost&expense_id=#add_expense_total_cost.max_expense_id#'
			warning_description='Gelir Fişi : #attributes.belge_no#'  >
</cfif>	
<script type="text/javascript">
    window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_income_cost&event=upd&expense_id=#add_expense_total_cost.max_expense_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
