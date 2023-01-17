<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
	<cfargument name="activity_status">
            <cfquery name="GET_BUDGET_ACTIVITY" datasource="#dsn#">
               		SELECT 
						ACTIVITY_ID,
					    ACTIVITY_NAME 
					FROM 
						SETUP_ACTIVITY 
					WHERE 
					1=1
						<cfif arguments.activity_status eq 1>
							AND ACTIVITY_STATUS = 1
						<cfelseif arguments.activity_status eq 0>
							AND ACTIVITY_STATUS = 0
						</cfif>	
 					ORDER BY 
						ACTIVITY_NAME
            </cfquery>
        <cfreturn GET_BUDGET_ACTIVITY>
    </cffunction>
</cfcomponent>

