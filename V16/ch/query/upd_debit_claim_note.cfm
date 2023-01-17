<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>

<cfscript>
	process_type = get_process_type.process_type;
	is_cari =get_process_type.is_cari;
	is_account = get_process_type.is_account;
	ACTION_CURRENCY_ID = listlast(attributes.ACTION_CURRENCY_ID,';');
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>

<cf_date tarih="attributes.action_date">
<cfif is_account eq 1>
	<cfif len(form.COMPANY_ID)><!--- firmanın muhasebe kodu --->
		<cfset MY_ACC_RESULT=GET_COMPANY_PERIOD(form.COMPANY_ID)>
	<cfelseif len(attributes.employee_id)><!--- çalışanın muhasebe kodu--->
		<cfset MY_ACC_RESULT = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
	<cfelseif len(form.CONSUMER_ID)><!---	bireysel uyenin muhasebe kodu--->
		<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(form.CONSUMER_ID)>
	</cfif>
	<cfif not len(MY_ACC_RESULT)>
		<script type="text/javascript">
			alert("<cf_get_lang no='74.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfscript>
	attributes.action_value = filterNum(attributes.action_value);
	attributes.other_cash_act_value = filterNum(attributes.other_cash_act_value);
	attributes.system_amount = filterNum(attributes.system_amount);
	for(u_sy=1; u_sy lte attributes.kur_say; u_sy=u_sy+1)
	{
		'attributes.txt_rate1_#u_sy#' = filterNum(evaluate('attributes.txt_rate1_#u_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#u_sy#' = filterNum(evaluate('attributes.txt_rate2_#u_sy#'),session.ep.our_company_info.rate_round_num);
	}
</cfscript>

<cflock name="#CreateUUID()#" timeout="20">	
	<cftransaction>	
		<cfquery name="ADD_CASH_PAYMENT_IN_OP" datasource="#DSN2#">
			UPDATE
				CARI_ACTIONS
			SET
				ACTION_VALUE = #attributes.action_value#,
				ACTION_CURRENCY_ID = '#ACTION_CURRENCY_ID#',
				OTHER_MONEY = <cfif len(attributes.money_type)>'#attributes.money_type#'<cfelse>NULL</cfif>,
				PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				OTHER_CASH_ACT_VALUE = <cfif len(attributes.other_cash_act_value)>#attributes.other_cash_act_value#<cfelse>NULL</cfif>,
				TO_CMP_ID = <cfif (process_type eq 41) and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				FROM_CMP_ID = <cfif (process_type eq 42) and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				TO_CONSUMER_ID = <cfif (process_type eq 41) and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				FROM_CONSUMER_ID = <cfif (process_type eq 42) and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				TO_EMPLOYEE_ID = <cfif (process_type eq 41) and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				FROM_EMPLOYEE_ID = <cfif (process_type eq 42) and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				ACTION_DATE = #attributes.action_date#,
				ACTION_ACCOUNT_CODE = <cfif len(attributes.action_account_code)>'#attributes.action_account_code#'<cfelse>NULL</cfif>,
				ACTION_DETAIL = '#attributes.action_detail#',
				PROCESS_CAT = #form.process_cat#,
				SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				ACTION_TYPE_ID = #process_type#,
				PAPER_NO = <cfif len(attributes.paper_number)>'#attributes.paper_number#'<cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				ACC_DEPARTMENT_ID = <cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
                ACC_BRANCH_ID=<cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelse>NULL</cfif>,
				CONTRACT_ID = <cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>,
                ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
				ACTIVITY_ID = <cfif isdefined("attributes.activity_id") and len(attributes.activity_id)>#attributes.activity_id#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'												
			WHERE 
				ACTION_ID = #attributes.action_id# AND
				ACTION_TYPE_ID = #form.old_process_type#
		</cfquery>
		<cfscript>
		currency_multiplier = '';
		paper_currency_multiplier = '';
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
					currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
					paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			}
				
		//masraf kaydını siler
		butce_sil(action_id:attributes.ACTION_ID,process_type:form.old_process_type);
		act_other_money_value = iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de(''));
		act_other_money = form.money_type;
		_branch_id='';
		if (isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id))
			_branch_id = attributes.acc_branch_id;
		else
			_branch_id = listgetat(session.ep.user_location,2,'-');
		if (process_type eq 41)
		{
			if (is_cari eq 1)
			{
				carici(
					action_id : attributes.ACTION_ID,
					islem_belge_no : attributes.paper_number,
					process_cat : form.process_cat,
					workcube_process_type :process_type,
					workcube_old_process_type : form.old_process_type,
					action_table : 'CARI_ACTIONS',
					islem_tutari : attributes.system_amount,
					action_currency : session.ep.money,
					other_money_value : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
					other_money : form.money_type,
					islem_tarihi : attributes.action_date,
					islem_detay : 'BORÇ DEKONTU',
					acc_type_id : attributes.acc_type_id,
					action_detail : attributes.action_detail,
					to_cmp_id : attributes.company_id,
					to_consumer_id : attributes.consumer_id,
					to_employee_id : attributes.employee_id,	
					subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
					currency_multiplier : currency_multiplier,
					account_card_type : 13,
					project_id : attributes.project_id,
					to_branch_id : _branch_id,
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
				);
			}
			else
				cari_sil(action_id:attributes.ACTION_ID,process_type:form.old_process_type);

			if (len(attributes.expense_center_1) and len(attributes.EXPENSE_CENTER_ID_1) and len(attributes.EXPENSE_ITEM_ID_1) and len(attributes.expense_item_name_1))
			{
				if(len(attributes.action_detail))
					action_detail_ = attributes.action_detail;
				else
					action_detail_ = 'BORÇ DEKONTU MASRAFI';
					
				butceci(
					action_id : attributes.ACTION_ID,
					muhasebe_db : dsn2,
					is_income_expense : true,
					process_type : process_type,
					nettotal : attributes.system_amount,
					other_money_value : act_other_money_value,
					action_currency : act_other_money,
					currency_multiplier : currency_multiplier,
					expense_date : attributes.action_date,
					expense_center_id : attributes.EXPENSE_CENTER_ID_1,
					expense_item_id : attributes.EXPENSE_ITEM_ID_1,
					activity_type : attributes.activity_id,
					detail : action_detail_,
					project_id : attributes.project_id,
					paper_no : attributes.paper_number,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					employee_id : attributes.employee_id,
					branch_id : _branch_id,
					insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
				);
			}
		}
		else if (process_type eq 42)
		{
			if (is_cari eq 1)
			{
				carici(
					action_id : attributes.ACTION_ID,
					islem_belge_no : attributes.paper_number,
					process_cat : form.process_cat,
					workcube_process_type :process_type,
					workcube_old_process_type : form.old_process_type,
					action_table : 'CARI_ACTIONS',
					islem_tutari : attributes.system_amount,		
					action_currency : session.ep.money,
					other_money_value : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
					other_money : form.money_type,
					islem_tarihi : attributes.action_date,
					islem_detay : 'ALACAK DEKONTU',
					acc_type_id : attributes.acc_type_id,
					action_detail : attributes.action_detail,
					from_cmp_id : attributes.company_id,
					from_consumer_id : attributes.consumer_id,
					from_employee_id : attributes.employee_id,
					subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
					currency_multiplier : currency_multiplier,
					account_card_type : 13,
					project_id : attributes.project_id,
					from_branch_id : _branch_id,
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
				);
			}
			else
				cari_sil(action_id:attributes.ACTION_ID,process_type:form.old_process_type);
			
			if (len(attributes.expense_center_2) and len(attributes.EXPENSE_CENTER_ID_2) and len(attributes.EXPENSE_ITEM_ID_2) and len(attributes.expense_item_name_2))
			{
				if(len(attributes.action_detail))
					action_detail_ = attributes.action_detail;
				else
					action_detail_ = 'ALACAK DEKONTU MASRAFI';
			
				butceci(
					action_id : attributes.ACTION_ID,
					muhasebe_db : dsn2,
					is_income_expense : false,
					process_type : process_type,
					nettotal : attributes.system_amount,
					other_money_value : act_other_money_value,
					action_currency : act_other_money,
					currency_multiplier : currency_multiplier,
					expense_date : attributes.action_date,
					expense_center_id : attributes.EXPENSE_CENTER_ID_2,
					expense_item_id : attributes.EXPENSE_ITEM_ID_2,
					activity_type : attributes.activity_id,
					detail : action_detail_,
					project_id : attributes.project_id,
					paper_no : attributes.paper_number,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					employee_id : attributes.employee_id,
					branch_id : _branch_id,
					insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
				);
			}
		}

		
		if (len(ATTRIBUTES.ACTION_ACCOUNT_CODE) and (is_account eq 1))
		{
			if (process_type eq 42)
			{
				str_borc_hesap=attributes.ACTION_ACCOUNT_CODE;
				str_alacak_hesap=MY_ACC_RESULT;
				str_borc_tutar=attributes.system_amount;
				str_alacak_tutar=attributes.system_amount;
				fis_detay = "ALACAK DEKONTU";
			}
			else
			{
				str_borc_hesap = MY_ACC_RESULT;
				str_alacak_hesap = attributes.ACTION_ACCOUNT_CODE;
				str_borc_tutar=attributes.system_amount;
				str_alacak_tutar=attributes.system_amount;
				fis_detay = "BORÇ DEKONTU";
			}
			if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
				acc_department_id = attributes.acc_department_id;
			else
				acc_department_id = '';
				muhasebeci (
					action_id:attributes.ACTION_ID,
					belge_no : attributes.paper_number,
					workcube_process_type:process_type,
					workcube_old_process_type:form.old_process_type,
					acc_department_id : acc_department_id,
					workcube_process_cat:form.process_cat,
					account_card_type:13,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					islem_tarihi:attributes.ACTION_DATE,
					fis_detay:fis_detay,
					borc_hesaplar:str_borc_hesap,
					borc_tutarlar:str_borc_tutar,
					other_amount_borc : act_other_money_value,
					other_currency_borc : act_other_money,
					alacak_hesaplar:str_alacak_hesap,
					alacak_tutarlar:str_alacak_tutar,
					other_amount_alacak : act_other_money_value,
					other_currency_alacak : act_other_money,
					currency_multiplier : currency_multiplier,
					fis_satir_detay:attributes.ACTION_DETAIL,
					acc_project_id : attributes.project_id,
					to_branch_id : iif((process_type eq 41),_branch_id,de('')),
					from_branch_id : iif((process_type eq 42),_branch_id,de(''))
				);		
		}
		else
		{
			muhasebe_sil(action_id:attributes.ACTION_ID,process_type:form.old_process_type);
		}			
			f_kur_ekle_action(action_id:attributes.ACTION_ID,process_type:1,action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#');
	</cfscript>
	<cfif len(get_process_type.action_file_name)>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #attributes.ACTION_ID#
			is_action_file = 1
			action_file_name='#get_process_type.action_file_name#'
			action_db_type = '#dsn2#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cfif>	
	</cftransaction>
    <cf_add_log log_type="0" action_id="#attributes.ACTION_ID#" action_name="#attributes.paper_number# Güncellendi" paper_no="#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=ch.form_add_debit_claim_note&event=upd&id=#attributes.action_id#</cfoutput>';
	</cfif>
</script>
