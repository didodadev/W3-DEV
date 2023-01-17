<cfscript>
	if(not isDefined("attributes.temp_dsn"))
		attributes.temp_dsn = dsn2;
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name))
		project_id_ = attributes.project_id;
	else
		project_id_ = '';
	//masraf kayıtlarını siler
	butce_sil(action_id:attributes.credit_contract_payment_id,process_type:form.old_process_type,muhasebe_db:attributes.temp_dsn);
	
	if(attributes.is_capital_budget_act eq 1 and len(attributes.expense_center_id) and attributes.capital_price gt 0 and len(attributes.capital_expense) and len(attributes.capital_expense_id))
	{
		butceci(
			action_id : attributes.credit_contract_payment_id,
			muhasebe_db:attributes.temp_dsn,
			is_income_expense : false,
			process_type : process_type,
			nettotal : wrk_round(attributes.capital_price*other_currency_multiplier),
			other_money_value : attributes.capital_price,
			action_currency : form.money_type,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.payment_date,
			expense_center_id : attributes.expense_center_id,
			expense_item_id : attributes.capital_expense_id,
			detail : 'KREDİ ÖDEMESİ MASRAFI',
			paper_no : attributes.document_no,
			company_id : attributes.company_id,
			branch_id : branch_id,
			insert_type : 1,
			project_id : project_id_
			);
	}

	if(len(attributes.interest_expense_id) and attributes.interest_price gt 0 and len(attributes.interest_expense))
	{
		butceci(
			action_id : attributes.credit_contract_payment_id,
			muhasebe_db:attributes.temp_dsn,
			is_income_expense : false,
			process_type : process_type,
			nettotal : wrk_round(attributes.interest_price*other_currency_multiplier),
			other_money_value : attributes.interest_price,
			action_currency : form.money_type,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.payment_date,
			expense_center_id : attributes.expense_center_id,
			expense_item_id : attributes.interest_expense_id,
			detail : 'KREDİ ÖDEMESİ FAİZ MASRAFI',
			paper_no : attributes.document_no,
			company_id : attributes.company_id,
			branch_id : branch_id,
			insert_type : 1,
			project_id : project_id_
			);
	}
	for(i=1; i lte attributes.record_num; i=i+1)
	{
		if (evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.tax_price_#i#")) and evaluate("attributes.tax_price_#i#") gt 0 and len(evaluate("attributes.tax_expense_id_#i#")) and len(evaluate("attributes.tax_expense_#i#")))
		{
			butceci(
				action_id : attributes.credit_contract_payment_id,
				muhasebe_db:attributes.temp_dsn,
				is_income_expense : false,
				process_type : process_type,
				nettotal : wrk_round(evaluate("attributes.tax_price_#i#")*other_currency_multiplier),
				other_money_value : evaluate("attributes.tax_price_#i#"),
				action_currency : form.money_type,
				currency_multiplier : currency_multiplier,
				expense_date : attributes.payment_date,
				expense_center_id : attributes.expense_center_id,
				expense_item_id : evaluate("attributes.tax_expense_id_#i#"),
				detail : 'KREDİ ÖDEMESİ VERGİ MASRAFI',
				paper_no : attributes.document_no,
				company_id : attributes.company_id,
				branch_id : branch_id,
				insert_type : 1,
				project_id : project_id_
			);
		}
	}
	if(len(attributes.delay_expense_id) and attributes.delay_price gt 0 and len(attributes.delay_expense))
	{
		butceci(
			action_id : attributes.credit_contract_payment_id,
			muhasebe_db:attributes.temp_dsn,
			is_income_expense : false,
			process_type : process_type,
			nettotal : wrk_round(attributes.delay_price*other_currency_multiplier),
			other_money_value : attributes.delay_price,
			action_currency : form.money_type,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.payment_date,
			expense_center_id : attributes.expense_center_id,
			expense_item_id : attributes.delay_expense_id,
			detail : 'KREDİ ÖDEMESİ GECİKME MASRAFI',
			paper_no : attributes.document_no,
			company_id : attributes.company_id,
			branch_id : branch_id,
			insert_type : 1,
			project_id : project_id_
			);
	}
</cfscript>

