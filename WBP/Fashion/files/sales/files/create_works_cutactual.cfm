<cfobject name="cutactual" component="WBP.Fashion.files.cfc.cutactual">
<cfquery name="query_process" datasource="#caller.dsn3#">
    SELECT PROCESS_ROW_ID FROM #caller.dsn#.PROCESS_TYPE INNER JOIN #caller.dsn#.PROCESS_TYPE_ROWS ON PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID WHERE FACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%textile.cutactual%'> AND PROCESS_TYPE_ROWS.LINE_NUMBER = 1
</cfquery>
<cfset cutactual.copyFromPlan(caller.cutplan_id, query_process.PROCESS_ROW_ID)>
