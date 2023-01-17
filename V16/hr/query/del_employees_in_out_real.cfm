<cfquery name="del_in_out_real" datasource="#dsn#">
DELETE 
	FROM
		EMPLOYEES_IN_OUT_REAL
	WHERE
		REAL_ID=#attributes.real_id#
</cfquery>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
