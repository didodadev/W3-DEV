<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_organization_step" access="public" returntype="query">
        <cfargument name="level_no" default="">
        <cfquery name="get_organization_steps" datasource="#this.dsn#">
            SELECT 
            	ORGANIZATION_STEP_ID,
                #dsn#.Get_Dynamic_Language(ORGANIZATION_STEP_ID,'#session.ep.language#','SETUP_ORGANIZATION_STEPS','ORGANIZATION_STEP_NAME',NULL,NULL,ORGANIZATION_STEP_NAME) AS ORGANIZATION_STEP_NAME
            FROM
            	SETUP_ORGANIZATION_STEPS
            WHERE 
                1 = 1
                <cfif len(arguments.level_no)>
                    AND ORGANIZATION_STEP_NO =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level_no#">
                </cfif>
            ORDER BY
             	ORGANIZATION_STEP_NAME  
        </cfquery>
  		<cfreturn get_organization_steps>
	</cffunction>
    
    <cffunction name="KNOW_LEVELS" access="public" returntype="query" output="no">
        <cfargument name="knowlevel_id" default="">
        <cfquery name="KNOW_LEVELS" datasource="#DSN#">
            SELECT 
                KNOWLEVEL_ID, 
                KNOWLEVEL 
            FROM 
                SETUP_KNOWLEVEL 
            WHERE
                1 = 1
                <cfif len(arguments.knowlevel_id)>
                    AND KNOWLEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.knowlevel_id#">
                </cfif>
        </cfquery>
        <cfreturn KNOW_LEVELS>
    </cffunction>
</cfcomponent>
