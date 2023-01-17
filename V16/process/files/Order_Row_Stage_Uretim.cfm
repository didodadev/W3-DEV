<!--- Eklendigi Asamanin Satirlarini Uretim Yapar --->
<cfquery name="UpdOrderRow" datasource="#attributes.data_source#">
	UPDATE
		#caller.dsn3_alias#.ORDER_ROW
	SET
		ORDER_ROW_CURRENCY  = -5
	WHERE
		ORDER_ID = #attributes.action_id#
</cfquery>

