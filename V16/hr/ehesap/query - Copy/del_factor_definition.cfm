<cfquery name="del_query" datasource="#dsn#">
	DELETE 
	FROM 
		SALARY_FACTOR_DEFINITION
	WHERE
		ID = #attributes.ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
