<!--- güncellemede kasa işleminden banka işlemine geçiş yaptı ise eski kasa işlemi siliniyor
islem tipi :24 gelen havale--->

<cfif isdefined("attributes.expense_id") and isdefined("is_upd_action")>
	<cfquery name="GET_CASH_ACTION" datasource="#dsn2#">
		SELECT ACTION_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfif get_cash_action.recordcount>
		<cfscript>
			cari_sil(action_id:GET_CASH_ACTION.ACTION_ID,process_type:31);
			muhasebe_sil (action_id:GET_CASH_ACTION.ACTION_ID,process_type:31);
		</cfscript>		
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CASH_ACTION.ACTION_ID#">
		</cfquery>
	</cfif>
	<cfquery name="GET_BANK_ACTIONS" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
<cfelse>
	<cfset get_bank_actions.recordcount = 0>
</cfif>
<cfif GET_BANK_ACTIONS.RECORDCOUNT>
	<cfquery name="UPD_BANK_PAYMENT" datasource="#dsn2#">
		UPDATE 
			BANK_ACTIONS 
		SET
			PROCESS_CAT=#attributes.process_cat#,
			ACTION_TYPE=#sql_unicode()#'#UCase(getLang("main",2738))#',
			ACTION_TYPE_ID=#process_type#,
			ACTION_DETAIL=<cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>#sql_unicode()#'BANKA GELİR FİŞİ'</cfif>,
			ACTION_VALUE=#attributes.net_total_amount/currency_multiplier_banka#,
			BANK_ACTION_KDVSIZ_VALUE=#attributes.total_amount/currency_multiplier_banka#,
			BANK_ACTION_TAX_VALUE=#attributes.kdv_total_amount/currency_multiplier_banka#,
			ACTION_CURRENCY_ID=#sql_unicode()#'#attributes.currency_id#',
			ACTION_DATE=#attributes.expense_date#,
			OTHER_CASH_ACT_VALUE=<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
			OTHER_MONEY=<cfif len(rd_money_value)>#sql_unicode()#'#rd_money_value#',<cfelse>NULL,</cfif>
			ACTION_EMPLOYEE_ID=#attributes.expense_employee_id#,
			UPDATE_DATE=#now()#,
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP=#sql_unicode()#'#cgi.REMOTE_ADDR#',
			FROM_BRANCH_ID = #branch_id_info#,
			IS_ACCOUNT=<cfif is_account eq 1>1,<cfelse>0,</cfif>
			IS_ACCOUNT_TYPE=13,
			PAPER_NO=#sql_unicode()#'#attributes.belge_no#',
			ACTION_TO_ACCOUNT_ID=#attributes.account_id#,
			SYSTEM_ACTION_VALUE = #attributes.net_total_amount#,
			SYSTEM_CURRENCY_ID = #sql_unicode()#'#session.ep.money#'
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2 = #wrk_round(attributes.net_total_amount/currency_multiplier_money2,4)#
				,ACTION_CURRENCY_ID_2 = #sql_unicode()#'#session.ep.money2#'
			</cfif>
		WHERE
			EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfquery name="ADD_BANK_PAYMENT" datasource="#dsn2#">
		SELECT ACTION_ID AS MAX_ACT_ID FROM BANK_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfset workcube_old_process_type = 24>
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
				ACTION_TO_ACCOUNT_ID,
				EXPENSE_ID,
				TO_BRANCH_ID,
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
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('main',2738))#">,
				#process_type#,
				<cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>#sql_unicode()#'#UCase(getLang("main",2738))#'</cfif>,
				#attributes.net_total_amount/currency_multiplier_banka#,
				#attributes.total_amount/currency_multiplier_banka#,
				#attributes.kdv_total_amount/currency_multiplier_banka#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				#attributes.expense_date#,
				<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
				<cfif len(rd_money_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#rd_money_value#">,<cfelse>NULL,</cfif>
				#attributes.expense_employee_id#,
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
				 <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.belge_no#">,
				#attributes.account_id#,
				#attributes.expense_id#,
				#branch_id_info#,
				#attributes.net_total_amount#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,#wrk_round(attributes.net_total_amount/currency_multiplier_money2,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
			)
			SELECT @@IDENTITY AS MAX_ACT_ID
	</cfquery>
	<cfset workcube_old_process_type = 0>
