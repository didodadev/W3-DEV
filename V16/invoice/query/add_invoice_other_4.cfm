<cfif isdefined("form.cash")><!--- kasa seçili ise --->
	<cfscript>
		//Kasa Para Birimi Bulunarak Hesaplama Yapilir
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(Evaluate("attributes.str_kasa_parasi#kasa#") is Evaluate("attributes.hidden_rd_money_#mon#"))
					cash_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			}
	</cfscript>
	<cfquery name="get_cash_code" datasource="#dsn2#">
		SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID=#KASA#
	</cfquery>
	<cfif len(get_cash_code.branch_id)>
		<cfset cash_branch_id = get_cash_code.branch_id>
	<cfelse>
		<cfset cash_branch_id = ''>
	</cfif>
	<cfquery name="ADD_ALISF_KAPA" datasource="#dsn2#">
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
			RECORD_DATE
		)
		VALUES
		(
			#kasa#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#str_line_detail# Ödemesi">,
			34,
			#get_invoice_id.max_id#,
			#attributes.invoice_date#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#str_line_detail# Ödemesi">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
			<cfif session.ep.period_is_integrated>
				1,
				12,
			<cfelse>
				0,
				12,
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
			#wrk_round(form.basket_net_total-form.stopaj)#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
			<cfif len(session.ep.money2)>
				#wrk_round((form.basket_net_total-form.stopaj)/attributes.currency_multiplier,4)#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
			</cfif>
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#
		)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
	</cfquery>
	<cfset act_id=get_act_id.ACT_ID>

	<cfscript>
		if(is_cari eq 1)//kasa cari
		{
			carici(
				action_id : act_id,  
				action_table : 'CASH_ACTIONS',
				workcube_process_type : 34,
				workcube_old_process_type : 34,
				account_card_type : 12,
				islem_tarihi : attributes.invoice_date,
				islem_tutari : wrk_round(form.basket_net_total-form.stopaj),
				islem_belge_no : FORM.INVOICE_NUMBER,
				to_consumer_id : attributes.consumer_id,
				to_cmp_id : attributes.company_id,
				islem_detay : '#str_line_detail# Ödemesi',
				action_detail : note,
				other_money_value : wrk_round((form.basket_net_total-form.stopaj)/form.basket_rate2),
				other_money : form.basket_money,
				action_currency : session.ep.money,
				from_cash_id : kasa,
				from_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
				process_cat : 0,
				currency_multiplier : attributes.currency_multiplier,
				rate2:form.basket_rate2
				 );
		}
		
		if(is_account eq 1) // kasa muhasebe
		{
			muhasebeci(
				wrk_id='#wrk_id#',
				action_id : act_id,
				workcube_process_type : 34,
				workcube_old_process_type : 34,
				account_card_type : 12,//0,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				islem_tarihi : attributes.invoice_date,
				borc_hesaplar : acc,
				borc_tutarlar : wrk_round(form.basket_net_total-form.stopaj),
				other_amount_borc : wrk_round((form.basket_net_total-form.stopaj)/form.basket_rate2),
				other_currency_borc : form.basket_money,
				alacak_hesaplar : get_cash_code.cash_acc_code,
				alacak_tutarlar : wrk_round(form.basket_net_total-form.stopaj),
				other_amount_alacak : wrk_round((form.basket_net_total-form.stopaj)/form.basket_rate2),
				other_currency_alacak :form.basket_money,
				from_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
				fis_detay : '#str_line_detail# Ödemesi',
				fis_satir_detay : '#str_line_detail# Ödemesi',
				belge_no : form.invoice_number,
				is_account_group : is_account_group,
				currency_multiplier : attributes.currency_multiplier
			);
		}
	</cfscript>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			CASH_ID = #act_id#,
			KASA_ID = #kasa#,
			IS_CASH = 1,
			IS_ACCOUNTED = #cari_hesap_secili#
		WHERE
			INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
</cfif>
