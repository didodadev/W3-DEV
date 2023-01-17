<cfquery datasource="#dsn#">
    SELECT #paramx()# AS n
</cfquery>

<cffunction name="paramx" access="public" returntype="any">
    <cfreturn queryparam(value:"3", cfsqltype:"cf_sql_varchar")>
</cffunction>