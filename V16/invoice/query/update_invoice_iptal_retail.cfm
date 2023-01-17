<!---
	Silinecek:
	Cari Hareketler
	Kasa Hareketleri
	Muhasebe Fişleri
	Pos Hareketleri
	Kendi İrsaliyesi ve İrsaliye Hareketleri

	1- İrsaliyeli Fatura İptal edildiginde, irsaliyesi iptal edilir. bu irsaliyeye baglı stock hareketleri vs silinir. İptal geri alındıgında, fatura yeniden irsaliyesini oluşturur.
	2- İrsaliye çekilerek oluşturulmus bir fatura iptal edildiginde ise, INVOICE_SHIPS tablosundan bu fatura ile ilgili kayıtlar silinir, INVOICE_ROW'da
	SHIP_ID alanları guncellenir. İptal kaldırıldıgında, faturaya irsaliyelerin tekrar cekilmesi gerekir.  
	OZDEN20060411
--->
<!--- fatura  --->
<cfquery name="UPD_INVOICE" datasource="#dsn2#">
	UPDATE 
		INVOICE 
	SET 
		IS_IPTAL = 1,
		IS_PROCESSED = 0,
		IS_ACCOUNTED = 0,
		IS_CASH=0,
		IS_COST=0,
		CANCEL_TYPE_ID = <cfif isdefined("attributes.cancel_type_id") and len(attributes.cancel_type_id)>#attributes.cancel_type_id#<cfelse>NULL</cfif>
	WHERE
		INVOICE_ID=#form.invoice_id#
</cfquery>
<cfquery name="GET_INVOICE_CASH_ACTIONS" datasource="#dsn2#">
	SELECT * FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID IS NOT NULL
</cfquery>
<cfset cash_action_list=listsort(valuelist(GET_INVOICE_CASH_ACTIONS.CASH_ID,','),'numeric','asc',',')>
<!--- varsa cash hareketleri siliniyor --->
<cfif len(cash_action_list)>
	<cfscript>
		for(k=1; k lte listlen(cash_action_list); k=k+1)
		{
			cari_sil(action_id:listgetat(cash_action_list,k,','), process_type:35);
			muhasebe_sil(action_id:listgetat(cash_action_list,k,','), process_type:35);
		}
	</cfscript>
	<cfquery name="DEL_CASH_ACTION" datasource="#dsn2#">
		DELETE FROM CASH_ACTIONS WHERE ACTION_ID IN (#cash_action_list#)
	</cfquery>
	<cfquery name="DEL_INVOICE_CASH" datasource="#dsn2#">
		DELETE FROM INVOICE_CASH_POS WHERE CASH_ID IN (#cash_action_list#) AND INVOICE_ID=#form.invoice_id#
	</cfquery>
</cfif>
<!--- varsa pos hareketleri siliniyor --->
<cfquery name="GET_INVOICE_POS_ACTIONS" datasource="#dsn2#">
	SELECT * FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND POS_PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfset pos_action_list=listsort(valuelist(GET_INVOICE_POS_ACTIONS.POS_ACTION_ID,','),'numeric','asc',',')>
<cfif len(pos_action_list)>
	<cfscript>
		for(n=1; n lte listlen(pos_action_list); n=n+1)
		{
			cari_sil(action_id:listgetat(pos_action_list,n,','), process_type:241);
			muhasebe_sil(action_id:listgetat(pos_action_list,n,','), process_type:241);
		}
	</cfscript>
	<cfquery name="DEL_CARD" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID IN (#pos_action_list#)
	</cfquery>
	<cfquery name="DEL_CARD_ROWS" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID IN (#pos_action_list#)
	</cfquery>
	<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
		DELETE FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND POS_ACTION_ID IN (#pos_action_list#) AND POS_PERIOD_ID = #session.ep.period_id#
	</cfquery>
</cfif>

<!--- faturanın kendi irsaliyesi ve irsaliyeye baglı hareketler siliniyor  --->
<cfif get_ship_id.recordcount and get_ship_id.is_with_ship>
	<!--- 
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
	<cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
		DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>		
	<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_ship_id.ship_id# AND PROCESS_TYPE = #get_ship_id.ship_type#
	</cfquery>
<cfelseif len(attributes.ship_ids)><!--- irsaliye cekilmiş ise --->
	<cfquery name="UPD_INV_ROWS" datasource="#dsn2#">
		UPDATE INVOICE_ROW SET SHIP_ID = NULL WHERE INVOICE_ID= #form.invoice_id#
	</cfquery>
	<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#"><!---fatura irsaliye baglantıları siliniyor --->
		DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
	</cfquery>
</cfif>
<cfscript>
	cari_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2);
</cfscript>	

