<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>

    <cffunction name="decrypt">
        <cfargument name="refid">
        <cfargument name="schema">
        <cfargument name="table">
        <cfargument name="column">

        <cfif structKeyExists(request, "single_decrypt"&arguments.schema&arguments.table&arguments.column)>
            <cfset query_plevne = request["single_decrypt"&arguments.schema&arguments.table&arguments.column]>
        <cfelse>
            <cfquery name="query_plevne" datasource="#dsn#">
                SELECT * FROM PLEVNE_DOCK 
                WHERE SCHEMA_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.schema#'>
                AND TABLE_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.table#'>
                AND COLUMN_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.column#'>
                AND RELATION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.refid#'>
            </cfquery>
                <cfset request["single_decrypt"&arguments.schema&arguments.table&arguments.column] = query_plevne>
        </cfif>

        <cfif query_plevne.recordcount eq 0><creturn ""></cfif>

        <cfset door = createObject("component", "WDO.gdpr.doors.door#query_plevne.PLEVNE_DOOR#")>
        <cfreturn door.decrypt(query_plevne.PLEVNE_DOCK, "wrk" & arguments.refid)>

    </cffunction>

</cfcomponent>