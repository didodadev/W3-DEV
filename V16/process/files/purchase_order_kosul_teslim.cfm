<!--- 
	BK 20060410
	Dikkat edilecekler :
	Bu dosya Teslim Alındı icin hazırlanmistir.
 --->

<cfquery name="UPD_ORDER_TESLIM" datasource="#caller.dsn3#">
	UPDATE
		ORDER_ROW
	SET
		ORDER_ROW_CURRENCY  = -3
	WHERE
		ORDER_ID = #attributes.action_id#
</cfquery>

