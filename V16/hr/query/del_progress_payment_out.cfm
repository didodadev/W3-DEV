<cfquery name="del_progress_payment_out" datasource="#dsn#">
DELETE 
	FROM
		EMPLOYEE_PROGRESS_PAYMENT_OUT
	WHERE
		PROGRESS_PAYMENT_OUT_ID=#attributes.progress_payment_out_id#
</cfquery>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
