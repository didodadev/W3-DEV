<cfquery name="get_file_amount" datasource="#DSN_dev#">
	DELETE FROM
    	STOCK_COUNT_ORDERS_ROWS
    WHERE
    	ROW_ID = #attributes.row_id#
</cfquery>
<script type="text/javascript">
	window.opener.location.reload();
	window.close();
</script>