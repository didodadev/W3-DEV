<cfif isdefined("attributes.row_order_id") and Len(attributes.row_order_id) and isdefined("attributes.row_deliver_date") and Len(attributes.row_deliver_date)>
	<cf_date tarih="attributes.row_deliver_date">
	<cfquery name="Upd_Order_Row" datasource="#dsn3#">
		UPDATE
			ORDER_ROW
		SET
			DELIVER_DATE = #attributes.row_deliver_date#
		WHERE
			ORDER_ROW_ID = #attributes.row_order_id#
	</cfquery>
	<cfquery name="Upd_Order" datasource="#dsn3#">
		UPDATE
			ORDERS
		SET
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			ORDER_ID IN (SELECT ORDER_ID FROM ORDER_ROW WHERE ORDER_ROW_ID = #attributes.row_order_id#)
	</cfquery>
</cfif>
