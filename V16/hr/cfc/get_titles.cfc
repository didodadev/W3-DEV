<cfcomponent>
    
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_title" access="public" returntype="query">
        <cfargument  name="title_id" required="no">
        <cfquery name="get_titles" datasource="#this.dsn#">
            SELECT 
            	TITLE_ID,
                #dsn#.Get_Dynamic_Language(TITLE_ID,'#session.ep.language#','SETUP_TITLE','TITLE',NULL,NULL,TITLE) AS TITLE
            FROM 
            	SETUP_TITLE 
             WHERE 
             	IS_ACTIVE = 1
                <cfif isdefined("arguments.title_id") and len(arguments.title_id)>
                AND TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">
                </cfif>
             ORDER BY 
             	TITLE        
        </cfquery>
		<cfreturn get_titles>
	</cffunction>
    <cffunction name="get_position_title" access="public" returntype="query">
        <cfargument  name="position_id" required="no">
        <cfquery name="get_position_title" datasource="#dsn#">
            SELECT 
                TITLE
            FROM 
                EMPLOYEE_POSITIONS EP
                INNER JOIN SETUP_TITLE ST ON  ST.TITLE_ID = EP.TITLE_ID
            WHERE     
                POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
        </cfquery>
		<cfreturn get_position_title>
	</cffunction>
</cfcomponent>
