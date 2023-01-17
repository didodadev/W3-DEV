<cfquery name="query_stretching_test" datasource="#caller.dsn3#">
    SELECT FINISH_DATE FROM TEXTILE_STRETCHING_TEST_HEAD WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#caller.attributes.stretching_test_id#'>
</cfquery>

<cfif len(query_stretching_test.FINISH_DATE) eq 0>
    <cfquery name="query_stretching_test_finish" datasource="#caller.dsn3#">
    UPDATE TEXTILE_STRETCHING_TEST_HEAD SET FINISH_DATE = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#now()#'> WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#caller.attributes.stretching_test_id#'>
    </cfquery>
</cfif>