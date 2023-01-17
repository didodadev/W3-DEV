<!--- güncellemede bank işleminden kasa işlemine geçiş yaptı ise eski kasa işlemi ve kredi kartı siliniyor--->
<cfif isdefined("form.invoice_id")>
	<cfquery name="GET_CASH_ACTION" datasource="#dsn2#">
		SELECT ACTION_ID FROM CASH_ACTIONS WHERE BILL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
	</cfquery>
	<cfif get_cash_action.recordcount>
		<cfscript>
			cari_sil(action_id:GET_CASH_ACTION.ACTION_ID,process_type:32);
			muhasebe_sil (action_id:GET_CASH_ACTION.ACTION_ID,process_type:32);
		</cfscript>		
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CASH_ACTION.ACTION_ID#">
		</cfquery>
	</cfif>
	<cfquery name="GET_CREDIT_ACTION" datasource="#dsn2#">
		SELECT CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#"> AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfif get_credit_action.recordcount>
		<cfscript>
			cari_sil(action_id:GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID,process_type:242);
			muhasebe_sil (action_id:GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID,process_type:242);
		</cfscript>
		<cfquery name="DEL_CC_REVENUE_MONEY" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#">
		</cfquery>
		<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS WHERE CREDITCARD_EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#">
		</cfquery>
		<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE CREDITCARD_EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#">
		</cfquery>
	</cfif>
	<cfquery name="GET_BANK_ACTIONS" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE BILL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
	</cfquery>
<cfelse>
	<cfset get_bank_actions.recordcount = 0>
</cfif>
<cfset actionDetail = "#getLang('main',1760)#">
<cfif GET_BANK_ACTIONS.RECORDCOUNT>
	<cfquery name="UPD_BANK_PAYMENT" datasource="#dsn2#">
		UPDATE 
			BANK_ACTIONS 
		SET
			PROCESS_CAT=#attributes.process_cat#,
			ACTION_TYPE=#sql_unicode()#'BANKA MASRAF FİŞİ',
			ACTION_TYPE_ID=#process_type#,
			ACTION_DETAIL=<cfif len(attributes.note)>#sql_unicode()#'#attributes.note#'<cfelse>#sql_unicode()#'#actionDetail#'</cfif>,
			ACTION_VALUE=#form.basket_net_total/currency_multiplier_banka#,
			BANK_ACTION_KDVSIZ_VALUE=#form.basket_gross_total/currency_multiplier_banka#,
			BANK_ACTION_TAX_VALUE=#form.basket_tax_total/currency_multiplier_banka#,
			ACTION_CURRENCY_ID=#sql_unicode()#'#attributes.currency_id#',
			ACTION_DATE=#attributes.invoice_date#,
			OTHER_CASH_ACT_VALUE=<cfif len(form.basket_net_total) and len(form.basket_rate2)>#form.basket_net_total/form.basket_rate2#,<cfelse>NULL,</cfif>
			OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BASKET_MONEY#">,
			ACTION_EMPLOYEE_ID=<cfif len(attributes.deliver_get) and len(attributes.deliver_get_id)>#attributes.deliver_get_id#,<cfelse>NULL,</cfif>
			UPDATE_DATE=#now()#,
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP=#sql_unicode()#'#cgi.REMOTE_ADDR#',
			FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#,
			IS_ACCOUNT=<cfif is_account eq 1>1,<cfelse>0,</cfif>
			IS_ACCOUNT_TYPE=13,
			PAPER_NO=#sql_unicode()#'#form.invoice_number#',
			PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
			ACTION_FROM_ACCOUNT_ID=#attributes.account_id#,
			SYSTEM_ACTION_VALUE = #form.basket_net_total#,
			SYSTEM_CURRENCY_ID = #sql_unicode()#'#session.ep.money#'
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2 = #wrk_round(form.basket_net_total/currency_multiplier_money2,4)#
				,ACTION_CURRENCY_ID_2 = #sql_unicode()#'#session.ep.money2#'
			</cfif>
		WHERE
			BILL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT ACTION_ID AS ACT_ID FROM BANK_ACTIONS WHERE BILL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
	</cfquery>
	<cfset workcube_old_process_type = 25>
