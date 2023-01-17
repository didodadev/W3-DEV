<cfscript>
	muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	cari_sil(action_id:form.invoice_id, process_type:form.old_process_type, is_delete_action:1);
	if(len(get_number.cash_id))
	{
		muhasebe_sil(action_id:get_number.cash_id, process_type:35);
		cari_sil(action_id:get_number.cash_id, process_type:35);
	}
	butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2);
</cfscript>	
<cfif len(get_number.cash_id)>
	<cfquery name="GET_CASH_DET" datasource="#dsn2#">
		DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #GET_NUMBER.CASH_ID# AND ACTION_TYPE_ID = 35
	</cfquery>
</cfif>

<cfif len(GET_NUMBER.IS_WITH_SHIP) and GET_NUMBER.IS_WITH_SHIP>
	<!---20040311 IS_WITH_SHIP bos olmaz ama faturayla ilgili kayıt yoksa --->
	<cfquery name="GET_SHIP" datasource="#dsn2#">
		SELECT 
			INV_S.SHIP_ID,
			SHIP.SHIP_TYPE 
		FROM 
			SHIP,
			INVOICE_SHIPS INV_S 
		WHERE 
			INV_S.INVOICE_ID = #form.invoice_id# AND 
			INV_S.SHIP_ID=SHIP.SHIP_ID AND
			INV_S.SHIP_PERIOD_ID = #session.ep.period_id# AND
			SHIP.IS_WITH_SHIP=1 
	</cfquery>
	<cfif GET_SHIP.recordcount>
		<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#GET_SHIP.SHIP_TYPE# AND UPD_ID=#GET_SHIP.SHIP_ID#
		</cfquery>
		<cfquery name="DEL_SHIP_ROW4" datasource="#dsn2#">
			DELETE FROM SHIP_MONEY WHERE ACTION_ID = #GET_SHIP.SHIP_ID#
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
		<!--- SHIP_RESULT'daki kayda ait SHIP_RESULT_ROW'da farklı kayıt kalmıyorsa, SHIP_RESULT kaydı da silinmeli OZDEN20060408 --->
		<cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
			DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
		</cfquery>
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
<cfquery name="DEL_INVOICE_MLM_SALES" datasource="#dsn2#">
	DELETE FROM INVOICE_MULTILEVEL_SALES WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_MLM_PREMIUM" datasource="#dsn2#">
	DELETE FROM INVOICE_MULTILEVEL_PREMIUM WHERE INVOICE_ID=#form.invoice_id#
</cfquery>

<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
<cfquery name="Del_Relation_Warnings" datasource="#dsn2#">
	DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'INVOICE' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>

