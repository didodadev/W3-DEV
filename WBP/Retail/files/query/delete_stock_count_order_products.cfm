<cfquery name="get_rows" datasource="#dsn_dev#">
	SELECT TOP 1 * FROM STOCK_COUNT_ORDERS_ROWS WHERE ORDER_ID = #attributes.order_id#
</cfquery>
<cfif get_rows.recordcount>
	<script>
		alert('Satır Girilmiş Olan Sayımdan Stok Silemezsiniz!');
		window.close();
	</script>
    <cfabort>
</cfif>

<cfquery name="del_products" datasource="#DSN_dev#">
	DELETE FROM
		STOCK_COUNT_ORDERS_STOCKS
	WHERE
		ORDER_ID = #attributes.order_id#
</cfquery>

<script>
	alert('İlgili Kayıtlar Silindi!!!');
	window.opener.location.reload();
	window.close();
</script>