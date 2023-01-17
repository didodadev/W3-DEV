<cffunction name="get_assetp_space" access="public" returntype="query" output="no">
    <cfargument  name="space_name" default="" required="yes">
    <cfquery name="GET_ASSETP_SPACE" datasource="#dsn#">
            SELECT
                SPACE_NAME,
                SPACE_CODE,
                ASSET_P_SPACE_ID
            
            FROM 
                ASSET_P_SPACE
            WHERE SPACE_NAME LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.space_name#%">

    </cfquery>
	<cfreturn get_assetp_space>
</cffunction>