</cfif>
<!--- eğer cari seçilmişse muhasebe ve cari hareketi yapacak --->
<cfif ((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)) or (attributes.ch_member_type eq 'consumer' and len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)))>
	<cfscript>
		if(is_cari eq 1)//kasa carici
		{
			carici(
				action_id :ADD_BANK_PAYMENT.MAX_ACT_ID,  
				workcube_old_process_type : workcube_old_process_type,
				action_table : 'BANK_ACTIONS',
				workcube_process_type : 24,
				account_card_type : 13,
				islem_tarihi : attributes.expense_date,
				due_date : attributes.expense_date,
				islem_tutari : attributes.net_total_amount,
				islem_belge_no : attributes.belge_no,
				from_cmp_id : to_company_id,
				from_consumer_id : to_consumer_id,
				from_employee_id : to_employee_id,
				to_branch_id :branch_id_info,
				to_account_id : attributes.account_id,
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
			cari_sil(action_id:ADD_BANK_PAYMENT.MAX_ACT_ID,process_type:24);
		if(is_account eq 1)//kasa muhasebe
		{
			document_type_ = '';
			payment_type_ = '';
			if(session.ep.our_company_info.is_edefter eq 1)
			{
				INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 DOCUMENT_TYPE,PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 24 ORDER BY PROCESS_CAT_ID");
				payment_type_ = INFO_.PAYMENT_TYPE;
				document_type_ = INFO_.DOCUMENT_TYPE;
			}
			muhasebeci (
				action_id:ADD_BANK_PAYMENT.MAX_ACT_ID,
				workcube_old_process_type : workcube_old_process_type,
				workcube_process_type : 24,
				workcube_process_cat : attributes.process_cat,
				account_card_type : 13,
				company_id : to_company_id,
				consumer_id : to_consumer_id,
				employee_id : to_employee_id,
				islem_tarihi : attributes.expense_date,
				alacak_hesaplar : string_acc_code,
				alacak_tutarlar : attributes.net_total_amount,
				borc_hesaplar : attributes.account_acc_code,
				borc_tutarlar : attributes.net_total_amount,
				fis_satir_detay: UCase(getLang('main',2740)),//BANKA GELİR FİŞİ TAHSİLAT
				fis_detay : UCase(getLang('main',2740)),//BANKA GELİR FİŞİ TAHSİLAT
				belge_no : attributes.belge_no,
				to_branch_id :branch_id_info,
				other_amount_borc : wrk_round(attributes.net_total_amount/currency_multiplier_banka ,4),
				other_currency_borc : attributes.currency_id,
				other_amount_alacak : attributes.other_net_total_amount,
				other_currency_alacak : rd_money_value,
				currency_multiplier : currency_multiplier_money2,
				is_account_group : account_group,
				document_type : document_type_,
				acc_project_id : main_project_id,
				acc_project_list_alacak : acc_project_list_alacak,
				acc_project_list_borc : acc_project_list_borc,
				payment_method : payment_type_
			);
		}
		else if(isdefined("attributes.expense_id"))
			muhasebe_sil(action_id:ADD_BANK_PAYMENT.MAX_ACT_ID,process_type:24);
	</cfscript>
<cfelseif isdefined("attributes.expense_id")>
	<cfscript>
		cari_sil(action_id:ADD_BANK_PAYMENT.MAX_ACT_ID,process_type:24);
		muhasebe_sil(action_id:ADD_BANK_PAYMENT.MAX_ACT_ID,process_type:24);
	</cfscript>
</cfif>
