<cfquery name="upd_note" datasource="#dsn#">
	UPDATE
		EMPLOYEE_DAILY_IN_OUT
	SET
		DETAIL = '#attributes.detail#'
	WHERE
		ROW_ID = #attributes.row_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
