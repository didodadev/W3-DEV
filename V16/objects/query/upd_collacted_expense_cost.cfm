<!---uyarı:TolgaS20060210 aynı masraf fişinde hem cari hemde banka veya kasa seçilmesi işinde bir masraf fişine ait 2 muhasebe fişi 
olacağı için ve bunlardan birinin silinmesi durumunda tutarsızlık olcağından işten vazgeçildi--->
<cfif not isdefined('xml_import')>
	<cfinclude template="../../invoice/query/check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
</cfif>
<cfif not isdefined("form.belge_no")>
	<cfif isdefined('form.serial_number') and len(form.serial_number)>
		<cfset form.belge_no = "#form.serial_number#-#form.serial_no#">
		<cfset attributes.belge_no = "#form.serial_number#-#form.serial_no#">
	<cfelse>
		<cfset form.belge_no = "#form.serial_no#">
		<cfset attributes.belge_no = "#form.serial_no#">
	</cfif>
</cfif>
<cf_get_lang_set module_name="objects">
<cf_date tarih = 'attributes.expense_date'>
<cf_date tarih = "attributes.basket_due_value_date_">
<cfif isdefined("attributes.process_date") and len(attributes.process_date)>
	<cf_date tarih='attributes.process_date'>
</cfif>
<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") />
<cfset attributes.expense_date_time = createdatetime(year(attributes.expense_date),month(attributes.expense_date),day(attributes.expense_date),attributes.expense_date_h,attributes.expense_date_m,0)>
<cfquery name="GET_NUMBER" datasource="#dsn2#"><!--- action file da v kullanılıyor,silmeyiniz --->
	SELECT WRK_ID,TOTAL_AMOUNT_KDVLI,DUE_DATE FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
</cfquery>
<cfquery name="get_cari_kontrol" datasource="#dsn2#">
	SELECT DISTINCT PROJECT_ID FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> AND ACTION_TYPE_ID = #attributes.old_process_type#
</cfquery>
<cfif isDefined("attributes.basket_due_value_date_") and len(attributes.basket_due_value_date_)>
	<cfset expence_due_date = attributes.basket_due_value_date_>
<cfelse>
	<cfset expence_due_date = attributes.expense_date>
</cfif>
<cfscript>
	action_id = attributes.expense_id;
	//Proses Tipleri İçin İşlemler
	get_process_type = cfquery(datasource : "#dsn3#", sqlstring : "SELECT ISNULL(IS_ROW_PROJECT_BASED_CARI,0) IS_ROW_PROJECT_BASED_CARI,IS_PROJECT_BASED_ACC,PROCESS_CAT_ID,IS_DEPT_BASED_ACC,PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_STOCK_ACTION,IS_EXP_BASED_ACC,IS_PAYMETHOD_BASED_CARI,IS_EXPENSING_TAX,ISNULL(IS_EXPENSING_OTV,0) IS_EXPENSING_OTV,ISNULL(IS_EXPENSING_OIV,0) IS_EXPENSING_OIV FROM SETUP_PROCESS_CAT WHERE  PROCESS_CAT_ID = #attributes.process_cat#");
	is_expensing_tax = get_process_type.IS_EXPENSING_TAX;
	process_type = get_process_type.process_type;
	islem_detay = UCASETR(get_process_name(process_type));
	is_project_based_acc = get_process_type.IS_PROJECT_BASED_ACC;
	is_row_project_based_cari = get_process_type.IS_ROW_PROJECT_BASED_CARI;
	is_cari = get_process_type.is_cari;
	is_cari_islem=0;
	is_muh_action=0;
	is_dept_based_acc = get_process_type.is_dept_based_acc;
	is_account = get_process_type.is_account;
	is_paymethod_based_cari=get_process_type.is_paymethod_based_cari;
	is_stock_action = get_process_type.is_stock_action;
	is_exp_based_acc = get_process_type.is_exp_based_acc;
	account_group=get_process_type.is_account_group;
	rate_round_info_=session.ep.our_company_info.rate_round_num;
	str_alacak_tutar_list="";
	str_alacak_kod_list="";
	str_borc_tutar_list="";
	str_borc_kod_list="";
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
	str_borclu_miktar = ArrayNew(1);
	rd_money_value = listfirst(attributes.rd_money, ',');
	str_other_alacak_tutar_list = "";
	str_other_borc_tutar_list = "";
	str_other_borc_currency_list = "";
	str_other_alacak_currency_list = "";
	acc_branch_list_alacak='';
	acc_branch_list_borc='';
	acc_project_list_alacak='';
	acc_project_list_borc='';
	fis_satir_row_detail = '#attributes.belge_no# - #attributes.detail# - #islem_detay#'; //muhasebe islemlerinde kullanılıyor
	
	attributes.acc_type_id = '';
	if(listlen(attributes.emp_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.emp_id,'_');
		attributes.emp_id = listfirst(attributes.emp_id,'_');
	}
	
	attributes.acc_type_id_exp = '';
	if(listlen(attributes.expense_employee_id,'_') eq 2)
	{
		attributes.acc_type_id_exp = listlast(attributes.expense_employee_id,'_');
		attributes.expense_employee_id = listfirst(attributes.expense_employee_id,'_');
	}
	//Kasa Seçili İse Kasanın Para Birimi ve Muhasebe Kodu 
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
		string_acc_code = get_cash_.cash_acc_code;
		string_currency_id = get_cash_.cash_currency_id;
	}
	else if(isdefined("attributes.bank"))//Banka Seçili İse Bankanın Para Birimi ve Muhasebe Kodu
	{
		string_acc_code = attributes.account_acc_code;
		string_currency_id = attributes.currency_id;
	}
	else if(isdefined("attributes.credit"))
	{
		account_id_first = listgetat(attributes.credit_card_info,1,';');
		action_curreny = listgetat(attributes.credit_card_info,2,';');
		account_id_last = listgetat(attributes.credit_card_info,3,';');
		get_credit_ = cfquery(datasource : "#dsn3#", sqlstring : "SELECT ACCOUNT_CODE FROM CREDIT_CARD WHERE CREDITCARD_ID = #account_id_last#");
		string_acc_code = get_credit_.account_code;
		string_currency_id = listgetat(attributes.credit_card_info,2,';');
	}
	currency_multiplier = 1;
	currency_multiplier_banka = 1;
	currency_multiplier_kk = 1;
	currency_multiplier_money2 = 1;
	rd_money_rate=1;
	paper_currency_multiplier = '';

	if(isDefined('attributes.kur_say') and len(attributes.kur_say)){
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(isdefined('attributes.cash') and evaluate("attributes.hidden_rd_money_#mon#") is ListGetAt(attributes.kasa,2,";"))
					currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(isdefined('attributes.credit') and evaluate("attributes.hidden_rd_money_#mon#") is listgetat(attributes.credit_card_info,2,';'))
					currency_multiplier_kk = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(isdefined('attributes.bank') and evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
					currency_multiplier_banka = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
					currency_multiplier_money2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value) //sayfada secilen para br. kur bilgisi
				{
					rd_money_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');	
					paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
				"last_rate_1_#evaluate("attributes.hidden_rd_money_#mon#")#" = evaluate('attributes.txt_rate1_#mon#');
			}
	}
	if (isdefined("attributes.ch_company_id") and len(attributes.ch_company_id) and isdefined("attributes.ch_company") and len(attributes.ch_company) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner')
	{
		from_company_id = attributes.ch_company_id;
		from_consumer_id = '';
		from_employee_id= '';
	}
	else if (isdefined("attributes.ch_partner_id") and len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer')
	{
		from_consumer_id = attributes.ch_partner_id;
		from_company_id = '';
		from_employee_id= '';
	}
	else if (isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee')
	{
		from_employee_id = attributes.emp_id;
		from_company_id = '';
		from_consumer_id= '';
	}
	else
	{
	 	from_employee_id = '';
		from_company_id = '';
		from_consumer_id= '';
	}	
	//belgede secilen sube
	if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
		branch_id_info_document = listfirst(ListDeleteDuplicates(attributes.branch_id_),',');
	else
		branch_id_info_document = listgetat(session.ep.user_location,2,'-');
	//kasaya ait sube
	if (isdefined("attributes.cash"))
		branch_id_info = ListGetAt(attributes.kasa,3,";");
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
	
	if(isdefined("attributes.project_id")  and len(attributes.project_id) and len(attributes.project_head))
		project_id_info = attributes.project_id;
	else
		project_id_info = '';
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)) main_project_id = attributes.project_id; else main_project_id = 0;
	if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id))
		acc_department_id = attributes.acc_department_id;
	else
		acc_department_id = '';
