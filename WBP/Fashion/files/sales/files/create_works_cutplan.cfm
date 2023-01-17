<!--- Aşama üretim seçildiğinde kesim planlamaya iş atar HY 20190807 --->
<cfparam name="caller.order_id" default="0">
<cfquery name="query_check_record" datasource="#caller.dsn3#">
    SELECT COUNT(*) AS CNT FROM TEXTILE_CUTPLAN_HEAD WHERE ORDER_ID = #caller.order_id#
</cfquery>

<cfif query_check_record.CNT eq 0>
    <cfquery name="query_process" datasource="#caller.dsn3#">
        SELECT TOP 1 PROCESS_ROW_ID FROM #caller.dsn#.PROCESS_TYPE INNER JOIN #caller.dsn#.PROCESS_TYPE_ROWS ON PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID WHERE FACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%textile.cutplan%'>
    </cfquery>
    <cfquery name="query_get_companyid" datasource="#caller.dsn3#">
        SELECT COMPANY_ID FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#caller.order_id#'> 
    </cfquery>
    <cfscript> 
        company_id = query_get_companyid.COMPANY_ID;
        order_id = caller.order_id;
    </cfscript>

    <cfquery name="query_add_cutplan" datasource="#caller.dsn3#" result="result_add_cutplan">
        INSERT INTO TEXTILE_CUTPLAN_HEAD ( COMPANY_ID, ORDER_ID, STRETCHING_TEST_ID, STAGE_ID, RECORD_DATE, RECORD_EMP, RECORD_IP ) VALUES (
            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#company_id#'>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#order_id#'>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#caller.attributes.stretching_test_id#'>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#query_process.PROCESS_ROW_ID#'>
            ,#now()#
            ,#session.ep.userid#
            ,'#cgi.REMOTE_ADDR#'
        )
    </cfquery>

</cfif>