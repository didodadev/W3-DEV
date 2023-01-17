<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = ''></cfif>
<cfscript>
	/*if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
		to_branch_id = attributes.branch_id;
	else
		to_branch_id = '';*/
		

	// Şube Bilgisi Depo Şubesinden Alınsın XML seçeneği Evet seçilirse carici ve muhasebeciye giden şubeler faturada seçili olan deponun şubesi olur
	if(isDefined("attributes.xml_get_branch_from_department") AND attributes.xml_get_branch_from_department EQ 1)
		to_branch_id = attributes.branch_id;
	else if(len(ListGetAt(session.ep.user_location,2,"-")))
		to_branch_id = ListGetAt(session.ep.user_location,2,"-");
	else
		to_branch_id = '';

	if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
		acc_department_id = attributes.acc_department_id;
	else
		acc_department_id = '';
		
	if( len(attributes.location_id) and len(attributes.department_id)) 
	{	
		LOCATION=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT LOCATION_TYPE,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_id# AND LOCATION_ID=#attributes.location_id#");
		location_type = LOCATION.LOCATION_TYPE;
		is_scrap = LOCATION.IS_SCRAP;
	}
	else
	{location_type ='';is_scrap =0;}

	if(is_cari)
	{
		if(isdefined("session.ep"))
			period_integrated = session.ep.period_is_integrated;
		else
			period_integrated = 1;
		
		kontrol_cari_row = 0;
		if(isdefined("attributes.subscription_id") and isdefined("attributes.subscription_no") and len(attributes.subscription_id) and len(attributes.subscription_no))
			attributes.subscription_id_ = attributes.subscription_id;
		else
			attributes.subscription_id_ = '';
		if(is_due_date_based_cari eq 1 and not isdefined("session.ww")) //vade bazında carilestirme yapılıyorsa
		{
			include('invoice_sale_cari_process.cfm');
			for(ind_d=1;ind_d lte listlen(row_duedate_list); ind_d=ind_d+1)
			{
				kontrol_cari_row = 1;
				temp_list_row_=listgetat(row_duedate_list,ind_d);
				cari_row_duedate = date_add("d",listlast(temp_list_row_,'_'),attributes.invoice_date);
				//bedelsiz ihracat yapildigi zaman cari kayitlarinda 0 olarak gitmesi gerekiyor 
				if(isdefined("inv_profile_id") and inv_profile_id is 'BEDELSIZIHRACAT')
				{
					islem_tutari_ = 0;
					islem_tutari_other_value_ = 0;
				}
				else 
				{
					islem_tutari_ = (is_expensing_bsmv eq 1 and IsDefined("form.row_bsmv_amount#temp_list_row_#")) ? evaluate('duedate_amount_total_#temp_list_row_#') - evaluate("form.row_bsmv_amount#temp_list_row_#") : evaluate('duedate_amount_total_#temp_list_row_#');
					islem_tutari_other_value_ = evaluate('duedate_other_amount_total_#temp_list_row_#');
				}
				carici(
					action_id : get_invoice_id.max_id,
					action_table : 'INVOICE',
					workcube_process_type : INVOICE_CAT,
					account_card_type : 12,
					islem_tarihi : attributes.invoice_date,
					due_date : cari_row_duedate,
					islem_tutari :islem_tutari_,
					islem_belge_no : FORM.INVOICE_NUMBER,
					action_detail : note,
					to_cmp_id : attributes.company_id,
					to_consumer_id : attributes.consumer_id,
					to_employee_id : attributes.employee_id,
					to_branch_id : to_branch_id,
					islem_detay : DETAIL_,
					acc_type_id : attributes.acc_type_id,
					other_money_value : islem_tutari_other_value_,
					other_money : listfirst(temp_list_row_,'_'),
					action_currency : session_base.money,
					action_currency_2 : session_base.money2,
					period_is_integrated : period_integrated,
					process_cat : form.process_cat,
					currency_multiplier : attributes.currency_multiplier,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
					subscription_id: iif((isdefined("attributes.row_subscription_id#ind_d#") and len(evaluate('attributes.row_subscription_id#ind_d#')) and isdefined("attributes.row_subscription_name#ind_d#") and len(evaluate('attributes.row_subscription_name#ind_d#'))),evaluate("attributes.row_subscription_id#ind_d#"),attributes.subscription_id_),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier,
					cari_db : new_dsn2_group
				);
			}
		}
		else if(is_paymethod_based_cari eq 1 and not isdefined("session.ww"))
		{
			include('invoice_sale_cari_process.cfm');
			for(ind_t=1;ind_t lte listlen(row_duedate_list); ind_t=ind_t+1)
			{
				//bedelsiz ihracat yapildigi zaman cari kayitlarinda 0 olarak gitmesi gerekiyor 
				if(isdefined("inv_profile_id") and inv_profile_id is 'BEDELSIZIHRACAT')
				{
					islem_tutari_ = 0;
					islem_tutari_other_value_ = 0;
				}
				else 
				{
					//Eğer işlem tipinde bsmv yi giderleştir seçili ise bsmv tutarı total tutardan çıkarılır.
					islem_tutari_ = (is_expensing_bsmv eq 1 and IsDefined("form.row_bsmv_amount#ind_t#")) ? evaluate('row_amount_total_#ind_t#') - evaluate("form.row_bsmv_amount#ind_t#") : evaluate('row_amount_total_#ind_t#');
					islem_tutari_other_value_ = evaluate('row_other_amount_total_#ind_t#');
				}
				
				kontrol_cari_row = 1;
				cari_row_duedate=listgetat(row_duedate_list,ind_t);
				carici(
					action_id :get_invoice_id.max_id,
					action_table : 'INVOICE',
					workcube_process_type : INVOICE_CAT,
					account_card_type : 13,
					islem_tarihi : attributes.invoice_date,
					due_date : cari_row_duedate,
					islem_tutari :islem_tutari_,
					islem_belge_no :form.invoice_number,
					to_cmp_id : attributes.company_id,
					to_consumer_id : attributes.consumer_id,
					to_employee_id : attributes.employee_id,
					to_branch_id : to_branch_id,
					islem_detay : DETAIL_,
					acc_type_id : attributes.acc_type_id,
					action_detail : note,
					other_money_value : islem_tutari_other_value_,
					other_money : form.basket_money,
					action_currency : session_base.money,
					action_currency_2 : session_base.money2,
					process_cat : form.process_cat,
					currency_multiplier : attributes.currency_multiplier,
					period_is_integrated : period_integrated,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
					subscription_id: iif((isdefined("attributes.row_subscription_id#ind_t#") and len(evaluate('attributes.row_subscription_id#ind_t#')) and isdefined("attributes.row_subscription_name#ind_t#") and len(evaluate('attributes.row_subscription_name#ind_t#'))),evaluate("attributes.row_subscription_id#ind_t#"),attributes.subscription_id_),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier,
					cari_db : new_dsn2_group
					);
			}
		}
		else if(is_row_project_based_cari eq 1 and not isdefined("session.ww"))
		{
			kontrol_cari_row = 1;
			include('invoice_sale_cari_process.cfm');
		}
		if(kontrol_cari_row eq 0)
		{
			//bedelsiz ihracat yapildigi zaman cari kayitlarinda 0 olarak gitmesi gerekiyor 
			if(isdefined("inv_profile_id") and inv_profile_id is 'BEDELSIZIHRACAT')
			{
				islem_tutari_ = 0;
				islem_tutari_other_value_ = 0;
			}
			else if(is_export_registered eq 1 or is_export_product eq 1)
			{
				islem_tutari_ = form.basket_net_total - form.basket_tax_total - form.basket_otv_total;
				islem_tutari_other_value_ = ( form.basket_net_total - form.basket_tax_total - form.basket_otv_total )/form.basket_rate2;
			}
			else 
			{
				islem_tutari_ = (is_expensing_bsmv eq 1 and IsDefined("form.total_bsmv")) ? form.basket_net_total - form.total_bsmv : form.basket_net_total;
				islem_tutari_other_value_ = islem_tutari_ / form.basket_rate2;
			}
			
			carici(
				action_id : get_invoice_id.max_id,
				action_table : 'INVOICE',
				workcube_process_type : INVOICE_CAT,
				account_card_type : 12,
				islem_tarihi : attributes.invoice_date,
				due_date : invoice_due_date,
				islem_tutari : islem_tutari_,
				islem_belge_no : FORM.INVOICE_NUMBER,
				action_detail : note,
				to_cmp_id : attributes.company_id,
				to_consumer_id : attributes.consumer_id,
				to_employee_id : attributes.employee_id,
				to_branch_id : to_branch_id,
				islem_detay : DETAIL_,
				acc_type_id : attributes.acc_type_id,
				other_money_value : islem_tutari_other_value_,
				other_money : form.basket_money,
				action_currency : session_base.money,
				action_currency_2 : session_base.money2,
				period_is_integrated : period_integrated,
				process_cat : form.process_cat,
				currency_multiplier : attributes.currency_multiplier,
				project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
				subscription_id: attributes.subscription_id_,
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:paper_currency_multiplier,
				cari_db : new_dsn2_group
			);
		}
	}

	if(is_account eq 1)  //fatura muhasebe
	{	
		if (isDefined('form.stopaj_rate_id') and len(form.stopaj_rate_id))//stopaj popuptan seçilmişse
			GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#new_dsn2_group#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #form.stopaj_rate_id#");
		else if (isDefined('form.stopaj_yuzde'))
			GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#new_dsn2_group#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE = #form.stopaj_yuzde#");
		if (invoice_cat eq 531 and IsDefined("attributes.realization_date") and len(attributes.realization_date)) 
			realization_date_ = attributes.realization_date;

		include('invoice_sale_account_process.cfm');
		muhasebeci(
			wrk_id : wrk_id,
			action_id : get_invoice_id.max_id,
			workcube_process_type : INVOICE_CAT,
			workcube_process_cat:process_cat,
			account_card_type : 13,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			islem_tarihi :iif(isdefined("realization_date_") and len(realization_date_), "realization_date_", DE('#attributes.invoice_date#')),
			borc_hesaplar : str_borclu_hesaplar,
			action_currency : session_base.money,
			action_currency_2 : session_base.money2,
			base_period_year : session_base.period_year,
			borc_tutarlar : str_borclu_tutarlar,
			other_amount_borc : str_dovizli_borclar,
			other_currency_borc : str_other_currency_borc,
			alacak_hesaplar : str_alacakli_hesaplar,
			alacak_tutarlar : str_alacakli_tutarlar,
			other_amount_alacak : str_dovizli_alacaklar,
			other_currency_alacak :str_other_currency_alacak,
			alacak_miktarlar : str_alacak_miktar,
			alacak_birim_tutar : str_alacak_tutar,
			to_branch_id : to_branch_id,
			acc_department_id : acc_department_id,
			fis_detay : "#DETAIL_1#",
			fis_satir_detay : satir_detay_list,
			belge_no : form.invoice_number,
			is_account_group : is_account_group,
			currency_multiplier : attributes.currency_multiplier,
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:str_round_detail,
			is_abort : iif(isdefined('xml_import'),0,1),
			acc_project_id : main_project_id,
			acc_project_list_alacak : acc_project_list_alacak,
			acc_project_list_borc : acc_project_list_borc,
			muhasebe_db : new_dsn2_group
		);
	}
</cfscript>
<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2_group#">
	UPDATE INVOICE SET IS_PROCESSED=#is_account# WHERE INVOICE_ID=#get_invoice_id.max_id#
</cfquery>

<cfif next_periods_accrual_action eq 1>
	<cfscript>
		if(isDefined('form.invoice_id')) {
			accrual_invoice_id = form.invoice_id;
		} else if(isDefined('get_invoice_id.max_id')) {
			accrual_invoice_id = get_invoice_id.max_id;
		}
	</cfscript>
	<cfquery name = "get_budget_plan" datasource = "#new_dsn2_group#">
		SELECT * FROM #dsn#.BUDGET_PLAN WHERE INVOICE_ID = #accrual_invoice_id#
	</cfquery>
	<cfinclude template = "invoice_accrual_action.cfm">
</cfif>