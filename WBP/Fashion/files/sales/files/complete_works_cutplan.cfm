<cfquery name="query_cutplan" datasource="#caller.dsn3#">
    SELECT FINISH_DATE FROM TEXTILE_CUTPLAN_HEAD WHERE CUTPLAN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#caller.attributes.cutplan_id#'>
</cfquery>

<cfif len(query_cutplan.FINISH_DATE) eq 0>
    <cfquery name="query_cutplan_finish" datasource="#caller.dsn3#">
    UPDATE TEXTILE_CUTPLAN_HEAD SET FINISH_DATE = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#now()#'> WHERE CUTPLAN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#caller.attributes.cutplan_id#'>
    </cfquery>
</cfif>