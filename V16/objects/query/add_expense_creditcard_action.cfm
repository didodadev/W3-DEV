<cfif isdefined("attributes.expense_id") and isdefined("is_upd_action")>
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
	<cfquery name="GET_CREDIT_ACTIONS" datasource="#dsn2#">
		SELECT CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
<cfelse>
	<cfset get_credit_actions.recordcount = 0>
</cfif>
<cfscript>
	if(attributes.ch_member_type eq "partner")
	{
		attributes.action_to_company_id = attributes.ch_company_id;
		action_to_company_id = attributes.ch_company_id;
		attributes.par_id = attributes.ch_partner_id;
		cons_id = '';
		attributes.cons_id = '';
	}
	else if(attributes.ch_member_type eq "consumer")
	{
		attributes.action_to_company_id = '';
		action_to_company_id = '';
		attributes.cons_id = attributes.ch_partner_id;
		cons_id = attributes.ch_partner_id;
		attributes.par_id = '';
	}
	else
	{
		attributes.action_to_company_id = '';
		action_to_company_id = '';
		attributes.cons_id = '';
		cons_id = '';
		attributes.par_id = '';
	}
	if((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (len(attributes.emp_id) and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and len(attributes.ch_partner) and attributes.ch_member_type eq 'consumer'))//cari seçilmiş ise
		is_cari_acc = 1;
	else
		is_cari_acc = 0;
	my_acc_result = string_acc_code;
	account_id_first = listgetat(attributes.credit_card_info,1,';');
	action_curreny = listgetat(attributes.credit_card_info,2,';');
	account_id_last = listgetat(attributes.credit_card_info,3,';');
	cc_rate=1;
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
	{
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is action_curreny)
				cc_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	}
	attributes.system_amount = attributes.net_total_amount;
	attributes.action_value = wrk_round(attributes.net_total_amount/cc_rate);
	attributes.other_money_value = attributes.other_net_total_amount;
	attributes.money_type = rd_money_value;
	attributes.action_date = attributes.expense_date;
	attributes.action_detail = attributes.detail;
	attributes.paper_number = attributes.belge_no;
	process_type_credit = 242;
	old_process_type_credit = 242;
	if(get_credit_actions.recordcount gt 0)
	{
		expense_id = attributes.expense_id;
		attributes.creditcard_expense_id = get_credit_actions.creditcard_expense_id;
	}
	else
	{
		if (isdefined("attributes.expense_id") and isdefined("is_upd_action"))
			expense_id = attributes.expense_id;
		else
			expense_id = get_maxid.max_id;
		attributes.creditcard_expense_id = '';
	}
	if(not isdefined("attributes.project_id"))
	{
		attributes.project_id='';
		attributes.project_head='';
	}
	if(isdefined("attributes.project_id"))
		attributes.project_name = attributes.project_head;
	if(not isdefined("attributes.subscription_id"))
	{
		attributes.subscription_id='';
		attributes.subscription_no='';
	}	
	if( isdefined("attributes.subscription_name"))
	{
		attributes.subscription_no=attributes.subscription_name;
	}	
	is_from_expense = 1;
</cfscript>
<cfquery name="GET_CREDIT_CARD" datasource="#dsn2#"><!--- Seçilen kredi kartının ek bilgileri --->
	SELECT 
		ISNULL(CLOSE_ACC_DAY,1) CLOSE_ACC_DAY,
		ACCOUNT_CODE
	FROM 
		#dsn3_alias#.CREDIT_CARD 
	WHERE 
		CREDITCARD_ID = #account_id_last#
</cfquery>
<cfif not len(attributes.creditcard_expense_id)>
	<cfinclude template="../../bank/query/add_creditcard_bank_expense_ic.cfm">
<cfelse>
	<cfinclude template="../../bank/query/upd_creditcard_bank_expense_ic.cfm">
</cfif>
<cfquery name="get_cari_kontrol_credit" datasource="#dsn2#">
	SELECT DISTINCT PROJECT_ID FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CREDITCARD_EXPENSE_ID#"> AND ACTION_TYPE_ID = #process_type_credit#
</cfquery>
<cfscript>
	if(is_cari eq 1)//kredi kartı carici
	{
		if(is_row_project_based_cari eq 1 or (is_row_project_based_cari eq 0 and get_cari_kontrol_credit.recordcount neq 1))
			cari_sil(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:process_type_credit);
		if(is_row_project_based_cari eq 1)
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
				if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") and isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project#j#")))
				{
					//row_number = row_number + 1;
					if(not listfind(row_project_list,evaluate("attributes.project_id#j#")))
					{
						row_project_list = listappend(row_project_list,evaluate("attributes.project_id#j#"));
						row_number = listfind(row_project_list,evaluate("attributes.project_id#j#"));
						'row_amount_total_#row_number#' = row_total_;
						'row_other_amount_total_#row_number#' = row_total_/paper_currency_multiplier;
					}
					else
					{
						row_number = listfind(row_project_list,evaluate("attributes.project_id#j#"));
						'row_amount_total_#row_number#' = evaluate("row_amount_total_#row_number#")+row_total_;
						'row_other_amount_total_#row_number#' = evaluate("row_other_amount_total_#row_number#")+(row_total_/paper_currency_multiplier);
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
					action_id : attributes.CREDITCARD_EXPENSE_ID,
					action_table : 'CREDIT_CARD_BANK_EXPENSE',
					workcube_process_type : process_type_credit,
					process_cat : attributes.process_cat,	
					islem_tarihi : attributes.action_date,
					from_account_id : account_id_first,
					from_branch_id : branch_id_info,
					islem_tutari : evaluate('row_amount_total_#ind_t#'),
					action_currency : session.ep.money,
					other_money_value : evaluate('row_other_amount_total_#ind_t#'),
					other_money : attributes.money_type,
					currency_multiplier : currency_multiplier,
					islem_detay : UCase("#getLang('main',1756)#"),
					action_detail : attributes.action_detail,
					account_card_type : 13,
					to_cmp_id : action_to_company_id,
					to_consumer_id : attributes.cons_id,
					project_id : cari_row_project,
					islem_belge_no : attributes.paper_number,
					due_date : attributes.action_date,
					special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
			if(total_cash_price gt 0)
			{
				carici(
					action_id : attributes.CREDITCARD_EXPENSE_ID,
					action_table : 'CREDIT_CARD_BANK_EXPENSE',
					workcube_process_type : process_type_credit,
					process_cat : attributes.process_cat,	
					islem_tarihi : attributes.action_date,
					from_account_id : account_id_first,
					from_branch_id : branch_id_info,
					islem_tutari : total_cash_price,
					action_currency : session.ep.money,
					other_money_value : total_other_cash_price,
					other_money : attributes.money_type,
					currency_multiplier : currency_multiplier,
					islem_detay : UCase("#getLang('main',1756)#"),
					action_detail : attributes.action_detail,
					account_card_type : 13,
					to_cmp_id : action_to_company_id,
					to_consumer_id : attributes.cons_id,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de('')),
					islem_belge_no : attributes.paper_number,
					due_date : attributes.action_date,
					special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
		}
	}
	else if(isdefined("attributes.expense_id"))
		cari_sil(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:old_process_type_credit);
</cfscript>

