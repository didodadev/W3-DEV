<cfscript>
	/*if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
		to_branch_id = attributes.branch_id;
	else
		to_branch_id = '';*/
		
	if( len(ListGetAt(session.ep.user_location,2,"-")))
		to_branch_id = ListGetAt(session.ep.user_location,2,"-");
	else
		to_branch_id = '';

	if(is_cari) //fatura cari
		{
			carici(
			action_id : form.invoice_id,
			action_table : 'INVOICE',
			workcube_process_type : INVOICE_CAT,
			workcube_old_process_type : form.old_process_type,
			account_card_type : 13,
			islem_tarihi : attributes.invoice_date,
			islem_tutari : form.basket_net_total ,
			islem_belge_no : FORM.INVOICE_NUMBER ,
			to_cmp_id : attributes.company_id,
			to_consumer_id : attributes.consumer_id,
			to_branch_id :iif(len(to_branch_id),de('#to_branch_id#'),de('')),
			due_date : invoice_due_date,
			islem_detay : DETAIL_,
			action_detail : note,
			other_money_value : form.basket_net_total/form.basket_rate2,
			other_money : form.basket_money,
			action_currency : SESSION.EP.MONEY,
			process_cat : form.process_cat,
			currency_multiplier : attributes.currency_multiplier,
			assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')) ,
			rate2:paper_currency_multiplier
			 );	
		}
	else
		{ cari_sil(action_id:form.invoice_id, process_type:form.old_process_type); }
		
	if(is_account)  //fatura muhasebe
	{	
		include('invoice_retail_account_process.cfm');
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
			alacak_hesaplar : str_alacakli_hesaplar,			
			alacak_tutarlar : str_alacakli_tutarlar,
			other_amount_alacak : str_dovizli_alacaklar,
			other_currency_borc : str_other_currency_borc,
			other_currency_alacak :str_other_currency_alacak,
			alacak_miktarlar : str_alacak_miktar,
			alacak_birim_tutar : str_alacak_tutar,
			to_branch_id :iif(len(to_branch_id),de('#to_branch_id#'),de('')),
			fis_detay : '#DETAIL_1#',
			fis_satir_detay : satir_detay_list,
			belge_no : form.invoice_number,
			is_account_group : is_account_group,
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:str_round_detail,
			currency_multiplier : attributes.currency_multiplier ,
			acc_project_id : main_project_id,
			acc_project_list_alacak : acc_project_list_alacak,
			acc_project_list_borc : acc_project_list_borc
			);
	}
	else
		muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type);
</cfscript>
<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
	UPDATE INVOICE SET IS_PROCESSED = #is_account# WHERE INVOICE_ID = #form.invoice_id#
</cfquery>
