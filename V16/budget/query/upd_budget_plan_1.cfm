<!--- cari muhasebe işlemleri --->
<cfscript>
	if(process_type eq 161)
	{
		act_name = UCase(getLang('main',1853));//TAHAKKUK FİŞİ
		act_name2 = UCase(getLang('main',1853));
	}
	else
	{
		act_name = UCase(getLang('main',2708)); //BÜTÇE GİDER PLANI
		act_name2 = UCase(getLang('main',2150)); //BÜTÇE PLANLAMA FİŞİ
	}
	if(isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id))
		branch_id_info = attributes.acc_branch_id;
	else
		branch_id_info = ListGetAt(session.ep.user_location,2,"-");
	cari_sil(action_id:attributes.budget_plan_id,action_table:'BUDGET_PLAN', process_type:form.old_process_type);
	if(is_cari eq 1)
	{
		for(ind=1;ind lte get_last_rows.recordcount;ind=ind+1)
		{
			if(len(get_last_rows.related_emp_id[ind]))
			{
				if (get_last_rows.related_emp_type[ind] is 'partner')
				{
					from_company_id = get_last_rows.related_emp_id[ind];
					from_consumer_id = '';
					from_employee_id = '';
				}	
				else if (get_last_rows.related_emp_type[ind] is 'consumer')
				{
					from_consumer_id = get_last_rows.related_emp_id[ind];
					from_company_id = '';
					from_employee_id = '';
				}
				else if (get_last_rows.related_emp_type[ind] is 'employee')
				{
					from_employee_id = get_last_rows.related_emp_id[ind];	
					from_company_id = '';
					from_consumer_id = '';
				}
				
				if(get_last_rows.action_value_exp[ind] gt 0)
				{
					if(len(get_last_rows.detail[ind]))
						detail_info =  "#get_last_rows.detail[ind]#";
					else
						detail_info =  UCase(getLang('main',2708)); //BÜTÇE GİDER PLANI
					carici(
						action_id : attributes.budget_plan_id,
						action_table : 'BUDGET_PLAN',
						workcube_process_type : process_type,
						account_card_type : 13,
						acc_type_id : get_last_rows.acc_type_id[ind],
						due_date : createodbcdatetime(get_last_rows.plan_date[ind]),
						islem_tarihi : attributes.record_date,
						islem_tutari : get_last_rows.action_value_exp[ind],
						to_cmp_id : from_company_id,
						to_consumer_id : from_consumer_id,
						to_employee_id : from_employee_id,
						to_branch_id : branch_id_info,
						islem_detay : act_name,
						islem_belge_no : attributes.paper_number,
						action_detail : detail_info,
						other_money_value : get_last_rows.other_money_value_exp[ind],
						other_money : rd_money_value,
						action_currency : session.ep.money,
						process_cat : form.process_cat,
						project_id: get_last_rows.project_id[ind],
						currency_multiplier : currency_multiplier2,
						rate2:currency_multiplier2
					);
				}
				else if(get_last_rows.action_value_inc[ind] gt 0)
				{
					if(len(get_last_rows.detail[ind]))
						detail_info =  "#get_last_rows.detail[ind]#";
					else
						detail_info =  UCase(getLang('main',2709)); //BÜTÇE GELİR PLANI
					carici(
						action_id : attributes.budget_plan_id,
						action_table : 'BUDGET_PLAN',
						workcube_process_type : process_type,
						account_card_type : 13,
						acc_type_id : get_last_rows.acc_type_id[ind],
						due_date : createodbcdatetime(get_last_rows.plan_date[ind]),
						islem_tarihi : attributes.record_date,
						islem_tutari : get_last_rows.action_value_inc[ind],
						from_cmp_id : from_company_id,
						from_consumer_id : from_consumer_id,
						from_employee_id : from_employee_id,
						from_branch_id : branch_id_info,
						islem_detay : act_name,
						islem_belge_no : attributes.paper_number,
						action_detail : detail_info,
						other_money_value : get_last_rows.other_money_value_inc[ind],
						other_money : rd_money_value,
						action_currency : session.ep.money,
						process_cat : form.process_cat,
						project_id: get_last_rows.project_id[ind],
						currency_multiplier : currency_multiplier2,
						rate2:currency_multiplier2
					);
				}
			}
		}
	}
		
	str_alacak_tutar_list="";
	str_alacak_kod_list="";
	str_borc_tutar_list="";
	str_borc_kod_list="";
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
	str_other_alacak_tutar_list = "";
	str_other_borc_tutar_list = "";
	str_other_borc_currency_list = "";
	str_other_alacak_currency_list = "";
	acc_project_list_borc = '';
	acc_project_list_alacak = '';
	if(is_account eq 1)
	{
		if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
			acc_department_id = attributes.acc_department_id;
		else
			acc_department_id = '';
		kontrol_acc = 0;
		for(j=1;j lte attributes.record_num;j=j+1)
		{
			if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") and len(evaluate("attributes.account_id#j#")) and len(evaluate("attributes.account_code#j#")))
			{
				kontrol_acc = 1;
				str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,evaluate("attributes.income_total#j#"),",");
				str_alacak_kod_list = ListAppend(str_alacak_kod_list,evaluate("attributes.account_id#j#"),",");
				str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, evaluate("attributes.other_income_total#j#"),",");
				str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,rd_money_value,",");
				satir_detay_list[1][listlen(str_alacak_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
				str_borc_tutar_list = ListAppend(str_borc_tutar_list,evaluate("attributes.expense_total#j#"),",");
				str_borc_kod_list = ListAppend(str_borc_kod_list,evaluate("attributes.account_id#j#"),",");
				str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, evaluate("attributes.other_expense_total#j#"),",");
				str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,rd_money_value,",");
				if (is_account_group eq 0)
					satir_detay_list[2][listlen(str_borc_tutar_list)]='#evaluate("attributes.row_detail#j#")#';
				else
					satir_detay_list[2][listlen(str_borc_tutar_list)]='#evaluate("attributes.authorized#j#")#';
				
				if(isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project_head#j#")))
				{
					acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#j#"),',');
					acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#j#"),',');
				}
				else
				{
					acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
					acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
				}
			}
		}
		
		muhasebeci (
			wrk_id:wrk_id,
			action_id:attributes.budget_plan_id,
			action_table :'BUDGET_PLAN',
			workcube_process_type : process_type,
			workcube_old_process_type : form.old_process_type,
			workcube_process_cat:form.process_cat,
			acc_department_id:acc_department_id,
			account_card_type : 13,
			islem_tarihi : attributes.record_date,
			borc_hesaplar : str_borc_kod_list,
			borc_tutarlar : str_borc_tutar_list,
			alacak_hesaplar : str_alacak_kod_list,
			alacak_tutarlar : str_alacak_tutar_list,
			fis_satir_detay: satir_detay_list,
			fis_detay : act_name2,
			belge_no : attributes.paper_number,
			from_branch_id : branch_id_info,
			to_branch_id : branch_id_info,
			other_amount_borc : str_other_borc_tutar_list,
			other_currency_borc : str_other_borc_currency_list,
			other_amount_alacak : str_other_alacak_tutar_list,
			other_currency_alacak : str_other_alacak_currency_list,
			is_account_group : is_account_group,
			currency_multiplier : currency_multiplier2,
			acc_project_list_alacak : acc_project_list_alacak,
			acc_project_list_borc : acc_project_list_borc,
			due_date: attributes.due_date,
			document_type: attributes.document_type,
			payment_method: attributes.payment_type
		);
		if(kontrol_acc == 0)
			muhasebe_sil(action_id:attributes.budget_plan_id,action_table:'BUDGET_PLAN', process_type:form.old_process_type);
	}
	else
		muhasebe_sil(action_id:attributes.budget_plan_id,action_table:'BUDGET_PLAN', process_type:form.old_process_type);
	//Bütçe
	butce_sil (action_id:attributes.budget_plan_id,muhasebe_db:dsn2,process_type:form.old_process_type);
	if(is_budget eq 1)
	{
		for(ind=1;ind lte get_last_rows.recordcount;ind=ind+1)
		{
			/* if(isdefined("attributes.project_id#ind#") and len(evaluate("attributes.project_id#ind#")))
				project_id_info = evaluate("attributes.project_id#ind#");
			else
				project_id_info = ''; */
				
			if(len(get_last_rows.project_id[ind]))
				project_id_info = get_last_rows.project_id[ind];
			else
				project_id_info = '';
			
			if(len(get_last_rows.related_emp_id[ind]))
			{
				if (get_last_rows.related_emp_type[ind] is 'partner')
				{
					from_company_id_ = get_last_rows.related_emp_id[ind];
					from_consumer_id_ = '';
					from_employee_id_ = '';
				}	
				else if (get_last_rows.related_emp_type[ind] is 'consumer')
				{
					from_consumer_id_ = get_last_rows.related_emp_id[ind];
					from_company_id_ = '';
					from_employee_id_ = '';
				}
				else if (get_last_rows.related_emp_type[ind] is 'employee')
				{
					from_employee_id_ = get_last_rows.related_emp_id[ind];	
					from_company_id_ = '';
					from_consumer_id_ = '';
				}
			}	
			else
			{
				from_employee_id_ = '';	
				from_company_id_ = '';
				from_consumer_id_ = '';
			}
						
			if(get_last_rows.action_value_exp[ind] gt 0 and len(get_last_rows.budget_item_id[ind]))
			{
				if(len(get_last_rows.detail[ind]))
					detail_info =  "#get_last_rows.detail[ind]#";
				else
					detail_info =  UCase(getLang('main',2708)); //BÜTÇE GİDER PLANI
				butceci(
					action_id : attributes.budget_plan_id,
					muhasebe_db : dsn2,
					is_income_expense : false,
					process_type : process_type,
					nettotal : get_last_rows.action_value_exp[ind],
					other_money_value : get_last_rows.other_money_value_exp[ind],
					action_currency : rd_money_value,
					currency_multiplier : currency_multiplier2,
					expense_date : createodbcdatetime(get_last_rows.plan_date[ind]),
					expense_center_id : get_last_rows.exp_inc_center_id[ind],
					expense_item_id : get_last_rows.budget_item_id[ind],
					expense_account_code : get_last_rows.budget_account_code[ind],
					detail : detail_info,
					branch_id : branch_id_info,
					project_id : project_id_info,
					paper_no : attributes.paper_number,
					activity_type : get_last_rows.activity_type_id[ind],
					insert_type : 1,//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
					company_id : from_company_id_,
					consumer_id : from_consumer_id_,
					employee_id : from_employee_id_
				);
			}
			if(get_last_rows.action_value_inc[ind] gt 0 and len(get_last_rows.budget_item_id[ind]))
			{
				if(len(get_last_rows.detail[ind]))
					detail_info =  "#get_last_rows.detail[ind]#";
				else
					detail_info =  UCase(getLang('main',2709)); //BÜTÇE GELİR PLANI
				butceci(
					action_id : attributes.budget_plan_id,
					muhasebe_db : dsn2,
					is_income_expense : true,
					process_type : process_type,
					nettotal : get_last_rows.action_value_inc[ind],
					other_money_value : get_last_rows.other_money_value_inc[ind],
					action_currency : rd_money_value,
					currency_multiplier : currency_multiplier2,
					expense_date : createodbcdatetime(get_last_rows.plan_date[ind]),
					expense_center_id : get_last_rows.exp_inc_center_id[ind],
					expense_item_id : get_last_rows.budget_item_id[ind],
					expense_account_code : get_last_rows.budget_account_code[ind],
					detail : detail_info,
					branch_id : branch_id_info,
					project_id : project_id_info,
					paper_no : attributes.paper_number,
					activity_type : get_last_rows.activity_type_id[ind],
					insert_type : 1,//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
					company_id : from_company_id_,
					consumer_id : from_consumer_id_,
					employee_id : from_employee_id_
				);
			}
		}
	}
</cfscript>

