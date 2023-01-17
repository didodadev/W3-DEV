<cfif isdefined("form.cash") and len(kasa) and invoice_cat neq 531><!--- Kasa Islemi Secili Ise --->
	<cfscript>
		//Kasa Para Birimi Bulunarak Hesaplama Yapilir
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(Evaluate("attributes.str_kasa_parasi#kasa#") is Evaluate("attributes.hidden_rd_money_#mon#"))
					cash_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			}
	</cfscript>
	<cfquery name="get_cash_code" datasource="#new_dsn2_group#">
		SELECT BRANCH_ID,CASH_ACC_CODE FROM CASH WHERE CASH_ID = #kasa#
	</cfquery>
	<cfif len(get_cash_code.branch_id)><!--- carici ve muhasebecide kullanılıyor --->
		<cfset cash_branch_id = get_cash_code.branch_id>
	<cfelse>
		<cfset cash_branch_id = ''>
	</cfif>
	<cfquery name="ADD_SATISF_KAPA" datasource="#new_dsn2_group#">
		INSERT INTO
			 CASH_ACTIONS
		(
			CASH_ACTION_TO_CASH_ID,
			ACTION_TYPE,
			ACTION_TYPE_ID,
			BILL_ID,
			ACTION_DATE,
			ACTION_DETAIL,
			PAPER_NO,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			IS_PROCESSED,
			PROCESS_CAT,
			<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.comp_name") and len(attributes.comp_name)>
				CASH_ACTION_FROM_COMPANY_ID,
			<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
				CASH_ACTION_FROM_CONSUMER_ID,
			<cfelse>
				CASH_ACTION_FROM_EMPLOYEE_ID,
			</cfif>
			CASH_ACTION_VALUE,
			CASH_ACTION_CURRENCY_ID,
			OTHER_CASH_ACT_VALUE,
			OTHER_MONEY,
			ACTION_VALUE,
			ACTION_CURRENCY_ID,
			<cfif len(session.ep.money2)>
				ACTION_VALUE_2,
				ACTION_CURRENCY_ID_2,
			</cfif>
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		VALUES
		(
			#kasa#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="SATIŞ FATURASI KAPAMA İŞLEMİ">,
			35,
			#get_invoice_id.max_id#,
			#attributes.invoice_date#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="SATIŞ FATURASI KAPAMA İŞLEMİ">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
			<cfif is_account eq 1>
				1,
				11,
			<cfelse>
				0,
				11,
			</cfif>
			<cfif is_account>1<cfelse>0</cfif>,
			0,
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
				#attributes.company_id#,
			<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
				#attributes.consumer_id#,
			<cfelse>
				#attributes.employee_id#,
			</cfif>
			#wrk_round(form.basket_net_total/cash_currency_multiplier,4)#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('attributes.str_kasa_parasi#kasa#')#">,
			#form.basket_net_total/form.basket_rate2#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
			#form.basket_net_total#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
			<cfif len(session.ep.money2)>
				#wrk_round(form.basket_net_total/attributes.currency_multiplier,4)#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
			</cfif>
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#
		)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#new_dsn2_group#">
		SELECT MAX(ACTION_ID) AS ACT_ID	FROM CASH_ACTIONS
	</cfquery>
	<cfset act_id=get_act_id.act_id>
	<cfquery name="UPD_INVOICE_LAST" datasource="#new_dsn2_group#">
		UPDATE INVOICE SET CASH_ID = #act_id# WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>

	<cfscript>
		if(is_cari eq 1) //kasa cari
		{
			carici(
				action_id : ACT_ID,  
				action_table : 'CASH_ACTIONS',
				workcube_process_type : 35,
				account_card_type : 11,
				islem_tarihi : attributes.invoice_date,
				due_date : invoice_due_date,
				islem_tutari : form.basket_net_total ,
				islem_belge_no : FORM.INVOICE_NUMBER,
				from_cmp_id : attributes.company_id,
				from_consumer_id : attributes.consumer_id,
				from_employee_id : attributes.employee_id,
				islem_detay : 'SATIŞ FATURASI KAPAMA İŞLEMİ',
				action_detail : note,
				other_money_value : form.basket_net_total/form.basket_rate2,
				other_money : form.basket_money,
				action_currency : session.ep.money,
				to_cash_id : kasa,
				to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
				process_cat : 0,
				currency_multiplier : attributes.currency_multiplier,
				rate2:paper_currency_multiplier
			 );
		 }
		 
		 if(is_account eq 1) // kasa muhasebe 
		 {
			DETAIL_2 = DETAIL_ & " KAPAMA İŞLEMİ";
			muhasebeci(
				wrk_id='#wrk_id#',
				action_id : ACT_ID,
				workcube_process_type : 35,
				account_card_type : 11,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				islem_tarihi : attributes.invoice_date,
				borc_hesaplar : get_cash_code.CASH_ACC_CODE,
				borc_tutarlar : wrk_round(form.basket_net_total),
				other_amount_borc : wrk_round(form.basket_net_total/cash_currency_multiplier),
				other_currency_borc : Evaluate("attributes.str_kasa_parasi#kasa#"),
				alacak_hesaplar : ACC,
				alacak_tutarlar : wrk_round(form.basket_net_total),
				other_amount_alacak : wrk_round(form.basket_net_total/form.basket_rate2),
				other_currency_alacak :form.basket_money,
				to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
				fis_detay : '#DETAIL_2#',
				fis_satir_detay : 'Satış Fatura Kapama',
				belge_no : form.invoice_number,
				is_account_group : is_account_group,
				currency_multiplier : attributes.currency_multiplier
			);
		 }
	</cfscript>			
	<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2_group#">
		UPDATE INVOICE SET IS_ACCOUNTED = #is_account# WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
<cfelse>
	<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2_group#">
		UPDATE INVOICE SET IS_ACCOUNTED = 0 WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
</cfif>
