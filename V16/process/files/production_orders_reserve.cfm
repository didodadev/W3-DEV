<!--- eklendiği aşamada üretim emrinin rezerve check boxını kaldırır SM20100415 --->
<cfquery name="UPD_PROD_ORDER" datasource="#attributes.data_source#">
	UPDATE
		#caller.dsn3_alias#.PRODUCTION_ORDERS
	SET
		IS_STOCK_RESERVED  = 0
	WHERE
		P_ORDER_ID = #ListGetAt(attributes.action_id,1,',')#
</cfquery>
