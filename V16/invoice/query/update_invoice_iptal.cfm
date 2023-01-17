<!---
	Silinecek:
	Cari Hareketler
	Kasa Hareketleri
	Muhasebe Fişleri
	Kendi İrsaliyesi ve İrsaliye Hareketleri
	Siparişten oluşturulan faturalar icin ORDERS_INVOICE ve ORDERS_SHIP tablolarındaki baglantılar

	1- İrsaliyeli Fatura İptal edildiginde, irsaliyesi iptal edilir. bu irsaliyeye baglı stock hareketleri vs silinir. İptal geri alındıgında, fatura yeniden irsaliyesini oluşturur.
	2- İrsaliye çekilerek oluşturulmus bir fatura iptal edildiginde ise, INVOICE_SHIPS tablosundan bu fatura ile ilgili kayıtlar silinir, INVOICE_ROW'da
	SHIP_ID alanları guncellenir. İptal kaldırıldıgında, faturaya irsaliyelerin tekrar cekilmesi gerekir.  
	OZDEN20060411
 --->
<!--- fatura  --->
<cfif not isdefined("session_base")><cfset session_base = 'session.ep'></cfif>
<cfif isdefined("from_order_info") and isdefined("session.ep")>
	<cfquery name="get_inv_order_info" datasource="#DSN2#">
		SELECT INVOICE_CAT,PROCESS_CAT FROM INVOICE WHERE INVOICE_ID=#form.invoice_id#
	</cfquery>
	<cfquery name="get_process_type_order_info" datasource="#dsn2#">
		SELECT 
			ACTION_FILE_NAME,
			ACTION_FILE_FROM_TEMPLATE
		 FROM 
			#dsn3_alias#.SETUP_PROCESS_CAT 
		WHERE 
			PROCESS_CAT_ID = #get_inv_order_info.process_cat#
	</cfquery>
</cfif>
<cfquery name="upd_invoice" datasource="#DSN2#">
	UPDATE 
		INVOICE 
	SET
		IS_IPTAL = 1,
		IS_PROCESSED = 0,
		IS_ACCOUNTED = 0,
		CASH_ID=NULL,
		KASA_ID=NULL,
		IS_CASH=0,
		IS_COST=0,
		CANCEL_TYPE_ID = <cfif isdefined("attributes.cancel_type_id") and len(attributes.cancel_type_id)>#attributes.cancel_type_id#<cfelse>NULL</cfif>
	<cfif isdefined("from_order_info") and isdefined("session.ep")>
		,UPDATE_EMP=#SESSION.EP.USERID#
		,UPDATE_DATE = #NOW()#
	</cfif>
	WHERE
		INVOICE_ID=#form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_MLM_SALES" datasource="#dsn2#">
	DELETE FROM INVOICE_MULTILEVEL_SALES WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_MLM_PREMIUM" datasource="#dsn2#">
	DELETE FROM INVOICE_MULTILEVEL_PREMIUM WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfif len(get_number.CASH_ID)>
	<cfquery name="delete_cash_actions" datasource="#DSN2#">
		DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #get_number.CASH_ID#
	</cfquery>
</cfif>
<cfif get_ship_id.recordcount and get_ship_id.is_with_ship> <!--- faturanın kendi irsaliyesi iptal edilip, irsaliyeye baglı hareketler siliniyor --->
	 <cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
		DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>	
	<cfquery name="UPD_SHIP_IPTAL" datasource="#dsn2#">
		UPDATE SHIP SET IS_SHIP_IPTAL=1 WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>
	<cfquery name="UPD_SHIP_IPTAL" datasource="#dsn2#"> <!--- sipariş faturaya cekildiginde faturanın irsaliyesinin satırlarında da sipariş bilgisi tutulur, bu bilgiler siliniyor --->
		UPDATE SHIP_ROW SET ROW_ORDER_ID=0 WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>
	<cfscript>
		del_serial_no(
		process_id : get_ship_id.ship_id,
		process_cat : get_ship_id.ship_type, 
		period_id : session_base.period_id
		);
	</cfscript>
	<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_ship_id.ship_id# AND PROCESS_TYPE = #get_ship_id.ship_type#
	</cfquery>
	<cfif isdefined("attributes.order_id") and len(attributes.order_id)><!--- siparişten satış faturası eklenmiş ise --->
		<cfquery name="DEL_ORD_SHIPS" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#get_ship_id.ship_id# AND PERIOD_ID=#session_base.period_id# AND ORDER_ID=#attributes.order_id# 
		</cfquery>
	</cfif>
<cfelseif included_irs><!--- len(attributes.ship_ids) ---><!--- faturaya cekilmis irsaliye varsa, satırlardaki baglantılar siliniyor --->
	<cfquery name="UPD_INV_ROWS" datasource="#dsn2#">
		UPDATE INVOICE_ROW SET SHIP_ID = NULL WHERE INVOICE_ID= #form.invoice_id#
	</cfquery>
	<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#"><!---faturaya cekilmis irsaliye varsa fatura irsaliye baglantıları siliniyor --->
		DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id# AND IS_WITH_SHIP=0
	</cfquery>
</cfif>
<cfscript>
	cari_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2);
	if(len(get_number.cash_id))
	{
		cari_sil(action_id:get_number.cash_id, process_type:35);
		muhasebe_sil(action_id:get_number.cash_id, process_type:35);
	}
	//siparişten gelen fatura ilişkisinin silinmesi 
	if(not isdefined('xml_import'))// xml importdan gelmiyorsa yüklensin
	add_reserve_row(
		related_process_id : form.invoice_id,
		reserve_action_type:1,
		reserve_action_iptal : 1,
		is_order_process:2,
		is_purchase_sales:1,
		process_db :dsn2
		);
</cfscript>
<!---Sistem ödeme planı faturasına iptal bilgisi set edilir,o tarafta gösterimi yapılmadı çokfazla işlem gerekiyordu burdan set edildi--->
<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
	UPDATE
		#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
	SET
		IS_INVOICE_IPTAL = 1,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		<cfif isdefined("session.ep")>
			,UPDATE_EMP = #session_base.userid#
		</cfif>
	WHERE
		INVOICE_ID = #form.invoice_id# AND 
		PERIOD_ID = #session_base.period_id#
</cfquery>
<!--- Fatura Ödeme Plani Satirlari Iptal Ediliyor --->
<cfquery name="UPD_INVOICE_PAYMENT_ROWS" datasource="#dsn2#">
	UPDATE
		#dsn3_alias#.INVOICE_PAYMENT_PLAN
	SET
		IS_ACTIVE = 0,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		<cfif isdefined("session.ep")>
			,UPDATE_EMP = #session_base.userid#
		</cfif>
	WHERE
		INVOICE_ID = #form.invoice_id# AND 
		PERIOD_ID = #session_base.period_id#
</cfquery>
<cfif isdefined("from_order_info") and len(get_process_type_order_info.action_file_name)><!--- Objects2 sipariş detayından geliyorsa action file ları çalıştırmak için eklendi. --->
	<cf_workcube_process_cat 
		process_cat="#get_inv_order_info.process_cat#"
		action_id = "#form.invoice_id#"
		action_table="INVOICE"
		action_column="INVOICE_ID"
		is_action_file = 1
		action_file_name='#get_process_type_order_info.action_file_name#'
		action_db_type = '#dsn2#'
		is_template_action_file = '#get_process_type_order_info.action_file_from_template#'>
</cfif>
