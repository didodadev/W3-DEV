<!--- güncellemede bank işleminden kasa işlemine geçiş yaptı ise eski bank işlemi ve kredi kartı siliniyor--->
<cfif isdefined("attributes.expense_id") and isdefined("is_upd_action")>
	<cfquery name="GET_BANK_ACTION" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfif get_bank_action.recordcount>
		<cfscript>
			cari_sil(action_id:GET_BANK_ACTION.ACTION_ID,process_type:25);
			muhasebe_sil (action_id:GET_BANK_ACTION.ACTION_ID,process_type:25);
		</cfscript>		
		<cfquery name="DEL_FROM_BANK_ACTIONS" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_BANK_ACTION.ACTION_ID#">
		</cfquery>
	</cfif>
	<cfquery name="GET_CREDIT_ACTION" datasource="#dsn2#">
		SELECT CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
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
			PAPER_NO=#sql_unicode()#'#attributes.belge_no#',
			ACTION_TYPE=#sql_unicode()#'KASA MASRAF FİŞİ',
			ACTION_TYPE_ID=#process_type#,
			<cfif len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner'> 
				CASH_ACTION_TO_COMPANY_ID = <cfif len(attributes.ch_company) and len(attributes.ch_company_id)>#attributes.ch_company_id#<cfelse>NULL</cfif>,
				CASH_ACTION_TO_CONSUMER_ID = NULL,
				CASH_ACTION_TO_EMPLOYEE_ID = NULL,
			<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer'>
				CASH_ACTION_TO_COMPANY_ID = NULL,
				CASH_ACTION_TO_CONSUMER_ID = <cfif isdefined("attributes.ch_partner") and len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
				CASH_ACTION_TO_EMPLOYEE_ID = NULL,
			<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee'>
				CASH_ACTION_TO_COMPANY_ID = NULL,
				CASH_ACTION_TO_CONSUMER_ID = NULL,
				CASH_ACTION_TO_EMPLOYEE_ID = <cfif len(attributes.ch_member_type) and len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
			</cfif>
			CASH_ACTION_VALUE=#attributes.net_total_amount/currency_multiplier#,
			CASH_ACTION_KDVSIZ_VALUE=#attributes.total_amount/currency_multiplier#,
			CASH_ACTION_TAX_VALUE=#attributes.kdv_total_amount/currency_multiplier#,
			CASH_ACTION_CURRENCY_ID=#sql_unicode()#'#ListGetAt(attributes.kasa,2,";")#',
			CASH_ACTION_FROM_CASH_ID=#ListFirst(attributes.kasa,";")#,
			ACTION_DATE=#attributes.expense_date#,
			PAYER_ID=<cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#,<cfelse>NULL,</cfif>
			ACTION_DETAIL='#left(attributes.detail,250)#',
			OTHER_CASH_ACT_VALUE=<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
			OTHER_MONEY=<cfif len(rd_money_value)>'#rd_money_value#',<cfelse>NULL,</cfif>
			IS_ACCOUNT=<cfif is_account eq 1>1,<cfelse>0,</cfif>
			IS_ACCOUNT_TYPE=12,
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP=#sql_unicode()#'#cgi.remote_addr#',
			UPDATE_DATE=#now()#,
			PAYMETHOD_ID=<cfif len(attributes.paymethod) and len(attributes.paymethod_name)>#attributes.paymethod#<cfelse>NULL</cfif>,
			ACTION_VALUE = #attributes.net_total_amount#,
			ACTION_CURRENCY_ID = #sql_unicode()#'#session.ep.money#',
			PROJECT_ID = <cfif len(project_id_info)>#project_id_info#<cfelse>NULL</cfif>
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2 = #wrk_round(attributes.net_total_amount/currency_multiplier_money2,4)#
				,ACTION_CURRENCY_ID_2 = #sql_unicode()#'#session.ep.money2#'
			</cfif>
		WHERE 
			EXPENSE_ID = #attributes.expense_id#
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT ACTION_ID ACT_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfset workcube_old_process_type = 32>
<cfelse>
	<cfquery name="ADD_CASH_PAYMENT" datasource="#DSN2#">
		INSERT INTO
			CASH_ACTIONS
			(
				PROCESS_CAT,
				PAPER_NO,
				ACTION_TYPE,
				ACTION_TYPE_ID,
				CASH_ACTION_TO_COMPANY_ID,
				CASH_ACTION_TO_CONSUMER_ID,
				CASH_ACTION_TO_EMPLOYEE_ID,
				CASH_ACTION_VALUE,
				CASH_ACTION_KDVSIZ_VALUE,
				CASH_ACTION_TAX_VALUE,
				CASH_ACTION_CURRENCY_ID,
				CASH_ACTION_FROM_CASH_ID,
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
				ACTION_CURRENCY_ID,
				PROJECT_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>				
			)
			VALUES
			(	
				#attributes.process_cat#,
				#sql_unicode()#'#attributes.belge_no#',
				#sql_unicode()#'KASA MASRAF FISI',
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
				#sql_unicode()#'#ListGetAt(attributes.kasa,2,";")#',
				#ListFirst(attributes.kasa,";")#,
				#attributes.expense_date#,
				<cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#,<cfelse>NULL,</cfif>
				#sql_unicode()#'#left(attributes.detail,250)#',
				<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
				<cfif len(rd_money_value)>#sql_unicode()#'#rd_money_value#',<cfelse>NULL,</cfif>
				<cfif is_account eq 1>1,12,<cfelse>0,12,</cfif>
				#session.ep.userid#,
				#sql_unicode()#'#cgi.remote_addr#',
				#now()#,
				<cfif len(attributes.paymethod) and len(attributes.paymethod_name)>#attributes.paymethod#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.expense_id") and isdefined("is_upd_action")>#attributes.expense_id#<cfelse>#get_maxid.max_id#</cfif>,
				#attributes.net_total_amount#,
				#sql_unicode()#'#session.ep.money#',
				<cfif len(project_id_info)>#project_id_info#<cfelse>NULL</cfif>
				<cfif len(session.ep.money2)>
					,#wrk_round(attributes.net_total_amount/currency_multiplier_money2,4)#
					,#sql_unicode()#'#session.ep.money2#'
				</cfif>
			)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
	</cfquery>
	<cfset workcube_old_process_type = 0>
