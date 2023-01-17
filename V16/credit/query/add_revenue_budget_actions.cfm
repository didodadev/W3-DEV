<cfscript>
	if(attributes.is_capital_budget_act eq 1 and len(attributes.capital_expense_id) and len(attributes.capital_expense))
	{
		butceci(
			action_id : GET_PAYMENT_ID.MAX_ID,
			muhasebe_db : dsn2,
			is_income_expense : true,
			process_type : process_type,
			nettotal : wrk_round(attributes.capital_price*other_currency_multiplier),
			other_money_value : attributes.capital_price,
			action_currency : form.money_type,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.revenue_date,
			expense_center_id : attributes.expense_center_id,
			expense_item_id : attributes.capital_expense_id,
			detail : 'KREDİ TAHSİLATI GELİRİ',
			paper_no : attributes.document_no,
			company_id : attributes.company_id,
			branch_id : branch_id,
			insert_type : 1
			);
	}

	if(len(attributes.interest_expense_id) and attributes.interest_price gt 0 and len(attributes.interest_expense))
	{
		butceci(
			action_id : GET_PAYMENT_ID.MAX_ID,
			muhasebe_db : dsn2,
			is_income_expense : true,
			process_type : process_type,
			nettotal : wrk_round(attributes.interest_price*other_currency_multiplier),
			other_money_value : attributes.interest_price,
			action_currency : form.money_type,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.revenue_date,
			expense_center_id : attributes.expense_center_id,
			expense_item_id : attributes.interest_expense_id,
			detail : 'KREDİ TAHSİLATI FAİZ GELİRİ',
			paper_no : attributes.document_no,
			company_id : attributes.company_id,
			branch_id : branch_id,
			insert_type : 1
			);
	}
	for(i=1; i lte attributes.record_num; i=i+1)
	{
		if (evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.tax_price_#i#")) and evaluate("attributes.tax_price_#i#") gt 0 and len(evaluate("attributes.tax_expense_#i#")) and len(evaluate("attributes.tax_expense_id_#i#")))
		{
			butceci(
				action_id : GET_PAYMENT_ID.MAX_ID,
				muhasebe_db : dsn2,
				is_income_expense : true,
				process_type : process_type,
				nettotal : wrk_round(evaluate("attributes.tax_price_#i#")*other_currency_multiplier),
				other_money_value : evaluate("attributes.tax_price_#i#"),
				action_currency : form.money_type,
				currency_multiplier : currency_multiplier,
				expense_date : attributes.revenue_date,
				expense_center_id : attributes.expense_center_id,
				expense_item_id : evaluate("attributes.tax_expense_id_#i#"),
				detail : 'KREDİ ÖDEMESİ VERGİ MASRAFI',
				paper_no : attributes.document_no,
				company_id : attributes.company_id,
				branch_id : branch_id,
				insert_type : 1
			);
		}
	}
	if(len(attributes.delay_expense) and len(attributes.delay_expense_id) and attributes.delay_price gt 0)
	{
		butceci(
			action_id : GET_PAYMENT_ID.MAX_ID,
			muhasebe_db : dsn2,
			is_income_expense : true,
			process_type : process_type,
			nettotal : wrk_round(attributes.delay_price*other_currency_multiplier),
			other_money_value : attributes.delay_price,
			action_currency : form.money_type,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.revenue_date,
			expense_center_id : attributes.expense_center_id,
			expense_item_id : attributes.delay_expense_id,
			detail : 'KREDİ TAHSİLATI GECİKME GELİRİ',
			paper_no : attributes.document_no,
			company_id : attributes.company_id,
			branch_id : branch_id,
			insert_type : 1
			);
	}
</cfscript>

