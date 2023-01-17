<cfcomponent>
    <cffunction name="get_titles_positions" access="public" returntype="query">
        <cfargument  name="title_id" required="no">
        <cfargument  name="position_id" required="YES">
        <cfquery name="get_titles" datasource="#this.dsn#">
            SELECT 
            	st.TITLE_ID,
                st.TITLE
            FROM 
                EMPLOYEE_POSITIONS EP
            	JOIN SETUP_TITLE ST ON EP.TITLE_ID = ST.TITLE_ID
             WHERE 
             	IS_ACTIVE = 1
                <cfif isdefined("arguments.title_id") and len(arguments.title_id)>
                    AND ST.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">
                </cfif>
                <cfif isdefined("arguments.position_id") and len(arguments.position_id)>
                    AND EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
                </cfif>
             ORDER BY 
             	st.TITLE        
        </cfquery>
		<cfreturn get_titles>
	</cffunction>
</cfcomponent>
