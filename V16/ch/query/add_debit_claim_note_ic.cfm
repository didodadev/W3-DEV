<cfif not isdefined("new_dsn_2")><cfset new_dsn_2 = dsn2></cfif>
<cfif isdefined('attributes.claim_company_id') and len(attributes.claim_company_id)>
	<cfset member_company_id = attributes.claim_company_id>
<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfset member_company_id = attributes.company_id>
<cfelse>
	<cfset member_company_id = ''>
</cfif>
<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cfset member_consumer_id = attributes.consumer_id>
<cfelse>
	<cfset member_consumer_id = ''>
</cfif>
<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
	<cfset member_employee_id = attributes.employee_id>
<cfelse>
	<cfset member_employee_id = ''>
</cfif>
<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = ''></cfif>
<cfquery name="ADD_CASH_PAYMENT_IN_OP" datasource="#new_dsn_2#">
	INSERT INTO
		#dsn2_alias#.CARI_ACTIONS
	(
		PROCESS_CAT,
		ACTION_NAME,
		ACTION_TYPE_ID,
		ACTION_VALUE,
		ACTION_CURRENCY_ID,
		OTHER_MONEY,
		PROJECT_ID,
		OTHER_CASH_ACT_VALUE,
		<cfif (process_type eq 41) and len(member_company_id)>TO_CMP_ID,								
		<cfelseif (process_type eq 42) and len(member_company_id)>FROM_CMP_ID,
		<cfelseif (process_type eq 41) and len(member_consumer_id)>TO_CONSUMER_ID,
		<cfelseif (process_type eq 42) and len(member_consumer_id)>FROM_CONSUMER_ID,
		<cfelseif (process_type eq 41) and len(member_employee_id)>TO_EMPLOYEE_ID,
		<cfelseif (process_type eq 42) and len(member_employee_id)>FROM_EMPLOYEE_ID,</cfif>
		ACTION_DETAIL,
		ACTION_ACCOUNT_CODE,
		ACTION_DATE,
		PAPER_NO,
		RECORD_DATE,
		<cfif isdefined('session.ep')>RECORD_EMP,<cfelseif isdefined('session.pp')>RECORD_PAR,<cfelseif isdefined('session.ww')>RECORD_CONS,</cfif>
		RECORD_IP,
		DUE_DIFF_ID,
		ASSETP_ID,
		ACC_DEPARTMENT_ID,
        ACC_BRANCH_ID,
		INVOICE_ID,
		RELATION_ACTION_TYPE_ID,
		RELATION_ACTION_ID,
		CONTRACT_ID,
		PROGRESS_ID,
		SUBSCRIPTION_ID,
		FROM_PROGRESS,
        ACC_TYPE_ID,
		ACTIVITY_ID
	)
	VALUES
	(
		#form.process_cat#,
		<cfif process_type eq 41><cfqueryparam cfsqltype="cf_sql_varchar" value="BORÇ DEKONTU"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="ALACAK DEKONTU"></cfif>,
		#process_type#,
		#attributes.action_value#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_CURRENCY_ID#">,
		<cfif len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#"><cfelse>NULL</cfif>,
		<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.other_cash_act_value)>#attributes.other_cash_act_value#<cfelse>NULL</cfif>,
		<cfif (process_type eq 41) and len(member_company_id)>#member_company_id#,						
		<cfelseif (process_type eq 42) and len(member_company_id)>#member_company_id#,	
		<cfelseif (process_type eq 41) and len(member_consumer_id)>#member_consumer_id#,
		<cfelseif (process_type eq 42) and len(member_consumer_id)>#member_consumer_id#,
		<cfelseif (process_type eq 41) and len(member_employee_id)>#member_employee_id#,
		<cfelseif (process_type eq 42) and len(member_employee_id)>#member_employee_id#,</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,
		<cfif len(attributes.action_account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_account_code#"><cfelse>NULL</cfif>,
		#attributes.action_date#,
		<cfif len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
		#now()#,
		<cfif isdefined('session.ep')>#session.ep.userid#,<cfelseif isdefined('session.pp')>#session.pp.userid#,<cfelseif isdefined('session.ww')>#session.ww.userid#,</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfif isdefined("attributes.due_diff_id")>#attributes.due_diff_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.invoice_id")>#attributes.invoice_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.relation_action_type_id")>#attributes.relation_action_type_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.relation_action_id")>#attributes.relation_action_id#<cfelse>NULL</cfif>,
		<cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>,
		<cfif isdefined("atttributes.progress_id") and len(atttributes.progress_id)>#atttributes.progress_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.form_progress") and attributes.form_progress eq 1>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.activity_id") and len(attributes.activity_id)>#attributes.activity_id#<cfelse>NULL</cfif>
	)
</cfquery>
<cfquery name="GET_MAX" datasource="#new_dsn_2#">
	SELECT MAX(ACTION_ID) AS ACTION_ID FROM #dsn2_alias#.CARI_ACTIONS
