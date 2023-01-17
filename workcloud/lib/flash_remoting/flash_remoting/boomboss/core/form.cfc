<cfcomponent output="no">
	<!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss Core - Form component is accessible.">
	</cffunction>
 
    <!--- Get Function Groups --->
    <cffunction name="getFunctionGroups" returntype="any" access="remote" output="no">
        <cfargument name="site_id" type="numeric" required="yes">
        
        <cfset result = StructNew()>
        
        <cftry>
	    	<cfquery name="function_groups" datasource="#session.databaseName#">
            	SELECT
                    MENU_ID				AS id,
                    MENU				AS menu,
                    MENU_DETAIL			AS detail,
                    MENU_ICON			AS icon,
                    HORIZONTAL_ORDER	AS horizontalOrder
                FROM
                    MENU
                WHERE
                    SITE_ID = #arguments.site_id#
                ORDER BY
                    HORIZONTAL_ORDER, MENU
        	</cfquery>
            <cfset result["functionGroups"] = function_groups>
            
		    <cfcatch type="any">
            	<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                <cfreturn result>
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
</cfcomponent>