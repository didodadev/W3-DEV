<cfcomponent>
    
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>

    <cffunction name="pattern">
        <cfargument name="fuseaction">
        <cfargument name="schema">
        <cfargument name="table">
        <cfargument name="column">
        <cfargument name="data">

        <cfif structKeyExists(request, "pattern_service"&arguments.schema&arguments.table&arguments.column)>
            <cfset query_gdpr_classification = request["pattern_service"&arguments.schema&arguments.table&arguments.column]>
        <cfelse>
            <cfquery name="query_gdpr_classification" datasource="#dsn#">
                SELECT * FROM GDPR_CLASSIFICATION 
                WHERE FUSEACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.fuseaction#%'>
                AND SCHEMA_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.schema#'>
                AND TABLE_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.table#'>
                AND COLUMN_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.column#'>
            </cfquery>
            <cfset request["pattern_service"&arguments.schema&arguments.table&arguments.column] = query_gdpr_classification>
        </cfif>

        <cfif query_gdpr_classification.recordcount eq 0><creturn arguments.data></cfif>

        <cfset pattern = createObject("component", "WDO.gdpr.patterns.pattern#query_gdpr_classification.PLEVNE_DOOR#")>
        <cfreturn pattern.pattern(arguments.data)>

    </cffunction>

</cfcomponent>