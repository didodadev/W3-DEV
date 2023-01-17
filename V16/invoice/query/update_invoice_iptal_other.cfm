<!---
	Silinecek:
	Cari Hareketler
	Kasa Hareketleri
	Muhasebe Fişleri
	İrsaliye Hareketleri
	1- İrsaliyeli Fatura İptal edildiginde, irsaliyesi iptal edilir. bu irsaliyeye baglı stock hareketleri vs silinir. İptal geri alındıgında, fatura yeniden irsaliyesini oluşturur.
	OZDEN20070822
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
	<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_ship_id.ship_id# AND PROCESS_TYPE = #get_ship_id.ship_type#
	</cfquery>
	<!--- faturanın irsaliyesi siliniyor
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
<cfelse>
	<!--- 690,64 haricindeki hizmet faturalarında stok hareketi direk fatura ile ilişkilendirildiğinden, invoice_id ve invoice_cat ile bağlantılı stok hareketleri silinir  --->
	<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = #form.invoice_id# AND PROCESS_TYPE = #form.old_process_type#
	</cfquery>
	<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#"><!---fatura irsaliye baglantıları siliniyor --->
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
</cfscript>
