<cfif isdefined("form.cash") and len(kasa) and invoice_cat neq 591><!--- Kasa Islemi Secili Ise --->
	<cfscript>
		//Kasa Para Birimi Bulunarak Hesaplama Yapilir
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(Evaluate("attributes.str_kasa_parasi#kasa#") is Evaluate("attributes.hidden_rd_money_#mon#"))
					cash_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			}
	</cfscript>
	<cfquery name="get_cash_code" datasource="#new_dsn2_group#" >
		SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#kasa#">
	</cfquery>
	<cfif len(get_cash_code.branch_id)><!--- carici ve muhasebecide kullanılıyor --->
		<cfset cash_branch_id = get_cash_code.branch_id>
	<cfelse>
		<cfset cash_branch_id = ''>
	</cfif>
	<cfquery name="ADD_ALISF_KAPA" datasource="#new_dsn2_group#">
		INSERT INTO
			CASH_ACTIONS
		(
			CASH_ACTION_FROM_CASH_ID,
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
				CASH_ACTION_TO_COMPANY_ID,
			<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
				CASH_ACTION_TO_CONSUMER_ID,
			<cfelse>
				CASH_ACTION_TO_EMPLOYEE_ID,
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
			RECORD_DATE,
			PROJECT_ID
		)
		VALUES
		(
			#KASA#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="ALIŞ FATURASI KAPAMA İŞLEMİ">,
			34,
			#get_invoice_id.max_id#,
			#attributes.invoice_date#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="ALIŞ FATURASI KAPAMA İŞLEMİ">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
			<cfif is_account eq 1>
				1,
				12,
			<cfelse>
				0,
				12,
			</cfif>
			1,
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
			#now()#,
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>
		)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#new_dsn2_group#">
		SELECT MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
	</cfquery>
	<cfset act_id = get_act_id.act_id>
	<cfquery name="UPD_INVOICE_LAST" datasource="#new_dsn2_group#">
		UPDATE INVOICE SET CASH_ID = #act_id# WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
	<cfscript>
		if(is_cari eq 1)//kasa carici
		{
			carici(
				action_id : act_id,  
				action_table : 'CASH_ACTIONS',
				workcube_process_type : 34,
				account_card_type : 12,
				islem_tarihi : attributes.invoice_date,
				due_date : invoice_due_date,
				islem_tutari : form.basket_net_total,
				islem_belge_no : form.invoice_number,
				to_cmp_id : attributes.company_id,
				to_consumer_id : attributes.consumer_id,
				to_employee_id : attributes.employee_id,
				from_cash_id : kasa,
				from_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),				
				islem_detay : 'ALIŞ FATURASI KAPAMA İŞLEMİ',
				action_detail : note,
				other_money_value : form.basket_net_total/form.basket_rate2,
				other_money : form.basket_money,
				action_currency : session.ep.money,
				process_cat : 0,
				currency_multiplier : attributes.currency_multiplier,
				project_id :  iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
				rate2:paper_currency_multiplier
				);
		}
		if(is_account eq 1) //kasa muhasebeci
		{
			DETAIL_2 = DETAIL_ & " KAPAMA ISLEMI";
			muhasebeci(
				wrk_id='#wrk_id#',
				action_id : ACT_ID,
				workcube_process_type : 34,
				account_card_type : 12,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				islem_tarihi : attributes.invoice_date,
				borc_hesaplar : ACC,
				borc_tutarlar : wrk_round(form.basket_net_total),
				other_amount_borc : wrk_round(form.basket_net_total/form.basket_rate2),
				other_currency_borc : form.basket_money,
				alacak_hesaplar : get_cash_code.CASH_ACC_CODE,
				alacak_tutarlar : wrk_round(form.basket_net_total),
				other_amount_alacak : wrk_round(form.basket_net_total/cash_currency_multiplier),
				other_currency_alacak :Evaluate("attributes.str_kasa_parasi#kasa#"),
				from_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
				fis_detay : '#DETAIL_2#',
				fis_satir_detay : 'Alış Fatura Kapama',
				belge_no : form.invoice_number,
				is_account_group : is_account_group,
				currency_multiplier : attributes.currency_multiplier,
				acc_project_list_alacak : acc_project_list_alacak,
				acc_project_list_borc : acc_project_list_borc
			);
		}
	</cfscript>
	<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2_group#">
		UPDATE INVOICE SET IS_ACCOUNTED = #is_account# WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
<cfelseif isdefined("attributes.bank") or isdefined("attributes.credit")>
	<cfscript>
		if(isdefined("attributes.bank")){
			string_acc_code = acc;
			string_currency_id = attributes.currency_id;
		}
		else if(isdefined("attributes.credit")){
			account_id_first = listgetat(attributes.credit_card_info,1,';');
			action_curreny = listgetat(attributes.credit_card_info,2,';');
			account_id_last = listgetat(attributes.credit_card_info,3,';');
			get_credit_ = cfquery(datasource : "#new_dsn2_group#", sqlstring : "SELECT ACCOUNT_CODE FROM #dsn3#.CREDIT_CARD WHERE CREDITCARD_ID = #account_id_last#");
			string_acc_code = acc;
			string_currency_id = listgetat(attributes.credit_card_info,2,';');
			cc_rate=1;
		}

		if(isDefined('attributes.kur_say') and len(attributes.kur_say)){
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(isdefined('attributes.credit') and evaluate("attributes.hidden_rd_money_#mon#") is listgetat(attributes.credit_card_info,2,';'))
					currency_multiplier_kk = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(isdefined('attributes.bank') and evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
					currency_multiplier_banka = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
					currency_multiplier_money2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(attributes.rd_money, ','))
				{
					rd_money_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
				"last_rate_1_#evaluate("attributes.hidden_rd_money_#mon#")#" = evaluate('attributes.txt_rate1_#mon#');
			}
		}

		if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)) main_project_id = attributes.project_id; else main_project_id = 0;

		attributes.acc_type_id = '';
		if(listlen(attributes.employee_id,'_') eq 2)
		{
			attributes.acc_type_id = listlast(attributes.employee_id,'_');
			attributes.employee_id = listfirst(attributes.employee_id,'_');
		}
	</cfscript>

	<cfif isdefined("attributes.bank")>
		<cfinclude template="add_invoice_bank_action.cfm">
	</cfif>

	<cfif isdefined("attributes.credit")>
		<cfinclude template="add_invoice_creditcard_action.cfm">
	</cfif>

	<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2_group#">
		UPDATE INVOICE SET IS_ACCOUNTED = #is_account# WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
<cfelse>
	<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2_group#">
		UPDATE INVOICE SET IS_ACCOUNTED = 0 WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
</cfif>
