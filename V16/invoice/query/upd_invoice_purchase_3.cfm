<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = ''></cfif>
<cfscript>
	/*if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
		from_branch_id = attributes.branch_id;
	else
		from_branch_id = '';*/
		
	// Şube Bilgisi Depo Şubesinden Alınsın XML seçeneği Evet seçilirse carici ve muhasebeciye giden şubeler faturada seçili olan deponun şubesi olur
	if(isDefined("attributes.xml_get_branch_from_department") AND attributes.xml_get_branch_from_department EQ 1)
		to_branch_id = attributes.branch_id;
	else if(len(ListGetAt(session.ep.user_location,2,"-")))
		to_branch_id = ListGetAt(session.ep.user_location,2,"-");
	else
		to_branch_id = '';

	if(isDefined("attributes.xml_get_branch_from_department") AND attributes.xml_get_branch_from_department EQ 1)
		from_branch_id = attributes.branch_id;
	else if(len(ListGetAt(session.ep.user_location,2,"-")))
		from_branch_id = ListGetAt(session.ep.user_location,2,"-");
	else
		from_branch_id = '';

	if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
		acc_department_id = attributes.acc_department_id;
	else
		acc_department_id = '';

	if(not isdefined("attributes.employee_id"))
		attributes.employee_id = '';
		
	if((isDefined("attributes.invoice_payment_plan") and attributes.invoice_payment_plan eq 1) or not isDefined("attributes.invoice_payment_plan"))//odeme planini guncellememesi icin eklendi
	{
		if(is_cari)//fatura cari
		{ /*alış faturalarında vade bazında carilestirme-belge bazında carileştirme islemlerinin geçişlerinde sorun olmaması icin herhalukarda cari hareketi 
		silinip yeniden olusturuluyor. bu nedenle workcube_old_process_type cariciye gonderilmiyor*/
			if(GET_INV_INFO.NETTOTAL neq attributes.basket_net_total or GET_INV_INFO.DUE_DATE neq invoice_due_date)//eğer vadesi veya tutarı değişmişse kapama işlemini de siliyor
				cari_sil(action_id:form.invoice_id,process_type:form.old_process_type); //herhalukarda cari islemi silinip yeniden olusturuluyor
			else
				cari_sil(action_id:form.invoice_id,process_type:form.old_process_type,inv_related_info:1); //herhalukarda cari islemi silinip yeniden olusturuluyor
			kontrol_cari_row = 0;
			if(is_due_date_based_cari eq 1) //vade bazında carilestirme yapılıyorsa
			{
				include('invoice_sale_cari_process.cfm');
				for(ind_d=1;ind_d lte listlen(row_duedate_list); ind_d=ind_d+1)
				{
					kontrol_cari_row = 1;
					temp_list_row_=listgetat(row_duedate_list,ind_d);
					cari_row_duedate = date_add("d",listlast(temp_list_row_,'_'),attributes.invoice_date);
					carici(
						action_id : form.invoice_id,  
						action_table : 'INVOICE',
						workcube_process_type : INVOICE_CAT,
						account_card_type : 13,
						islem_tarihi : attributes.invoice_date,
						due_date : cari_row_duedate,
						islem_tutari : evaluate('duedate_amount_total_#temp_list_row_#'),
						islem_belge_no : FORM.INVOICE_NUMBER,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						from_employee_id : attributes.employee_id,
						from_branch_id : from_branch_id,
						islem_detay : DETAIL_,
						acc_type_id : attributes.acc_type_id,
						action_detail : note,
						other_money_value :evaluate('duedate_other_amount_total_#temp_list_row_#'),
						other_money : listfirst(temp_list_row_,'_'),
						action_currency : SESSION.EP.MONEY,
						process_cat : form.process_cat,
						currency_multiplier : attributes.currency_multiplier,
						project_id :  iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
						subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_name") and len(attributes.subscription_name)),'attributes.subscription_id',de('')),
						assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
						rate2:paper_currency_multiplier
						);
				}
			}
			else if(is_paymethod_based_cari eq 1 and isdefined('attributes.paymethod_id') and len(attributes.paymethod_id))
			{
				include('invoice_sale_cari_process.cfm');
				for(ind_t=1;ind_t lte listlen(row_duedate_list); ind_t=ind_t+1)
				{
					kontrol_cari_row = 1;
					cari_row_duedate=listgetat(row_duedate_list,ind_t);
					carici(
						action_id : form.invoice_id,
						action_table : 'INVOICE',
						workcube_process_type : INVOICE_CAT,
						account_card_type : 13,
						islem_tarihi : attributes.invoice_date,
						due_date : cari_row_duedate,
						islem_tutari :evaluate('row_amount_total_#ind_t#'),
						islem_belge_no :form.invoice_number,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						from_employee_id : attributes.employee_id,
						islem_detay : DETAIL_,
						acc_type_id : attributes.acc_type_id,
						action_detail : note,
						from_branch_id : from_branch_id,
						other_money_value : evaluate('row_other_amount_total_#ind_t#'),
						other_money : form.basket_money,
						action_currency : session.ep.money,
						process_cat : form.process_cat,
						currency_multiplier : attributes.currency_multiplier,
						project_id :  iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
						subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_name") and len(attributes.subscription_name)),'attributes.subscription_id',de('')),
						assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
						rate2:paper_currency_multiplier
						);
				}
			}
			else if(is_row_project_based_cari eq 1)
			{
				kontrol_cari_row = 1;
				include('invoice_sale_cari_process.cfm');
			}
			if(kontrol_cari_row eq 0)
			{
				carici(
					action_id : form.invoice_id,  
					action_table : 'INVOICE',
					workcube_process_type : INVOICE_CAT,
					account_card_type : 13,
					islem_tarihi : attributes.invoice_date,
					due_date : invoice_due_date,
					islem_tutari : attributes.basket_net_total,
					islem_belge_no : FORM.INVOICE_NUMBER,
					from_cmp_id : attributes.company_id,
					from_consumer_id : attributes.consumer_id,
					from_employee_id : attributes.employee_id,
					from_branch_id : from_branch_id,
					islem_detay : DETAIL_,
					acc_type_id : attributes.acc_type_id,
					action_detail : note,
					other_money_value : attributes.basket_net_total/attributes.basket_rate2,
					other_money : attributes.basket_money,
					action_currency : SESSION.EP.MONEY,
					process_cat : form.process_cat,
					currency_multiplier : attributes.currency_multiplier,
					project_id :  iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
					subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_name") and len(attributes.subscription_name)),'attributes.subscription_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
		}
		else
			cari_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	}

	if(is_account)  //fatura muhasebe
	{
		if (isDefined('form.stopaj_rate_id') and len(form.stopaj_rate_id))//stopaj popuptan seçilmişse
			GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #form.stopaj_rate_id#");
		else if (isDefined('form.stopaj_yuzde'))
			GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE = #form.stopaj_yuzde#");

		include('invoice_account_process.cfm');
		muhasebeci(
			action_id : form.invoice_id,
			workcube_process_type : INVOICE_CAT,
			workcube_old_process_type : form.old_process_type,
			workcube_process_cat:process_cat,
			account_card_type : 13,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			islem_tarihi : attributes.invoice_date,
			borc_hesaplar : str_borclu_hesaplar,
			borc_tutarlar : str_borclu_tutarlar,
			other_amount_borc : str_dovizli_borclar,
			other_currency_borc : str_other_currency_borc,
			alacak_hesaplar : str_alacakli_hesaplar,
			alacak_tutarlar : str_alacakli_tutarlar,
			other_amount_alacak : str_dovizli_alacaklar,
			other_currency_alacak :str_other_currency_alacak,
			borc_miktarlar : str_borclu_miktar,
			borc_birim_tutar : str_borclu_tutar,
			from_branch_id : from_branch_id,
			acc_department_id : acc_department_id,
			fis_detay : '#DETAIL_1#',
			fis_satir_detay : satir_detay_list,
			belge_no : form.invoice_number,
			is_account_group : is_account_group,
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:str_round_detail,
			currency_multiplier : attributes.currency_multiplier,
			acc_project_id : main_project_id,
			acc_project_list_alacak : acc_project_list_alacak,
			acc_project_list_borc : acc_project_list_borc
		);
	}
	else
		muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type, belge_no:form.invoice_number);
</cfscript>
<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
	UPDATE INVOICE SET IS_PROCESSED=#is_account# WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<!--- Ödeme taleplerinde vade tarihi güncellenince talepler silindiği için sorun oluyordu, Ersanda sorun olmaması için tek satırlı cari hareketlerde 
kapama va talepler silinmeyecek şekilde düzenlendi. --->
<cfquery name="GET_CARI" datasource="#dsn2#">
	SELECT ACTION_ID,CARI_ACTION_ID,ACTION_TABLE,DUE_DATE,ACTION_TYPE_ID FROM CARI_ROWS WHERE ACTION_ID = #form.invoice_id# AND ACTION_TYPE_ID = #INVOICE_CAT#
</cfquery>
<cfif get_cari.recordcount eq 1 and isdefined('cari_row_duedate') and len(cari_row_duedate)>
	<cfquery name="UPD_CARI" datasource="#dsn2#">
		UPDATE
			CARI_CLOSED_ROW
		SET
			DUE_DATE = #cari_row_duedate#
		WHERE
			ACTION_ID = #form.invoice_id# 
			AND ACTION_TYPE_ID = #INVOICE_CAT#
	</cfquery>
</cfif>

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