</cfif>
<cfquery name="get_cari_kontrol_cash" datasource="#dsn2#">
	SELECT DISTINCT PROJECT_ID FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACT_ID.ACT_ID#"> AND ACTION_TYPE_ID = 32
</cfquery>
<!--- eğer cari seçilmişse muhasebe ve cari hareketi yapacak --->
<cfif ((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)) or (attributes.ch_member_type eq 'consumer' and len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)))>
	<cfscript>
		if(is_cari eq 1)//kasa carici
		{
			if(is_row_project_based_cari eq 1 or (is_row_project_based_cari eq 0 and get_cari_kontrol_cash.recordcount neq 1))
				cari_sil(action_id:GET_ACT_ID.ACT_ID,process_type:32);
			if(is_row_project_based_cari eq 1)
			{
				row_project_list='';
				total_cash_price=0;
				total_other_cash_price=0;
				row_number = 0;
				row_all_total = 0;
				for(j=1;j lte attributes.record_num;j=j+1)
				{
					if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
					{
						row_all_total = row_all_total + evaluate("attributes.net_total#j#");
					}
				}
				for(j=1;j lte attributes.record_num;j=j+1)
				{
					if(row_all_total gt 0)
						row_total_ = attributes.net_total_amount*evaluate("attributes.net_total#j#")/row_all_total;
					else
						row_total_ = 0;
					if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") and isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project#j#")))
					{
						row_number = row_number + 1;
						if(not listfind(row_project_list,evaluate("attributes.project_id#j#")))
						{
							row_project_list = listappend(row_project_list,evaluate("attributes.project_id#j#"));
							'row_amount_total_#row_number#' = row_total_;
							'row_other_amount_total_#row_number#' = row_total_/paper_currency_multiplier;
						}
						else
						{
							row_number = listfind(row_project_list,evaluate("attributes.project_id#j#"));
							'row_amount_total_#row_number#' = evaluate("row_amount_total_#row_number#")+row_total_;
							'row_other_amount_total_#row_number#' = evaluate("row_other_amount_total_#row_number#")+(row_total_/paper_currency_multiplier);
						}
					}
					else if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
					{
						total_cash_price = total_cash_price + row_total_;
						total_other_cash_price = total_other_cash_price + row_total_/paper_currency_multiplier;
					}	
				}
				for(ind_t=1;ind_t lte listlen(row_project_list); ind_t=ind_t+1)
				{
					cari_row_project=listgetat(row_project_list,ind_t);
					carici(
						action_id :GET_ACT_ID.ACT_ID,
						action_table : 'CASH_ACTIONS',
						workcube_process_type : 32,
						account_card_type : 12,
						islem_tarihi : attributes.expense_date,
						due_date : attributes.expense_date,
						islem_tutari : evaluate('row_amount_total_#ind_t#'),
						islem_belge_no : attributes.belge_no,
						to_cmp_id : from_company_id,
						to_consumer_id : from_consumer_id,
						to_employee_id : from_employee_id,
						to_branch_id :branch_id_info,
						islem_detay : UCase("#getLang('main',652)# #getLang('main',435)# #getLang('main',3610)#"),
						action_detail : attributes.detail,
						other_money_value : evaluate('row_other_amount_total_#ind_t#'),
						other_money : rd_money_value,
						action_currency : session.ep.money,
						currency_multiplier : currency_multiplier_money2,
						process_cat : form.process_cat,
						project_id : cari_row_project,
						rate2:paper_currency_multiplier,
						acc_type_id : attributes.acc_type_id
					);
				}
				if(total_cash_price gt 0)
				{
					carici(
						action_id :GET_ACT_ID.ACT_ID,
						action_table : 'CASH_ACTIONS',
						workcube_process_type : 32,
						account_card_type : 12,
						islem_tarihi : attributes.expense_date,
						due_date : attributes.expense_date,
						islem_tutari : total_cash_price,
						islem_belge_no : attributes.belge_no,
						to_cmp_id : from_company_id,
						to_consumer_id : from_consumer_id,
						to_employee_id : from_employee_id,
						to_branch_id :branch_id_info,
						islem_detay : UCase("#getLang('main',652)# #getLang('main',435)# #getLang('main',2610)#"),
						action_detail : attributes.detail,
						other_money_value : total_other_cash_price,
						other_money : rd_money_value,
						action_currency : session.ep.money,
						currency_multiplier : currency_multiplier_money2,
						process_cat : form.process_cat,
						project_id:project_id_info,
						rate2:paper_currency_multiplier,
						acc_type_id : attributes.acc_type_id
					);
				}
			}
			else
			{
				carici(
					action_id :GET_ACT_ID.ACT_ID,
					workcube_old_process_type : workcube_old_process_type,
					action_table : 'CASH_ACTIONS',
					workcube_process_type : 32,
					account_card_type : 12,
					from_cash_id : ListFirst(attributes.kasa,";"),
					islem_tarihi : attributes.expense_date,
					due_date : attributes.expense_date,
					islem_tutari : attributes.net_total_amount,
					islem_belge_no : attributes.belge_no,
					to_cmp_id : from_company_id,
					to_consumer_id : from_consumer_id,
					to_employee_id : from_employee_id,
					to_branch_id :branch_id_info,
					islem_detay : UCase("#getLang('main',652)# #getLang('main',435)# #getLang('main',2610)#"),
					action_detail : attributes.detail,
					other_money_value : attributes.other_net_total_amount,
					other_money : rd_money_value,
					action_currency : session.ep.money,
					currency_multiplier : currency_multiplier_money2,
					process_cat : form.process_cat,
					project_id:project_id_info,
					rate2:paper_currency_multiplier,
					acc_type_id : attributes.acc_type_id
				);
			}
		}
		else if(isdefined("attributes.expense_id"))
			cari_sil(action_id:GET_ACT_ID.ACT_ID,process_type:32);
		
		if(is_account eq 1)//kasa muhasebe
		{	
			document_type_ = '';
			payment_type_ = '';
			get_cash_acc = cfquery(datasource : "#dsn2#", sqlstring : "SELECT CASH_CURRENCY_ID, CASH_ACC_CODE FROM CASH WHERE CASH_ID = #ListFirst(attributes.kasa,";")#");
			if(session.ep.our_company_info.is_edefter eq 1)
			{
				INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 DOCUMENT_TYPE,PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 32 ORDER BY PROCESS_CAT_ID");
				payment_type_ = INFO_.PAYMENT_TYPE;
				document_type_ = INFO_.DOCUMENT_TYPE;
			}
			
			muhasebeci (
				action_id:GET_ACT_ID.ACT_ID,
				workcube_old_process_type : workcube_old_process_type,
				workcube_process_type : 32,
				workcube_process_cat : attributes.process_cat,
				acc_department_id:acc_department_id,
				account_card_type : 12,
				company_id : from_company_id,
				consumer_id : from_consumer_id,
				employee_id : from_employee_id,
				islem_tarihi : attributes.expense_date,
				borc_hesaplar : string_acc_code,
				borc_tutarlar : attributes.net_total_amount,
				alacak_hesaplar : get_cash_acc.CASH_ACC_CODE,
				alacak_tutarlar : attributes.net_total_amount,
				fis_satir_detay: UCase("#getLang('main',1769)# #getLang('main',435)#"),
				fis_detay : UCase("#getLang('main',1769)# #getLang('main',435)#"),
				belge_no : attributes.belge_no,
				from_branch_id :branch_id_info,
				to_branch_id :branch_id_info_document,
				other_amount_borc : attributes.other_net_total_amount,
				other_currency_borc : rd_money_value,
				other_amount_alacak : wrk_round(attributes.net_total_amount/currency_multiplier ,4),
				other_currency_alacak : ListGetAt(attributes.kasa,2,";"),
				currency_multiplier : currency_multiplier_money2,
				is_account_group : account_group,
				borc_miktarlar : str_borclu_miktar,
				acc_project_id : main_project_id,
				acc_project_list_alacak : acc_project_list_alacak,
				acc_project_list_borc : acc_project_list_borc,
				document_type : document_type_,
				payment_method : payment_type_
			);
		}
		else if(isdefined("attributes.expense_id"))
			muhasebe_sil(action_id:GET_ACT_ID.ACT_ID,process_type:32);
	</cfscript>
<cfelseif isdefined("attributes.expense_id")>
	<cfscript>
		cari_sil(action_id:GET_ACT_ID.ACT_ID,process_type:32);
		muhasebe_sil(action_id:GET_ACT_ID.ACT_ID,process_type:32);
	</cfscript>
</cfif>
	
