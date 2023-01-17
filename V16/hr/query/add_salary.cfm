<cfquery name="upd_list_rows" datasource="#dsn#">
	UPDATE
		EMPLOYEES_APP_SEL_LIST_ROWS
	SET
		SALARY = <cfif isdefined("attributes.salary") and len(attributes.salary)>'#attributes.salary#'<cfelse>NULL</cfif>
	WHERE
		LIST_ROW_ID = #attributes.list_row_id# AND LIST_ID = #attributes.list_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
