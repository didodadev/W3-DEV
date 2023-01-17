<!--- cari --->
<cfscript>
	/*if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
		from_branch_id = attributes.branch_id;
	else
		from_branch_id = '';*/
	
	if( len(ListGetAt(session.ep.user_location,2,"-")))
		from_branch_id = ListGetAt(session.ep.user_location,2,"-");
	else
		from_branch_id = '';

	if(is_cari)
	{
		carici(
			action_id : form.invoice_id,
			action_table : 'INVOICE',
			workcube_process_type : INVOICE_CAT,
			workcube_old_process_type : form.old_process_type,
			account_card_type : 13,
			islem_tarihi : attributes.invoice_date,
			islem_tutari : (attributes.basket_net_total-form.stopaj),
			islem_belge_no : FORM.INVOICE_NUMBER,
			from_cmp_id : attributes.company_id,
			from_consumer_id : attributes.consumer_id,
			from_branch_id :iif(len(from_branch_id),de('#from_branch_id#'),de('')),
			islem_detay : str_line_detail,
			action_detail : note,
			due_date : invoice_due_date,
			other_money_value : wrk_round((attributes.basket_net_total-form.stopaj)/attributes.basket_rate2),
			other_money : attributes.basket_money,
			action_currency : SESSION.EP.MONEY,
			process_cat : form.process_cat,
			currency_multiplier : attributes.currency_multiplier,
			project_id :  iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
			assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
			rate2:paper_currency_multiplier
			 );
	}
	else
		cari_sil(action_id:form.invoice_id, process_type:form.old_process_type);

	if(is_account)
	{
		if (isDefined('form.stopaj_rate_id') and len(form.stopaj_rate_id) and form.stopaj_rate_id neq 0)//stopaj popuptan seçilmişse
			GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #form.stopaj_rate_id#");
		else
			GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE = #form.stopaj_yuzde#");
			
			GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
		include('invoice_other_account_process.cfm');
		
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
			from_branch_id :iif(len(from_branch_id),de('#from_branch_id#'),de('')),
			borc_miktarlar : str_borclu_miktar,
			borc_birim_tutar : str_borclu_tutar,
			fis_detay : str_line_detail,
			fis_satir_detay : satir_detay_list,
			belge_no : form.invoice_number,
			is_account_group : is_account_group,
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:str_round_detail,
			currency_multiplier : attributes.currency_multiplier,
			acc_department_id : attributes.acc_department_id,
			acc_project_id : main_project_id,
			acc_project_list_alacak : acc_project_list_alacak,
			acc_project_list_borc : acc_project_list_borc
		);
	}
	else
		muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	</cfscript>
<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
	UPDATE INVOICE SET IS_PROCESSED=#session.ep.period_is_integrated# WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<!--- // muhasebe --->
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
