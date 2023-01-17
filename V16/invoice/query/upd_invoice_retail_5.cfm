<cfif isdefined("form.cash") and (form.cash eq 1)>
	<cfloop from="1" to="#kur_say#" index="k">
		 <cfif isdefined("kasa#k#") and isdefined("cash_amount#k#") and (filternum(evaluate('cash_amount#k#')) gt 0)>
			<cfset 'attributes.cash_amount#k#' = filternum(evaluate('cash_amount#k#'))>
			<cfquery name="get_cash_code" datasource="#dsn2#">
				SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID=#evaluate("kasa#k#")#
			</cfquery>
			<cfif len(get_cash_code.BRANCH_ID)> <!--- carici ve muhasebecide kullanılıyor --->
				<cfset cash_branch_id = get_cash_code.BRANCH_ID>
			<cfelse>
				<cfset cash_branch_id = ''>
			</cfif>
		  	<cfif isdefined("cash_action_id_#k#") and len(evaluate("cash_action_id_#k#"))>
				<cfquery name="UPD_ALISF_KAPA" datasource="#dsn2#">
					UPDATE 
						CASH_ACTIONS
					SET					
						CASH_ACTION_TO_CASH_ID=#evaluate("kasa#k#")#,
						ACTION_TYPE_ID=35,
						BILL_ID=#form.invoice_id#,
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
						CASH_ACTION_FROM_COMPANY_ID=#attributes.company_id#,
					<cfelse>
						CASH_ACTION_FROM_CONSUMER_ID=#attributes.consumer_id#,
					</cfif>
						CASH_ACTION_VALUE=#evaluate('attributes.cash_amount#k#')#,
						CASH_ACTION_CURRENCY_ID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('currency_type#k#')#">,
						ACTION_DATE=#attributes.invoice_date#,
						IS_PROCESSED=#is_account#,
						PAPER_NO=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
						IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
						IS_ACCOUNT_TYPE = 11,
						PROCESS_CAT=0,
						UPDATE_EMP=#session.ep.userid#,
						UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						UPDATE_DATE=#now()#,
						ACTION_VALUE = #evaluate('system_cash_amount#k#')#,
						ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
						<cfif len(session.ep.money2)>
							,ACTION_VALUE_2 = #wrk_round(evaluate('system_cash_amount#k#')/attributes.currency_multiplier,4)#
							,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
						</cfif>
					WHERE
						ACTION_ID=#evaluate("cash_action_id_#k#")#
				</cfquery>
				<cfquery name="UPD_INVOICE_CASH_POS2" datasource="#dsn2#">
					UPDATE 
						INVOICE_CASH_POS
					SET
						KASA_ID=#evaluate("kasa#k#")#
					WHERE
						INVOICE_ID=#form.invoice_id#
						AND CASH_ID=#evaluate("cash_action_id_#k#")#
				</cfquery>
				<cfset act_id=evaluate("cash_action_id_#k#")>
			<cfelse>
				<cfquery name="ADD_ALISF_KAPA" datasource="#dsn2#">
					INSERT INTO CASH_ACTIONS
						(
						CASH_ACTION_TO_CASH_ID,
						ACTION_TYPE,
						ACTION_TYPE_ID,
						BILL_ID,
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
						CASH_ACTION_FROM_COMPANY_ID,
					<cfelse>
						CASH_ACTION_FROM_CONSUMER_ID,
					</cfif>
						CASH_ACTION_VALUE,
						CASH_ACTION_CURRENCY_ID,
						ACTION_DATE,
						ACTION_DETAIL,
						IS_PROCESSED,
						PAPER_NO,
						IS_ACCOUNT,
						IS_ACCOUNT_TYPE,
						PROCESS_CAT,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						ACTION_VALUE,
						ACTION_CURRENCY_ID
						<cfif len(session.ep.money2)>
							,ACTION_VALUE_2
							,ACTION_CURRENCY_ID_2
						</cfif>
						)
					VALUES
						(
						#evaluate("kasa#k#")#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="SATIŞ FATURASI KAPAMA İŞLEMİ">,
						35,
						#form.invoice_id#,
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
						#attributes.company_id#,
					<cfelse>
						#attributes.consumer_id#,
					</cfif>
						#evaluate('attributes.cash_amount#k#')#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('currency_type#k#')#">,
						#attributes.invoice_date#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="SATIŞ FATURASI KAPAMA İŞLEMİ">,
					<cfif is_account>1<cfelse>0</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
						<cfif is_account eq 1>
							1,
							11,
						<cfelse>
							0,
							11,
						</cfif>
						0,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						#now()#,
						#form.basket_net_total#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
						<cfif len(session.ep.money2)>
							,#wrk_round(form.basket_net_total/attributes.currency_multiplier,4)#
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
						</cfif>
						)
				</cfquery>
				<cfquery name="GET_ACT_ID" datasource="#dsn2#">
					SELECT MAX(ACTION_ID) AS ACT_ID	FROM CASH_ACTIONS
				</cfquery>
				<cfset act_id=get_act_id.ACT_ID>
				<cfquery name="UPD_INVOICE_CASH" datasource="#dsn2#">
					INSERT INTO INVOICE_CASH_POS
						(
						INVOICE_ID,
						CASH_ID,
						KASA_ID
						)
					VALUES
						(
						#form.invoice_id#,
						#ACT_ID#,
						#evaluate("kasa#k#")#
						)
				</cfquery>
			</cfif>
			<cfscript>
				if(is_cari eq 1)
				{
					carici(
						action_id : ACT_ID,  
						action_table : 'CASH_ACTIONS',
						workcube_process_type : 35,
						workcube_old_process_type : 35,
						account_card_type : 13,
						islem_tarihi : attributes.invoice_date,
						islem_tutari : evaluate("attributes.system_cash_amount#k#"),
						islem_belge_no : FORM.INVOICE_NUMBER,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						islem_detay : 'SATIŞ FATURASI KAPAMA İŞLEMİ',
						action_detail : note,
						other_money_value : evaluate("attributes.cash_amount#k#"),
						other_money : evaluate("attributes.currency_type#k#"),
						action_currency : SESSION.EP.MONEY,
						to_cash_id : evaluate("kasa#k#"),
						to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
						process_cat : 0,
						currency_multiplier : attributes.currency_multiplier 
						);
				}
				else
					cari_sil(action_id:ACT_ID, process_type:35);
					
				if(is_account eq 1)
				{
					DETAIL_2 = DETAIL_ & " KAPAMA ISLEMI";
					muhasebeci(
						action_id : ACT_ID,
						workcube_process_type : 35,
						workcube_old_process_type : 35,
						account_card_type : 11,
						company_id : attributes.company_id,
						consumer_id : attributes.consumer_id,
						islem_tarihi : attributes.invoice_date,
						borc_hesaplar : get_cash_code.CASH_ACC_CODE,							
						borc_tutarlar : wrk_round(evaluate("attributes.system_cash_amount#k#")),
						other_amount_borc : evaluate("attributes.cash_amount#k#"),
						other_currency_borc : evaluate("attributes.currency_type#k#"),
						alacak_hesaplar : ACC,
						alacak_tutarlar : wrk_round(evaluate("attributes.system_cash_amount#k#")),
						other_amount_alacak : evaluate("attributes.cash_amount#k#"),
						other_currency_alacak : evaluate("attributes.currency_type#k#"),
						to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
						fis_detay : '#DETAIL_2#',
						fis_satir_detay : 'Satış Fatura Kapama',
						belge_no : form.invoice_number,
						is_account_group : is_account_group,
						currency_multiplier : attributes.currency_multiplier  
						);
					}
				else
					muhasebe_sil(action_id:ACT_ID, process_type:35);
			</cfscript>		
		<cfelse>
			<cfif isdefined("cash_action_id_#k#") and  len(evaluate('cash_action_id_#k#'))>
				<cfscript>
					cari_sil(action_id:evaluate('cash_action_id_#k#'), process_type:35);
					muhasebe_sil(action_id:evaluate('cash_action_id_#k#'), process_type:35);
				</cfscript>
				<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
					DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #evaluate('cash_action_id_#k#')# AND ACTION_TYPE_ID=35
				</cfquery>
				<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
					DELETE FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID = #evaluate('cash_action_id_#k#')#
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			IS_CASH=1,
			IS_ACCOUNTED = #is_account#
		WHERE
			INVOICE_ID=#form.invoice_id#
	</cfquery>
<cfelse>
	<cfquery name="control_invoice_cash" datasource="#dsn2#">
		SELECT CASH_ID,KASA_ID,INVOICE_CASH_ID FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID IS NOT NULL
	</cfquery>
	<cfif control_invoice_cash.recordcount>
		<cfscript>
			for(i=1; i lte control_invoice_cash.recordcount; i=i+1)
				{
					cari_sil(action_id:control_invoice_cash.cash_id[i], process_type:35);
					muhasebe_sil(action_id:control_invoice_cash.cash_id[i], process_type:35);
				}
		</cfscript>
		<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID IN (#valuelist(control_invoice_cash.CASH_ID)#)
		</cfquery>
		<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID IN (#valuelist(control_invoice_cash.CASH_ID)#)
		</cfquery>
	</cfif>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			IS_CASH = 0,
			IS_ACCOUNTED = 0
		WHERE
			INVOICE_ID=#form.invoice_id#
	</cfquery>		
</cfif>

