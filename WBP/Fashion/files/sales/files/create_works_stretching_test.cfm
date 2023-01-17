<!--- Aşama üretim seçildiğinde çekme testine iş atar HY 20190807 --->
<cfquery name="query_check_record" datasource="#caller.dsn3#">
    SELECT COUNT(*) AS CNT FROM TEXTILE_STRETCHING_TEST_HEAD WHERE ORDER_ID = #caller.order_id#
</cfquery>

<cfif query_check_record.CNT eq 0>

    <cfquery name="query_process" datasource="#caller.dsn3#">
        SELECT TOP 1 PROCESS_ROW_ID FROM #caller.dsn#.PROCESS_TYPE INNER JOIN #caller.dsn#.PROCESS_TYPE_ROWS ON PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID WHERE FACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%textile.stretching_test%'>
    </cfquery>
    <cfquery name="query_reqid" datasource="#caller.dsn3#">
        select TOP 1 RELATED_ACTION_ID from ORDER_ROW WHERE RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND ORDER_ID=#caller.order_id#
    </cfquery>

    <cfset req_id = iif(query_reqid.recordcount gt 0, "query_reqid.RELATED_ACTION_ID", de("null"))>
    <cfset prj_id = iif(isDefined("caller.project_id"), "caller.project_id", de("null"))>
    <cfquery name="query_add_stretching_test" datasource="#caller.dsn3#">
        INSERT INTO TEXTILE_STRETCHING_TEST_HEAD( TEST_DATE, PROJECT_ID, ORDER_ID, REQ_ID, STAGE_ID, RECORD_DATE, RECORD_EMP, RECORD_IP )
        VALUES( #now()#, #prj_id#, #caller.order_id#, #req_id#, #query_process.PROCESS_ROW_ID#, #now()#, #session.ep.userid#, '#cgi.REMOTE_ADDR#' )
    </cfquery>

</cfif>
<cfset caller.actionId = caller.order_id>