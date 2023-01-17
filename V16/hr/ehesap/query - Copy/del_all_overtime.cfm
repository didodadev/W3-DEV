<cfquery name="del_overtime" datasource="#dsn#">
	DELETE FROM EMPLOYEES_OVERTIME WHERE WORKTIMES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_id#">
</cfquery>
<script type="text/javascript">
	window_opener_reload();
</script>
