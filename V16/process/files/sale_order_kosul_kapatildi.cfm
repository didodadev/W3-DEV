<!--- Bu dosya Siparis Kapatildi Asamasi icin hazırlanmistir --->
<cfquery name="upd_order_kapatildi" datasource="#caller.dsn3#">
	UPDATE
		ORDER_ROW
	SET
		ORDER_ROW_CURRENCY  = -3
	WHERE
		ORDER_ID = #attributes.action_id#
</cfquery>

