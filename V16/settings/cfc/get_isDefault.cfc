<cfcomponent>
<cffunction name="get_isDefault" access="public" returntype="query">
    <cfargument name="ID" default="">
    <cfargument name="isDefault">
    <cfargument name="isNotId">
    <cfquery name="get_isDefaults" datasource="#this.dsn#">
        SELECT 
            USER_GROUP_ID,
            USER_GROUP_NAME
        FROM 
            USER_GROUP
        WHERE 
       	 USER_GROUP_ID IS NOT NULL
		<cfif isdefined('arguments.ID') and len(arguments.ID)>
			<cfif isdefined('arguments.isNotId') and arguments.isNotId eq 1>
        	AND USER_GROUP_ID <>  #arguments.ID#
           <cfelse>
            AND	USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#">
            </cfif>
        </cfif>
        <cfif isdefined('arguments.isDefault') and len(arguments.isDefault)>
            AND	IS_DEFAULT = #arguments.isDefault#	
        </cfif>
    </cfquery>
<cfreturn get_isDefaults>
</cffunction>
</cfcomponent>
