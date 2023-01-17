<!--- 
	BK 20060410
	Dikkat edilecekler :
	Bu dosya Sevk emri icin hazırlanmistir.
	Siparis eklemedeki query adı degismemeli
 --->
<cfquery name="UPD_ORDER_SEVK" datasource="#caller.dsn3#">
	UPDATE
		ORDER_ROW
	SET
		ORDER_ROW_CURRENCY  = -6
	WHERE
		ORDER_ID = #attributes.action_id#
</cfquery>