</cfquery>
<cfscript>
	if(isdefined('session.ep'))
	{
		if (isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id))
		{
			 _branch_id_=attributes.acc_branch_id;
		}
		else
		{
			 _branch_id_=listgetat(session.ep.user_location,2,'-');
		}
		is_period_entegrated_ = session.ep.period_is_integrated;
		base_period_year_ = session.ep.period_year;
		action_currency_ = session.ep.money;
		action_currency2_ = session.ep.money2;
	}
	else
	{
		is_period_entegrated_ = 1;
		base_period_year_ = session_base.period_year;
		action_currency_ = session_base.money;
		action_currency2_ = '';
		_branch_id_='';
	}
	currency_multiplier = '';
	paper_currency_multiplier = '';
	
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(isdefined('session.ep.money2') and (evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2))
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	
	act_other_money_value = iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de(''));
	act_other_money = form.money_type;
	
	if (process_type eq 41)
	{
		if (is_cari eq 1)
		{
			carici(
				action_id : get_max.action_id,
				islem_belge_no : attributes.paper_number,
				process_cat : form.process_cat,
				workcube_process_type : process_type,
				action_table : 'CARI_ACTIONS',
				islem_tutari : attributes.system_amount,
				action_currency : action_currency_,
				action_currency_2 :action_currency2_,
				other_money_value : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
				other_money : form.money_type,
				islem_tarihi : attributes.action_date,
				islem_detay : 'BORÇ DEKONTU',
				action_detail : attributes.action_detail,
				acc_type_id : attributes.acc_type_id,
				to_cmp_id : member_company_id,
				subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
				to_consumer_id : member_consumer_id,
				to_employee_id : member_employee_id,			
				currency_multiplier : currency_multiplier,
				account_card_type : 13,
				project_id : attributes.project_id,
				to_branch_id : _branch_id_,
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:paper_currency_multiplier,
				period_is_integrated:is_period_entegrated_,
				cari_db : new_dsn_2,
				cari_db_alias : dsn2_alias
				);
		}
		if (len(attributes.expense_center_1) and len(attributes.EXPENSE_CENTER_ID_1) and len(attributes.EXPENSE_ITEM_ID_1) and len(attributes.expense_item_name_1))
		{
			if(len(attributes.action_detail))
				action_detail_ = attributes.action_detail;
			else
				action_detail_ = 'BORÇ DEKONTU MASRAFI';
				
			butceci(
				action_id : get_max.action_id,
				muhasebe_db : new_dsn_2,
				is_income_expense : true,
				process_type : process_type,
				nettotal : attributes.system_amount,
				other_money_value : act_other_money_value,
				action_currency : act_other_money,
				currency_multiplier : currency_multiplier,
				expense_date : attributes.action_date,
				expense_center_id : attributes.EXPENSE_CENTER_ID_1,
				activity_type : attributes.activity_id,
				expense_item_id : attributes.EXPENSE_ITEM_ID_1,
				detail : action_detail_,
				project_id : attributes.project_id,
				paper_no : attributes.paper_number,
				company_id : member_company_id,
				consumer_id : member_consumer_id,
				employee_id : member_employee_id,
				branch_id : _branch_id_,
				insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
			);
		}
	}		
	else if (process_type eq 42)
	{
		if (is_cari eq 1)
		{
			carici(
				action_id : get_max.action_id,
				islem_belge_no : attributes.paper_number,
				process_cat : form.process_cat,
				workcube_process_type : process_type,
				action_table : 'CARI_ACTIONS',
				islem_tutari : attributes.system_amount,
				action_currency : action_currency_,
				action_currency_2 :action_currency2_,
				other_money_value : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
				other_money : form.money_type,
				islem_tarihi : attributes.action_date,
				islem_detay : 'ALACAK DEKONTU',
				acc_type_id : attributes.acc_type_id,
				action_detail : attributes.action_detail,
				from_cmp_id : member_company_id,
				from_consumer_id : member_consumer_id,
				from_employee_id : member_employee_id,
				currency_multiplier : currency_multiplier,
				account_card_type : 13,
				project_id : attributes.project_id,
				from_branch_id : _branch_id_,
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:paper_currency_multiplier,
				period_is_integrated:is_period_entegrated_,
				cari_db : new_dsn_2,
				cari_db_alias : dsn2_alias
				);
		}
		if (len(attributes.expense_center_2) and len(attributes.expense_center_id_2) and len(attributes.expense_item_id_2) and len(attributes.expense_item_name_2))
		{
			if(len(attributes.action_detail))
				action_detail_ = attributes.action_detail;
			else
				action_detail_ = 'ALACAK DEKONTU MASRAFI';
				
			butceci(
				action_id : get_max.action_id,
				muhasebe_db : new_dsn_2,
				is_income_expense : false,
				process_type : process_type,
				nettotal : attributes.system_amount,
				other_money_value : act_other_money_value,
				action_currency : act_other_money,
				currency_multiplier : currency_multiplier,
				expense_date : attributes.action_date,
				expense_center_id : attributes.expense_center_id_2,
				expense_item_id : attributes.expense_item_id_2,
				activity_type : attributes.activity_id,
				detail : action_detail_,
				project_id : attributes.project_id,
				paper_no : attributes.paper_number,
				company_id : member_company_id,
				consumer_id : member_consumer_id,
				employee_id : member_employee_id,
				branch_id : _branch_id_,
				insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
			);
		}
	}
	if ((len(ATTRIBUTES.ACTION_ACCOUNT_CODE)) and (is_account eq 1))
	{
		//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
		GET_NO_ = cfquery(datasource:"#new_dsn_2#", sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
		str_fark_gelir = get_no_.fark_gelir;
		str_fark_gider = get_no_.fark_gider;
		str_max_round = 0.1;	
	
		if (process_type eq 42)
		{
			str_borc_hesap = attributes.ACTION_ACCOUNT_CODE;
			str_alacak_hesap = MY_ACC_RESULT;
			str_borc_tutar = attributes.system_amount;
			str_alacak_tutar = attributes.system_amount;
			fis_detay = "ALACAK DEKONTU";
		}
		else
		{
			str_borc_hesap = MY_ACC_RESULT;
			str_alacak_hesap = attributes.ACTION_ACCOUNT_CODE;
			str_borc_tutar = attributes.system_amount;
			str_alacak_tutar = attributes.system_amount;
			fis_detay = "BORÇ DEKONTU";
		}
		if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
			acc_department_id = attributes.acc_department_id;
		else
			acc_department_id = '';
			
		muhasebeci (
			action_id:get_max.action_id,
			belge_no : attributes.paper_number,
			workcube_process_type:process_type,
			workcube_process_cat:form.process_cat,
			acc_department_id : acc_department_id,
			account_card_type:13,
			islem_tarihi:attributes.ACTION_DATE,
			company_id : member_company_id,
			consumer_id : member_consumer_id,
			fis_detay:fis_detay,
			borc_hesaplar:str_borc_hesap,
			borc_tutarlar:str_borc_tutar,
			other_amount_borc : act_other_money_value,
			other_currency_borc : act_other_money,
			alacak_hesaplar:str_alacak_hesap,
			alacak_tutarlar:str_alacak_tutar,
			other_amount_alacak : act_other_money_value,
			other_currency_alacak : act_other_money,
			fis_satir_detay:attributes.ACTION_DETAIL,
			currency_multiplier : currency_multiplier,
			acc_project_id : attributes.project_id,
			to_branch_id : iif((len(_branch_id_) and process_type eq 41),_branch_id_,de('')),
			from_branch_id : iif((len(_branch_id_) and process_type eq 42),_branch_id_,de('')),
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:fis_detay,
			action_currency : action_currency_,
			action_currency_2 :action_currency2_,
			base_period_year : base_period_year_,
			muhasebe_db : new_dsn_2,
			muhasebe_db_alias : dsn2_alias
		);		
	}
	if(isdefined('session.ep') and not isdefined("from_action_file"))
		f_kur_ekle_action(action_id:get_max.action_id,process_type:0,action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#new_dsn_2#');
</cfscript>

<cfif (isdefined('session.pp') or isdefined('session.ww') or isdefined('from_action_file')) and GET_MONEY_INFO.recordcount>
	<cfoutput query="GET_MONEY_INFO">
		<cfquery name="INSERT_MONEY_INFO" datasource="#new_dsn_2#">
			INSERT INTO #dsn2_alias#.CARI_ACTION_MONEY 
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				 #get_max.action_id#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_MONEY_INFO.MONEY#">,
				 #GET_MONEY_INFO.RATE2#,
				 #GET_MONEY_INFO.RATE1#,
				<cfif GET_MONEY_INFO.MONEY eq process_money_type>1<cfelse>0</cfif>
			)
		</cfquery>
	</cfoutput>
</cfif>

<cfif not isdefined("is_from_premium") and not isdefined("from_action_file")>
	<cfquery name="UPD_GENERAL_PAPERS" datasource="#new_dsn_2#">
		UPDATE 
			#dsn3_alias#.GENERAL_PAPERS
		SET
			DEBIT_CLAIM_NUMBER = #paper_number#
		WHERE
			DEBIT_CLAIM_NUMBER IS NOT NULL
	</cfquery>
</cfif>
<cfif len(get_process_type.action_file_name)>
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		action_id = #get_max.action_id#
		is_action_file = 1
		action_file_name='#get_process_type.action_file_name#'
		action_db_type = '#new_dsn_2#'
		is_template_action_file = '#get_process_type.action_file_from_template#'>
</cfif>	
<cf_add_log log_type="1" action_id="#get_max.action_id#" action_name="#attributes.paper_number# Eklendi" paper_no="#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
