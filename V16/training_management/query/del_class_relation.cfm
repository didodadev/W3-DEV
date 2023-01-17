<cfquery name="DEL_CLASS_RELATION" datasource="#DSN#">
	DELETE FROM CLASS_RELATION WHERE RELATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relation_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
