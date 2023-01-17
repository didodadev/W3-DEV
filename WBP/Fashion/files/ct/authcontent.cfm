<!--- AddOns/CustomTags --->
<cfif thisTag.ExecutionMode eq 'end'>
<cfquery name="query_authorized_user" datasource="#caller.dsn#">
    SELECT 
        1
    FROM
        PROCESS_TYPE PT,
        PROCESS_TYPE_ROWS PRT,
        PROCESS_TYPE_ROWS_POSID PPP,
        EMPLOYEE_POSITIONS PO
    WHERE 
        PT.PROCESS_ID=PRT.PROCESS_ID 
        AND PPP.PROCESS_ROW_ID=PRT.PROCESS_ROW_ID
        AND PO.POSITION_ID=PPP.PRO_POSITION_ID
        AND PRT.PROCESS_ROW_ID= <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.prcid#'>
        AND PO.EMPLOYEE_ID = #session.ep.USERID#
</cfquery>
<cfif query_authorized_user.recordCount eq 0>
    <cfset thisTag.GeneratedContent = "">
</cfif>
</cfif>