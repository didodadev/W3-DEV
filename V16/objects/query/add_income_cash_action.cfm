<!--- güncellemede bank işleminden kasa işlemine geçiş yaptı ise eski banka işlemi siliniyor
islem tipi : 31 tahsilat
			 11 kasa gelir fisi
			 24 gelen havale --->
			 
<cfif isdefined("attributes.expense_id") and isdefined("is_upd_action")>
	<cfquery name="GET_BANK_ACTION" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfif get_bank_action.recordcount>
		<cfscript>
			cari_sil(action_id:GET_BANK_ACTION.ACTION_ID,process_type:24);
			muhasebe_sil (action_id:GET_BANK_ACTION.ACTION_ID,process_type:24);
		</cfscript>		
		<cfquery name="DEL_BANK_ACTIONS" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
		</cfquery>
	</cfif>
	<cfquery name="GET_CASH_ACTIONS" datasource="#dsn2#">
		SELECT ACTION_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
<cfelse>
	<cfset get_cash_actions.recordcount = 0>
</cfif>
<cfif GET_CASH_ACTIONS.RECORDCOUNT>
	<cfquery name="UPD_CASH_ACTION" datasource="#dsn2#">
		UPDATE 
			CASH_ACTIONS
		SET
			PROCESS_CAT=#attributes.process_cat#,
			PAPER_NO=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.belge_no#">,
			ACTION_TYPE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('main',2741))#">,
			ACTION_TYPE_ID=#process_type#,
			<cfif len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner'> 
				CASH_ACTION_FROM_COMPANY_ID = <cfif len(attributes.ch_company) and len(attributes.ch_company_id)>#attributes.ch_company_id#<cfelse>NULL</cfif>,
				CASH_ACTION_FROM_CONSUMER_ID = NULL,
				CASH_ACTION_FROM_EMPLOYEE_ID = NULL,
			<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer'>
				CASH_ACTION_FROM_COMPANY_ID = NULL,
				CASH_ACTION_FROM_CONSUMER_ID = <cfif isdefined("attributes.ch_partner") and len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
				CASH_ACTION_FROM_EMPLOYEE_ID = NULL,
			<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee'>
				CASH_ACTION_FROM_COMPANY_ID = NULL,
				CASH_ACTION_FROM_CONSUMER_ID = NULL,
				CASH_ACTION_FROM_EMPLOYEE_ID = <cfif len(attributes.ch_member_type) and len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
			</cfif>
			CASH_ACTION_VALUE=#attributes.net_total_amount/currency_multiplier#,
			CASH_ACTION_KDVSIZ_VALUE=#attributes.total_amount/currency_multiplier#,
			CASH_ACTION_TAX_VALUE=#attributes.kdv_total_amount/currency_multiplier#,
			CASH_ACTION_CURRENCY_ID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.kasa,2,';')#">,
			CASH_ACTION_TO_CASH_ID=#ListFirst(attributes.kasa,";")#,
			ACTION_DATE=#attributes.expense_date#,
			PAYER_ID=#attributes.expense_employee_id#,
			ACTION_DETAIL=#sql_unicode()#'#attributes.detail#',
			OTHER_CASH_ACT_VALUE=<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
			OTHER_MONEY=<cfif len(rd_money_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#rd_money_value#">,<cfelse>NULL,</cfif>
			IS_ACCOUNT=<cfif is_account eq 1>1,<cfelse>0,</cfif>
			IS_ACCOUNT_TYPE=11,
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE=#now()#,
			PAYMETHOD_ID=<cfif len(attributes.paymethod) and len(attributes.paymethod_name)>#attributes.paymethod#<cfelse>NULL</cfif>,
			ACTION_VALUE = #attributes.net_total_amount#,
			ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2 = #wrk_round(attributes.net_total_amount/currency_multiplier_money2,4)#
				,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
			</cfif>
		WHERE 
			EXPENSE_ID = #attributes.expense_id#
	</cfquery>
	<cfquery name="ADD_CASH_PAYMENT" datasource="#dsn2#">
		SELECT ACTION_ID AS MAX_ACT_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfset workcube_old_process_type = 31>
<cfelse>
	<cfquery name="ADD_CASH_PAYMENT" datasource="#DSN2#">
		INSERT INTO
			CASH_ACTIONS
			(
				PROCESS_CAT,
				PAPER_NO,
				ACTION_TYPE,
				ACTION_TYPE_ID,
				CASH_ACTION_FROM_COMPANY_ID,
				CASH_ACTION_FROM_CONSUMER_ID,
				CASH_ACTION_FROM_EMPLOYEE_ID,
				CASH_ACTION_VALUE,
				CASH_ACTION_KDVSIZ_VALUE,
				CASH_ACTION_TAX_VALUE,
				CASH_ACTION_CURRENCY_ID,
				CASH_ACTION_TO_CASH_ID,
				ACTION_DATE,
				PAYER_ID,
				ACTION_DETAIL,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				PAYMETHOD_ID,
				EXPENSE_ID,
				ACTION_VALUE,
				ACTION_CURRENCY_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>							
			)
			VALUES
			(	
				#attributes.process_cat#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.belge_no#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('main',2741))#">,
				#process_type#,
				<cfif len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner'> 
					<cfif len(attributes.ch_company) and len(attributes.ch_company_id)>#attributes.ch_company_id#<cfelse>NULL</cfif>,
					NULL,
					NULL,
				<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer'>
					NULL,
					<cfif isdefined("attributes.ch_partner") and len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
					NULL,
				<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee'>
					NULL,
					NULL,
					<cfif len(attributes.ch_member_type) and len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
				<cfelse>
					NULL,
					NULL,
					NULL,
				</cfif>
				#attributes.net_total_amount/currency_multiplier#,
				#attributes.total_amount/currency_multiplier#,
				#attributes.kdv_total_amount/currency_multiplier#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.kasa,2,';')#">,
				#ListFirst(attributes.kasa,";")#,
				#attributes.expense_date#,
				#attributes.expense_employee_id#,
				#sql_unicode()#'#attributes.detail#',
				<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
				<cfif len(rd_money_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#rd_money_value#">,<cfelse>NULL,</cfif>
				<cfif is_account eq 1>1,11,<cfelse>0,11,</cfif>
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#now()#,
				<cfif len(attributes.paymethod) and len(attributes.paymethod_name)>#attributes.paymethod#<cfelse>NULL</cfif>,
				#attributes.expense_id#,
				#attributes.net_total_amount#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,#wrk_round(attributes.net_total_amount/currency_multiplier_money2,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
			)
			SELECT @@IDENTITY MAX_ACT_ID
	</cfquery>
	<cfset workcube_old_process_type = 0>
</cfif>
<!--- eğer cari seçilmişse muhasebe ve cari hareketi yapacak --->
<cfif ((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)) or (attributes.ch_member_type eq 'consumer' and len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)))>
	<cfscript>
		if(is_cari eq 1)//kasa carici
		{
			carici(
				action_id :ADD_CASH_PAYMENT.MAX_ACT_ID,
				workcube_old_process_type : workcube_old_process_type,
				action_table : 'CASH_ACTIONS',
				workcube_process_type : 31,
				account_card_type : 11,
				islem_tarihi : attributes.expense_date,
				due_date : attributes.expense_date,
				islem_tutari : attributes.net_total_amount,
				islem_belge_no : attributes.belge_no,
				from_cmp_id : to_company_id,
				from_consumer_id : to_consumer_id,
				from_employee_id : to_employee_id,
				to_cash_id : ListFirst(attributes.kasa,";"),
				to_branch_id : branch_id_info,
				islem_detay : UCase(getLang('main',2739)),//GELİR FİŞİ TAHSİLAT İŞLEMİ
				action_detail : attributes.detail,
				other_money_value : attributes.other_net_total_amount,
				other_money : rd_money_value,
				action_currency : session.ep.money,
				currency_multiplier : currency_multiplier_money2,
				process_cat : form.process_cat,
				project_id:project_id_info
			);
		}
		else if(isdefined("attributes.expense_id"))
			cari_sil(action_id:ADD_CASH_PAYMENT.MAX_ACT_ID,process_type:31);
		
		if(is_account eq 1)//kasa muhasebe
		{
			document_type_ = '';
			payment_type_ = '';
			get_cash_acc = cfquery(datasource : "#dsn2#", sqlstring : "SELECT CASH_CURRENCY_ID, CASH_ACC_CODE FROM CASH WHERE CASH_ID = #ListFirst(attributes.kasa,";")#");
			if(session.ep.our_company_info.is_edefter eq 1)
			{
				INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 DOCUMENT_TYPE,PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 31 ORDER BY PROCESS_CAT_ID");
				payment_type_ = INFO_.PAYMENT_TYPE;
				document_type_ = INFO_.DOCUMENT_TYPE;
			}
			muhasebeci (
				action_id:ADD_CASH_PAYMENT.MAX_ACT_ID,
				workcube_old_process_type : workcube_old_process_type,
				workcube_process_type : 31,
				workcube_process_cat : attributes.process_cat,
				account_card_type : 11,
				company_id : to_company_id,
				consumer_id : to_consumer_id,
				employee_id : to_employee_id,
				islem_tarihi : attributes.expense_date,
				alacak_hesaplar : string_acc_code,
				alacak_tutarlar : attributes.net_total_amount,
				borc_hesaplar : get_cash_acc.CASH_ACC_CODE,
				borc_tutarlar : attributes.net_total_amount,
				fis_satir_detay: UCase(getLang('main',2742)),//KASA GELİR FİŞİ TAHSİLAT
				fis_detay : UCase(getLang('main',2742)),//KASA GELİR FİŞİ TAHSİLAT
				belge_no : attributes.belge_no,
				to_branch_id :branch_id_info,
				other_amount_borc : wrk_round(attributes.net_total_amount/currency_multiplier ,4),
				other_currency_borc : ListGetAt(attributes.kasa,2,";"),
				other_amount_alacak : attributes.other_net_total_amount,
				other_currency_alacak : rd_money_value,
				currency_multiplier : currency_multiplier_money2,
				is_account_group : account_group,
				acc_project_id : main_project_id,
				acc_project_list_alacak : acc_project_list_alacak,
				acc_project_list_borc : acc_project_list_borc,
				document_type : document_type_,
				payment_method : payment_type_
			);
		}
		else if(isdefined("attributes.expense_id"))
			muhasebe_sil(action_id:ADD_CASH_PAYMENT.MAX_ACT_ID,process_type:31);
	</cfscript>
<cfelseif isdefined("attributes.expense_id")>
	<cfscript>
		cari_sil(action_id:ADD_CASH_PAYMENT.MAX_ACT_ID,process_type:31);
		muhasebe_sil(action_id:ADD_CASH_PAYMENT.MAX_ACT_ID,process_type:31);
	</cfscript>
</cfif>
	
