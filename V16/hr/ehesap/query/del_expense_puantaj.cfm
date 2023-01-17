<cfquery name="del_puantaj" datasource="#dsn#">
	DELETE FROM EMPLOYEES_EXPENSE_PUANTAJ WHERE EXPENSE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_puantaj_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
