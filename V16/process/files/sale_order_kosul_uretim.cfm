<!--- 
	BK 20060410
	Dikkat edilecekler :
	Bu dosya Uretim emri icin hazırlanmistir.
	Siparis eklemedeki query adı degismemeli
 --->
<cfquery name="UPD_ORDER_URETIM1" datasource="#caller.dsn3#">
	UPDATE
		ORDER_ROW
	SET
		ORDER_ROW_CURRENCY  = -5
	WHERE
		ORDER_ID = #attributes.action_id#
</cfquery>

