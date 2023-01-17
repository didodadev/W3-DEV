<cfobject name="cutactual" component="WBP.Fashion.files.cfc.cutactual">
<cfquery name="query_process" datasource="#dsn3#">
    SELECT PROCESS_ROW_ID FROM #dsn#.PROCESS_TYPE INNER JOIN #dsn#.PROCESS_TYPE_ROWS ON PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID WHERE FACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%textile.cutactual%'> AND PROCESS_TYPE_ROWS.LINE_NUMBER = 1
</cfquery>
<cfset cutactual_id = cutactual.copyFromPlan(attributes.cutplan_id, query_process.PROCESS_ROW_ID)>
<script>
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.cutactual&event=add&id=#attributes.cutactual_id#</cfoutput>';
</script>