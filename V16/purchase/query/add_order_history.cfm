<cfquery name="get_order" datasource="#dsn3#">
	SELECT * FROM ORDERS WHERE ORDER_ID = #attributes.ORDER_ID#
</cfquery>
<cfif not get_order.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='1531.Böyle Bir Kayıt Bulunamamaktadır'> !");
		window.location.href='<cfoutput>#request.self#?fuseaction=purchase.list_order</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_order_row" datasource="#dsn3#">
	SELECT * FROM ORDER_ROW WHERE ORDER_ID = #attributes.ORDER_ID#
</cfquery>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
    <cf_wrk_get_history datasource="#dsn3#" source_table="ORDERS" target_table="ORDERS_HISTORY" record_id= "#attributes.order_id#" record_name="ORDER_ID">
    <cfquery name="get_max_hist_id" datasource="#dsn3#">
    	SELECT MAX(ORDER_HISTORY_ID) MAX_ID FROM ORDERS_HISTORY
    </cfquery>
    <cf_wrk_get_history datasource="#dsn3#" source_table="ORDER_ROW" target_table="ORDER_ROW_HISTORY" insert_column_name="ORDER_HISTORY_ID" insert_column_value="#get_max_hist_id.MAX_ID#" record_id= "#valuelist(GET_ORDER_ROW.order_ROW_id)#" record_name="ORDER_ROW_ID">
	</cftransaction>
</cflock>