<cfelse>
	<cfquery name="ADD_BANK_PAYMENT" datasource="#DSN2#">
		INSERT INTO
			BANK_ACTIONS
			(
				PROCESS_CAT,
				ACTION_TYPE,
				ACTION_TYPE_ID,
				ACTION_DETAIL,
				ACTION_VALUE,
				BANK_ACTION_KDVSIZ_VALUE,
				BANK_ACTION_TAX_VALUE,
				ACTION_CURRENCY_ID,
				ACTION_DATE,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,
				ACTION_EMPLOYEE_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				PAPER_NO,
				PROJECT_ID,
				ACTION_FROM_ACCOUNT_ID,
				BILL_ID,		
				FROM_BRANCH_ID,
				SYSTEM_ACTION_VALUE,
				SYSTEM_CURRENCY_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
			)
			VALUES
			(
				#attributes.process_cat#,
				#sql_unicode()#'BANKA MASRAF FİŞİ',
				#process_type#,
				<cfif len(attributes.note)>#sql_unicode()#'#attributes.note#'<cfelse>#sql_unicode()#'#actionDetail#'</cfif>,
				#form.basket_net_total/currency_multiplier_banka#,
				#form.basket_gross_total/currency_multiplier_banka#,
				#form.basket_tax_total/currency_multiplier_banka#,
				#sql_unicode()#'#attributes.currency_id#',
				#attributes.invoice_date#,
				<cfif len(form.basket_net_total) and len(form.basket_rate2)>#form.basket_net_total/form.basket_rate2#,<cfelse>NULL,</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BASKET_MONEY#">,
				<cfif len(attributes.deliver_get) and len(attributes.deliver_get_id)>#attributes.deliver_get_id#,<cfelse>NULL,</cfif>
				#now()#,
				#session.ep.userid#,
				#sql_unicode()#'#cgi.REMOTE_ADDR#',
				 <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
				#sql_unicode()#'#form.invoice_number#',
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				#attributes.account_id#,
				<cfif isdefined("form.invoice_id")>#form.invoice_id#<cfelse>#get_invoice_id.max_id#</cfif>,
				#listgetat(session.ep.user_location,2,'-')#,
				#form.basket_net_total#,
				#sql_unicode()#'#session.ep.money#'
				<cfif len(session.ep.money2)>
					,#wrk_round(form.basket_net_total/currency_multiplier_money2,4)#
					,#sql_unicode()#'#session.ep.money2#'
				</cfif>
			)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT MAX(ACTION_ID) AS ACT_ID FROM BANK_ACTIONS
	</cfquery>
	<cfset workcube_old_process_type = 0>
</cfif>

<cfscript>
	if(is_cari eq 1)//banka carici
	{
		carici(
			action_id :GET_ACT_ID.ACT_ID,  
			workcube_old_process_type : workcube_old_process_type,
			action_table : 'BANK_ACTIONS',
			workcube_process_type : 25,
			account_card_type : 13,
			from_account_id : account_id,
			islem_tarihi : attributes.invoice_date,
			due_date : invoice_due_date,
			islem_tutari : form.basket_net_total,
			islem_belge_no : form.invoice_number,
			to_cmp_id : attributes.company_id,
			to_consumer_id : attributes.consumer_id,
			to_employee_id : attributes.employee_id,
			to_branch_id : listgetat(session.ep.user_location,2,'-'),
			islem_detay : UCase("#getLang(dictionary_id : 32451)# #getLang('main',435)#"),
			action_detail : attributes.note,
			other_money_value : form.basket_net_total/form.basket_rate2,
			other_money : form.basket_money,
			action_currency : session.ep.money,
			currency_multiplier : currency_multiplier_money2,
			process_cat : attributes.process_cat,
			project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
			rate2:paper_currency_multiplier,
			acc_type_id : attributes.acc_type_id
		);
	}
	else if(isdefined("form.invoice_id"))
		cari_sil(action_id:GET_ACT_ID.ACT_ID,process_type:25);
	if(is_account eq 1)//kasa muhasebe
	{
		document_type_ = '';
		payment_type_ = '';
		if(session.ep.our_company_info.is_edefter eq 1)
		{
			INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 DOCUMENT_TYPE,PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 25 ORDER BY PROCESS_CAT_ID");
			payment_type_ = INFO_.PAYMENT_TYPE;
			document_type_ = INFO_.DOCUMENT_TYPE;
		}
		muhasebeci (
			action_id:GET_ACT_ID.ACT_ID,
			workcube_old_process_type : workcube_old_process_type,
			workcube_process_type : 25,
			workcube_process_cat : attributes.process_cat,
			acc_department_id : iif((isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)),'attributes.acc_department_id',de('')),
			account_card_type : 13,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			employee_id : attributes.employee_id,
			islem_tarihi : attributes.invoice_date,
			borc_hesaplar : string_acc_code,
			borc_tutarlar : form.basket_net_total,
			alacak_hesaplar : attributes.account_acc_code,
			alacak_tutarlar : form.basket_net_total,
			fis_satir_detay: UCase("#getLang('main',1760)# #getLang('main',435)#"),
			fis_detay : UCase("#getLang('main',1760)# #getLang('main',435)#"),
			belge_no : form.invoice_number,
			from_branch_id :listgetat(session.ep.user_location,2,'-'),
			other_amount_borc : form.basket_net_total/form.basket_rate2,
			other_currency_borc : form.basket_money,
			other_amount_alacak : wrk_round(form.basket_net_total/currency_multiplier_banka ,4),
			other_currency_alacak : attributes.currency_id,
			currency_multiplier : currency_multiplier_money2,
			is_account_group : is_account_group,
			document_type : document_type_,
			acc_project_id : main_project_id,
			acc_project_list_alacak : '',
			acc_project_list_borc : '',
			payment_method : payment_type_
		);
	}
	else if(isdefined("form.invoice_id"))
		muhasebe_sil(action_id:GET_ACT_ID.ACT_ID,process_type:25);
</cfscript>