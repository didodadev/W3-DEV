<!--- güncellemede bank işleminden kasa işlemine geçiş yaptı ise eski kasa işlemi ve kredi kartı siliniyor--->
<cfif isdefined("attributes.expense_id") and isdefined("is_upd_action")>
	<cfquery name="GET_CASH_ACTION" datasource="#dsn2#">
		SELECT ACTION_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
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
	<cfquery name="GET_BANK_ACTIONS" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
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
			ACTION_DETAIL=<cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>#sql_unicode()#'#actionDetail#'</cfif>,
			ACTION_VALUE=#attributes.net_total_amount/currency_multiplier_banka#,
			BANK_ACTION_KDVSIZ_VALUE=#attributes.total_amount/currency_multiplier_banka#,
			BANK_ACTION_TAX_VALUE=#attributes.kdv_total_amount/currency_multiplier_banka#,
			ACTION_CURRENCY_ID=#sql_unicode()#'#attributes.currency_id#',
			ACTION_DATE=#attributes.expense_date#,
			OTHER_CASH_ACT_VALUE=<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
			OTHER_MONEY=<cfif len(rd_money_value)>#sql_unicode()#'#rd_money_value#',<cfelse>NULL,</cfif>
			ACTION_EMPLOYEE_ID=<cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#,<cfelse>NULL,</cfif>
			UPDATE_DATE=#now()#,
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP=#sql_unicode()#'#cgi.REMOTE_ADDR#',
			FROM_BRANCH_ID = #branch_id_info_document#,
			IS_ACCOUNT=<cfif is_account eq 1>1,<cfelse>0,</cfif>
			IS_ACCOUNT_TYPE=13,
			PAPER_NO=#sql_unicode()#'#attributes.belge_no#',
			PROJECT_ID = <cfif len(project_id_info)>#project_id_info#<cfelse>NULL</cfif>,
			ACTION_FROM_ACCOUNT_ID=#attributes.account_id#,
			SYSTEM_ACTION_VALUE = #attributes.net_total_amount#,
			SYSTEM_CURRENCY_ID = #sql_unicode()#'#session.ep.money#'
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2 = #wrk_round(attributes.net_total_amount/currency_multiplier_money2,4)#
				,ACTION_CURRENCY_ID_2 = #sql_unicode()#'#session.ep.money2#'
			</cfif>
		WHERE
			EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT ACTION_ID AS ACT_ID FROM BANK_ACTIONS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
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
				EXPENSE_ID,		
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
				<cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>#sql_unicode()#'#actionDetail#'</cfif>,
				#attributes.net_total_amount/currency_multiplier_banka#,
				#attributes.total_amount/currency_multiplier_banka#,
				#attributes.kdv_total_amount/currency_multiplier_banka#,
				#sql_unicode()#'#attributes.currency_id#',
				#attributes.expense_date#,
				<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
				<cfif len(rd_money_value)>'#rd_money_value#',<cfelse>NULL,</cfif>
				<cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#,<cfelse>NULL,</cfif>
				#now()#,
				#session.ep.userid#,
				#sql_unicode()#'#cgi.REMOTE_ADDR#',
				 <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
				#sql_unicode()#'#attributes.belge_no#',
				<cfif len(project_id_info)>#project_id_info#<cfelse>NULL</cfif>,
				#attributes.account_id#,
				<cfif isdefined("attributes.expense_id") and isdefined("is_upd_action")>#attributes.expense_id#<cfelse>#get_maxid.max_id#</cfif>,				
				#branch_id_info_document#,
				#attributes.net_total_amount#,
				#sql_unicode()#'#session.ep.money#'
				<cfif len(session.ep.money2)>
					,#wrk_round(attributes.net_total_amount/currency_multiplier_money2,4)#
					,#sql_unicode()#'#session.ep.money2#'
				</cfif>
			)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT MAX(ACTION_ID) AS ACT_ID FROM BANK_ACTIONS
	</cfquery>
	<cfset workcube_old_process_type = 0>
