<cfcomponent>
    <cffunction name="controlSession" access="remote" returntype="string">
        <cfargument name="dsn" type="string" required="yes">
        <cfargument name="userid" type="numeric" required="yes">
        <cfquery name="getSessionInfo" datasource="#arguments.dsn#">
            SELECT USERID FROM WRK_SESSION WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
        </cfquery>
		<cfreturn getSessionInfo.recordcount>
	</cffunction>
</cfcomponent>
