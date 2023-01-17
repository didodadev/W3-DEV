<cfcomponent>
    <cfparam name="dsn" default="#application.SystemParam.SystemParam().dsn#">
    <cfparam name="dsn_alias" default="#application.SystemParam.SystemParam().dsn#">

    <cfif isdefined("session.ep")>
        <cfset dsn3 = "#dsn#_#session.ep.company_id#">
        <cfset dsn3_alias = "#dsn#_#session.ep.company_id#">
        <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfelseif isdefined("session.pp")>
        <cfset dsn3 = "#dsn#_#session.pp.our_company_id#">
        <cfset dsn3_alias = "#dsn#_#session.pp.our_company_id#">
        <cfset dsn2 = "#dsn#_#session.pp.period_year#_#session.pp.our_company_id#">
    <cfelseif isdefined("session.ww")>
        <cfset dsn3_alias = "#dsn#_#session.ww.our_company_id#">
        <cfset dsn3 = "#dsn#_#session.ww.our_company_id#">
        <cfset dsn2 = "#dsn#_#session.ww.period_year#_#session.ww.our_company_id#">
    </cfif>

    <cffunction name="get_remainder" returntype="query">
        <cfargument name="company_id" default="">
        <cfargument name="consumer_id" default="">
        <cfquery name="GET_REMAINDER" datasource="#DSN2#">
            SELECT 
                * 
            FROM 
                COMPANY_REMAINDER 
            WHERE
                1=1 
            <cfif len(arguments.company_id)>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            <cfelseif len(arguments.consumer_id)>
                AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
            </cfif>
        </cfquery>
        <cfreturn GET_REMAINDER>
    </cffunction>

</cfcomponent>