<cfquery name="del_progress_payment" datasource="#dsn#">
DELETE 
	FROM
		EMPLOYEE_PROGRESS_PAYMENT
	WHERE
		PROGRESS_ID=#attributes.progress_id#
</cfquery>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
