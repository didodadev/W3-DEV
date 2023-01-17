<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction" returntype="query">
	<cfargument name="branch_id">
	<cfargument name="is_active">
	<cfargument name="position_code">
	<cfargument name="hierarchy">
            <cfquery name="GET_SALES_ZONE" datasource="#dsn#">
               	SELECT 
					<cfif isdefined('session.ep.userid') and isDefined('session.ep.language')>
						#dsn#.Get_Dynamic_Language(SZ_ID,'#session.ep.language#','SALES_ZONES','SZ_NAME',NULL,NULL,SZ_NAME) AS SZ_NAME,
					<cfelseif isdefined('session.pda.userid')>
						#dsn#.Get_Dynamic_Language(SZ_ID,'#session.pda.language#','SALES_ZONES','SZ_NAME',NULL,NULL,SZ_NAME) AS SZ_NAME,					
					</cfif>
					SZ_ID
				FROM 
					SALES_ZONES
				WHERE 
				1=1
					AND IS_ACTIVE = 1	
					<cfif len(arguments.branch_id)>
						AND RESPONSIBLE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
					</cfif>
					<cfif len(arguments.position_code)>
						AND RESPONSIBLE_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
					</cfif>
					<cfif len(arguments.hierarchy)>
						AND SZ_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hierarchy#">
					</cfif>
				ORDER BY
					SZ_NAME
            </cfquery>
        <cfreturn GET_SALES_ZONE>
    </cffunction>
</cfcomponent>

