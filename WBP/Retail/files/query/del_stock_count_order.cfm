<cfquery name="get_rows" datasource="#dsn_dev#">
	SELECT TOP 1 * FROM STOCK_COUNT_ORDERS_ROWS WHERE ORDER_ID = #attributes.order_id#
</cfquery>
<cfif get_rows.recordcount>
	<script>
		alert('Satır Girilmiş Olan Sayımı Silemezsiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfquery name="get_alts" datasource="#dsn_dev#">
	SELECT * FROM STOCK_COUNT_ORDERS WHERE MAIN_ORDER_ID = #attributes.order_id#
</cfquery>
<cfif get_alts.recordcount>
	<cfset alt_list_ = valuelist(get_alts.order_id)>
<cfelse>
	<cfset alt_list_ = "">
</cfif>

<cfquery name="del_" datasource="#dsn_dev#">
	DELETE FROM STOCK_COUNT_ORDERS_PRODUCT_CATS WHERE ORDER_ID = #attributes.order_id#
</cfquery>

<cfif listlen(alt_list_)>
    <cfquery name="del_" datasource="#dsn_dev#">
        DELETE FROM STOCK_COUNT_ORDERS_PRODUCT_CATS WHERE ORDER_ID IN (#alt_list_#)
    </cfquery>
</cfif>

<cfquery name="del_order_" datasource="#dsn_Dev#">
    DELETE FROM STOCK_COUNT_ORDERS WHERE MAIN_ORDER_ID = #attributes.order_id#
</cfquery>

<cfquery name="del_order_" datasource="#dsn_Dev#">
    DELETE FROM STOCK_COUNT_ORDERS WHERE ORDER_ID = #attributes.order_id#
</cfquery>

<script>
	window.opener.location.reload();
	window.close();
</script>