<cfcomponent>
    <cffunction name="userGroupMembers" access="remote" returntype="query">
    	<cfargument name="user_group_id" required="yes">
        <cfargument name="datasource" default="#dsn#" required="yes">
        <cfquery name="GET_MEMBERS" datasource="#arguments.datasource#">
            SELECT
            	DISTINCT
            	EP.EMPLOYEE_ID,
                EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMPLOYEE,
                EP.POSITION_NAME,
                EP.POSITION_ID
			FROM
            	USER_GROUP_EMPLOYEE AS UGE
                LEFT JOIN EMPLOYEE_POSITIONS AS EP ON UGE.POSITION_ID = EP.POSITION_ID
			WHERE
            	UGE.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#">
        </cfquery>
		<cfreturn GET_MEMBERS>
    </cffunction>
</cfcomponent>
