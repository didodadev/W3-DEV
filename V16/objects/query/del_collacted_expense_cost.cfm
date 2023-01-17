<cfquery name="get_process" datasource="#dsn2#">
	SELECT 
		PROCESS_CAT,
		SERIAL_NO,
		SERIAL_NUMBER,
		EXPENSE_ITEM_PLANS_ID
	FROM 
		EXPENSE_ITEM_PLANS
	WHERE
		EXPENSE_ID = #attributes.expense_id# 
</cfquery>
<cfif not isdefined('xml_import')>
	<cfinclude template="../../invoice/query/check_our_period.cfm"><!--- islem yapilan donem session'dakine uygun mu? --->
</cfif>
<cfscript>
	//Proses Tipleri İçin İşlemler
	get_process_type = cfquery(datasource : "#dsn3#", sqlstring : "SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE  PROCESS_CAT_ID = #attributes.process_cat#");
	process_type = get_process_type.process_type;
</cfscript>
<cflock timeout="30" name="#CreateUUID()#">
	<cftransaction>		
		<!--- Gider planalrının ödeme taleplerini ödenmedi durumuna geliyor --->
		<cfquery name="get_budget_id" datasource="#dsn2#">
			SELECT BUDGET_PLAN_ROW_ID FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = #attributes.expense_id#
		</cfquery>
		<cfif get_budget_id.recordcount>
			<cfoutput query="get_budget_id">
				<cfif len(get_budget_id.budget_plan_row_id)>
					<cfquery name="upd_payment" datasource="#dsn2#">
						UPDATE #dsn_alias#.CORRESPONDENCE_PAYMENT SET STATUS = NULL WHERE BUDGET_PLAN_ROW_ID = #get_budget_id.budget_plan_row_id#
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
		<cfif get_process.EXPENSE_ITEM_PLANS_ID neq "">
			<cfquery name="get_exp_item_plan_request" datasource="#dsn2#">
				SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
			<cfscript>
				cari_sil(action_id:get_process.EXPENSE_ITEM_PLANS_ID,process_type:get_exp_item_plan_request.EXPENSE_STAGE,cari_db : dsn2,action_table : "EXPENSE_ITEM_PLAN_REQUESTS");
				butce_sil(action_id:get_process.EXPENSE_ITEM_PLANS_ID,process_type:2503);
				muhasebe_sil(action_id:get_process.EXPENSE_ITEM_PLANS_ID,process_type:2503);
			</cfscript>
			<cfquery name="DELETE_SALARYPARAM_PAY_FROM_HEALTH_ID" datasource="#dsn2#">
				DELETE FROM #dsn#.SALARYPARAM_PAY WHERE EXPENSE_HEALTH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
			<cfquery name="DELETE_SALARYPARAM_GET_FROM_HEALTH_ID" datasource="#dsn2#">
				DELETE FROM #dsn#.SALARYPARAM_GET WHERE EXPENSE_HEALTH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
			<cfquery name="del_limb_drug_comp" datasource="#dsn2#">
				DELETE FROM HEALTH_EXPENSE WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process.EXPENSE_ITEM_PLANS_ID#"> OR EXPENSE_ITEM_PLAN_REQUESTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
			<cfquery name="del_exp_item_plan_request" datasource="#dsn2#">
				DELETE FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process.EXPENSE_ITEM_PLANS_ID#">
			</cfquery>
		</cfif>
		<cfquery name="del_expense_items_plans" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = #attributes.expense_id#
		</cfquery>
		<cfquery name="del_expense_items_plan_money" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = #attributes.expense_id#
		</cfquery>
		<cfquery name="DEL_ROW" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = #attributes.expense_id#
		</cfquery>
		<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
			DELETE FROM STOCKS_ROW WHERE UPD_ID = #attributes.expense_id# AND PROCESS_TYPE = #process_type#
		</cfquery>
		<!--- Kasa  hareketleri siliniyor --->
		<cfquery name="GET_CASH_ACTION" datasource="#dsn2#">
			SELECT ACTION_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = #attributes.expense_id#
		</cfquery>
		<cfif get_process_type.process_type eq 121>
			<cfset cash_process_type = 31>
			<cfset bank_process_type = 24>
		<cfelse>
			<cfset cash_process_type = 32>
			<cfset bank_process_type = 25>
		</cfif>
		<cfif get_cash_action.recordcount>
			<cfscript>
				cari_sil(action_id:GET_CASH_ACTION.ACTION_ID,process_type:cash_process_type);
				muhasebe_sil (action_id:GET_CASH_ACTION.ACTION_ID,process_type:cash_process_type);
			</cfscript>		
			<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #GET_CASH_ACTION.ACTION_ID#
			</cfquery>
		</cfif>
		<!--- banka hareketleri siliniyor --->
		<cfquery name="GET_BANK_ACTION" datasource="#dsn2#">
			SELECT ACTION_ID FROM BANK_ACTIONS WHERE EXPENSE_ID = #attributes.expense_id#
		</cfquery>
		<!---tevkifat kayıtları siliniyor --->
		<cfquery name="DEL_EXPENSE_TAXES" datasource="#dsn2#">
			DELETE FROM INVOICE_TAXES WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
		</cfquery>
		<cfif get_bank_action.recordcount>
			<cfscript>
				cari_sil(action_id:GET_BANK_ACTION.ACTION_ID,process_type:bank_process_type);
				muhasebe_sil (action_id:GET_BANK_ACTION.ACTION_ID,process_type:bank_process_type);
			</cfscript>		
			<cfquery name="DEL_FROM_BANK_ACTIONS" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #GET_BANK_ACTION.ACTION_ID#
			</cfquery>
		</cfif>
		<!--- kredi kartı ödeme hareketlleri siliniyor --->
		<cfquery name="GET_CREDIT_ACTION" datasource="#dsn2#">
			SELECT CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE EXPENSE_ID = #attributes.expense_id# AND ACTION_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfif get_credit_action.recordcount>
			<cfscript>
				cari_sil(action_id:GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID,process_type:242);
				muhasebe_sil (action_id:GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID,process_type:242);
			</cfscript>
			<cfquery name="DEL_CC_REVENUE_MONEY" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_MONEY WHERE ACTION_ID = #GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#
			</cfquery>
			<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS WHERE CREDITCARD_EXPENSE_ID = #GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#
			</cfquery>
			<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE CREDITCARD_EXPENSE_ID = #GET_CREDIT_ACTION.CREDITCARD_EXPENSE_ID#
			</cfquery>
		</cfif>
		<cfquery name="upd_efatura" datasource="#dsn2#">
			UPDATE
				EINVOICE_RECEIVING_DETAIL
			SET
				EXPENSE_ID = NULL,
				IS_PROCESS = 0,
				STATUS = NULL,
				UPDATE_DATE = #CREATEODBCDATETIME(NOW())#
			WHERE
				EXPENSE_ID = #attributes.expense_id#
		</cfquery>
		<!---- masrafı silinen kaydın kredi ödemesinde gerçekleşen kaydının silinmesi ---->
		<cfquery name="del_rows" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CONTRACT_ROW WHERE ACTION_ID = #attributes.expense_id# AND PROCESS_TYPE = #process_type#
		</cfquery> 
		<cfscript>
			cari_sil(action_id:attributes.expense_id, process_type:process_type);
			muhasebe_sil(action_id:attributes.expense_id, process_type:process_type);
		</cfscript>
		<cf_add_log  log_type="-1" action_id="#attributes.expense_id#" action_name="#attributes.head# Silindi"  process_type="#get_process_type.process_type#" process_stage="#get_process.process_cat#" paper_no="#get_process.serial_number#-#get_process.serial_no#" data_source="#dsn2#">
	</cftransaction>
</cflock>

<cfif isdefined("attributes.is_from_credit") and len(attributes.is_from_credit) and attributes.is_from_credit eq 1>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=cost.list_expense_income</cfoutput>';
	</script>
</cfif>