<!--- Sistemle iliskisi varsa --->
<cfquery name="GET_CONTRACT_INVOICE" datasource="#DSN2#">
	SELECT PAYMENT_ROW_ID FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT_INVOICE WHERE INVOICE_ID = #form.invoice_id# AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfif get_contract_invoice.recordcount>
	<cfif len(get_contract_invoice.payment_row_id)><!--- Odeme Planindan gelmisse --->
		<cfquery name="UPD_PAYMENT_INVOICE" datasource="#DSN2#">
			UPDATE
				#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
			SET
				IS_BILLED = 0,
				INVOICE_ID = NULL,
				INVOICE_DATE = NULL,
				PERIOD_ID = NULL,
				IS_INVOICE_IPTAL = NULL,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_EMP = #session.ep.userid#
			WHERE
				SUBSCRIPTION_PAYMENT_ROW_ID IN (#get_contract_invoice.payment_row_id#)
		</cfquery>
	</cfif>
	<cfquery name="GET_CONTRACT_INVOICE" datasource="#DSN2#"><!--- fatura iliskisi kalmiyor. --->
		DELETE FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT_INVOICE WHERE INVOICE_ID = #form.invoice_id# AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
</cfif>
<!--- Fatura Ödeme Planinda Kayıt Varsa(sadece, bankaya gonderilmemis satirlara sahip odeme planlari) --->
<cfquery name="DEL_PAYMENT_PLAN_INVOICE" datasource="#DSN2#">
	DELETE FROM #dsn3_alias#.INVOICE_PAYMENT_PLAN WHERE INVOICE_ID = #form.invoice_id# AND PERIOD_ID = #session.ep.period_id#
</cfquery>

<!---Toplu Fatura Odeme Planlari güncellenir--->
<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
	UPDATE
		#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
	SET
		IS_BILLED = 0,
		INVOICE_DATE = NULL,
		INVOICE_ID = NULL,
		PERIOD_ID = NULL,
		IS_INVOICE_IPTAL = NULL,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_EMP = #session.ep.userid#
	WHERE
		INVOICE_ID = #form.invoice_id# AND 
		PERIOD_ID = #session.ep.period_id#
</cfquery>
<!--- sevkiyat planinda irsaliye iliskisini silmek icin eklendi sm 20140106 --->
<cfquery name="ship_result_control" datasource="#dsn2#">
	SELECT SHIP_ID,SR.SHIP_RESULT_ID FROM SHIP_RESULT SR, SHIP_RESULT_ROW SRR WHERE SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID AND SR.IS_ORDER_TERMS = 1 AND SRR.INVOICE_ID = #form.invoice_id#
</cfquery>
<cfif ship_result_control.recordcount>
	<cfquery name="Upd_Ship_Result_Row" datasource="#dsn2#">
		UPDATE SHIP_RESULT_ROW SET INVOICE_ID = NULL WHERE INVOICE_ID = #form.invoice_id#
	</cfquery>
	<cfquery name="Upd_Ship_Result_Row_Component" datasource="#dsn2#">
		UPDATE SHIP_RESULT_ROW_COMPONENT SET SHIP_RESULT_ROW_AMOUNT = 0 WHERE SHIP_RESULT_ID = #ship_result_control.ship_result_id#
	</cfquery>
</cfif>
<cfif IsDefined("form.service_id") and len(form.service_id)>
	<cfquery name="Upd_G_Servıce" datasource="#dsn2#">
    	UPDATE #dsn3_alias#.SERVICE SET INVOICE_ID = NULL WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.service_id#">
    </cfquery>
</cfif>

<cfquery name="DEL_INVOICE_TAXES" datasource="#dsn2#">
	DELETE FROM INVOICE_TAXES WHERE INVOICE_ID = #form.invoice_id#
</cfquery>

<cfquery name="DEL_INVOICE" datasource="#dsn2#">
	DELETE FROM INVOICE WHERE INVOICE_ID = #form.invoice_id#
</cfquery>

<cfif isDefined("attributes.order_id_listesi") and len(attributes.order_id_listesi) and len(GET_NUMBER.IS_WITH_SHIP) and GET_NUMBER.IS_WITH_SHIP eq 1 and len(GET_SHIP.SHIP_ID)>
	<cfloop list="#attributes.order_id_listesi#" index="kk">
		<cfquery name="DEL_ORD_SHIPS" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#GET_SHIP.SHIP_ID# AND PERIOD_ID=#session.ep.period_id# AND ORDER_ID=#kk# 
		</cfquery>
	</cfloop>
<cfelseif isdefined("attributes.order_id") and len(attributes.order_id) and len(GET_NUMBER.IS_WITH_SHIP) and GET_NUMBER.IS_WITH_SHIP eq 1 and len(GET_SHIP.SHIP_ID)><!--- siparişten satış faturası eklenmiş ise ve fatura kendi irsaliyesini oluşturmuşsa--->
	<cfquery name="DEL_ORD_SHIPS" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#GET_SHIP.SHIP_ID# AND PERIOD_ID=#session.ep.period_id# AND ORDER_ID=#attributes.order_id# 
	</cfquery>
</cfif>
<cfscript>
	add_reserve_row(
		related_process_id : form.invoice_id,
		reserve_action_type:2,
		is_order_process:2,
		is_purchase_sales:1,
		process_db :dsn2
		);
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
</cfscript>
