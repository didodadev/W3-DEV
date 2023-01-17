<cfquery name="del_" datasource="#dsn#">
	DELETE FROM TRAINING_CLASS_ANNOUNCE_ATTS WHERE EMPLOYEE_ID=#attributes.employee_id# AND ANNOUNCE_ID=#attributes.ANNOUNCE_ID#
</cfquery>
<cfquery name="del_" datasource="#dsn#">
	DELETE FROM TRAINING_REQUEST_ROWS WHERE EMPLOYEE_ID=#attributes.employee_id# AND ANNOUNCE_ID=#attributes.ANNOUNCE_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