</cfif>
<!--- eğer cari seçilmişse muhasebe ve cari hareketi yapacak --->
<cfquery name="get_cari_kontrol_bank" datasource="#dsn2#">
	SELECT DISTINCT PROJECT_ID FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACT_ID.ACT_ID#"> AND ACTION_TYPE_ID = 25
</cfquery>
<cfif ((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)) or (attributes.ch_member_type eq 'consumer' and len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)))>
	<cfscript>
		if(is_cari eq 1)//banka carici
		{
			if(is_row_project_based_cari eq 1 or (is_row_project_based_cari eq 0 and get_cari_kontrol_bank.recordcount neq 1))
				cari_sil(action_id:GET_ACT_ID.ACT_ID,process_type:25);
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
						action_table : 'BANK_ACTIONS',
						workcube_process_type : 25,
						account_card_type : 13,
						islem_tarihi : attributes.expense_date,
						due_date : attributes.expense_date,
						islem_tutari : evaluate('row_amount_total_#ind_t#'),
						islem_belge_no : attributes.belge_no,
						to_cmp_id : from_company_id,
						to_consumer_id : from_consumer_id,
						to_employee_id : from_employee_id,
						to_branch_id :branch_id_info_document,
						islem_detay : UCase("#getLang('main',652)# #getLang('main',435)# #getLang('main',2610)#"),
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
						action_table : 'BANK_ACTIONS',
						workcube_process_type : 25,
						account_card_type : 13,
						islem_tarihi : attributes.expense_date,
						due_date : attributes.expense_date,
						islem_tutari : total_cash_price,
						islem_belge_no : attributes.belge_no,
						to_cmp_id : from_company_id,
						to_consumer_id : from_consumer_id,
						to_employee_id : from_employee_id,
						to_branch_id :branch_id_info_document,
						islem_detay : UCase("#getLang('main',652)# #getLang('main',435)# #getLang('main',2610)#"),
						action_detail : attributes.detail,
						other_money_value : total_other_cash_price,
						other_money : rd_money_value,
						action_currency : session.ep.money,
						currency_multiplier : currency_multiplier_money2,
						process_cat : form.process_cat,
						project_id : project_id_info,
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
					action_table : 'BANK_ACTIONS',
					workcube_process_type : 25,
					account_card_type : 13,
					from_account_id : account_id,
					islem_tarihi : attributes.expense_date,
					due_date : attributes.expense_date,
					islem_tutari : attributes.net_total_amount,
					islem_belge_no : attributes.belge_no,
					to_cmp_id : from_company_id,
					to_consumer_id : from_consumer_id,
					to_employee_id : from_employee_id,
					to_branch_id :branch_id_info_document,
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
				acc_department_id:acc_department_id,
				account_card_type : 13,
				company_id : from_company_id,
				consumer_id : from_consumer_id,
				employee_id : from_employee_id,
				islem_tarihi : attributes.expense_date,
				borc_hesaplar : string_acc_code,
				borc_tutarlar : attributes.net_total_amount,
				alacak_hesaplar : attributes.account_acc_code,
				alacak_tutarlar : attributes.net_total_amount,
				fis_satir_detay: UCase("#getLang('main',1760)# #getLang('main',435)#"),
				fis_detay : UCase("#getLang('main',1760)# #getLang('main',435)#"),
				belge_no : attributes.belge_no,
				from_branch_id :branch_id_info_document,
				
				other_amount_borc : attributes.other_net_total_amount,
				other_currency_borc : rd_money_value,
				other_amount_alacak : wrk_round(attributes.net_total_amount/currency_multiplier_banka ,4),
				other_currency_alacak : attributes.currency_id,
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
			muhasebe_sil(action_id:GET_ACT_ID.ACT_ID,process_type:25);
	</cfscript>
<cfelseif isdefined("attributes.expense_id")>
	<cfscript>
		cari_sil(action_id:GET_ACT_ID.ACT_ID,process_type:25);
		muhasebe_sil(action_id:GET_ACT_ID.ACT_ID,process_type:25);
	</cfscript>
</cfif>
