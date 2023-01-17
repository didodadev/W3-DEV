<cfquery name="ADD_BANK_ORDER" datasource="#DSN2#">
	UPDATE 
		BANK_ORDERS
	SET
		BANK_ORDER_TYPE_ID=<cfif isdefined("form.process_cat") and len(form.process_cat)>#form.process_cat#<cfelse>NULL</cfif>,
		ACTION_VALUE = #attributes.ORDER_AMOUNT#,
		ACTION_MONEY = '#attributes.currency_id#',
        FROM_BRANCH_ID = <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
        ACTION_BANK_ACCOUNT=<cfif isdefined("attributes.list_bank") and len(attributes.list_bank)>#attributes.list_bank#<cfelse>NULL</cfif>,
		ACCOUNT_ID = #attributes.account_id#,
		COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
		CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
        EMPLOYEE_ID = <cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
        ACC_TYPE_ID = <cfif len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
		TO_ACCOUNT_ID = <cfif get_bank.recordcount>#get_bank.BANK_ID#<cfelse>NULL</cfif>,
		PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
		OTHER_MONEY_VALUE= <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
		OTHER_MONEY = <cfif len(money_type)>'#money_type#'<cfelse>NULL</cfif>,
		ACTION_DATE = #attributes.ACTION_DATE#,
		PAYMENT_DATE = #attributes.PAYMENT_DATE#,
		RELATED_ACTION_ID = <cfif isDefined("attributes.related_action_id") and len(attributes.related_action_id)>#attributes.related_action_id#,<cfelse>NULL,</cfif>
		RELATED_ACTION_TYPE_ID = <cfif isDefined("attributes.related_action_type_id") and len(attributes.related_action_type_id)>#attributes.related_action_type_id#,<cfelse>NULL,</cfif>
		ACTION_DETAIL = <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)>'#attributes.ACTION_DETAIL#'<cfelse>NULL</cfif>,
		ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		CREDIT_LIMIT_ID = <cfif isdefined("attributes.credit_limit") and len(attributes.credit_limit)>#attributes.credit_limit#,<cfelse>NULL,</cfif>
        SPECIAL_DEFINITION_ID=<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>
	WHERE
		BANK_ORDER_ID = #form.BANK_ORDER_ID# AND
		BANK_ORDER_TYPE = 260 <!--- gelen banka talimatıyla karışmaması icin --->
</cfquery>
<cfscript>
	if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
	{
		attributes.project_id = "";
		attributes.project_name = "";
	}
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				
	if(is_account eq 1)
	{
		if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
			str_card_detail = '#attributes.ACTION_DETAIL#';
		else
			str_card_detail = 'Giden Banka Talimatı';
		muhasebeci (
			action_id : form.bank_order_id,
			workcube_process_type : process_type,
			workcube_old_process_type : form.old_process_type,
			workcube_process_cat:form.process_cat,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			account_card_type : 13,
			islem_tarihi : attributes.ACTION_DATE,
			fis_satir_detay : str_card_detail,
			borc_hesaplar : borclu_hesap,
			borc_tutarlar : attributes.system_amount,
			other_amount_borc : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
			other_currency_borc : form.money_type,
			alacak_hesaplar : GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE,
			alacak_tutarlar : attributes.system_amount,
			other_amount_alacak : attributes.ORDER_AMOUNT,
			other_currency_alacak : attributes.currency_id,
			currency_multiplier : currency_multiplier,
			from_branch_id : branch_id_info,
			acc_project_id : iif((len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
			fis_detay : 'GİDEN BANKA TALİMATI'
		);	
	}
	else
		muhasebe_sil (action_id:form.bank_order_id,process_type:form.old_process_type);

	if(is_cari eq 1)
	{
		is_processed = attributes.is_havale;
		if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
			act_detail = '#attributes.ACTION_DETAIL#';
		else
			act_detail = '';
		carici
			(
			action_id : form.bank_order_id,
			workcube_process_type : process_type,	
			workcube_old_process_type : form.old_process_type,	
			action_table : 'BANK_ORDERS',			
			process_cat : form.process_cat,
			islem_tarihi : attributes.ACTION_DATE,				
			from_account_id : attributes.account_id,			
			from_branch_id : branch_id_info,
			islem_tutari : attributes.system_amount,
			action_currency : session.ep.money,				
			other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
			other_money : form.money_type,
			islem_detay : 'Ödeme Emri(Giden Banka Talimatı)',					
			currency_multiplier : currency_multiplier,
			action_detail : act_detail,
			account_card_type : 13,
			due_date: attributes.PAYMENT_DATE,		
			to_cmp_id : attributes.company_id,	
			to_consumer_id : attributes.consumer_id,
			to_employee_id : attributes.employee_id,
			acc_type_id : attributes.acc_type_id,
			project_id : iif((len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
			is_processed : is_processed,
			assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
			rate2:paper_currency_multiplier
			);
	}
	else
		cari_sil(action_id:form.bank_order_id,process_type:form.old_process_type);

	f_kur_ekle_action(action_id:form.bank_order_id,process_type:1,action_table_name:'BANK_ORDER_MONEY',action_table_dsn:'#dsn2#');
</cfscript>
<cf_workcube_process_cat 
process_cat="#form.process_cat#"
action_id = #form.bank_order_id#
is_action_file = 1
action_file_name='#get_process_type.action_file_name#'
action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_assign_order&event=upd_assign&bank_order_id=#form.bank_order_id#'
action_db_type = '#dsn2#'
is_template_action_file = '#get_process_type.action_file_from_template#'>
