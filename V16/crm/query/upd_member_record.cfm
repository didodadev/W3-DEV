<cfquery name="UPDATE_MEMBER_RECORD" datasource="#DSN#">
	UPDATE 
		COMPANY
	SET 
		ISPOTANTIAL = 0
	WHERE 
		COMPANY_ID = #attributes.cpid#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
