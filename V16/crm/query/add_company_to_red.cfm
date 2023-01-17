<cfquery name="ADD_COMPANY_TO_RED" datasource="#dsn#">
	UPDATE
		COMPANY
	SET
		IS_RED = 1
	WHERE
		COMPANY_ID = #attributes.cpid#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.clode();
</script>
