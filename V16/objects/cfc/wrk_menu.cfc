<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_MENU" access="remote">
        <cfargument name="menu_id" default="">
        <cfquery name="GET_MENU" datasource="#DSN#">
            SELECT 
                WRK_MENU_ID, 
                WRK_MENU_NAME
            FROM 
                WRK_MENU
            WHERE
                MENU_STATUS = 1 AND
                WRK_MENU_ID IN (#menu_id#)
            ORDER BY 
                WRK_MENU_NAME
        </cfquery>       
        <cfreturn GET_MENU>
    </cffunction>
    <cffunction name="GET_MENU_JSON" access="remote" returntype="any" returnFormat="json">
        <cfargument name="usergroup" default="0">
        <cfquery name="GET_USER_GROUP" datasource="#dsn#">
            SELECT
                WRK_MENU
			FROM
                USER_GROUP
			WHERE
            	USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.usergroup#">
        </cfquery>
        <cfif GET_USER_GROUP.recordCount AND len(GET_USER_GROUP.WRK_MENU)>
            <cfquery name="GET_MENU" datasource="#DSN#">
                SELECT 
                    WRK_MENU_ID, 
                    WRK_MENU_NAME
                FROM 
                    WRK_MENU
                WHERE
                    MENU_STATUS = 1 AND
                    WRK_MENU_ID IN (#GET_USER_GROUP.WRK_MENU#)
                ORDER BY 
                    WRK_MENU_NAME
            </cfquery>
            <cfreturn Replace(SerializeJSON(GET_MENU),'//','')>
        <cfelse>
            <cfreturn 0>
        </cfif>     
    </cffunction>
</cfcomponent>