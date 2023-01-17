<cfif isdefined("form.cash")  and len(kasa) and invoice_cat neq 531><!--- Kasa Islemi Secili Ise --->
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
		SELECT BRANCH_ID,CASH_ACC_CODE FROM CASH WHERE CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#kasa#">
	</cfquery>
	<cfif len(get_cash_code.branch_id)><!--- carici ve muhasebecide kullanılıyor --->
		<cfset cash_branch_id = get_cash_code.branch_id>
	<cfelse>
		<cfset cash_branch_id = ''>
	</cfif>
	<cfif len(get_number.cash_id)>
		<cfquery name="control_cash_action" datasource="#dsn2#">
			SELECT ACTION_ID FROM CASH_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_number.cash_id#">
		</cfquery>
	</cfif>
	<cfif len(get_number.cash_id) and control_cash_action.recordcount><!--- eski kasa hareketlerini sil --->
		<cfquery name="UPD_SATISF_KAPA" datasource="#dsn2#">
			UPDATE
				CASH_ACTIONS
			SET
				CASH_ACTION_TO_CASH_ID = #kasa#,
				ACTION_TYPE_ID = 35,
				BILL_ID = #form.invoice_id#,
				ACTION_DATE = #attributes.invoice_date#,
				PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
				IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 11,
				IS_PROCESSED = #is_account#,
				PROCESS_CAT = 0,
				<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.comp_name") and len(attributes.comp_name)>
					CASH_ACTION_FROM_COMPANY_ID = #attributes.company_id#,
				<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
					CASH_ACTION_FROM_CONSUMER_ID = #attributes.consumer_id#,
				<cfelse>
					CASH_ACTION_FROM_EMPLOYEE_ID = #attributes.employee_id#,
				</cfif>
				CASH_ACTION_VALUE = #wrk_round(form.basket_net_total/cash_currency_multiplier,4)#,
				CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('attributes.str_kasa_parasi#kasa#')#">,
				OTHER_CASH_ACT_VALUE = #form.basket_net_total/form.basket_rate2#,
				OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BASKET_MONEY#">,
				ACTION_VALUE = #form.basket_net_total#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				<cfif len(session.ep.money2)>
					ACTION_VALUE_2 = #wrk_round(form.basket_net_total/attributes.currency_multiplier,4)#,
					ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
				</cfif>
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = #now()#
			WHERE
				ACTION_ID = #get_number.cash_id#
		</cfquery>
		<cfset act_id = get_number.cash_id>
	<cfelse>
		<cfquery name="ADD_SATISF_KAPA" datasource="#dsn2#">
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
				#form.invoice_id#,
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
		<cfquery name="GET_ACT_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
		</cfquery>
		<cfset act_id = get_act_id.act_id>
	</cfif>
	<cfscript>
		if(is_cari eq 1) //kasa cari
		{
			carici(
				action_id : act_id,  
				action_table : 'CASH_ACTIONS',
				workcube_process_type : 35,
				workcube_old_process_type : 35,
				account_card_type : 11,
				islem_tarihi : attributes.invoice_date,
				due_date : invoice_due_date,
				islem_tutari : form.basket_net_total,
				islem_belge_no : form.invoice_number,
				from_consumer_id : attributes.consumer_id,
				from_cmp_id : attributes.company_id,
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
		else
		{
			if(len(get_number.cash_id))
				cari_sil(action_id:get_number.cash_id, process_type:35);
		}
		
		//kasa muhasebe
		if(is_account eq 1)
		{
			DETAIL_2 = str_line_detail & " KAPAMA İŞLEMİ";
			muhasebeci(
				action_id : act_id,
				workcube_process_type : 35,
				workcube_old_process_type : 35,
				account_card_type : 11,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				islem_tarihi : attributes.invoice_date,
				borc_hesaplar : get_cash_code.cash_acc_code,
				borc_tutarlar : wrk_round(form.basket_net_total),
				other_amount_borc : wrk_round(form.basket_net_total/cash_currency_multiplier),
				other_currency_borc : Evaluate("attributes.str_kasa_parasi#kasa#"),
				alacak_hesaplar : acc,
				alacak_tutarlar : wrk_round(form.basket_net_total),
				other_amount_alacak : wrk_round(form.basket_net_total/form.basket_rate2),
				other_currency_alacak :form.basket_money,
				fis_detay : '#detail_2#',
				fis_satir_detay : 'Satış Faturası Kapama İşlemi',
				belge_no : form.invoice_number,
				is_account_group : is_account_group,
				to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
				currency_multiplier : attributes.currency_multiplier
			);
		}
		else
		{
			if(len(get_number.cash_id))
				muhasebe_sil(action_id:get_number.cash_id, process_type:35);
		}
	</cfscript>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			CASH_ID = #act_id#,
			KASA_ID = #kasa#,
			IS_CASH = 1,
			IS_ACCOUNTED = #is_account#
		WHERE
			INVOICE_ID=#form.invoice_id#
	</cfquery>
<cfelse>
	<cfif len(get_number.cash_id)><!--- eski kasa hareketlerini sil --->
		<cfquery name="DEL_CASH" datasource="#dsn2#">
			DELETE FROM	CASH_ACTIONS WHERE ACTION_ID=#GET_NUMBER.CASH_ID#
		</cfquery>
		<cfscript>
			muhasebe_sil(action_id:get_number.cash_id, process_type:35);
			cari_sil(action_id:get_number.cash_id, process_type:35);
		</cfscript>	
	</cfif>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			CASH_ID = NULL,
			KASA_ID = NULL,
			IS_CASH = 0,
			IS_ACCOUNTED = 0
		WHERE
			INVOICE_ID = #form.invoice_id#
	</cfquery>
</cfif>
