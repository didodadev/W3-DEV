<cftry>
	<cfif StructKeyExists(variables,"merge_ifrs_card") IS "NO">
		<!---toplu faturalamada tekrar tekrar include edimesin dublicate hatası veriyordu include alındı --->
		<cfinclude template="invoice_accrual_action_func.cfm">
	</cfif>
	<cfquery name = "get_budget_process_cat" datasource = "#dsn2#">
		SELECT
			PROCESS_CAT_ID
		FROM
			#dsn3#.SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE = 160
			AND IS_DEFAULT = 1
	</cfquery>

	<cfquery name = "get_budget_stage" datasource = "#dsn2#">
		SELECT TOP 1
			PROCESS_ROW_ID
		FROM
			#dsn#.PROCESS_TYPE PT
				LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ID = PT.PROCESS_ID
		WHERE
			PT.PROCESS_ID = 9
		ORDER BY
			PTR.PROCESS_ROW_ID
	</cfquery>

	<cfquery name = "get_accrual_budget" datasource = "#dsn2#">
		SELECT
			PROPERTY_VALUE
		FROM
			#dsn#.FUSEACTION_PROPERTY
		WHERE
			PROPERTY_NAME = 'xml_default_accrual_budget'
			AND OUR_COMPANY_ID = #session.ep.company_id#
			<cfswitch expression = "#get_process_type.process_type#">
				<cfcase value="48,50,53,56,57,58,62,531,532,533,561">
					AND FUSEACTION_NAME = 'invoice.detail_invoice_sale'
				</cfcase>
				<cfcase value="49,51,54,55,59,60,61,63,591,601,690,691">
					AND FUSEACTION_NAME = 'invoice.detail_invoice_purchase'
				</cfcase>
				<cfdefaultcase>
					AND 1 = 2
				</cfdefaultcase>
			</cfswitch>
	</cfquery>
	<cfif get_budget_stage.recordcount and get_budget_process_cat.recordcount and len(get_accrual_budget.property_value) and get_accrual_budget.property_value gt 0>
		<cfquery name = "del_expense_rows" datasource = "#dsn2#" result = "r">
			DELETE FROM EXPENSE_ITEMS_ROWS WHERE INVOICE_ID = #accrual_invoice_id# AND EXPENSE_COST_TYPE = #INVOICE_CAT#
		</cfquery>

		<cfquery name = "get_invoice_rows" datasource = "#dsn2#">
			SELECT INVOICE_ROW_ID FROM INVOICE_ROW WHERE INVOICE_ID = #accrual_invoice_id# ORDER BY INVOICE_ROW_ID
		</cfquery>

		<cfscript>
			if(listFind('49,51,54,55,59,60,61,63,591,601,690,691', get_process_type.process_type)) {
				purchase_sales = 0; // Alış
			} else if(listFind('48,50,53,56,57,58,62,531,532,533,561', get_process_type.process_type)) {
				purchase_sales = 1; // Satış
			}
		</cfscript>

		<cfscript>
			save_attributes = attributes;
			save_get_process_type = get_process_type;
			save_form_process_cat = form.process_cat;
			budget_plan_row_id = 0;
			is_account_invoice = is_account;
			is_account_group_invoice = is_account_group;

			income_total_amount = 0;
			expense_total_amount = 0;
			other_income_total_amount = 0;
			other_expense_total_amount = 0;
			attributes.record_num = 0;

			for(s = 1; s lte 3; s++ ) {
				// Bu senaryoda, muhasebe fişinin ürün hesap ve tutarları manipüle ediliyor. Cari tarafı aynı kalacak.
				// Üçüncü turda da bütçe.

				/*
					s = 1 : Tek düzen
					s = 2 : IFRS
					s = 3 : Bütçe
				*/
				str_urun_hesaplar = '';
				str_urun_tutarlar = '';
				str_dovizli_urun = '';
				str_other_currency_urun = '';
				acc_project_list_urun = '';
				satir_detay_list_urun = [];
				str_urun_miktar = [];
				str_urun_tutar = [];

				if(purchase_sales eq 0) {
					expense_member_id = 0;
					branch_id = from_branch_id;

				} else {
					expense_member_id = sales_emp_id;
					branch_id = to_branch_id;
				}

				// Listeleri boşalttık. Revize halini doldurup tekrar muhasebeci çalıştıracağız.

				inv_row_count = 0;

				for( i = 1; i lte attributes.rows_; i++ ) { // Fatura satırları...

					inv_row_count = inv_row_count + 1;

					invoice_row_id = get_invoice_rows.invoice_row_id[inv_row_count];

					// Satırdaki ürünün muhasebe kod özelliklerini alıyoruz.
					product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:new_period_id,product_account_db:new_dsn2_group,product_alias_db:"#new_dsn3_group#");

					sale_acc_code = product_account_codes.account_code;
					purchase_acc_code = product_account_codes.account_code_pur;

					if(isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))) {
						purchase_budget_center_id = evaluate('attributes.row_exp_center_id#i#');
						sales_budget_center_id = evaluate('attributes.row_exp_center_id#i#');
					} else {
						purchase_budget_center_id = product_account_codes.cost_expense_center_id;
						sales_budget_center_id = product_account_codes.expense_center_id;
					}

					if(isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))) {
						purchase_budget_item_id = evaluate('attributes.row_exp_item_id#i#');
						sales_budget_item_id = evaluate('attributes.row_exp_item_id#i#');
					} else {
						purchase_budget_item_id = product_account_codes.accrual_expense_item_id;
						sales_budget_item_id = product_account_codes.accrual_income_item_id;
					}

					if(purchase_sales eq 0) {
						expense_center_id = purchase_budget_center_id;
						expense_item_id = purchase_budget_item_id;
					} else {
						expense_center_id = sales_budget_center_id;
						expense_item_id = sales_budget_item_id;
					}

					if(not isNumeric(expense_center_id)) {
						writeOutput("<script type = 'text/javascript'>alert('Tahakkuk yapılabilmesi için fatura satırında ya da üründe bütçe merkezi seçilmelidir. (#i#. satır)');</script>");
						abort;
					}
					if(not isNumeric(expense_item_id)) {
						writeOutput("<script type = 'text/javascript'>alert('Tahakkuk yapılabilmesi için fatura satırında ya da üründe bütçe kalemi seçilmelidir. (#i#. satır)');</script>");
						abort;
					}

					if(len(product_account_codes.accrual_month) and product_account_codes.accrual_month gt 0 and len(expense_center_id)) {
						accrual_month = product_account_codes.accrual_month;
					} else {
						accrual_month = 1;
					}

					if(len(product_account_codes.accrual_month_ifrs) and product_account_codes.accrual_month_ifrs gt 0 and len(expense_center_id)) {
						accrual_month_ifrs = product_account_codes.accrual_month_ifrs;
					} else {
						accrual_month_ifrs = 1;
					}

					if(len(product_account_codes.accrual_month_budget) and product_account_codes.accrual_month_budget gt 0 and len(expense_center_id)) {
						accrual_month_budget = product_account_codes.accrual_month_budget;
					} else {
						accrual_month_budget = 1;
					}

					first_12_to_month = product_account_codes.first_12_to_month;
					first_12_to_month_ifrs = product_account_codes.first_12_to_month_ifrs;

					if(s == 1) {
						type_month = accrual_month;
					} else if(s == 2) {
						type_month = accrual_month_ifrs;
					} else if(s == 3) {
						type_month = accrual_month_budget;
					}

					row_deliver_date = evaluate('attributes.deliver_date#i#');
					if(s == 1) {
						if(product_account_codes.start_from_delivery_date eq 1 and len(row_deliver_date) and row_deliver_date neq 'NULL') {
							distribute_start_date = row_deliver_date;
						} else {
							distribute_start_date = attributes.invoice_date;
						}
					} else if(s == 2) {
						if(product_account_codes.start_from_delivery_date_ifrs eq 1 and len(row_deliver_date) and row_deliver_date neq 'NULL') {
							distribute_start_date = row_deliver_date;
						} else {
							distribute_start_date = attributes.invoice_date;
						}
					}

					if(s == 1) {
						if(product_account_codes.distribute_to_fiscal_end eq 1) {
							months_remaining = dateDiff('m', distribute_start_date, session.ep.period_finish_date) + 1;

							if(months_remaining lt type_month) {
								type_month = months_remaining;
							}
						}
					} else if(s == 2) {
						if(product_account_codes.distribute_to_fiscal_end_ifrs eq 1) {
							months_remaining = dateDiff('m', distribute_start_date, session.ep.period_finish_date) + 1;

							if(months_remaining lt type_month) {
								type_month = months_remaining;
							}
						}
					}

					day_diff_factor = 0;

					if(s == 1) {
						if(product_account_codes.distribute_day_based eq 1) {
							if(day(distribute_start_date) neq 1) {
								day_diff_factor = 1;
							}
						}
					} else if(s == 2) {
						if(product_account_codes.distribute_day_based_ifrs eq 1) {
							if(day(distribute_start_date) neq 1) {
								day_diff_factor = 1;
							}
						}
					}

					// Tahakkuka ilişkin bütçe planı işlemi yapılıyor.

					if(s == 3) {
						attributes.rd_money = attributes.basket_money;
						rd_money = attributes.basket_money;
						rd_money_value = attributes.rd_money;

						currency_multiplier = '';
						currency_multiplier2 = '';

						if(isDefined('attributes.kur_say') and len(attributes.kur_say))
							for(mon=1;mon lte attributes.kur_say;mon=mon+1)
							{
								if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
									currency_multiplier = (evaluate('attributes.txt_rate2_#mon#'))/(evaluate('attributes.txt_rate1_#mon#'));
								if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
									currency_multiplier2 = (evaluate('attributes.txt_rate2_#mon#'))/(evaluate('attributes.txt_rate1_#mon#'));
							}

						attributes.budget_id = get_accrual_budget.property_value;
						attributes.process_stage = get_budget_stage.process_row_id;
						attributes.paper_number = form.invoice_number;
						attributes.record_date = dateformat(distribute_start_date,'dd/mm/yyyy');
						attributes.detail = '#form.invoice_number# nolu faturanın bütçe planı.';
						income_total_amount = income_total_amount + (evaluate("attributes.row_nettotal#i#")/type_month) * type_month * purchase_sales;
						expense_total_amount = expense_total_amount + (evaluate("attributes.row_nettotal#i#")/type_month) * type_month * ( 1 - purchase_sales);

						attributes.due_date = dateformat(distribute_start_date,'dd/mm/yyyy');
						attributes.document_type = '';
						attributes.payment_type = '';

						attributes.record_num = attributes.record_num + 1;
					}

					total_month_amount = 0;

					fiscal_year_start = createDate(year(distribute_start_date), 1, 1);

					for(j = 1; j lte type_month + day_diff_factor; j++) {

						if((s == 1 and product_account_codes.past_months_to_first eq 1) or (s == 2 and product_account_codes.past_months_to_first_ifrs eq 1)) {
							accrual_date = dateAdd('m', j - 1, fiscal_year_start);
						} else {
							accrual_date = dateAdd('m', j - 1, distribute_start_date);
						}

						if(is_discount == 1) {
							row_distribute_amount = evaluate("attributes.row_nettotal#i#");
						} else {
							row_distribute_amount = evaluate("attributes.row_total#i#");
						}
						if(s == 1 or s == 3) {	
							if(product_account_codes.distribute_day_based neq 1) {
								this_month_amount = row_distribute_amount / type_month; // her aya eşit böl.
							} else {
								distribute_end_date = dateAdd('d', -1, dateAdd('m', type_month, distribute_start_date));
								end_of_distribute_month = distribute_end_date;

								if(j == 1) {
									month_start = day(accrual_date);
								} else {
									month_start = 1;
								}

								if(j == type_month + day_diff_factor) {
									month_end = day(distribute_end_date);
								} else {
									month_end = daysInMonth(accrual_date);
								}

								this_month_days = month_end - month_start + 1;
								total_accrual_days = dateDiff('d', distribute_start_date, end_of_distribute_month) + 1;
								accrual_date = createDate(year(accrual_date), month(accrual_date), daysInMonth(accrual_date));
								this_month_amount = row_distribute_amount * this_month_days / total_accrual_days; // gün sayısına göre böl.
							}

						} else if(s == 2) {
							if(product_account_codes.distribute_day_based_ifrs neq 1) {
								this_month_amount = row_distribute_amount / type_month; // her aya eşit böl.
							} else {
								if(j == 1) {
									month_start = day(accrual_date);
								} else {
									month_start = 1;
								}
								month_end = daysInMonth(accrual_date);
								this_month_days = month_end - month_start + 1;
								distribute_end_date = dateAdd('m', type_month - 1, distribute_start_date);
								end_of_distribute_month = createDate(year(distribute_end_date), month(distribute_end_date), daysInMonth(distribute_end_date));
								total_accrual_days = dateDiff('d', distribute_start_date, end_of_distribute_month) + 1;
								accrual_date = createDate(year(accrual_date), month(accrual_date), daysInMonth(accrual_date));
								this_month_amount = row_distribute_amount * this_month_days / total_accrual_days; // gün sayısına göre böl.
							}
						}

						this_month_amount = NumberFormat(this_month_amount, '9.99');
						total_month_amount = total_month_amount + this_month_amount;

						if(j == type_month + day_diff_factor) {
							row_invoice_amount = row_distribute_amount;
							this_month_amount = this_month_amount + (row_invoice_amount - total_month_amount);
						}

						if(purchase_sales eq 0) {
							if(len(product_account_codes.next_month_expenses_acc_code)) {
								next_month_expenses_acc_key = product_account_codes.next_month_expenses_acc_key;
								if(not len(next_month_expenses_acc_key)) {
									writeOutput("<script type = 'text/javascript'>alert('Gelecek aylara ait giderler tahakkuk anahtarı alanı tanımlanmalıdır.');</script>");
									abort;
								} else {
									if((s == 1 and product_account_codes.past_months_to_first eq 1) or (s == 2 and product_account_codes.past_months_to_first_ifrs eq 1)) {
										if(dateDiff('m', fiscal_year_start, accrual_date) lte 0) {
											month_accrual_account = product_account_codes.next_month_expenses_acc_code & '.' & dateFormat(distribute_start_date,next_month_expenses_acc_key);
										} else {
											month_accrual_account = product_account_codes.next_month_expenses_acc_code & '.' & dateFormat(accrual_date,next_month_expenses_acc_key);
										}
									} else {
										month_accrual_account = product_account_codes.next_month_expenses_acc_code & '.' & dateFormat(accrual_date,next_month_expenses_acc_key);
									}
								}
							} else {
								month_accrual_account = purchase_acc_code;
							}
							if(len(product_account_codes.next_year_expenses_acc_code)) {
								next_year_expenses_acc_key = product_account_codes.next_year_expenses_acc_key;
								if(not len(next_year_expenses_acc_key)) {
									writeOutput("<script type = 'text/javascript'>alert('Gelecek yıllara ait giderler tahakkuk anahtarı alanı tanımlanmalıdır.');</script>");
									abort;
								} else {
									if((s == 1 and product_account_codes.past_months_to_first eq 1) or (s == 2 and product_account_codes.past_months_to_first_ifrs eq 1)) {
										if(dateDiff('m', distribute_start_date, accrual_date) lte 0) {
											year_accrual_account = product_account_codes.next_year_expenses_acc_code & '.' & dateFormat(distribute_start_date,next_year_expenses_acc_key);
										} else {
											year_accrual_account = product_account_codes.next_year_expenses_acc_code & '.' & dateFormat(accrual_date,next_year_expenses_acc_key);
										}
									} else {
										year_accrual_account = product_account_codes.next_year_expenses_acc_code & '.' & dateFormat(accrual_date,next_year_expenses_acc_key);
									}
								}
							} else {
								year_accrual_account = purchase_acc_code;
							}
						} else {
							if(len(product_account_codes.next_month_incomes_acc_code)) {
								next_month_incomes_acc_key = product_account_codes.next_month_incomes_acc_key;
								if(not len(next_month_incomes_acc_key)) {
									writeOutput("<script type = 'text/javascript'>alert('Gelecek aylara ait gelirler tahakkuk anahtarı alanı tanımlanmalıdır.');</script>");
									abort;
								} else {
									if((s == 1 and product_account_codes.past_months_to_first eq 1) or (s == 2 and product_account_codes.past_months_to_first_ifrs eq 1)) {
										if(dateDiff('m', distribute_start_date, accrual_date) lte 0) {
											month_accrual_account = product_account_codes.next_month_incomes_acc_code & '.' & dateFormat(distribute_start_date,next_month_incomes_acc_key);
										} else {
											month_accrual_account = product_account_codes.next_month_incomes_acc_code & '.' & dateFormat(accrual_date,next_month_incomes_acc_key);
										}
									} else {
										month_accrual_account = product_account_codes.next_month_incomes_acc_code & '.' & dateFormat(accrual_date,next_month_incomes_acc_key);
									}
								}
							} else {
								month_accrual_account = sale_acc_code;
							}
							if(len(product_account_codes.next_year_incomes_acc_code)) {
								next_year_incomes_acc_key = product_account_codes.next_year_incomes_acc_key;
								if(not len(next_year_incomes_acc_key)) {
									writeOutput("<script type = 'text/javascript'>alert('Gelecek yıllara ait gelirler tahakkuk anahtarı alanı tanımlanmalıdır.');</script>");
									abort;
								} else {
									if((s == 1 and product_account_codes.past_months_to_first eq 1) or (s == 2 and product_account_codes.past_months_to_first_ifrs eq 1)) {
										if(dateDiff('m', fiscal_year_start, accrual_date) lte 0) {
											year_accrual_account = product_account_codes.next_year_incomes_acc_code & '.' & dateFormat(distribute_start_date,next_year_incomes_acc_key);
										} else {
											year_accrual_account = product_account_codes.next_year_incomes_acc_code & '.' & dateFormat(accrual_date,next_year_incomes_acc_key);
										}
									} else {
										year_accrual_account = product_account_codes.next_year_incomes_acc_code & '.' & dateFormat(accrual_date,next_year_incomes_acc_key);
									}
								}
							} else {
								year_accrual_account = sale_acc_code;
							}
						}

						if(accrual_budget_action eq 1) {
							if(s == 3) {
								budget_plan_row_id = budget_plan_row_id + 1;
								evaluate("attributes.row_kontrol#budget_plan_row_id# = 1");
								evaluate("attributes.expense_center_id#budget_plan_row_id# = expense_center_id");
								evaluate("attributes.expense_item_id#budget_plan_row_id# = expense_item_id");
								evaluate("attributes.expense_item_name#budget_plan_row_id# = ' '");
								evaluate("attributes.employee_id#budget_plan_row_id# = attributes.employee_id");
								evaluate("attributes.expense_date#budget_plan_row_id# = dateformat(accrual_date,'dd/mm/yyyy')");
								evaluate("attributes.row_detail#budget_plan_row_id# = attributes.product_name#i# & ' Tahakkuk : ' & #budget_plan_row_id# & '/' & #accrual_month#");
								evaluate("attributes.income_total#budget_plan_row_id# = purchase_sales * this_month_amount");
								evaluate("attributes.expense_total#budget_plan_row_id# = (1 - purchase_sales) * this_month_amount");
								evaluate("attributes.other_income_total#budget_plan_row_id# = purchase_sales * (this_month_amount/currency_multiplier)");
								evaluate("attributes.other_expense_total#budget_plan_row_id# = (1 - purchase_sales) * (this_month_amount/currency_multiplier)");
								evaluate("attributes.diff_total#budget_plan_row_id# = attributes.income_total#budget_plan_row_id# - attributes.expense_total#budget_plan_row_id#");

								if(accrual_date lte session.ep.period_finish_date) {
									evaluate("attributes.account_id#budget_plan_row_id# = month_accrual_account");
									evaluate("attributes.account_code#budget_plan_row_id# = month_accrual_account");
								} else {
									evaluate("attributes.account_id#budget_plan_row_id# = year_accrual_account");
									evaluate("attributes.account_code#budget_plan_row_id# = year_accrual_account");
								}
							}
						} else {
							if(s == 3) {
								butce=butceci (
									action_id:accrual_invoice_id,
									muhasebe_db:dsn2,
									stock_id: evaluate("attributes.stock_id#i#"),
									product_id: evaluate("attributes.product_id#i#"),
									product_tax: evaluate("attributes.tax#i#"),
									product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
									product_bsmv: iif((isdefined("attributes.row_bsmv_rate#i#") and len(evaluate('attributes.row_bsmv_rate#i#'))),evaluate("attributes.row_bsmv_rate#i#"),0),
									product_oiv: iif((isdefined("attributes.row_oiv_rate#i#") and len(evaluate('attributes.row_oiv_rate#i#'))),evaluate("attributes.row_oiv_rate#i#"),0),
									tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
									activity_type: iif((isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#'))),evaluate("attributes.row_activity_id#i#"),de('')),
									expense_center_id: expense_center_id,
									expense_item_id: expense_item_id,
									subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
									invoice_row_id:invoice_row_id,
									invoice_number:form.INVOICE_NUMBER,
									detail : '#form.INVOICE_NUMBER# Nolu Fatura',
									is_income_expense: purchase_sales,
									process_type:INVOICE_CAT,
									nettotal:this_month_amount,
									other_money_value:this_month_amount/currency_multiplier,
									action_currency:other_money,
									expense_date:accrual_date,
									department_id:attributes.department_id,
									project_id:inv_project_id,
									branch_id : budget_branch_id,
									discounttotal : 0,
									currency_multiplier : attributes.currency_multiplier
								);
							}
						}

						if(s == 1) { // Tek düzen
							if(first_12_to_month neq 1) {
								if(accrual_date lte session.ep.period_finish_date) { // İlgili tahakkuk ayı, mevcut mali yıl içinde mi?
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,month_accrual_account,",");
								} else { // Sonraki yıllara ait kayıtlar.
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,year_accrual_account,",");
								}
							} else {
								if(j lte 12) { // İlgili tahakkuk ayı, mevcut mali yıl içinde mi?
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,month_accrual_account,",");
								} else { // Sonraki yıllara ait kayıtlar.
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,year_accrual_account,",");
								}
							}
						} else if(s == 2) { // IFRS
							if(first_12_to_month_ifrs neq 1) {
								if(accrual_date lte session.ep.period_finish_date) { // İlgili tahakkuk ayı, mevcut mali yıl içinde mi?
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,month_accrual_account,",");
								} else { // Sonraki yıllara ait kayıtlar.
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,year_accrual_account,",");
								}
							} else {
								if(j lte 12) { // İlgili tahakkuk ayı, mevcut mali yıl içinde mi?
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,month_accrual_account,",");
								} else { // Sonraki yıllara ait kayıtlar.
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,year_accrual_account,",");
								}
							}
						}

						if(is_account_invoice eq 1) {
							str_urun_tutarlar = ListAppend(str_urun_tutarlar,this_month_amount,",");
							//other_money_value_ urun indirimlerinin dusulmus degerini tasır ve sadece indirimler 0 oladugunda veya muhasebe fisinde gosterilmeyecekse other_money_value_ ile row_total degerleri esit olur.
							if(urun_toplam_indirim eq 0 and isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) )
							{
								str_dovizli_urun = ListAppend(str_dovizli_urun,this_month_amount/form.basket_rate2,",");
								str_other_currency_urun = ListAppend(str_other_currency_urun,evaluate("attributes.other_money_#i#"),",");
							}
							else
							{
								str_dovizli_urun = ListAppend(str_dovizli_urun,this_month_amount/form.basket_rate2,",");
								str_other_currency_urun = ListAppend(str_other_currency_urun,form.basket_money,",");
							}

							if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
								acc_project_list_urun = ListAppend(acc_project_list_urun,evaluate("attributes.row_project_id#i#"),",");
							else
								acc_project_list_urun = ListAppend(acc_project_list_urun,main_project_id,",");
							str_urun_miktar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.amount#i#")#';
							str_urun_tutar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
							if(is_account_group_invoice neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
								satir_detay_list_urun[listlen(str_urun_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
							else
								satir_detay_list_urun[listlen(str_urun_tutarlar)] = genel_fis_satir_detay;
						}
					}

					if(is_account_invoice eq 1) {
						//Satılan Malın Maliyeti Muhasebeleştiriliyor
						if(isdefined('is_prod_cost_acc_action') and is_prod_cost_acc_action eq 1 and listfind("52,53,56,531",invoice_cat))
						{
							temp_row_amount=0;
							if(len(new_karma_prod_id_list_) and listfind(new_karma_prod_id_list_,evaluate("attributes.product_id#i#"))) //satırdaki karma koli urunse, set icerigindeki urunlerin maliyet toplamı karmakoli urune yansıtılacak
							{
								row_prod_id=evaluate("attributes.product_id#i#");
								'temp_row_amount_#row_prod_id#'=0;
								for(kp=1;kp lte get_karma_prods_.recordcount;kp=kp+1)
								{
									if(row_prod_id eq get_karma_prods_.KARMA_PRODUCT_ID[kp] and listfind(product_cost_list_new,get_karma_prods_.PRODUCT_ID[kp]))
									{
										temp_karma_prod_amount=get_karma_prods_.PRODUCT_AMOUNT[kp];
										'temp_row_amount_#row_prod_id#'=evaluate('temp_row_amount_#row_prod_id#')+wrk_round(get_prod_cost_amounts.PRODUCT_COST_SYSTEM_AMOUNT[listfind(product_cost_list_new,get_karma_prods_.PRODUCT_ID[kp])]*get_karma_prods_.PRODUCT_AMOUNT[kp]);
									}
								}
								temp_row_amount=evaluate('temp_row_amount_#row_prod_id#')*evaluate("attributes.amount#i#");
								temp_row_other_amount=wrk_round(temp_row_amount*(attributes.basket_rate1/attributes.basket_rate2));
								temp_row_other_currency=form.basket_money;
							}
							else if(listfind(product_cost_list_new,evaluate("attributes.product_id#i#")))
							{
								temp_row_amount=(get_prod_cost_amounts.PRODUCT_COST_SYSTEM_AMOUNT[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))]*evaluate("attributes.amount#i#"));
								temp_row_other_amount=(get_prod_cost_amounts.PRODUCT_COST_AMOUNT[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))]*evaluate("attributes.amount#i#"));
								temp_row_other_currency=get_prod_cost_amounts.PURCHASE_NET_MONEY[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))];
							}
							if(temp_row_amount neq 0)
							{
								if(purchase_sales eq 0) {
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,product_account_codes.ACCOUNT_CODE_PUR,",");
								} else {
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,product_account_codes.ACCOUNT_CODE,",");
								}
								str_urun_tutarlar = ListAppend(str_urun_tutarlar,temp_row_amount,",");
								str_dovizli_urun = ListAppend(str_dovizli_urun,temp_row_other_amount,",");
								str_other_currency_urun = ListAppend(str_other_currency_urun,temp_row_other_currency,",");
								str_urun_miktar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.amount#i#")#';
								str_urun_tutar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
					
								if(is_account_group_invoice neq 1)
									satir_detay_list_urun[listlen(str_urun_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
								else
									satir_detay_list_urun[listlen(str_urun_tutarlar)] = genel_fis_satir_detay;
							
								if(location_type eq 3)
									str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,product_account_codes.SALE_MANUFACTURED_COST,",");  //satılan mamulun maliyeti hesabı borclu
								else
									str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,product_account_codes.SALE_PRODUCT_COST,",");  //satılan malın maliyeti hesabı borclu
								str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,temp_row_amount,",");
								str_dovizli_borclar = ListAppend(str_dovizli_borclar,temp_row_other_amount,",");
								str_other_currency_borc = ListAppend(str_other_currency_borc,temp_row_other_currency,",");
								if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
								{
									acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
									acc_project_list_urun = ListAppend(acc_project_list_urun,evaluate("attributes.row_project_id#i#"),",");
								}
								else
								{
									acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
									acc_project_list_urun = ListAppend(acc_project_list_urun,main_project_id,",");
								}
								if(is_account_group_invoice neq 1)
									satir_detay_list[1][listlen(str_borclu_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
								else
									satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
							}
						}
						//otv bloğu
						if(evaluate("form.row_otvtotal#i#") neq 0)
						{
							get_otv_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM #new_dsn3_group#.SETUP_OTV WHERE TAX = #evaluate("form.otv_oran#i#")#  AND PERIOD_ID = #new_period_id#");
							if(purchase_sales eq 0) {
								if(invoice_cat eq 62) //iade ve verilen fiyat farkı faturalarında
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_otv_row.purchase_code_iade, ",");
								else
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_otv_row.purchase_code, ",");
							} else {
								if(invoice_cat eq 55) //iade ve verilen fiyat farkı faturalarında
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_otv_row.account_code_iade, ",");
								else
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_otv_row.account_code, ",");
							}
							temp_otv_tutar = evaluate("form.row_otvtotal#i#");
							if(genel_indirim_yuzdesi gt 0) //fatura altı indirim varsa, indirim kdv toplamlara da yansıtılır
								temp_otv_tutar =  wrk_round((temp_otv_tutar-(temp_otv_tutar*genel_indirim_yuzdesi)),attributes.basket_price_round_number);
							str_urun_tutarlar = ListAppend(str_urun_tutarlar,temp_otv_tutar, ",");
							str_dovizli_urun = ListAppend(str_dovizli_urun, (temp_otv_tutar*(form.basket_rate1/form.basket_rate2)), ",");
							str_other_currency_urun = ListAppend(str_other_currency_urun,form.basket_money,",");
							if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
								acc_project_list_urun = ListAppend(acc_project_list_urun,evaluate("attributes.row_project_id#i#"),",");
							else
								acc_project_list_urun = ListAppend(acc_project_list_urun,main_project_id,",");
							str_urun_tutar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
							str_urun_miktar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.amount#i#")#';
							if(is_account_group_invoice neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
								satir_detay_list_urun[listlen(str_urun_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
							else
								satir_detay_list_urun[listlen(str_urun_tutarlar)] = genel_fis_satir_detay;
						}
						// kdv bloğu
						if(evaluate("form.row_taxtotal#i#") gt 0)
						{
							temp_tax_tutar = evaluate("form.row_taxtotal#i#");
							temp_tax_tutar2 = evaluate("form.row_taxtotal#i#");
							if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran))
							{ /*herbir kdv ye uygulanacak tevkşfat icin muhasebe hesapları cekiliyor*/
								tevkifat_acc_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT 
															ST_ROW.TEVKIFAT_BEYAN_CODE,ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
														FROM 
															#new_dsn3_group#.SETUP_TEVKIFAT S_TEV,#new_dsn3_group#.SETUP_TEVKIFAT_ROW ST_ROW 
														WHERE
															S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
															AND S_TEV.TEVKIFAT_ID = #form.tevkifat_id#
															AND ST_ROW.TAX = #evaluate("form.tax#i#")#
														ORDER BY ST_ROW.TAX");
								if(purchase_sales eq 1)
								temp_tax_tutar = wrk_round((temp_tax_tutar*form.tevkifat_oran),attributes.basket_price_round_number);
								temp_tax_tutar2 = wrk_round((temp_tax_tutar*form.tevkifat_oran),attributes.basket_price_round_number);
							}
							get_tax_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM SETUP_TAX WHERE TAX = #evaluate("form.tax#i#")#");
							if(genel_indirim_yuzdesi gt 0){ //fatura altı indirim varsa, indirim kdv toplamlara da yansıtılır
								temp_tax_tutar =  wrk_round((temp_tax_tutar-(temp_tax_tutar*genel_indirim_yuzdesi)),attributes.basket_price_round_number);
								temp_tax_tutar2 =  wrk_round((temp_tax_tutar2-(temp_tax_tutar2*genel_indirim_yuzdesi)),attributes.basket_price_round_number);
							}
							if(purchase_sales eq 0) {// alış
								if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran))
									{
										str_urun_hesaplar = ListAppend(str_urun_hesaplar,tevkifat_acc_codes.tevkifat_code_pur, ","); 
									}
								else
								{
									if( is_expensing_tax eq 1 ){
										str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.direct_expense_code, ",");
									}else{
										if(invoice_cat eq 55) //iade faturası
											str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.sale_code_iade, ",");
										else if(invoice_cat eq 63) //alınan fiyat farkı
											str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.purchase_price_diff_code, ",");
										else
											str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.purchase_code, ",");
									}
								}
								if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran)) 
								{
									str_urun_tutarlar = ListAppend(str_urun_tutarlar,temp_tax_tutar2, ",");
									str_dovizli_urun = ListAppend(str_dovizli_urun, (temp_tax_tutar2*(form.basket_rate1/form.basket_rate2)), ",");
									str_other_currency_urun= ListAppend(str_other_currency_urun,form.basket_money,",");
									if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
										acc_project_list_urun = ListAppend(acc_project_list_urun,evaluate("attributes.row_project_id#i#"),",");
									else
										acc_project_list_urun = ListAppend(acc_project_list_urun,main_project_id,",");
										
									str_urun_tutar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
									str_urun_miktar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.amount#i#")#';
									
									if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
										satir_detay_list_urun[listlen(str_urun_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
									else
										satir_detay_list_urun[listlen(str_urun_tutarlar)] = genel_fis_satir_detay;


									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.purchase_code, ",");
									str_urun_tutarlar = ListAppend(str_urun_tutarlar,(temp_tax_tutar-temp_tax_tutar2), ",");
									str_dovizli_urun = ListAppend(str_dovizli_urun, ((temp_tax_tutar-temp_tax_tutar2)*(form.basket_rate1/form.basket_rate2)), ",");
									str_other_currency_urun= ListAppend(str_other_currency_urun,form.basket_money,",");


								}
								else
								{	
									str_urun_tutarlar = ListAppend(str_urun_tutarlar,temp_tax_tutar, ",");
									str_dovizli_urun = ListAppend(str_dovizli_urun, (temp_tax_tutar*(form.basket_rate1/form.basket_rate2)), ",");
									str_other_currency_urun = ListAppend(str_other_currency_urun,form.basket_money,",");
								}
								
								
								if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
									acc_project_list_urun = ListAppend(acc_project_list_urun,evaluate("attributes.row_project_id#i#"),",");
								else
									acc_project_list_urun = ListAppend(acc_project_list_urun,main_project_id,",");
								str_urun_tutar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
								str_urun_miktar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.amount#i#")#';
								if(is_account_group_invoice neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
									satir_detay_list_urun[listlen(str_urun_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
								else
									satir_detay_list_urun[listlen(str_urun_tutarlar)] = genel_fis_satir_detay;

							} else { // satış
								if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran))
									str_urun_hesaplar = ListAppend(str_urun_hesaplar,tevkifat_acc_codes.tevkifat_beyan_code, ",");
								else
								{
									if( is_expensing_tax eq 1 ){
										str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.direct_expense_code, ",");
									}else{
										if(invoice_cat eq 62) //iade faturası
											str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.purchase_code_iade, ",");
										else if(invoice_cat eq 58) //verilen fiyat farkı
											str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.sale_price_diff_code, ",");
										else
											str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_tax_row.sale_code, ",");
									}
								}

								str_urun_tutarlar = ListAppend(str_urun_tutarlar,temp_tax_tutar, ",");
								str_dovizli_urun = ListAppend(str_dovizli_urun, (temp_tax_tutar*(form.basket_rate1/form.basket_rate2)), ",");
								str_other_currency_urun = ListAppend(str_other_currency_urun,form.basket_money,",");
								if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
									acc_project_list_urun = ListAppend(acc_project_list_urun,evaluate("attributes.row_project_id#i#"),",");
								else
									acc_project_list_urun = ListAppend(acc_project_list_urun,main_project_id,",");
								str_urun_tutar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
								str_urun_miktar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.amount#i#")#';
								if(is_account_group_invoice neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
									satir_detay_list_urun[listlen(str_urun_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
								else
									satir_detay_list_urun[listlen(str_urun_tutarlar)] = genel_fis_satir_detay;
							}
						}
						
						// bsmv bloğu
						if(IsDefined("form.row_bsmv_amount#i#") and evaluate("form.row_bsmv_amount#i#") gt 0)
						{
							temp_bsmv_tutar = evaluate("form.row_bsmv_amount#i#");
							get_bsmv_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM #new_dsn3_group#.SETUP_BSMV WHERE TAX = #evaluate("form.row_bsmv_rate#i#")#");
							if(purchase_sales eq 0) {
								if(invoice_cat eq 55) //iade faturası
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_bsmv_row.account_code_iade, ",");
								else
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_bsmv_row.purchase_code, ",");
							} else {
								if(invoice_cat eq 62) //iade faturası
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_bsmv_row.purchase_code_iade, ",");
								else
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_bsmv_row.account_code, ",");
							}
							str_urun_tutarlar = ListAppend(str_urun_tutarlar,temp_bsmv_tutar, ",");
							str_dovizli_urun = ListAppend(str_dovizli_urun, (temp_bsmv_tutar*(form.basket_rate1/form.basket_rate2)), ",");
							str_other_currency_urun = ListAppend(str_other_currency_urun,form.basket_money,",");
							if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
								acc_project_list_urun = ListAppend(acc_project_list_urun,evaluate("attributes.row_project_id#i#"),",");
							else
								acc_project_list_urun = ListAppend(acc_project_list_urun,main_project_id,",");
							str_urun_tutar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
							str_urun_miktar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.amount#i#")#';
							if(is_account_group_invoice neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
								satir_detay_list_urun[listlen(str_urun_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
							else
								satir_detay_list_urun[listlen(str_urun_tutarlar)] = genel_fis_satir_detay;
						}

						// oiv bloğu
						if(IsDefined("form.row_oiv_amount#i#") and evaluate("form.row_oiv_amount#i#") gt 0)
						{
							temp_oiv_tutar = evaluate("form.row_oiv_amount#i#");
							get_oiv_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM #new_dsn3_group#.SETUP_OIV WHERE TAX = #evaluate("form.row_oiv_rate#i#")#");
							if(purchase_sales eq 0) {
								if(invoice_cat eq 55) //iade faturası
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_oiv_row.account_code_iade, ",");
								else
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_oiv_row.purchase_code, ",");
							} else {
								if(invoice_cat eq 62) //iade faturası
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_oiv_row.purchase_code_iade, ",");
								else
									str_urun_hesaplar = ListAppend(str_urun_hesaplar, get_oiv_row.account_code, ",");
							}

							str_urun_tutarlar = ListAppend(str_urun_tutarlar,temp_oiv_tutar, ",");
							str_dovizli_urun = ListAppend(str_dovizli_urun, (temp_oiv_tutar*(form.basket_rate1/form.basket_rate2)), ",");
							str_other_currency_urun = ListAppend(str_other_currency_urun,form.basket_money,",");
							if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
								acc_project_list_urun = ListAppend(acc_project_list_urun,evaluate("attributes.row_project_id#i#"),",");
							else
								acc_project_list_urun = ListAppend(acc_project_list_urun,main_project_id,",");
							str_urun_tutar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
							str_urun_miktar[listlen(str_urun_tutarlar)] = '#evaluate("attributes.amount#i#")#';
							if(is_account_group_invoice neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
								satir_detay_list_urun[listlen(str_urun_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
							else
								satir_detay_list_urun[listlen(str_urun_tutarlar)] = genel_fis_satir_detay;
						}
					}
				}

				if(is_account_invoice eq 1 and s neq 3) {

					//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
					str_fark_gelir =GET_NO_.FARK_GELIR;
					str_fark_gider =GET_NO_.FARK_GIDER;
					
					str_round_detail = genel_fis_satir_detay;

					if(s == 1) {
						acc_action_id = accrual_invoice_id;
					} else if(s == 2) {
						acc_action_id = 0;
					}

					if(not isDefined('wrk_id')) {
						wrk_id = GET_NUMBER.WRK_ID;
					}

					if(purchase_sales eq 0) {
						str_borclu_hesaplar = str_urun_hesaplar;
						str_borclu_tutarlar = str_urun_tutarlar;
						str_dovizli_borclar = str_dovizli_urun;
						str_other_currency_borc = str_other_currency_urun;
						acc_project_list_borc = acc_project_list_urun;
						//fis_satir_detay[1] = satir_detay_list_urun;
						satir_detay_list[1]  = satir_detay_list_urun;
						str_alacak_miktar = str_urun_miktar;
						str_alacak_tutar = str_urun_tutar;
					} else {
						str_alacakli_hesaplar = str_urun_hesaplar;
						str_alacakli_tutarlar = str_urun_tutarlar;
						str_dovizli_alacaklar = str_dovizli_urun;
						str_other_currency_alacak = str_other_currency_urun;
						acc_project_list_alacak = acc_project_list_urun;
						//fis_satir_detay[2] = satir_detay_list_urun;
						satir_detay_list[2]  = satir_detay_list_urun;
						str_borc_miktar = str_urun_miktar;
						str_borc_tutar = str_urun_tutar;
					}

					this_card_id = muhasebeci(
						wrk_id = wrk_id,
						action_id : acc_action_id,
						workcube_process_type : INVOICE_CAT,
						workcube_old_process_type : INVOICE_CAT,
						workcube_process_cat:process_cat,
						account_card_type : 13,
						company_id : attributes.company_id,
						consumer_id : attributes.consumer_id,
						islem_tarihi : attributes.invoice_date,//distribute_start_date,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borclu_tutarlar,
						other_amount_borc : str_dovizli_borclar,
						other_currency_borc : str_other_currency_borc,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacakli_tutarlar,
						other_amount_alacak : str_dovizli_alacaklar,
						other_currency_alacak :str_other_currency_alacak,
						alacak_miktarlar : str_alacak_miktar,
						alacak_birim_tutar : str_alacak_tutar,
						to_branch_id : branch_id,
						acc_department_id : acc_department_id,
						fis_detay : '#DETAIL_1#',
						fis_satir_detay : satir_detay_list,
						belge_no : form.invoice_number,
						is_account_group : is_account_group_invoice,
						currency_multiplier : attributes.currency_multiplier,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail,
						acc_project_id : main_project_id,
						acc_project_list_alacak : acc_project_list_urun,
						acc_project_list_borc : acc_project_list_borc
						);

					if(s == 1) {
						standard_card_id = this_card_id;
					} else if(s == 2) {
						ifrs_card_id = this_card_id;
					}
				}
			}

			diff_total_amount = income_total_amount - expense_total_amount;
			attributes.diff_total_amount = diff_total_amount;
			other_diff_total_amount = other_income_total_amount - other_expense_total_amount;
			attributes.other_diff_total_amount = other_diff_total_amount;

			other_income_total_amount = income_total_amount / currency_multiplier;
			other_expense_total_amount = income_total_amount / currency_multiplier;

			from_invoice = 1;
			if(get_budget_plan.recordcount) {
				attributes.budget_plan_id = get_budget_plan.budget_plan_id;
				include "../../budget/query/del_budget_plan.cfm";
			}
			if(budget_plan_row_id gte 1) {
				// Bu koşul sağlandıysa, faturadaki ürünlerden en az biri ileriki aylara birşeyler tahakkuk etmiştir.
				form.process_cat = get_budget_process_cat.process_cat_id;
				include "../../budget/query/add_budget_plan.cfm";
			}

			/*
				şimdi,
					card_id = standard_card_id olan ifrs satırlarını
					card_id = ifrs_card_id olan tek düzen satırlarını ve tek düzen belgesini sileceğim ve ifrs_satırlarındaki card_id değerini standard_card_id olarak güncelleyeceğim.
				
				Bu işleme kısaca 'ifrs fiş birleştirme diyorum.'
			*/

			if(is_account_invoice eq 1) {
				res = merge_ifrs_card(standard_card_id, ifrs_card_id);
			}

			attributes = save_attributes;
			attributes.invoice_id = accrual_invoice_id;
			get_process_type = save_get_process_type;
			form.process_cat = save_form_process_cat;
		</cfscript>
	</cfif>
	<cfcatch>
		<cfdump var = "#cfcatch#">
		<cfabort>
		<script type = "text/javascript">
			alert('Tahakkuk planlamada bir hata oluştu!');
		</script>
	</cfcatch>
</cftry>

