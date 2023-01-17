<cfcomponent>
    <cffunction name="getBillInfo" access="public" returntype="query">
        <cfquery name="get" datasource="#this.dsn#">
            SELECT ISNULL(IS_OTHER_MONEY,0) AS IS_OTHER_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfreturn get>
    </cffunction>
</cfcomponent>
