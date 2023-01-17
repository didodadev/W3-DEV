<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			muhasebe_sil(action_id:form.invoice_id, process_type: form.old_process_type);    
			cari_sil(action_id:form.invoice_id, process_type: form.old_process_type, is_delete_action:1);   
			butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2);
			if(len(get_number.cash_id))
				{
				muhasebe_sil(action_id:get_number.cash_id, process_type: 34);
				cari_sil(action_id:get_number.cash_id, process_type: 34);
				}
		</cfscript>
		<cfif len(get_number.cash_id)>				
			<cfquery name="GET_CASH_DET" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS WHERE ACTION_ID=#GET_NUMBER.CASH_ID#
			</cfquery>
		</cfif>
		<cfif len(GET_NUMBER.IS_WITH_SHIP) and GET_NUMBER.IS_WITH_SHIP>
			<!--- 20040311 IS_WITH_SHIP bos olamaz ama fatura ile iliskili kayıt yoksa --->
			<cfquery name="GET_SHIP" datasource="#dsn2#">
				SELECT 
					INV_S.SHIP_ID,
					SHIP.SHIP_TYPE 
				FROM 
					SHIP,
					INVOICE_SHIPS INV_S 
				WHERE 
					INV_S.SHIP_ID=SHIP.SHIP_ID AND
					INV_S.INVOICE_ID = #form.invoice_id# AND 
					INV_S.SHIP_PERIOD_ID=#session.ep.period_id# AND
					SHIP.IS_WITH_SHIP=1 
			</cfquery>
			<cfif get_ship.recordcount>
				<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
					DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#GET_SHIP.SHIP_TYPE# AND UPD_ID=#GET_SHIP.SHIP_ID#
				</cfquery>					
				<cfquery name="DEL_SHIP_ROW4" datasource="#dsn2#">
					DELETE FROM SHIP_MONEY WHERE ACTION_ID = #get_ship.ship_id#
				</cfquery>				
				<cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
					DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #get_ship.ship_id#
				</cfquery>		
				<cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
					DELETE FROM SHIP_ROW WHERE SHIP_ID = #get_ship.ship_id#
				</cfquery>					
				<cfquery name="DEL_SHIP" datasource="#dsn2#">
					DELETE FROM SHIP WHERE SHIP_ID = #get_ship.ship_id#
				</cfquery>
				<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
					DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
				</cfquery>
			</cfif>
		<cfelse>
			<!--- 20050326 hizmet islemleri yuzunden olabilecek kacak stok hareketlerini silmeliyiz
			(Serbest Meslek Makbuzuna envantere dahil urun secilebilmesi gibi -urun secerken process_type ile oynayarak-) --->
			<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
				DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#form.old_process_type# AND UPD_ID=#form.invoice_id#
			</cfquery>					
		</cfif>
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
		<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
		<cfquery name="Del_Relation_Warnings" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'INVOICE' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#form.invoice_id# " action_name="#form.invoice_number# Silindi" process_cat="#get_number.process_cat#" paper_no="#get_number.invoice_number#"  process_type="#form.old_process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfquery name="DEL_INVOICE_CONTRACT_COMPARISON" datasource="#dsn2#">
	DELETE FROM INVOICE_CONTRACT_COMPARISON WHERE MAIN_INVOICE_ID = #form.invoice_id#
</cfquery>
