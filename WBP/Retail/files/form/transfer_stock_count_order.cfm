<cfquery name="upd_" datasource="#dsn_dev#">
	UPDATE
    	STOCK_COUNT_ORDERS_ROWS
    SET
    	STOCK_ID = (SELECT TOP 1 SB.STOCK_ID FROM #dsn1_alias#.STOCKS_BARCODES SB WHERE SB.BARCODE = STOCK_COUNT_ORDERS_ROWS.BARCODE),
        STOCK_NAME = (SELECT TOP 1 S.PROPERTY FROM #dsn1_alias#.STOCKS_BARCODES SB,#dsn1_alias#.STOCKS S WHERE SB.BARCODE = STOCK_COUNT_ORDERS_ROWS.BARCODE AND SB.STOCK_ID = S.STOCK_ID)
    WHERE
    	ORDER_ID = #attributes.order_id# AND
        STOCK_ID IS NULL
</cfquery>
<script>
	alert('Eşleştirme Tamamlandı!');
	window.opener.location.reload();
	window.close();
</script>