</cfscript>
<cflock timeout="60" name="#CreateUUID()#">
	<cftransaction>
		<cfquery name="ADD_EXPENSE_TOTAL_COST" datasource="#dsn2#">
			UPDATE
				EXPENSE_ITEM_PLANS
			SET
				IS_BANK = <cfif isdefined("attributes.bank")>1<cfelse>0</cfif>,
				IS_CASH = <cfif isdefined("attributes.cash")>1<cfelse>0</cfif>,
				IS_CREDITCARD = <cfif isdefined("attributes.credit")>1<cfelse>0</cfif>,
				EXPENSE_CASH_ID = <cfif isdefined("attributes.cash")>#ListFirst(attributes.kasa,";")#<cfelseif isdefined("attributes.bank")>#attributes.account_id#<cfelse>NULL</cfif>,
				EXPENSE_COST_TYPE = #attributes.expense_cost_type#,
				OTHER_MONEY_AMOUNT = <cfif len(attributes.other_total_amount)>#attributes.other_total_amount#<cfelse>0</cfif>,
				OTHER_MONEY_KDV = <cfif len(attributes.other_kdv_total_amount)>#attributes.other_kdv_total_amount#<cfelse>0</cfif>,
				OTHER_MONEY_OTV = <cfif len(attributes.other_otv_total_amount)>#attributes.other_otv_total_amount#<cfelse>0</cfif>,
				OTHER_MONEY_NET_TOTAL = <cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#<cfelse>0</cfif>,
				OTHER_MONEY = <cfif len(rd_money_value)>#sql_unicode()#'#rd_money_value#'<cfelse>NULL</cfif>,
				PAYMETHOD_ID =<cfif len(attributes.paymethod) and len(attributes.paymethod_name)>#attributes.paymethod#<cfelse>NULL</cfif>,
				SERIAL_NUMBER = <cfif len(attributes.serial_number)>#sql_unicode()#'#attributes.serial_number#'<cfelse>NULL</cfif>,
				SERIAL_NO = <cfif len(attributes.serial_no)>#sql_unicode()#'#attributes.serial_no#'<cfelse>NULL</cfif>,
				PAPER_NO = <cfif len(attributes.belge_no)>#sql_unicode()#'#attributes.belge_no#'<cfelse>NULL</cfif>,
				PROCESS_CAT = #attributes.process_cat#,
				ACTION_TYPE=#process_type#,
				EMP_ID = <cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#<cfelse>NULL</cfif>,
				POSITION_CODE = <cfif len(attributes.expense_employee_position) and len(attributes.expense_employee_position)>#attributes.expense_employee_position#<cfelse>NULL</cfif>,
				EXPENSE_DATE = <cfif len(attributes.expense_date)>#attributes.expense_date#<cfelse>NULL</cfif>,
				PROCESS_DATE = <cfif isdefined("attributes.process_date") and len(attributes.process_date)><cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#attributes.process_date#"><cfelse>NULL</cfif>,
				EXPENSE_DATE_TIME = <cfif len(attributes.expense_date)>#attributes.expense_date_time#<cfelse>NULL</cfif>,
				PAPER_TYPE = <cfif len(attributes.expense_paper_type)>#attributes.expense_paper_type#<cfelse>NULL</cfif>,
				SYSTEM_RELATION = <cfif len(attributes.system_relation)>#sql_unicode()#'#attributes.system_relation#'<cfelse>NULL</cfif>,
				DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = #sql_unicode()#'#cgi.remote_addr#',
				TOTAL_AMOUNT = #attributes.total_amount#,
				KDV_TOTAL = #attributes.kdv_total_amount#,
				OTV_TOTAL = <cfif len(attributes.otv_total_amount)>#attributes.otv_total_amount#<cfelse>NULL</cfif>,
				BSMV_TOTAL = <cfif len(attributes.bsmv_total_amount)>#attributes.bsmv_total_amount#<cfelse>0</cfif>,
				OIV_TOTAL = <cfif len(attributes.oiv_total_amount)>#attributes.oiv_total_amount#<cfelse>0</cfif>,
				TOTAL_AMOUNT_KDVLI = #attributes.net_total_amount#,
				DUE_DATE = <cfif len(expence_due_date)>#expence_due_date#<cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif isdefined("attributes.department_id") and len(attributes.department_id) and len(attributes.department_name)>#attributes.department_id#,<cfelse>NULL,</cfif>
				LOCATION_ID = <cfif isdefined("attributes.location_id") and len(attributes.location_id) and len(attributes.department_name)>#attributes.location_id#,<cfelse>NULL,</cfif>
				CARI_ACTION_TYPE = <!--- parçalı cari işlemi tutuyor --->
					<cfif isDefined("attributes.invoice_payment_plan") and attributes.invoice_payment_plan eq 0>
						<!--- FBS 20120711 Odeme Planini Yeniden Olusturmamasi Icin Type Degerinin Tasinmasi Gerekiyor --->
						<cfif isDefined("attributes.cari_action_type_") and Len(attributes.cari_action_type_)>#attributes.cari_action_type_#<cfelse>4</cfif>
					<cfelse>
						0
					</cfif>, 
				TEVKIFAT = <cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
				TEVKIFAT_ORAN = <cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
				TEVKIFAT_ID = <cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
				BRANCH_ID = #branch_id_info_document#,
                PROJECT_ID = <cfif len(project_id_info)>#project_id_info#<cfelse>NULL</cfif>,
				ROUND_MONEY = <cfif len(attributes.yuvarlama)>#attributes.yuvarlama#<cfelse>0</cfif>,
				STOPAJ = <cfif len(form.stopaj)>#form.stopaj#<cfelse>NULL</cfif>,
				STOPAJ_ORAN = <cfif len(form.stopaj_yuzde)>#form.stopaj_yuzde#<cfelse>NULL</cfif>,
				STOPAJ_RATE_ID = <cfif isdefined("form.stopaj_rate_id") and len(form.stopaj_rate_id)>#form.stopaj_rate_id#<cfelse>NULL</cfif>,
				ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
				ACC_TYPE_ID_EXP = <cfif isdefined("attributes.acc_type_id_exp") and len(attributes.acc_type_id_exp)>#attributes.acc_type_id_exp#<cfelse>NULL</cfif>,
				ACC_DEPARTMENT_ID = <cfif len(acc_department_id)>#acc_department_id#<cfelse>NULL</cfif>,
				TAX_CODE = <cfif isdefined("attributes.tax_code") and len(attributes.tax_code)>'#attributes.tax_code#'<cfelse>NULL</cfif>,
                SHIP_ADDRESS_ID = <cfif isdefined("attributes.ship_address_id") and isdefined("attributes.adres") and  len(attributes.ship_address_id) and len(attributes.adres)>'#attributes.ship_address_id#'<cfelse>NULL</cfif>,
                SHIP_ADDRESS = <cfif isdefined("attributes.ship_address_id") and isdefined("attributes.adres") and  len(attributes.ship_address_id) and len(attributes.adres)>'#attributes.adres#'<cfelse>NULL</cfif>,
				<cfif len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner' and len(attributes.ch_company)>
					CH_COMPANY_ID = <cfif len(attributes.ch_company) and len(attributes.ch_company_id)>#attributes.ch_company_id#<cfelse>NULL</cfif>,
					CH_PARTNER_ID = <cfif len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
					CH_CONSUMER_ID = NULL,
					CH_EMPLOYEE_ID = NULL
				<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer' and len(attributes.ch_partner)>
					CH_COMPANY_ID = NULL,
					CH_PARTNER_ID = NULL,
					CH_CONSUMER_ID = <cfif len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
					CH_EMPLOYEE_ID = NULL
				<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee' and len(attributes.ch_partner)>
					CH_COMPANY_ID = NULL,
					CH_PARTNER_ID = NULL,
					CH_CONSUMER_ID = NULL,
					CH_EMPLOYEE_ID = <cfif len(attributes.emp_id) and len(attributes.ch_partner)>#attributes.emp_id#<cfelse>NULL</cfif>
				<cfelse>
					CH_COMPANY_ID = NULL,
					CH_PARTNER_ID = NULL,
					CH_CONSUMER_ID = NULL,
					CH_EMPLOYEE_ID = NULL
				</cfif>
				,RELATIVE_ID = <cfif isdefined("attributes.relative_id") and len(attributes.relative_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relative_id#"><cfelse>NULL</cfif>
				<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>, PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"></cfif>,
				IS_EARCHIVE = <cfif isDefined("attributes.is_earchive")>1<cfelse>0</cfif>
			WHERE
				EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
		</cfquery>
		<cfscript>
			if(isdefined("attributes.process_date") and len(attributes.process_date))
				attributes.expense_date = attributes.process_date;// işlem tarihi üzerinden hareketler yaptırılıyor
		</cfscript>
		<cfquery name="get_health_expense_relation" datasource="#dsn2#">
			SELECT EXPENSE_ITEM_PLANS_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
		</cfquery>
		<cfif isdefined("attributes.health_id") and len(attributes.health_id)>
			<cfif get_health_expense_relation.EXPENSE_ITEM_PLANS_ID eq "">
				<cfquery name="upd_health_expense_relation" datasource="#dsn2#">
					UPDATE
						EXPENSE_ITEM_PLANS
					SET
						EXPENSE_ITEM_PLANS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.health_id#">
					WHERE
						EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
				</cfquery>
			</cfif>
		</cfif>
		<cfif get_health_expense_relation.EXPENSE_ITEM_PLANS_ID neq "">
			<cfquery name="del_health_expense_relation" datasource="#dsn2#">
				UPDATE
					EXPENSE_ITEM_PLANS
				SET
					EXPENSE_ITEM_PLANS_ID = NULL
				WHERE
					EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
			</cfquery>
			<cfquery name="get_exp_item_plan_request" datasource="#dsn2#">
				SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_health_expense_relation.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
			<cfscript>
				cari_sil(action_id:get_health_expense_relation.EXPENSE_ITEM_PLANS_ID,process_type:get_exp_item_plan_request.EXPENSE_STAGE,cari_db : dsn2,action_table : "EXPENSE_ITEM_PLAN_REQUESTS");
				butce_sil(action_id:get_health_expense_relation.EXPENSE_ITEM_PLANS_ID,process_type:2503);
				muhasebe_sil(action_id:get_health_expense_relation.EXPENSE_ITEM_PLANS_ID,process_type:2503);
			</cfscript>
			<cfquery name="DELETE_SALARYPARAM_PAY_FROM_HEALTH_ID" datasource="#dsn2#">
				DELETE FROM #dsn#.SALARYPARAM_PAY WHERE EXPENSE_HEALTH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_health_expense_relation.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
			<cfquery name="DELETE_SALARYPARAM_GET_FROM_HEALTH_ID" datasource="#dsn2#">
				DELETE FROM #dsn#.SALARYPARAM_GET WHERE EXPENSE_HEALTH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_health_expense_relation.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
			<cfquery name="del_limb_drug_comp" datasource="#dsn2#">
				DELETE FROM HEALTH_EXPENSE WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_health_expense_relation.EXPENSE_ITEM_PLANS_ID#"> OR EXPENSE_ITEM_PLAN_REQUESTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_health_expense_relation.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
			<cfquery name="del_exp_item_plan_request" datasource="#dsn2#">
				DELETE FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_health_expense_relation.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
		</cfif>
		<cfquery name="DEL_ROW" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
		</cfquery>
		<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
			DELETE FROM STOCKS_ROW WHERE UPD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> AND PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_type#">
		</cfquery>
		<cfif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)>
			<cfquery name="get_rows" datasource="#dsn2#">
				SELECT ISNULL(CAPITAL_PRICE,0) CAPITAL_PRICE,ISNULL(INTEREST_PRICE,0) INTEREST_PRICE,ISNULL(TAX_PRICE,0) TAX_PRICE,ISNULL(DELAY_PRICE,0) DELAY_PRICE,EXPENSE_ITEM_ID FROM #dsn3_alias#.CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#"> AND CREDIT_CONTRACT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_row_id#">
			</cfquery>
			<cfquery name="upd_credit_row" datasource="#dsn2#">		
				UPDATE
					#dsn3_alias#.CREDIT_CONTRACT_ROW
				SET
					CREDIT_CONTRACT_TYPE = 1,
					CREDIT_CONTRACT_ID = #attributes.credit_contract_id#,	
					PROCESS_DATE = #attributes.expense_date#,
					CAPITAL_PRICE = #get_rows.CAPITAL_PRICE#,						
					INTEREST_PRICE = #get_rows.INTEREST_PRICE#,
					TAX_PRICE = #get_rows.TAX_PRICE#,
					DELAY_PRICE = #get_rows.DELAY_PRICE#,
					TOTAL_PRICE = #attributes.other_net_total_amount#,
					OTHER_MONEY = #sql_unicode()#'#rd_money_value#',						
					IS_PAID = 1,
					OUR_COMPANY_ID = #session.ep.company_id#,
					PERIOD_ID = #session.ep.period_id#
				WHERE
					ACTION_ID = #attributes.expense_id#
					AND PROCESS_TYPE = #process_type#
			</cfquery>
		</cfif>
		<cfset is_upd_action = 1>
		<!--- Kasa seçili ise --->
		<cfif isdefined("attributes.cash")>
			<cfinclude template="add_expense_cash_action.cfm">
		</cfif>
		<!--- Banka Seçili İse Bankaya Hareket Yapacak --->
		<cfif isdefined("attributes.bank")>
			<cfinclude template="add_expense_bank_action.cfm">
		</cfif>
		<!--- Kredi kartı Seçili İse --->
		<cfif isdefined("attributes.credit")>
			<cfinclude template="add_expense_creditcard_action.cfm">
		</cfif>
		<!--- üç işlem türüde seçilmedi ise işlem kayıtlarını siliyor--->
		<cfif not isdefined("attributes.bank") and not isdefined("attributes.cash") and not isdefined("attributes.credit")>
			<cfquery name="GET_CASH_ACTION" datasource="#dsn2#">
				SELECT ACTION_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
			</cfquery>
			<cfif get_cash_action.recordcount>
				<cfscript>
					cari_sil(action_id:GET_CASH_ACTION.ACTION_ID,process_type:32);
					muhasebe_sil (action_id:GET_CASH_ACTION.ACTION_ID,process_type:32);
				</cfscript>		
				<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
					DELETE FROM CASH_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CASH_ACTION.ACTION_ID#">
				</cfquery>
			</cfif>
			<cfquery name="GET_BANK_ACTION" datasource="#dsn2#">
				SELECT ACTION_ID FROM BANK_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
			</cfquery>
			<cfif get_bank_action.recordcount>
				<cfscript>
					cari_sil(action_id:GET_BANK_ACTION.ACTION_ID,process_type:25);
					muhasebe_sil (action_id:GET_BANK_ACTION.ACTION_ID,process_type:25);
				</cfscript>		
				<cfquery name="DEL_FROM_BANK_ACTIONS" datasource="#dsn2#">
					DELETE FROM BANK_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_BANK_ACTION.ACTION_ID#">
				</cfquery>
			</cfif>
			<cfquery name="GET_CREDIT_ACTION" datasource="#dsn2#">
				SELECT CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
			</cfquery>
			<cfif get_credit_action.recordcount>
				<cfscript>
					cari_sil(action_id:GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID,process_type:242);
					muhasebe_sil (action_id:GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID,process_type:242);
				</cfscript>
				<cfquery name="DEL_CC_REVENUE_MONEY" datasource="#dsn2#">
					DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#">
				</cfquery>
				<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
					DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS WHERE CREDITCARD_EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#">
				</cfquery>
				<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
					DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE CREDITCARD_EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#">
				</cfquery>
			</cfif>
		</cfif>
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<cfset form_money_1 = listgetat(evaluate("attributes.money_id#i#"), 1, ',')>
					<cfif isDefined("attributes.other_net_total#i#") and Len(evaluate("attributes.other_net_total#i#"))>
						<cfset form_other_value = evaluate("attributes.other_net_total#i#")>
					<cfelse>
						<cfset form_other_value = 0>
					</cfif>
					<cfif isDefined("attributes.net_total#i#") and Len(evaluate("attributes.net_total#i#"))>
						<cfset form_value = evaluate("attributes.net_total#i#")>
					<cfelse>
						<cfset form_value = 0>
					</cfif>
					<cfset vergiler_ = 0>
					<cfif len(form_other_value) and form_other_value gt 0>
						<cfset rate1_row_ = evaluate("last_rate_1_#form_money_1#")>
						<cfset money_value = wrk_round(((form_value/form_other_value*rate1_row_)),session.ep.our_company_info.rate_round_num)>
						<cfset money_value = money_value/rate1_row_>
						<cfif isDefined("attributes.tax_rate#i#") and Len(evaluate("attributes.tax_rate#i#"))><cfset vergiler_ = vergiler_ + evaluate("attributes.tax_rate#i#")></cfif>
						<cfif isDefined("attributes.otv_rate#i#") and Len(evaluate("attributes.otv_rate#i#"))><cfset vergiler_ = vergiler_ + evaluate("attributes.otv_rate#i#")></cfif>
						<cfset form_other_kdvsiz_value = wrk_round(form_other_value/((vergiler_+100)/100))>
					<cfelse>
						<cfset money_value = 1>
						<cfset form_other_kdvsiz_value = 0>
					</cfif>
					<cfif isdefined("attributes.expense_date#i#") and isdefined("attributes.expense_date#i#")>
						<cf_date tarih="attributes.expense_date#i#">
					</cfif>
					<cfif isdefined("attributes.receipt_date#i#") and len(evaluate("attributes.receipt_date#i#"))>
						<cf_date tarih="attributes.receipt_date#i#">
					</cfif>
					<cfset detail_ =  "#evaluate("attributes.row_detail#i#")#">
					<cfif isdefined("attributes.product_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#"))>
						<cfquery name="get_production" datasource="#dsn2#">
							SELECT IS_PRODUCTION FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID = #evaluate("attributes.product_id#i#")#
						</cfquery>
						<cfif isdefined("session.ep") and session.ep.our_company_info.spect_type and get_production.recordcount and get_production.is_production eq 1 and not (isdefined("attributes.spect_var_id#i#") and len(evaluate("attributes.spect_var_id#i#")) and len(evaluate("attributes.spect_name#i#")))>
							<cfset dsn_type=dsn2>
							<cfinclude template="../../objects/query/add_basket_spec.cfm">
							<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
								<cfset "attributes.spect_var_id#i#" = evaluate("attributes.spect_id#i#")>
							</cfif>
						</cfif>
					</cfif>
					<cfif isDefined("attributes.total#i#") and Len(evaluate("attributes.total#i#"))>
						<cfset temp_row_total = evaluate("attributes.total#i#")>
					<cfelse>
						<cfset temp_row_total = 0>
					</cfif>
					<cfif isDefined("attributes.net_total#i#") and Len(evaluate("attributes.net_total#i#"))>
						<cfset temp_row_nettotal = evaluate("attributes.net_total#i#")>
					<cfelse>
						<cfset temp_row_nettotal = 0>
					</cfif>
					<cfif len(evaluate("attributes.other_net_total#i#"))>
						<cfset temp_row_other_nettotal = evaluate("attributes.other_net_total#i#")>
					<cfelse>
						<cfset temp_row_other_nettotal = 0>
					</cfif>
					<cfif get_process_type.is_expensing_oiv eq 1>
						<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>
							<cfset temp_row_total = temp_row_total + evaluate("attributes.row_oiv_amount#i#")>
							<cfset temp_row_nettotal = temp_row_nettotal + evaluate("attributes.row_oiv_amount#i#")>
							<cfset form_other_kdvsiz_value + evaluate("attributes.row_oiv_amount#i#")>
							<cfset temp_row_other_nettotal + evaluate("attributes.row_oiv_amount#i#")>
						</cfif>
					</cfif>
					<cfif get_process_type.is_expensing_otv eq 1>
						<cfif isdefined('attributes.otv_total#i#') and len(evaluate("attributes.otv_total#i#"))>
							<cfset temp_row_total = temp_row_total + evaluate("attributes.otv_total#i#")>
							<cfset temp_row_nettotal = temp_row_nettotal + evaluate("attributes.otv_total#i#")>
							<cfset form_other_kdvsiz_value + evaluate("attributes.otv_total#i#")>
							<cfset temp_row_other_nettotal + evaluate("attributes.otv_total#i#")>
						</cfif>
					</cfif>
					<cfquery name="ADD_EXPENSE_ROWS" datasource="#dsn2#">
						INSERT INTO
							EXPENSE_ITEMS_ROWS
							(
								EXPENSE_ID,
								EXPENSE_DATE,
								RECEIPT_DATE,
								EXPENSE_CENTER_ID,
								EXPENSE_ITEM_ID,
								EXPENSE_COST_TYPE,
								PAPER_TYPE,
								DETAIL,
								SYSTEM_RELATION,
								IS_INCOME,
								ACTION_ID,
								EXPENSE_EMPLOYEE,
								COMPANY_ID,
								COMPANY_PARTNER_ID,
								MEMBER_TYPE,
								PYSCHICAL_ASSET_ID,
								PROJECT_ID,
								SUBSCRIPTION_ID,
								ACTIVITY_TYPE,
								WORKGROUP_ID,
								AMOUNT,
								KDV_RATE,
								OTV_RATE,
								DISCOUNT_RATE,
								DISCOUNT_PRICE,
								DISCOUNT_TOTAL,
								AMOUNT_KDV,
								AMOUNT_OTV,
								TOTAL_AMOUNT,
								MONEY_CURRENCY_ID,
								OTHER_MONEY_VALUE,
								OTHER_MONEY_GROSS_TOTAL,
								OTHER_MONEY_VALUE_2,
								MONEY_CURRENCY_ID_2,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								BUDGET_PLAN_ROW_ID,
								QUANTITY,
								PRODUCT_ID,
								SPECT_VAR_ID,
								STOCK_ID_2,
								PRODUCT_NAME,
								UNIT_ID,
								UNIT,
                                WRK_ROW_ID,
								BRANCH_ID,
								EXPENSE_ACCOUNT_CODE,
								WORK_ID,
								OPP_ID,
								IS_INTEREST,<!--- Kredi sözleşmesi ile bağlantısı tutuluyor --->
								TAX_CODE
								<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
								<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,AMOUNT_BSMV</cfif>
								<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_CURRENCY</cfif>
								<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
								<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,AMOUNT_OIV</cfif>
								<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
								<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,AMOUNT_TEVKIFAT</cfif>
							)
							VALUES
							(
								#attributes.expense_id#,
								<cfif isdefined("attributes.expense_date#i#") and len(evaluate("attributes.expense_date#i#"))>#evaluate("attributes.expense_date#i#")#<cfelseif len(attributes.expense_date)>#attributes.expense_date#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.receipt_date#i#") and len(evaluate("attributes.receipt_date#i#"))>#evaluate("attributes.receipt_date#i#")#<cfelseif isdefined("attributes.expense_date#i#") and len(evaluate("attributes.expense_date#i#"))>#evaluate("attributes.expense_date#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_center_id#i#") and Len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_item_id#i#") and Len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_cost_type") and Len(attributes.expense_cost_type)>#attributes.expense_cost_type#<cfelse>NULL</cfif>,
								<cfif len(attributes.expense_paper_type)>#sql_unicode()#'#attributes.expense_paper_type#'<cfelse>NULL</cfif>,
								#sql_unicode()#'#detail_#',
								<cfif len(attributes.system_relation)>#sql_unicode()#'#attributes.system_relation#'<cfelse>NULL</cfif>,
								0,
								0,
								<cfif isDefined("attributes.expense_employee_id") and len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.authorized#i#") and len(evaluate("attributes.authorized#i#")) and len(evaluate("attributes.company_id#i#")) and len(evaluate("attributes.member_type#i#")) and evaluate("attributes.member_type#i#") eq 'partner'>#evaluate("attributes.company_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.authorized#i#") and len(evaluate("attributes.authorized#i#")) and len(evaluate("attributes.member_id#i#"))>#evaluate("attributes.member_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.member_type#i#") and len(evaluate("attributes.member_type#i#"))>#sql_unicode()#'#wrk_eval("attributes.member_type#i#")#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.asset#i#") and isdefined("attributes.asset_id#i#") and len(evaluate("attributes.asset#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.project#i#") and  isdefined("attributes.project_id#i#") and len(evaluate("attributes.project#i#")) and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.subscription_name#i#") and isdefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_name#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.activity_type#i#") and len(evaluate("attributes.activity_type#i#"))>#evaluate("attributes.activity_type#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.workgroup_id#i#") and len(evaluate("attributes.workgroup_id#i#"))>#evaluate("attributes.workgroup_id#i#")#<cfelse>NULL</cfif>,
								#temp_row_total#,
								<cfif isDefined("attributes.tax_rate#i#") and Len(evaluate("attributes.tax_rate#i#"))>#evaluate("attributes.tax_rate#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.otv_rate#i#") and Len(evaluate("attributes.otv_rate#i#"))>#evaluate("attributes.otv_rate#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.discount_rate#i#") and Len(evaluate("attributes.discount_rate#i#"))>#evaluate("attributes.discount_rate#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.discount_price#i#") and Len(evaluate("attributes.discount_price#i#"))>#evaluate("attributes.discount_price#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.discount_total#i#") and Len(evaluate("attributes.discount_total#i#"))>#evaluate("attributes.discount_total#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.kdv_total#i#") and Len(evaluate("attributes.kdv_total#i#"))>#evaluate("attributes.kdv_total#i#")#<cfelse>0</cfif>,
								<cfif isDefined("attributes.otv_total#i#") and Len(evaluate("attributes.otv_total#i#"))>#evaluate("attributes.otv_total#i#")#<cfelse>0</cfif>,
								#temp_row_nettotal#,
								#sql_unicode()#'#listgetat(evaluate("attributes.money_id#i#"), 1, ',')#',
								#form_other_kdvsiz_value#,
								#temp_row_other_nettotal#,
								<cfif isDefined("currency_multiplier_money2") and len(currency_multiplier_money2)>#wrk_round(evaluate("attributes.net_total#i#")/currency_multiplier_money2,session.ep.our_company_info.rate_round_num)#<cfelse>NULL</cfif>,
								#sql_unicode()#'#session.ep.money2#',
								#session.ep.userid#,
								#sql_unicode()#'#cgi.remote_addr#',
								#now()#,
								<cfif isdefined("attributes.budget_plan_row_id#i#")>#evaluate("attributes.budget_plan_row_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.quantity#i#") and len(evaluate("attributes.quantity#i#"))>#evaluate("attributes.quantity#i#")#<cfelse>1</cfif>,
								<cfif isdefined("attributes.product_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.product_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.spect_var_id#i#") and isdefined("attributes.spect_name#i#") and len(evaluate("attributes.spect_var_id#i#")) and len(evaluate("attributes.spect_name#i#"))>#evaluate("attributes.spect_var_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.stock_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_name#i#"))>#sql_unicode()#'#left(evaluate("attributes.product_name#i#"),50)#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.product_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#")) and isdefined("attributes.stock_unit_id#i#") and len(evaluate("attributes.stock_unit_id#i#"))>#evaluate("attributes.stock_unit_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.product_id#i#") and isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#")) and isdefined("attributes.stock_unit#i#") and len(evaluate("attributes.stock_unit#i#"))>#sql_unicode()#'#wrk_eval("attributes.stock_unit#i#")#'<cfelse>NULL</cfif>,
   								<cfif isdefined("attributes.wrk_row_id#i#") and len(evaluate("attributes.wrk_row_id#i#"))>#sql_unicode()#'#wrk_eval("attributes.wrk_row_id#i#")#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#"))>#evaluate("attributes.row_branch#i#")#<cfelse>#branch_id_info_document#</cfif>,
								<cfif isdefined("attributes.account_code#i#") and isdefined("attributes.account_code#i#")>#sql_unicode()#'#evaluate("attributes.account_code#i#")#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.work_id#i#") and isdefined("attributes.work_head#i#") and len(evaluate("attributes.work_id#i#")) and len(evaluate("attributes.work_head#i#"))>#evaluate("attributes.work_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.opp_id#i#") and isdefined("attributes.opp_head#i#") and len(evaluate("attributes.opp_id#i#")) and len(evaluate("attributes.opp_head#i#"))>#evaluate("attributes.opp_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.credit_type#i#") and len(evaluate("attributes.credit_type#i#")) and evaluate("attributes.credit_type#i#") eq 0>1<cfelse>0</cfif>,
								<cfif isdefined("attributes.tax_code#i#") and len(evaluate("attributes.tax_code#i#"))>'#evaluate("attributes.tax_code#i#")#'<cfelse>NULL</cfif>
								<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
								<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
								<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
								<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
								<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
								<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
								<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
							)
					</cfquery>
					
					<cfif is_stock_action eq 1 and isdefined("attributes.product_id#i#") and len(evaluate("attributes.product_id#i#")) and isdefined("attributes.product_name#i#") and len(evaluate("attributes.product_name#i#"))><!--- işlem tipinde stok hareketi yapsın seçiliyse ve satırda ürün seçilmişse --->
						<cfquery name="GET_UNIT" datasource="#dsn2#">
							SELECT 
								ADD_UNIT,
								MULTIPLIER,
								MAIN_UNIT,
								PRODUCT_UNIT_ID
							FROM
								#dsn3_alias#.PRODUCT_UNIT PRODUCT_UNIT
							WHERE 
								PRODUCT_ID = #evaluate("attributes.product_id#i#")# AND
								ADD_UNIT = '#evaluate("attributes.stock_unit#i#")#'
                                AND PRODUCT_UNIT_STATUS = 1 
						</cfquery>
						<cfif get_unit.recordcount and len(get_unit.multiplier)>
							<cfset multi = get_unit.multiplier*evaluate("attributes.quantity#i#")>
						<cfelse>
							<cfset multi = evaluate("attributes.quantity#i#")>
						</cfif>
						<cfif isdefined("attributes.spect_var_id#i#") and isdefined("attributes.spect_name#i#") and len(evaluate("attributes.spect_var_id#i#")) and len(evaluate("attributes.spect_name#i#"))>
							<cfquery name="get_spect_main" datasource="#dsn2#">
								SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID = #evaluate("attributes.spect_var_id#i#")#
							</cfquery>
						</cfif>
						<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
							INSERT INTO 
									STOCKS_ROW
									(
										UPD_ID,
										PRODUCT_ID,
										STOCK_ID,
										PROCESS_TYPE,
										STOCK_OUT,
										STORE,
										STORE_LOCATION,
										PROCESS_DATE,
										PROCESS_TIME,
										SPECT_VAR_ID
									)
									VALUES
									(
										#attributes.expense_id#,
										#evaluate("attributes.product_id#i#")#,
										#evaluate("attributes.stock_id#i#")#,
										#process_type#,
										#multi#,
										#attributes.department_id#,
										#attributes.location_id#,				
										#attributes.expense_date#,
										#attributes.expense_date_time#,
										<cfif isdefined("attributes.spect_var_id#i#") and isdefined("attributes.spect_name#i#") and len(evaluate("attributes.spect_var_id#i#")) and len(evaluate("attributes.spect_name#i#"))>#get_spect_main.SPECT_MAIN_ID#<cfelse>NULL</cfif>
									)
						</cfquery>
					</cfif>
					<cfif ((isdefined("attributes.budget_plan_id") and not len(attributes.budget_plan_id)) or not isdefined("attributes.budget_plan_id")) and  ((isdefined("attributes.credit_contract_id") and not len(attributes.credit_contract_id)) or (not isdefined("attributes.credit_contract_id")))><!--- Bütçe Planlamadan ve kredi fondan gelmediyse --->
						<cfscript>
							if(is_account eq 1)
							{
								if (is_stock_action eq 1 and isdefined("attributes.product_id#i#") and len(evaluate("attributes.product_id#i#")) and isdefined("attributes.product_name#i#") and len(Evaluate("attributes.product_name#i#")) and not (isdefined("attributes.cash") or isdefined("attributes.bank") or isdefined("attributes.credit") or is_cari_islem))
								//fiziki varlıktan girilen masraflarda (carikasabanka seçilmeyip ürün seçilmişse ürün alış hesabına muh.yazyor
								{
									is_muh_action = 1;
									str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(evaluate("attributes.net_total#i#")),",");
									if(is_dept_based_acc eq 1)
									{
										dept_id = attributes.department_id;
										loc_id = attributes.location_id;
									}
									else
									{
										dept_id = 0;
										loc_id = 0;
									}
									product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:session.ep.period_id,product_account_db:dsn2,product_alias_db:dsn3_alias,department_id:dept_id,location_id:loc_id);
									str_alacak_kod_list = ListAppend(str_alacak_kod_list,product_account_codes.ACCOUNT_CODE_PUR,",");
									str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, evaluate("attributes.other_net_total#i#"),",");
									str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,form_money_1,",");
									satir_detay_list[2][listlen(str_alacak_tutar_list)]= fis_satir_row_detail;
									if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),",");
									else
										acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");

									if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
										acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,evaluate("attributes.row_branch#i#"),',');
									else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
										acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
									else
										acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,listgetat(session.ep.user_location,2,'-'),',');
								}
								if (isdefined("attributes.cash") or isdefined("attributes.bank") or isdefined("attributes.credit") or is_cari_islem or is_muh_action)
								{
									if(not len(evaluate("attributes.quantity#i#")))
										'attributes.quantity#i#' = 1;
									exp_acc_code = '';
									if (is_project_based_acc eq 1 and isdefined("attributes.project#i#") and len(evaluate("attributes.project#i#")) and isdefined("attributes.project_id#i#") and len(Evaluate("attributes.project_id#i#")))
									{
										get_project_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT EXPENSE_PROGRESS_CODE ACCOUNT_CODE FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("attributes.project_id#i#")# AND PERIOD_ID = #session.ep.period_id#");
										exp_acc_code = get_project_account_code.ACCOUNT_CODE;
									}
									else if (is_exp_based_acc eq 1 and isdefined("attributes.product_id#i#") and len(evaluate("attributes.product_id#i#")) and isdefined("attributes.product_name#i#") and len(Evaluate("attributes.product_name#i#")))
									{
										get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE_PUR ACCOUNT_CODE FROM #dsn3_alias#.PRODUCT_PERIOD WHERE PRODUCT_ID = #evaluate("attributes.product_id#i#")# AND PERIOD_ID = #session.ep.period_id#");
										exp_acc_code = get_expense_item_account_code.ACCOUNT_CODE;
									}
									else if(isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id))
									{
										get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT TOTAL_ACCOUNT_ID ACCOUNT_CODE FROM #dsn3_alias#.CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id#");
										exp_acc_code = get_expense_item_account_code.ACCOUNT_CODE;
									}
									else
									{
										if(isdefined("attributes.account_code#i#") and len(evaluate("attributes.account_code#i#")))
											exp_acc_code = evaluate("attributes.account_code#i#");
										else if(isdefined("attributes.expense_item_id#i#"))
										{
											get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #evaluate("attributes.expense_item_id#i#")#");
											exp_acc_code = get_expense_item_account_code.ACCOUNT_CODE;
										}										
									}
									if( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_oran))
									{//tevkifat
										satir_tevk_tutar = (evaluate("attributes.kdv_total#i#")*attributes.tevkifat_oran);
										tevkifat_acc_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT 
												ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
											FROM 
												#dsn3_alias#.SETUP_TEVKIFAT S_TEV,#dsn3_alias#.SETUP_TEVKIFAT_ROW ST_ROW 
											WHERE
												S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID AND
												S_TEV.TEVKIFAT_ID = #attributes.tevkifat_id# AND
												ST_ROW.TAX = #evaluate("attributes.tax_rate#i#")#
											ORDER BY ST_ROW.TAX");
									}else if( isDefined("attributes.row_tevkifat_rate#i#") and len(evaluate("attributes.row_tevkifat_rate#i#")) and evaluate("attributes.row_tevkifat_rate#i#") gt 0 ){
										satir_tevk_tutar = (evaluate("attributes.kdv_total#i#")*evaluate("attributes.row_tevkifat_rate#i#"));
										tevkifat_acc_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT 
												ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
											FROM 
												#dsn3_alias#.SETUP_TEVKIFAT S_TEV,#dsn3_alias#.SETUP_TEVKIFAT_ROW ST_ROW 
											WHERE
												S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID AND
												S_TEV.STATEMENT_RATE = #evaluate("attributes.row_tevkifat_rate#i#")# AND
												ST_ROW.TAX = #evaluate("attributes.tax_rate#i#")#
											ORDER BY ST_ROW.TAX");
											//writeDump(tevkifat_acc_codes); abort;
									}
									
									else if(isDefined("attributes.tax_rate#i#") and Len(evaluate("attributes.tax_rate#i#"))){ //kdv
										get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE,DIRECT_EXPENSE_CODE FROM SETUP_TAX WHERE TAX = #evaluate("attributes.tax_rate#i#")#");
									}
									if(isDefined("attributes.otv_rate#i#") and len(evaluate("attributes.otv_rate#i#")) and evaluate("attributes.otv_rate#i#") gt 0)//varsa ötv hesaplar çekiliyor
										get_otv_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE FROM #dsn3_alias#.SETUP_OTV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND TAX = #evaluate("attributes.otv_rate#i#")#");
									
									if(form_money_1 neq session.ep.money) //Satır dovizli ise kdv,otv ve fiyatın dovizli tutarları hesaplanıyor, asagıda other_money listelerine yazdırılıyor
									{
										muhasebe_value = wrk_round(((evaluate("attributes.total#i#")*evaluate("attributes.quantity#i#")) / money_value),rate_round_info_);
										if(isDefined("attributes.tax_rate#i#") and len(evaluate("attributes.tax_rate#i#")) and evaluate("attributes.tax_rate#i#") gt 0)
											muhasebe_tax_value =wrk_round((evaluate("attributes.kdv_total#i#") / money_value),session.ep.our_company_info.rate_round_num);
										if(isDefined("attributes.otv_rate#i#") and len(evaluate("attributes.otv_rate#i#")) and evaluate("attributes.otv_rate#i#") gt 0)
											muhasebe_otv_value = wrk_round((evaluate("attributes.otv_total#i#") / money_value),session.ep.our_company_info.rate_round_num);
									}else
									{
										muhasebe_value = wrk_round((evaluate("attributes.total#i#")*evaluate("attributes.quantity#i#")),rate_round_info_);
										if(isDefined("attributes.tax_rate#i#") and len(evaluate("attributes.tax_rate#i#")) and evaluate("attributes.tax_rate#i#") gt 0)
											muhasebe_tax_value =  wrk_round(evaluate("attributes.kdv_total#i#"),session.ep.our_company_info.rate_round_num);
										if(isDefined("attributes.otv_rate#i#") and len(evaluate("attributes.otv_rate#i#")) and evaluate("attributes.otv_rate#i#") gt 0)
											muhasebe_otv_value =  wrk_round(evaluate("attributes.otv_total#i#"),session.ep.our_company_info.rate_round_num);
									}
									
									if( ( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_oran) ) or ( isDefined("attributes.row_tevkifat_rate#i#") and len(evaluate("attributes.row_tevkifat_rate#i#")) and evaluate("attributes.row_tevkifat_rate#i#") gt 0  ) )//tevkifat hesapları
									{//sadece tevkifat için tevkifat tutarları alacak hesaplara ekleniyor,kdv ler gene borca ilave ediliyor
										str_alacak_kod_list = ListAppend(str_alacak_kod_list,tevkifat_acc_codes.tevkifat_beyan_code_pur,",");		
										str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round((evaluate("attributes.kdv_total#i#")-satir_tevk_tutar),rate_round_info_),",");
									
										if(form_money_1 neq session.ep.money)
											str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,wrk_round(((evaluate("attributes.kdv_total#i#")-satir_tevk_tutar)/money_value),rate_round_info_),",");
										else
											str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,wrk_round(((evaluate("attributes.kdv_total#i#")-satir_tevk_tutar)),rate_round_info_),",");
										str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,form_money_1,",");
										
										if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
											satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
										else
											satir_detay_list[2][listlen(str_alacak_tutar_list)]= fis_satir_row_detail;
										tax_acc = tevkifat_acc_codes.tevkifat_code_pur;

										if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
											acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),",");
										else
											acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");

										if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
											acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,evaluate("attributes.row_branch#i#"),',');
										else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
											acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
										else
											acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,listgetat(session.ep.user_location,2,'-'),',');
									}
									else if(isDefined("attributes.tax_rate#i#") and Len(evaluate("attributes.tax_rate#i#")))//kdv
										if( is_expensing_tax eq 1 )
										{
											tax_acc = get_tax_acc_code.DIRECT_EXPENSE_CODE;
										}
										else 
										{
											tax_acc = get_tax_acc_code.purchase_code;
										}
									else
										tax_acc = "";
										
									//borç hesaplar yazılıyor
									str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round((evaluate("attributes.total#i#")*evaluate("attributes.quantity#i#")),rate_round_info_),",");//satır toplamlar
									if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
										satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
									else	
										satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
									
									str_borc_kod_list = ListAppend(str_borc_kod_list,exp_acc_code,",");
									str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,muhasebe_value,",");
									str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
									str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
									if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
										acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.project_id#i#"),",");
									else
										acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");

									if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
										acc_branch_list_borc = ListAppend(acc_branch_list_borc,evaluate("attributes.row_branch#i#"),',');
									else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
										acc_branch_list_borc = ListAppend(acc_branch_list_borc,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
									else
										acc_branch_list_borc = ListAppend(acc_branch_list_borc,listgetat(session.ep.user_location,2,'-'),',');
								
									if(isDefined("attributes.tax_rate#i#") and len(evaluate("attributes.tax_rate#i#")) and evaluate("attributes.tax_rate#i#") gt 0)//kdv hesapları varsa ekleniyor
									{
										if( ( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_oran) ) or ( isDefined("attributes.row_tevkifat_rate#i#") and len(evaluate("attributes.row_tevkifat_rate#i#")) and evaluate("attributes.row_tevkifat_rate#i#") gt 0 ) ){
											//tevkifat kısmı
											if(satir_tevk_tutar gt 0){
												get_tax_acc_code1 = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE FROM SETUP_TAX WHERE TAX = #evaluate("attributes.tax_rate#i#")#");
												kdv_code = get_tax_acc_code1.PURCHASE_CODE;
												str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(satir_tevk_tutar,session.ep.our_company_info.rate_round_num),",");
												if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
													satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
												else
													satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
												str_borc_kod_list = ListAppend(str_borc_kod_list,kdv_code,",");
												//str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,muhasebe_tax_value,",");
												
												if(form_money_1 neq session.ep.money)
													str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,wrk_round(((satir_tevk_tutar/money_value)),rate_round_info_),",");
												else
													str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,wrk_round(((satir_tevk_tutar)),rate_round_info_),",");
												
												
												str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
												str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
												if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
													acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.project_id#i#"),",");
												else
													acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");

													
											if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,evaluate("attributes.row_branch#i#"),',');
											else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
											else
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,listgetat(session.ep.user_location,2,'-'),',');

											}
											//kdv kısmı
											if(isDefined("attributes.kdv_total#i#") and Len(evaluate("attributes.kdv_total#i#")))
											str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(evaluate("attributes.kdv_total#i#")-satir_tevk_tutar,session.ep.our_company_info.rate_round_num),",");//kdv ler
						
											if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
												satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
											else
												satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
											str_borc_kod_list = ListAppend(str_borc_kod_list, tevkifat_acc_codes.tevkifat_code_pur,",");

											if(form_money_1 neq session.ep.money)
												str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,wrk_round(((evaluate("attributes.kdv_total#i#")-satir_tevk_tutar)/money_value),rate_round_info_),",");
											else
												str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,wrk_round(((evaluate("attributes.kdv_total#i#")-satir_tevk_tutar)),rate_round_info_),",");

											str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
											str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
											if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
												acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.project_id#i#"),",");
											else
												acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");

											if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,evaluate("attributes.row_branch#i#"),',');
											else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
											else
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,listgetat(session.ep.user_location,2,'-'),',');	
											
											
										}
										else{
											if(isDefined("attributes.kdv_total#i#") and Len(evaluate("attributes.kdv_total#i#")))
												str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(evaluate("attributes.kdv_total#i#"),session.ep.our_company_info.rate_round_num),",");//kdv ler
											if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
												satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
											else
												satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
											str_borc_kod_list = ListAppend(str_borc_kod_list,tax_acc,",");
											str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,muhasebe_tax_value,",");
											str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
											str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
											if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
												acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.project_id#i#"),",");
											else
												acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");	
											
												if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,evaluate("attributes.row_branch#i#"),',');
											else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
											else
												acc_branch_list_borc = ListAppend(acc_branch_list_borc,listgetat(session.ep.user_location,2,'-'),',');
										}
									}
										

									if(isDefined("attributes.otv_rate#i#") and len(evaluate("attributes.otv_rate#i#")) and evaluate("attributes.otv_rate#i#") gt 0)//ötv hesapları varsa ekleniyor
									{
										str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(evaluate("attributes.otv_total#i#"),rate_round_info_),",");
										if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
											satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
										else
											satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
										
										str_borc_kod_list = ListAppend(str_borc_kod_list,get_otv_acc_code.purchase_code,",");
										str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,muhasebe_otv_value,",");
										str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
										str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
										if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
											acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.project_id#i#"),",");
										else
											acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");	
										if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
											acc_branch_list_borc = ListAppend(acc_branch_list_borc,evaluate("attributes.row_branch#i#"),',');
										else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
											acc_branch_list_borc = ListAppend(acc_branch_list_borc,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
										else
											acc_branch_list_borc = ListAppend(acc_branch_list_borc,listgetat(session.ep.user_location,2,'-'),',');
									}
									// bsmv bloğu
									if(IsDefined("form.row_bsmv_amount#i#") and evaluate("form.row_bsmv_amount#i#") gt 0)
									{
										temp_bsmv_tutar = evaluate("form.row_bsmv_amount#i#");
										get_bsmv_row=cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_BSMV WHERE TAX = #evaluate("form.row_bsmv_rate#i#")#");
										
										if( is_expensing_bsmv eq 1 ){//Bsmv'yi giderleştir
											str_borc_kod_list = ListAppend(str_borc_kod_list, get_bsmv_row.direct_expense_code, ",");
										}else{
											str_borc_kod_list = ListAppend(str_borc_kod_list, get_bsmv_row.purchase_code, ",");
										}
										str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
										str_borc_tutar_list = ListAppend(str_borc_tutar_list,temp_bsmv_tutar, ",");
										temp_bsmv_tutar2 = wrk_round((evaluate("attributes.row_bsmv_amount#i#") / money_value),session.ep.our_company_info.rate_round_num);
										str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,temp_bsmv_tutar2, ",");
										str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
										if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
											acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
										else
											acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
										if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
											satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
										else
											satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
									}

									// oiv bloğu
									if(IsDefined("form.row_oiv_amount#i#") and evaluate("form.row_oiv_amount#i#") gt 0)
									{
										temp_oiv_tutar = evaluate("form.row_oiv_amount#i#");
										get_oiv_row=cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_OIV WHERE TAX = #evaluate("form.row_oiv_rate#i#")#");
										str_borc_kod_list = ListAppend(str_borc_kod_list, get_oiv_row.purchase_code, ",");
										str_borc_tutar_list = ListAppend(str_borc_tutar_list,temp_oiv_tutar, ",");
										str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
										temp_oiv_tutar2 = wrk_round((evaluate("attributes.row_oiv_amount#i#") / money_value),session.ep.our_company_info.rate_round_num);
										str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, temp_oiv_tutar, ",");
										str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
										if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
											acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
										else
											acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
										if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
											satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#i#")#';
										else
											satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;

										if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
											acc_branch_list_borc = ListAppend(acc_branch_list_borc,evaluate("attributes.row_branch#i#"),',');
										else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
											acc_branch_list_borc = ListAppend(acc_branch_list_borc,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
										else
											acc_branch_list_borc = ListAppend(acc_branch_list_borc,listgetat(session.ep.user_location,2,'-'),',');
									}
								}
						}
						</cfscript>
					</cfif>
			   </cfif>
			</cfloop>
		</cfif>
		<cfif ((isdefined("attributes.budget_plan_id") and not len(attributes.budget_plan_id)) or not isdefined("attributes.budget_plan_id"))><!--- Bütçe Planlamadan ve kredi fondan gelmediyse --->
			<cfscript>
				if((isDefined("attributes.invoice_payment_plan") and attributes.invoice_payment_plan eq 1) or not isDefined("attributes.invoice_payment_plan"))//odeme planini guncellememesi icin eklendi
				{
					if(is_cari and is_cari_islem eq 1)
					{
					/*vade bazında carilestirme-belge bazında carileştirme islemlerinin geçişlerinde sorun olmaması icin herhalukarda cari hareketi silinip yeniden olusturuluyor. bu nedenle workcube_old_process_type cariciye gonderilmiyor*/					
						if(attributes.ch_member_type eq 'consumer')
							attributes.consumer_id=attributes.ch_partner_id; 
						else 
							attributes.consumer_id='';//consumer_id partner_id degiskeni ile formdan geliyor
						if(attributes.ch_member_type eq 'employee')
							attributes.emp_id=attributes.emp_id; 
						else 
							attributes.emp_id='';
						if(is_row_project_based_cari eq 1 or (is_row_project_based_cari eq 0 and get_cari_kontrol.recordcount neq 1))
							cari_sil(action_id:attributes.expense_id,process_type:form.old_process_type);
						else if(GET_NUMBER.TOTAL_AMOUNT_KDVLI neq attributes.net_total_amount or GET_NUMBER.DUE_DATE neq expence_due_date)//eğer vadesi veya tutarı değişmişse kapama işlemini de siliyor
							cari_sil(action_id:attributes.expense_id,process_type:form.old_process_type); //herhalukarda cari islemi silinip yeniden olusturuluyor
						else
							cari_sil(action_id:attributes.expense_id,process_type:form.old_process_type,inv_related_info:1); //herhalukarda cari islemi silinip yeniden olusturuluyor
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
									row_duedate = date_add("d",0,expence_due_date); //peşinat belge tarihine kesiliyor
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
										new_expense_date=expence_due_date;
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
									action_id :attributes.expense_id,
									action_table : 'EXPENSE_ITEM_PLANS',
									workcube_process_type : process_type,
									account_card_type : 13,
									islem_tarihi : attributes.expense_date,
									due_date : cari_row_duedate,
									islem_tutari : evaluate('row_amount_total_#ind_t#'),
									islem_belge_no : attributes.belge_no,
									from_branch_id :branch_id_info_document,
									from_cmp_id : from_company_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									acc_type_id : attributes.acc_type_id,
									islem_detay : islem_detay,
									action_detail : attributes.detail,
									other_money_value : evaluate('row_other_amount_total_#ind_t#'),
									other_money : rd_money_value,
									action_currency : SESSION.EP.MONEY,
									currency_multiplier : currency_multiplier_money2,
									process_cat : form.process_cat,
									project_id : project_id_info,
									rate2:currency_multiplier_money2
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
										'row_amount_total_#row_number#' = row_total_;
										'row_other_amount_total_#row_number#' = row_total_/paper_currency_multiplier;
									}
									else
									{
										row_number_ = listfind(row_project_list,evaluate("attributes.project_id#j#"));
										'row_amount_total_#row_number_#' = evaluate("row_amount_total_#row_number_#")+row_total_;
										'row_other_amount_total_#row_number_#' = evaluate("row_other_amount_total_#row_number_#")+(row_total_/paper_currency_multiplier);
									}
								}
								else if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
								{
									total_cash_price = total_cash_price + row_total_;
									total_other_cash_price = total_other_cash_price + row_total_/paper_currency_multiplier;
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
									due_date : iif(len(expence_due_date),de('#expence_due_date#'),de('')),
									islem_tutari : evaluate('row_amount_total_#ind_t#'),
									islem_belge_no : attributes.belge_no,
									from_branch_id :branch_id_info_document,
									from_cmp_id : from_company_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									acc_type_id : attributes.acc_type_id,
									islem_detay : islem_detay,
									action_detail : attributes.detail,
									other_money_value : evaluate('row_other_amount_total_#ind_t#'),
									other_money : rd_money_value,
									action_currency : SESSION.EP.MONEY,
									currency_multiplier : currency_multiplier_money2,
									process_cat : form.process_cat,
									project_id : cari_row_project,
									rate2:currency_multiplier_money2
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
									due_date : iif(len(expence_due_date),de('#expence_due_date#'),de('')),
									islem_tutari : total_cash_price,
									islem_belge_no : attributes.belge_no,
									from_branch_id :branch_id_info_document,
									from_cmp_id : from_company_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									acc_type_id : attributes.acc_type_id,
									islem_detay : islem_detay,
									action_detail : attributes.detail,
									other_money_value : total_other_cash_price,
									other_money : rd_money_value,
									action_currency : SESSION.EP.MONEY,
									currency_multiplier : currency_multiplier_money2,
									process_cat : form.process_cat,
									project_id : project_id_info,
									rate2:currency_multiplier_money2
									);
							}
						}
						else
						{
							carici(
								action_id :attributes.expense_id,
								action_table : 'EXPENSE_ITEM_PLANS',
								workcube_process_type : process_type,
								account_card_type : 13,
								islem_tarihi : attributes.expense_date,
								due_date : iif(len(expence_due_date),de('#expence_due_date#'),de('')),
								islem_tutari : attributes.net_total_amount,
								islem_belge_no : attributes.belge_no,
								from_branch_id :branch_id_info_document,
								from_cmp_id : from_company_id,
								from_consumer_id : from_consumer_id,
								from_employee_id : from_employee_id,
								acc_type_id : attributes.acc_type_id,
								islem_detay : islem_detay,
								action_detail : attributes.detail,
								other_money_value : attributes.other_net_total_amount,
								other_money : rd_money_value,
								action_currency : SESSION.EP.MONEY,
								currency_multiplier : currency_multiplier_money2,
								process_cat : form.process_cat,
								project_id : project_id_info,
								rate2:currency_multiplier_money2
								);
						}
					}
					else
						cari_sil(action_id:attributes.expense_id, process_type:form.old_process_type);
				}
								
				fis_satir_row_detail = '#attributes.belge_no# - #attributes.detail# - #islem_detay#';
				if(is_cari_islem) //cari hesap secilmisse fis satıra cari adı gonderiliyor
				{
					if(attributes.ch_member_type is 'partner')
						paper_detail = '#form.belge_no# -#attributes.ch_company# -#attributes.detail# #islem_detay#';
					else
						paper_detail = '#form.belge_no# -#attributes.ch_partner# -#attributes.detail# #islem_detay#';
				}
				else
					paper_detail = fis_satir_row_detail;
				if(isdefined("attributes.cash") or isdefined("attributes.bank") or isdefined("attributes.credit") or is_cari_islem)
				{
					if(is_account eq 1 and ((isdefined("attributes.credit_contract_id") and not len(attributes.credit_contract_id))))
					{
						str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(attributes.net_total_amount,rate_round_info_),",");
						str_alacak_kod_list = ListAppend(str_alacak_kod_list,string_acc_code,",");
						if(is_cari_islem) //cari hesap secilmisse fis satıra cari adı gonderiliyor
						{
							if(attributes.ch_member_type is 'partner')
								satir_detay_list[2][listlen(str_alacak_tutar_list)]= '#form.belge_no# -#attributes.ch_company# -#attributes.detail# #islem_detay#';
							else
								satir_detay_list[2][listlen(str_alacak_tutar_list)]= '#form.belge_no# -#attributes.ch_partner# -#attributes.detail# #islem_detay#';
						}
						else
							satir_detay_list[2][listlen(str_alacak_tutar_list)]= fis_satir_row_detail;
						
						multiplier_ = '';
						if((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))//cari seçilmiş ise
						{
							multiplier_ = paper_currency_multiplier;
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
						else if(isdefined("attributes.credit"))
						{
							multiplier_ = currency_multiplier_kk;	
							string_currency_id_ = string_currency_id;
						}
						
						str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,wrk_round(attributes.net_total_amount/multiplier_,rate_round_info_),",");
						str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,string_currency_id_,",");

						if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project#i#")))
							acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),",");
						else
							acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
						if(isdefined("attributes.row_branch#i#") and len(evaluate("attributes.row_branch#i#")) and len(evaluate("attributes.row_branch#i#")))
							acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,evaluate("attributes.row_branch#i#"),',');
						else if(isdefined("attributes.branch_id_") and len(attributes.branch_id_))
							acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,listfirst(ListDeleteDuplicates(attributes.branch_id_),','),',');
						else
							acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,listgetat(session.ep.user_location,2,'-'),',');
					}
				}
				
				if (((isdefined("attributes.cash") or isdefined("attributes.bank") or isdefined("attributes.credit") or is_cari_islem or is_muh_action) and is_account eq 1) and ((isdefined("attributes.credit_contract_id") and not len(attributes.credit_contract_id)))) 
				{
						FARK_HESAP = cfquery(datasource:"#dsn2#",sqlstring:"SELECT FARK_GELIR,FARK_GIDER,YUVARLAMA_GELIR,YUVARLAMA_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
						//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
						str_fark_gelir =FARK_HESAP.FARK_GELIR;
						str_fark_gider =FARK_HESAP.FARK_GIDER;
						str_max_round = 0.9;
						str_round_detail = fis_satir_row_detail;
						document_type_ = '';
						payment_type_ = '';
						str_card_detail = '#islem_detay# - #attributes.detail#';
						string_action_number = 13;
						from_branch_id_info = branch_id_info_document;
						
						if(isdefined("attributes.cash") and not(((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))))
						{
							//kasa odeme islemine odeme sekli cekiliyor
							CASH_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE IS_ACCOUNT = 1 AND PROCESS_TYPE = 32 ORDER BY PROCESS_CAT_ID");
							payment_type_ = CASH_INFO_.PAYMENT_TYPE;
							DOCUMENT_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT DOCUMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#");
							document_type_ = DOCUMENT_INFO_.DOCUMENT_TYPE;
							
							str_card_detail = UCase("#getLang('main',1769)#")&'- #attributes.detail#';
							string_action_number = 12;
							from_branch_id_info = branch_id_info;
						}
						else if(isdefined("attributes.bank") and not(((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))))
						{
							//banka islemine ait belge tipi ve odeme sekli cekiliyor
							BANK_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE IS_ACCOUNT = 1 AND PROCESS_TYPE = 25 ORDER BY PROCESS_CAT_ID");
							payment_type_ = BANK_INFO_.PAYMENT_TYPE;
							DOCUMENT_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT DOCUMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#");
							document_type_ = DOCUMENT_INFO_.DOCUMENT_TYPE;
							
							str_card_detail = UCase("#getLang('main',1760)#")&'- #attributes.detail#';
							string_action_number = 13;
							from_branch_id_info = branch_id_info_document;
						}
						else if(isdefined("attributes.credit") and not(((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))))
						{
							//kredi karti islemine ait belge tipi ve odeme sekli cekiliyor
							CREDITCARD_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE IS_ACCOUNT = 1 AND PROCESS_TYPE = 242 ORDER BY PROCESS_CAT_ID");
							payment_type_ = CREDITCARD_INFO_.PAYMENT_TYPE;
							DOCUMENT_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT DOCUMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#");
							document_type_ = DOCUMENT_INFO_.DOCUMENT_TYPE;
							
							str_card_detail = '#islem_detay# - #attributes.detail#';
							string_action_number = 13;
							from_branch_id_info = branch_id_info_document;
						}
							
						if(attributes.ch_member_type eq 'partner')
							attributes.comp_id=attributes.ch_company_id; 
						else 
							attributes.comp_id='';
							
						if(len(attributes.yuvarlama) and attributes.yuvarlama lt 0)
						{
							str_alacak_kod_list = ListAppend(str_alacak_kod_list, FARK_HESAP.YUVARLAMA_GELIR, ",");
							str_alacak_tutar_list = ListAppend(str_alacak_tutar_list, abs(attributes.yuvarlama), ",");
							str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,abs(attributes.yuvarlama), ",");
							str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,session.ep.money, ",");
							satir_detay_list[2][listlen(str_alacak_tutar_list)]=paper_detail;
							if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
								acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
							else
								acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
							if(isdefined("branch_id_info_document") and len(branch_id_info_document))
								acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,branch_id_info_document,",");
							else
								acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,0,",");
						}
						else if(len(attributes.yuvarlama) and attributes.yuvarlama gt 0)
						{
							str_borc_kod_list = ListAppend(str_borc_kod_list, FARK_HESAP.YUVARLAMA_GIDER, ",");
							str_borc_tutar_list = ListAppend(str_borc_tutar_list, abs(attributes.yuvarlama), ",");
							str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,abs(attributes.yuvarlama), ",");
							str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,session.ep.money, ",");
							satir_detay_list[1][listlen(str_borc_tutar_list)]=paper_detail;
						//	str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
							if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
								acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
							else
								acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
								
							acc_branch_list_borc = ListAppend(acc_branch_list_borc,listgetat(session.ep.user_location,2,'-'),',');
						}
						if (isDefined('form.stopaj_rate_id') and len(form.stopaj_rate_id))//stopaj popuptan seçilmişse
							GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #form.stopaj_rate_id#");
						else if (len(form.stopaj_yuzde) and form.stopaj_yuzde neq 0)
							GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE = #form.stopaj_yuzde#");
						if(isdefined("GET_SETUP_STOPPAGE_RATES") and len(form.stopaj) and form.stopaj neq 0)
						{
							str_alacak_kod_list = ListAppend(str_alacak_kod_list, GET_SETUP_STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE, ",");
							str_alacak_tutar_list = ListAppend(str_alacak_tutar_list, form.stopaj, ",");
							str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,(form.stopaj/money_value),",");
							str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,form_money_1,",");
							satir_detay_list[2][listlen(str_alacak_tutar_list)]=paper_detail;
							if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
								acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
							else
								acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
								
							if(isdefined("branch_id_info_document") and len(branch_id_info_document))
								acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,branch_id_info_document,",");
							else
								acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,0,",");
						}
						
						muhasebeci (
							action_id:attributes.expense_id,
							workcube_process_type : process_type,
							workcube_process_cat : attributes.process_cat,
							workcube_old_process_type : attributes.old_process_type,
							acc_department_id:acc_department_id,
							account_card_type : string_action_number,
							company_id : from_company_id,
							consumer_id : from_consumer_id,
							employee_id : from_employee_id,
							islem_tarihi : attributes.expense_date,
							borc_hesaplar : str_borc_kod_list,
							borc_tutarlar : str_borc_tutar_list,
							alacak_hesaplar : str_alacak_kod_list,
							alacak_tutarlar : str_alacak_tutar_list,
							fis_satir_detay : satir_detay_list,
							fis_detay : str_card_detail,
							belge_no : attributes.belge_no,
							other_amount_borc : str_other_borc_tutar_list,
							other_currency_borc : str_other_borc_currency_list,
							other_amount_alacak : str_other_alacak_tutar_list,
							other_currency_alacak : str_other_alacak_currency_list,
							currency_multiplier : currency_multiplier_money2,
							to_branch_id :branch_id_info_document,
							from_branch_id :from_branch_id_info,
							is_account_group : account_group,
							dept_round_account :str_fark_gider,
							borc_miktarlar : str_borclu_miktar,
							claim_round_account : str_fark_gelir,
							max_round_amount :str_max_round,
							round_row_detail:str_round_detail,
							document_type : document_type_,
							acc_project_id : main_project_id,
							acc_project_list_alacak : acc_project_list_alacak,
							acc_project_list_borc : acc_project_list_borc,
							payment_method : payment_type_,
							acc_branch_list_alacak : acc_branch_list_alacak,
							acc_branch_list_borc : acc_branch_list_borc
						);	
				}
					else muhasebe_sil(action_id:attributes.expense_id, process_type:attributes.old_process_type);
			</cfscript>
		<cfelseif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><!--- Bütçe planlamadan geliyorsa muhasebe fişi --->
			<cfscript>
				if(is_account eq 1)
				{
					str_alacak_tutar_list="";
					str_alacak_kod_list="";
					str_borc_tutar_list="";
					str_borc_kod_list="";
					satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
					str_other_alacak_tutar_list = "";
					str_other_borc_tutar_list = "";
					str_other_borc_currency_list = "";
					str_other_alacak_currency_list = "";
					str_borclu_tutar = ArrayNew(1) ;
					str_alacakli_tutar = ArrayNew(1) ;
					for(j=1;j lte attributes.record_num;j=j+1)
					{
						if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") and isdefined("attributes.budget_plan_row_id#j#"))
						{
							
							str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(evaluate("attributes.net_total#j#")),",");
							if(isdefined("attributes.account_code#j#") and len(evaluate("attributes.account_code#j#")))
								exp_acc_code = evaluate("attributes.account_code#j#");
							else
							{
								get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #evaluate("attributes.expense_item_id#j#")#");
								exp_acc_code = get_expense_item_account_code.ACCOUNT_CODE;
							}
							str_borc_kod_list = ListAppend(str_borc_kod_list,exp_acc_code,",");
							str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#i#")#';
							str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, evaluate("attributes.other_net_total#j#"),",");
							str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,rd_money_value,",");
							str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(evaluate("attributes.net_total#j#")),",");
							get_first_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT BUDGET_ACCOUNT_CODE FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ROW_ID = #evaluate("attributes.budget_plan_row_id#j#")#");
							str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_first_expense_item_account_code.budget_account_code,",");
							str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, evaluate("attributes.other_net_total#j#"),",");
							str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,rd_money_value,",");
							if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
							{	
								satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
								satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
							}
							else
							{
								satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
								satir_detay_list[2][listlen(str_alacak_tutar_list)]=fis_satir_row_detail;
							}
							if(isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project#j#")))
								acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.project_id#j#"),",");
							else
								acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
							if(isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project#j#")))
								acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.project_id#j#"),",");
							else
								acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
						}
					}
					muhasebeci (
						action_id:attributes.expense_id,
						action_table :'EXPENSE_ITEM_PLANS',
						workcube_process_type : process_type,
						workcube_process_cat : attributes.process_cat,
						workcube_old_process_type : attributes.old_process_type,
						acc_department_id:acc_department_id,
						account_card_type : 13,
						islem_tarihi : attributes.expense_date,
						borc_hesaplar : str_borc_kod_list,
						borc_tutarlar : str_borc_tutar_list,
						alacak_hesaplar : str_alacak_kod_list,
						alacak_tutarlar : str_alacak_tutar_list,
						fis_satir_detay: satir_detay_list,
						fis_detay : UCase("#getLang('main',147)# #getLang('main',652)#"),
						to_branch_id :branch_id_info_document,
						from_branch_id :branch_id_info_document,
						belge_no : form.belge_no,
						borc_miktarlar : str_borclu_miktar,
						other_amount_borc : str_other_borc_tutar_list,
						other_currency_borc : str_other_borc_currency_list,
						other_amount_alacak : str_other_alacak_tutar_list,
						other_currency_alacak : str_other_alacak_currency_list,
						is_account_group : account_group,
						acc_project_id : main_project_id,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc,
						currency_multiplier : currency_multiplier_money2
					);
				}
				else 
					muhasebe_sil(action_id:attributes.expense_id, process_type:attributes.old_process_type);
			</cfscript>
		</cfif>
		<cfif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)>
			<cfscript>
				if(is_account eq 1)
				{
					str_alacak_tutar_list="";
					str_alacak_kod_list="";
					str_borc_tutar_list="";
					str_borc_kod_list="";
					satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
					str_other_alacak_tutar_list = "";
					str_other_borc_tutar_list = "";
					str_other_borc_currency_list = "";
					str_other_alacak_currency_list = "";
					str_borclu_tutar = ArrayNew(1) ;
					str_alacakli_tutar = ArrayNew(1) ;
					total_interest = 0;
					for(j=1;j lte attributes.record_num;j=j+1)
					{
						if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
						{
							money_value_ = wrk_round((evaluate("attributes.other_net_total#j#")/evaluate("attributes.net_total#j#")),session.ep.our_company_info.rate_round_num);
							//82664 id'li is kapsaminda kaldirildi
							if(evaluate("attributes.credit_type#j#") eq 0)//faiz satırı ise
							{
								if(not Len(str_borc_kod_list)){
									str_borc_tutar_list = ListAppend(str_borc_tutar_list,evaluate("attributes.total#j#"),",");
									str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#j#")#';
									get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_rows.expense_item_id#");
									exp_acc_code = get_expense_item_account_code.ACCOUNT_CODE;
									str_borc_kod_list = ListAppend(str_borc_kod_list,exp_acc_code,",");
									str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, wrk_round(evaluate("attributes.total#j#")*money_value_),",");
									str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listfirst(evaluate("attributes.money_id#j#")),",");
										if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
											{
												satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
											}
										else
											{
												satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
											}
										if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
											{
												satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
											}
										else
											{
												satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
											}
								}
								else{
									str_borc_tutar_list = ListAppend(str_borc_tutar_list,evaluate("attributes.total#j#"),",");
									str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#j#")#';
									get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_rows.expense_item_id#");
									exp_acc_code = get_expense_item_account_code.ACCOUNT_CODE;
									str_borc_kod_list = ListAppend(str_borc_kod_list,exp_acc_code,",");
									str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, wrk_round(evaluate("attributes.total#j#")*money_value_),",");
									str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listfirst(evaluate("attributes.money_id#j#")),",");
									
								str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,evaluate("attributes.total#j#"),",");
								get_first_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT BORROW FROM #dsn3_alias#.CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id#");
								str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_first_expense_item_account_code.borrow,",");
								str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, wrk_round(evaluate("attributes.total#j#")*money_value_),",");
								str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,listfirst(evaluate("attributes.money_id#j#")),",");
								if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
								{
									satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
									satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
								}
								else
								{
									satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
									satir_detay_list[2][listlen(str_alacak_tutar_list)]=fis_satir_row_detail;
								}
								total_interest = total_interest+wrk_round(evaluate("attributes.total#j#"));
								
								
								str_borc_tutar_list = ListAppend(str_borc_tutar_list,evaluate("attributes.total#j#"),",");
								str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#j#")#';
								get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT TOTAL_ACCOUNT_ID FROM #dsn3_alias#.CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id#");
								exp_acc_code = get_expense_item_account_code.TOTAL_ACCOUNT_ID;
								str_borc_kod_list = ListAppend(str_borc_kod_list,exp_acc_code,",");
								str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, wrk_round(evaluate("attributes.total#j#")*money_value_),",");
								str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listfirst(evaluate("attributes.money_id#j#")),",");
								if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
								{
									satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
								}
								else
								{
									satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
								}
								}
							}
							else
							{
							if(isdefined("attributes.account_code#j#") and len(evaluate("attributes.account_code#j#")))
								exp_acc_code = evaluate("attributes.account_code#j#");
							else
							{
								get_expense_item_account_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT TOTAL_ACCOUNT_ID FROM #dsn3_alias#.CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id#");
								exp_acc_code = get_expense_item_account_code.TOTAL_ACCOUNT_ID;
							}							
							str_borc_tutar_list = ListAppend(str_borc_tutar_list,evaluate("attributes.total#j#"),",");
							str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#j#")#';
							str_borc_kod_list = ListAppend(str_borc_kod_list,exp_acc_code,",");
							str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, wrk_round(evaluate("attributes.total#j#")*money_value_),",");
							str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listfirst(evaluate("attributes.money_id#j#")),",");
							if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
							{
								satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
							}
							else
							{
								satir_detay_list[1][listlen(str_borc_tutar_list)]=fis_satir_row_detail;
							}								
							}
							get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE FROM SETUP_TAX WHERE TAX = #evaluate("attributes.tax_rate#j#")#");
							if(form_money_1 neq session.ep.money)
							{
								muhasebe_value = wrk_round(((evaluate("attributes.total#j#")*evaluate("attributes.quantity#j#")) / money_value),rate_round_info_);
								muhasebe_tax_value =wrk_round((evaluate("attributes.kdv_total#j#") / money_value),session.ep.our_company_info.rate_round_num);
							}else
							{
								muhasebe_value = wrk_round((evaluate("attributes.total#j#")*evaluate("attributes.quantity#j#")),rate_round_info_);
								muhasebe_tax_value =  wrk_round(evaluate("attributes.kdv_total#j#"),session.ep.our_company_info.rate_round_num);
							}

							str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(evaluate("attributes.kdv_total#j#"),session.ep.our_company_info.rate_round_num),",");//kdv ler
							str_borclu_miktar[listlen(str_borc_tutar_list)] = '#evaluate("attributes.quantity#j#")#';
							if(account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
								satir_detay_list[1][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
							else
								satir_detay_list[1][listlen(str_borc_tutar_list)]= fis_satir_row_detail;
							if( is_expensing_tax eq 1 )
							{
								str_borc_kod_list = ListAppend(str_borc_kod_list, get_tax_acc_code.DIRECT_EXPENSE_CODE, ",");
							}
							else 
							{
								str_borc_kod_list = ListAppend(str_borc_kod_list,get_tax_acc_code.PURCHASE_CODE,",");
							}
							str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,muhasebe_tax_value,",");
							str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,form_money_1,",");
						}
					}
					
					str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,wrk_round(attributes.other_net_total_amount,rate_round_info_),",");
					str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,rd_money_value,",");
					
					str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(attributes.net_total_amount),",");
					str_alacak_kod_list = ListAppend(str_alacak_kod_list,string_acc_code,",");
					satir_detay_list[2][listlen(str_alacak_tutar_list)]=fis_satir_row_detail;
					FARK_HESAP = cfquery(datasource:"#dsn2#",sqlstring:"SELECT FARK_GELIR,FARK_GIDER,YUVARLAMA_GELIR,YUVARLAMA_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
					str_fark_gelir =FARK_HESAP.FARK_GELIR;
					str_fark_gider =FARK_HESAP.FARK_GIDER;
					str_max_round = 0.19;
					str_round_detail = fis_satir_row_detail;
					muhasebeci (
						action_id:attributes.expense_id,
						action_table :'EXPENSE_ITEM_PLANS',
						workcube_process_type : process_type,
						workcube_process_cat : attributes.process_cat,
						workcube_old_process_type : attributes.old_process_type,
						acc_department_id:acc_department_id,
						account_card_type : 13,
						company_id : attributes.ch_company_id,
						consumer_id : attributes.ch_partner_id,
						islem_tarihi : attributes.expense_date,
						borc_hesaplar : str_borc_kod_list,
						borc_tutarlar : str_borc_tutar_list,
						alacak_hesaplar : str_alacak_kod_list,
						alacak_tutarlar : str_alacak_tutar_list,
						fis_satir_detay: satir_detay_list,
						fis_detay : UCase("#getLang('main',2656)#"),
						to_branch_id :branch_id_info_document,
						from_branch_id :branch_id_info_document,
						belge_no : form.belge_no,
						other_amount_borc : str_other_borc_tutar_list,
						other_currency_borc : str_other_borc_currency_list,
						other_amount_alacak : str_other_alacak_tutar_list,
						other_currency_alacak : str_other_alacak_currency_list,
						is_account_group : account_group,
						currency_multiplier : currency_multiplier_money2,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						borc_miktarlar : str_borclu_miktar,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail,
						acc_project_id : main_project_id,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc
					);
				}else 
					muhasebe_sil(action_id:attributes.expense_id, process_type:attributes.old_process_type,action_table:'EXPENSE_ITEM_PLANS');
			</cfscript>
		</cfif>
				
			
		<!--- money kayıtları --->
		<cfquery name="DEL_EXPENSE_ITEM_PLANS_MONEY" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
		</cfquery>
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
					#attributes.expense_id#,
					#sql_unicode()#'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
				<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
		<cfquery name="DEL_EXPENSE_TAXES" datasource="#dsn2#">
			DELETE FROM INVOICE_TAXES WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
		</cfquery>
		<cfquery name="get_setup_tax" datasource="#dsn2#">
			SELECT TAX FROM SETUP_TAX
		</cfquery>
		<cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>
			<cfloop query="get_setup_tax">
				<cfif isdefined("attributes.basket_tax_#currentrow-1#")>
					<cfquery name="ADD_INVOICE_TAXES" datasource="#dsn2#">
						INSERT INTO
							INVOICE_TAXES
							(
								EXPENSE_ID,
								TAX,
								TEVKIFAT_TUTAR,
								BEYAN_TUTAR					
							)
						VALUES
							(
								#attributes.expense_id#,
								#evaluate("attributes.basket_tax_#currentrow-1#")#,
								#evaluate("attributes.tevkifat_tutar_#currentrow-1#")#,
								#evaluate("attributes.basket_tax_value_#currentrow-1#")#   
							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			old_process_cat_id = "#attributes.old_process_cat_id#"
			action_id = "#attributes.expense_id#"
			is_action_file = "1"
            action_table="EXPENSE_ITEM_PLANS"
			action_column="EXPENSE_ID"
			action_file_name='#get_process_type.action_file_name#'
			action_page='#request.self#?fuseaction=#nextEvent##attributes.expense_id#'
			action_db_type="#dsn2#"
			is_template_action_file = '#get_process_type.action_file_from_template#'>
    <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.expense_id#" action_name="#attributes.belge_no# Güncellendi" paper_no="#attributes.belge_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
	<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn2#' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#'
		action_table='EXPENSE_ITEM_PLANS'
		action_column='EXPENSE_ID'
		action_id='#attributes.expense_id#'
		action_page='#request.self#?fuseaction=#nextEvent##attributes.expense_id#'
		warning_description="#getLang('','Masraf Fişi',58064)# : #attributes.belge_no#">	
</cfif>
<cfif session.ep.our_company_info.is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfif is_stock_action eq 1>
		<cfscript>
			cost_action(action_type:6,action_id:attributes.expense_id,query_type:2);
		</cfscript>
	</cfif>
	<cfif isdefined("attributes.is_from_credit") and len(attributes.is_from_credit)>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	<cfelse>
		<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.expense_id#</cfoutput>";
		</script>
	</cfif>
<cfelse>
	<cfif isdefined("attributes.is_from_credit") and len(attributes.is_from_credit)>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	<cfelse>
    	<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.expense_id#</cfoutput>";
		</script>
	</cfif>
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.expense_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -17>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
