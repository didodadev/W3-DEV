<cf_get_lang_set module_name="cheque">
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
		<cfset action_date = attributes.payroll_date>
		<cf_date tarih = "action_date">
		<cfquery name="get_payroll_actions" datasource="#dsn2#">
			SELECT * FROM VOUCHER_PAYROLL_ACTIONS WHERE PAYROLL_ID = #attributes.payroll_id#
		</cfquery>
		<cfquery name="get_process" datasource="#dsn2#">
			SELECT PROCESS_CAT,PAPER_NO FROM CASH_ACTIONS WHERE ACTION_ID = #get_payroll_actions.action_id#
		</cfquery>
		<cfquery name="get_payroll_process_cat" datasource="#dsn2#" maxrows="1">
			SELECT IS_ACCOUNT,IS_CARI,IS_ACCOUNT_GROUP FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 1057
		</cfquery>
		<cfquery name="get_payroll_item" datasource="#dsn2#">
			SELECT INCOME_ITEM_ID,COMPANY_ID,CONSUMER_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID = #attributes.payroll_id#
		</cfquery>
		<cfquery name="get_closed_voucher" datasource="#dsn2#">
			SELECT * FROM VOUCHER_CLOSED WHERE PAYROLL_ID = #attributes.payroll_id#
		</cfquery>
		<cfif attributes.is_delete eq 0><!--- İptal işlemi --->
			<cfif get_payroll_process_cat.recordcount>
				<cfset is_account = get_payroll_process_cat.is_account>
				<cfset is_account_group = get_payroll_process_cat.is_account_group>
			<cfelse>
				<cfset is_account = 1>
				<cfset is_account_group = 1>
			</cfif>
			<cfif is_account eq 1>
				<cfif len(get_payroll_item.company_id)>
					<cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(get_payroll_item.company_id)>
				<cfelseif len(get_payroll_item.consumer_id)>
					<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(get_payroll_item.consumer_id)>
				</cfif>
				<cfif not len(MY_ACC_RESULT)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='126.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
						history.back();	
					</script>
					<cfabort>
				</cfif>
			</cfif>
			<cfif len(get_payroll_item.INCOME_ITEM_ID)>
				<cfquery name="get_exp_acc_code" datasource="#dsn2#">
					SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_payroll_item.INCOME_ITEM_ID#
				</cfquery>
				<cfset exp_acc_code = get_exp_acc_code.ACCOUNT_CODE>
			<cfelse>
				<cfset exp_acc_code = "">
			</cfif>		
			<cfif get_payroll_actions.action_type_id eq 31>
				<!--- Nakit tahsilat ise karşılında ödeme yapılıyor --->
				<cfinclude template="add_payroll_cancel_1.cfm">
			<cfelseif get_payroll_actions.action_type_id eq 24>
				<!--- banka havalesi ile ödenmiş ise giden havale kaydediliyor --->
				<cfinclude template="add_payroll_cancel_3.cfm">
			<cfelse>
				<!--- kredi kartı tahsilat ise karşılında tahsilat iptal yapılıyor --->
				<cfinclude template="add_payroll_cancel_2.cfm">
			</cfif>
		<cfelse><!--- Silme işlemi --->
			<cfinclude template="del_payroll_cancel.cfm">	
		</cfif>
		<cfoutput query="get_closed_voucher">
			<cfquery name="get_hist" datasource="#dsn2#">
				SELECT * FROM VOUCHER_CLOSED WHERE ACTION_ID = #get_closed_voucher.action_id# AND PAYROLL_ID <> #attributes.payroll_id#
			</cfquery>
			<cfif get_hist.recordcount>
				<cfquery name="UPD_PAYROLL_VOUCHERS" datasource="#dsn2#">
					UPDATE
						VOUCHER
					SET
						VOUCHER_STATUS_ID=11
					WHERE
						VOUCHER_ID=#get_closed_voucher.action_id#	
				</cfquery>
			<cfelse>
				<cfquery name="UPD_PAYROLL_VOUCHERS" datasource="#dsn2#">
					UPDATE
						VOUCHER
					SET
						VOUCHER_STATUS_ID=1
					WHERE
						VOUCHER_ID=#get_closed_voucher.action_id#	
				</cfquery>
			</cfif>
		</cfoutput>
		<cfquery name="del_closed" datasource="#dsn2#">
			DELETE FROM VOUCHER_CLOSED WHERE PAYROLL_ID = #attributes.payroll_id#
		</cfquery>
		<cfquery name="del_hist" datasource="#dsn2#">
			DELETE FROM VOUCHER_HISTORY WHERE PAYROLL_ID= #attributes.payroll_id#
		</cfquery>
		<cfquery name="del_money" datasource="#dsn2#">
			DELETE FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID= #attributes.payroll_id#
		</cfquery>
		<cfquery name="del_payroll" datasource="#dsn2#">
			DELETE FROM VOUCHER_PAYROLL WHERE ACTION_ID= #attributes.payroll_id#
		</cfquery>
		<cfquery name="del_payroll_actions" datasource="#dsn2#">
			DELETE FROM VOUCHER_PAYROLL_ACTIONS WHERE PAYROLL_ID= #attributes.payroll_id#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.payroll_id#" action_name="#attributes.head#" process_type="#attributes.payroll_type#" paper_no="#get_process.paper_no#" process_stage="#get_process.process_cat#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
