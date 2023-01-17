<cfquery name="get_process_type_dekont" datasource="#dsn2#" maxrows="1">
	SELECT
		PROCESS_CAT_ID,
		IS_CARI,
		IS_ACCOUNT,
		IS_CHEQUE_BASED_ACTION
	FROM
		#dsn3_alias#.SETUP_PROCESS_CAT
	WHERE
		PROCESS_TYPE = 41
</cfquery>
<cfset process_cat_dekont = get_process_type_dekont.process_cat_id>
<cfset new_detail = '#attributes.payroll_no# No lu Yeni Ödeme Planı'>
<cfquery name="ADD_CASH_PAYMENT_IN_OP" datasource="#DSN2#">
	INSERT INTO
		CARI_ACTIONS
		(
			PROCESS_CAT,
			ACTION_NAME,
			ACTION_TYPE_ID,
			ACTION_VALUE,
			ACTION_CURRENCY_ID,
			OTHER_MONEY,
			OTHER_CASH_ACT_VALUE,
			TO_CMP_ID,								
			TO_CONSUMER_ID,
			ACTION_DETAIL,
			ACTION_DATE,
			PAPER_NO,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP								
		)
		VALUES
		(
			#process_cat_dekont#,
			'BORÇ DEKONTU',
			41,
			#fark_tutar#,
			'#session.ep.money#',
			'#session.ep.money#',
			#fark_tutar#,
			<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
			'#new_detail#',
			#attributes.payroll_revenue_date#,
			#attributes.payroll_no#,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#'						
		)					
</cfquery>
<cfquery name="GET_MAX" datasource="#dsn2#">
	SELECT MAX(ACTION_ID) AS ACTION_ID FROM CARI_ACTIONS
</cfquery>
<cfoutput query="get_moneys">
	<cfquery name="add_money_obj_bskt" datasource="#dsn2#">
		INSERT INTO 
			CARI_ACTION_MONEY 
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				#GET_MAX.ACTION_ID#,
				'#get_moneys.money#',
				#get_moneys.rate2#,
				#get_moneys.rate1#,
				<cfif get_moneys.money is session.ep.money>1<cfelse>0</cfif>					
			)
	</cfquery>
</cfoutput>	
<cfscript>
	act_other_money_value = fark_tutar;
	act_other_money = session.ep.money;
	if (is_cari eq 1)
	{
		carici(
			action_id : GET_MAX.ACTION_ID,
			islem_belge_no : attributes.payroll_no,
			process_cat : process_cat_dekont,
			workcube_process_type : 41,
			action_table : 'CARI_ACTIONS',
			islem_tutari : fark_tutar,
			action_currency : session.ep.money,
			other_money_value : fark_tutar,
			other_money : session.ep.money,
			islem_tarihi : attributes.payroll_revenue_date,
			islem_detay : 'BORÇ DEKONTU',
			action_detail : new_detail,
			to_cmp_id : attributes.company_id,
			to_consumer_id : attributes.consumer_id,
			currency_multiplier : currency_multiplier,
			account_card_type : 13,
			to_branch_id : listgetat(session.ep.user_location,2,'-')
			);

	}		
	if (is_account eq 1)
	{
		get_cash_acc_code=cfquery(datasource:"#dsn2#", sqlstring:"SELECT DUE_DIFF_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
		str_borc_hesap = acc;
		str_alacak_hesap = get_cash_acc_code.due_diff_acc_code;
		str_borc_tutar = fark_tutar;
		str_alacak_tutar = fark_tutar;
		fis_detay = "BORÇ DEKONTU";
		muhasebeci (
			action_id:GET_MAX.ACTION_ID,
			belge_no : attributes.payroll_no,
			workcube_process_type: 41,
			account_card_type:13,
			islem_tarihi:attributes.payroll_revenue_date,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			fis_detay:fis_detay,
			borc_hesaplar:str_borc_hesap,
			borc_tutarlar:str_borc_tutar,
			other_amount_borc : act_other_money_value,
			other_currency_borc : act_other_money,
			alacak_hesaplar:str_alacak_hesap,
			alacak_tutarlar:str_alacak_tutar,
			other_amount_alacak : act_other_money_value,
			other_currency_alacak : act_other_money,
			fis_satir_detay: new_detail,
			currency_multiplier : currency_multiplier,
			to_branch_id : listgetat(session.ep.user_location,2,'-'),
			workcube_process_cat : process_cat_dekont
		);		
	}
</cfscript>
