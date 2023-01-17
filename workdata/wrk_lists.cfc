<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get" access="public" returntype="query">
        <cfargument name="groupkey">
        <cfquery name="qlists" datasource="#dsn#">
            SELECT ITEMKEY, ITEMVALUE FROM WRK_ELEMENTLISTS WHERE GROUPKEY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.groupkey#'>
        </cfquery>
        <cfreturn qlists>
    </cffunction>

</cfcomponent>