<cfinclude template="get_basket_irs.cfm">
<cfquery name="GET_SHIP" datasource="#dsn2#"><!--- faturanın kendi irsaliyesi varsa alır --->
	SELECT 
		INV_S.SHIP_ID,
		INV_S.INVOICE_NUMBER,
		INV_S.SHIP_NUMBER,
		INV_S.IS_WITH_SHIP,
		S.SHIP_TYPE
	FROM 
		INVOICE_SHIPS INV_S,
		SHIP S
	WHERE 
		INV_S.INVOICE_ID = #form.invoice_id# AND 
		INV_S.IS_WITH_SHIP=1 AND
		INV_S.SHIP_ID=S.SHIP_ID
</cfquery>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type, belge_no:form.invoice_number);
			cari_sil(action_id:form.invoice_id, process_type:form.old_process_type, is_delete_action:1);
			if(len(get_number.cash_id))
				{
				muhasebe_sil(action_id:get_number.cash_id, process_type:34, belge_no:form.invoice_number);
				cari_sil(action_id:get_number.cash_id, process_type:34);
				}
			butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2);
			if( listfind('59,60,65,68,64',invoice_cat,',') ){
				butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2,reserv_type:1); // butce rez. siliyor
			}
		</cfscript>
		<cfif len(get_number.cash_id)>				
			<cfquery name="GET_CASH_DET" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS WHERE ACTION_ID=#GET_NUMBER.CASH_ID#
			</cfquery>
		</cfif>
		<cfif len(GET_NUMBER.IS_WITH_SHIP) and GET_NUMBER.IS_WITH_SHIP>
			<!--- 20040311 IS_WITH_SHIP bos olamaz ama fatura ile iliskili kayıt yoksa --->
			<cfif get_ship.recordcount>
				<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
					DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#GET_SHIP.SHIP_TYPE# AND UPD_ID=#GET_SHIP.SHIP_ID#
				</cfquery>
				<cfquery name="DEL_SHIP_ROW4" datasource="#dsn2#">
					DELETE FROM SHIP_MONEY WHERE ACTION_ID = #GET_SHIP.SHIP_ID#
				</cfquery>	
				<cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
					DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
				</cfquery>	
				<!--- seri no kayitlari silinir --->
				<cfscript>
				del_serial_no(
				process_id : GET_SHIP.SHIP_ID,
				process_cat : GET_SHIP.SHIP_TYPE, 
				period_id : session.ep.period_id
				);
				</cfscript>
				<!--- seri no kayitlari silinir --->	
				<cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
					DELETE FROM SHIP_ROW WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
				</cfquery>
				<cfquery name="DEL_SHIP" datasource="#dsn2#">
					DELETE FROM SHIP WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
				</cfquery>	
			</cfif>
 		</cfif>
		<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
			DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="UPD_CONTROL_BILL" datasource="#dsn2#"><!--- fark faturası silindiginde kapattıgı fark satırı çözülüyor --->
			UPDATE
				INVOICE_CONTRACT_COMPARISON
			SET
				DIFF_INVOICE_ID = NULL
			WHERE
				CONTRACT_COMPARISON_ROW_ID IN (SELECT RELATED_ACTION_ID FROM INVOICE_ROW WHERE INVOICE_ID = #form.invoice_id# AND RELATED_ACTION_TABLE='INVOICE_CONTRACT_COMPARISON')
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW_1" datasource="#dsn2#">
			DELETE FROM INVOICE_CONTRACT_COMPARISON WHERE MAIN_INVOICE_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW_12" datasource="#dsn2#">
			DELETE FROM INVOICE_CONTROL WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW_123" datasource="#dsn2#">
			DELETE FROM INVOICE_CONTROL_CONTRACT_ACTIONS WHERE ACTION_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW_POS_PRO" datasource="#dsn2#">
			DELETE FROM INVOICE_ROW_POS_PROBLEM WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW_POS" datasource="#dsn2#">
			DELETE FROM INVOICE_ROW_POS WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW" datasource="#dsn2#">
			DELETE FROM INVOICE_ROW WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_11" datasource="#dsn2#">
			DELETE FROM INVOICE_COST WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_111" datasource="#dsn2#">
			DELETE FROM INVOICE_MONEY WHERE ACTION_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_1" datasource="#dsn2#">
			DELETE FROM INVOICE_GROUP_COMP_INVOICE WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE" datasource="#dsn2#">
			DELETE FROM INVOICE WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
		<cfquery name="Del_Relation_Warnings" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'INVOICE' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		</cfquery>
		<cfquery name="DEL_INVOICE_MLM_SALES" datasource="#dsn2#">
			DELETE FROM INVOICE_MULTILEVEL_SALES WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_MLM_PREMIUM" datasource="#dsn2#">
			DELETE FROM INVOICE_MULTILEVEL_PREMIUM WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfif isdefined("attributes.order_id") and len(attributes.order_id) and get_ship.recordcount><!--- siparişten satış faturası eklenmiş ise --->
			<cfquery name="DEL_ORD_SHIPS" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#GET_SHIP.SHIP_ID# AND PERIOD_ID=#session.ep.period_id# AND ORDER_ID=#attributes.order_id# 
			</cfquery>
		</cfif>
		<cfquery name="upd_efatura" datasource="#dsn2#">
			UPDATE
				EINVOICE_RECEIVING_DETAIL
			SET
				INVOICE_ID = NULL,
				IS_PROCESS = 0,
				STATUS = NULL,
				UPDATE_DATE = #CREATEODBCDATETIME(NOW())#
			WHERE
				INVOICE_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="GET_BANK_ACTION" datasource="#dsn2#">
			SELECT ACTION_ID FROM BANK_ACTIONS WHERE BILL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
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
		<cfscript>
			//siparişten gelen fatura ilişkisinin silinmesi
			add_ship_row_relation(
				to_related_process_id : form.invoice_id,
				to_related_process_type : form.process_cat,
				old_related_process_type : form.old_process_type,
				is_invoice_ship : 0,
				ship_related_action_type:2,
				process_db :dsn2
				);
			add_relation_rows(
				action_type:'del',
				action_dsn : '#dsn2#',
				to_table:'INVOICE',
				to_action_id : form.invoice_id
				);
			add_reserve_row(
				related_process_id : form.invoice_id,
				reserve_action_type:2,
				is_order_process:2,
				is_purchase_sales:0,
				process_db :dsn2
				);
		</cfscript>
		<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#form.invoice_id#"
				action_table="INVOICE"
				action_column="INVOICE_ID"
				is_action_file = 1
				action_db_type = '#dsn2#'
				action_file_name = '#get_process_type.action_file_name#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>
        <cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#form.invoice_id#" action_name="#form.invoice_number# Silindi" paper_no="#form.invoice_number#" period_id="#session.ep.period_id#" process_type="#form.old_process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
