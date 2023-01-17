<cfquery name="add_warehouse_task" datasource="#dsn3#" result="add_r">
	UPDATE
		WAREHOUSE_TASKS
	SET
		IS_ACTIVE = 1
	WHERE
		TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
</cfquery>
<script>
	window.location.href = '<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#</cfoutput>';
</script>
<cfabort>