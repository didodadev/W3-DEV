<!---
	Silinecek:
	Cari Hareketler
	Kasa Hareketleri
	Muhasebe Fişleri
	İrsaliye Hareketleri
	1- İrsaliyeli Fatura İptal edildiginde, irsaliyesi iptal edilir. bu irsaliyeye baglı stock hareketleri vs silinir. İptal geri alındıgında, fatura yeniden irsaliyesini oluşturur.
	2- İrsaliye çekilerek oluşturulmus bir fatura iptal edildiginde ise, INVOICE_SHIPS tablosundan bu fatura ile ilgili kayıtlar silinir, INVOICE_ROW'da
	SHIP_ID alanları guncellenir. İptal kaldırıldıgında, faturaya irsaliyelerin tekrar cekilmesi gerekir.  
	OZDEN20060411
 --->
<!--- fatura  --->
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
	WHERE
		INVOICE_ID=#form.invoice_id#
</cfquery>
<cfif len(get_number.CASH_ID)>
	<cfquery name="delete_cash_actions" datasource="#DSN2#">
		DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #get_number.CASH_ID#
	</cfquery>
</cfif>

<cfif get_ship_id.recordcount and get_ship_id.is_with_ship>
<!--- faturanın kendi irsaliyesi ve irsaliyeye baglı hareketler siliniyor  --->
	<cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
		DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID  = #get_ship_id.ship_id#
	</cfquery>		
	<!--- fatura iptal edildiginde kendi olusturdugu irsaliye siliniyor
	<cfquery name="DEL_SHIP_MONEY" datasource="#dsn2#">
		DELETE FROM SHIP_MONEY WHERE ACTION_ID = #get_ship_id.ship_id#
	</cfquery>	
	<cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
		DELETE FROM SHIP_ROW WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>
	<cfquery name="DEL_SHIP" datasource="#dsn2#">
		DELETE FROM SHIP WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery> --->
	<cfquery name="UPD_SHIP_IPTAL" datasource="#dsn2#">
		UPDATE SHIP SET IS_SHIP_IPTAL=1 WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>
	<cfquery name="UPD_SHIP_IPTAL" datasource="#dsn2#"> <!--- sipariş faturaya cekildiginde faturanın irsaliyesinin satırlarında da sipariş bilgisi tutulur, bu bilgiler siliniyor --->
		UPDATE SHIP_ROW SET ROW_ORDER_ID=0 WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>
	<!--- seri no kayitlari silinir --->
	<cfscript>
		del_serial_no(
		process_id : get_ship_id.ship_id,
		process_cat : get_ship_id.ship_type, 
		period_id : session.ep.period_id
		);
	</cfscript>
	<!--- seri no kayitlari silinir --->	
	<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_ship_id.ship_id# AND PROCESS_TYPE = #get_ship_id.ship_type#
	</cfquery>
	<cfif isdefined("attributes.order_id") and len(attributes.order_id)><!--- siparişten satış faturası eklenmiş ise --->
		<cfquery name="DEL_ORD_SHIPS" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#get_ship_id.ship_id# AND PERIOD_ID=#session.ep.period_id# AND ORDER_ID=#attributes.order_id# 
		</cfquery>
	</cfif>
<cfelseif len(attributes.ship_ids)><!--- irsaliye cekilmiş ise --->
	<cfquery name="UPD_INV_ROWS" datasource="#dsn2#">
		UPDATE INVOICE_ROW SET SHIP_ID = NULL WHERE INVOICE_ID= #form.invoice_id#
	</cfquery>
	<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#"><!---faturaya cekilmis irsaliye varsa fatura irsaliye baglantıları siliniyor --->
		DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
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
	// siparişten gelen fatura ilişkisinin silinmesi	
	add_reserve_row(
		related_process_id : form.invoice_id,
		reserve_action_type:1,
		reserve_action_iptal : 1,
		is_order_process:2,
		is_purchase_sales:0,
		process_db :dsn2
		);
</cfscript>
