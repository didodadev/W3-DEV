
    <cfcomponent extends="wdo.catalogs.dataComponent">
        <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset dsn1 = application.systemParam.systemParam().dsn & "_product">
        <cfset dsn2 = application.systemParam.systemParam().dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
        <cfset dsn3 = application.systemParam.systemParam().dsn & "_" & session.ep.company_id>
        <cffunction name="get_plpc" access="remote" returntype="any">
        <cfargument name="spect_id" type="any" required="no">
        <cfquery name="get_plpc" datasource="#DSN#">
            SELECT 
                * 
            FROM 
                 SPEC_PLP
            where 
                 SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_id#">
        </cfquery>
        <cfreturn get_plpc>
    </cffunction>
</cfcomponent>