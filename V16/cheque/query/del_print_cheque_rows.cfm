<cfquery name="UPD_ROWS" datasource="#dsn#">
	UPDATE
		CHEQUE_PRINTS_ROWS
	SET
		IS_USED = 1
	WHERE
		CHEQUE_GIFT_ROW_ID = #attributes.cheque_gift_row_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
