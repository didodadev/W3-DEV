<cfcomponent output="no">
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss Core - Text Input Filter Object component is accessible.">
	</cffunction>
    
    <!--- Get Positions --->
    <cffunction name="getPositions" access="remote" returntype="any" output="no">
        <cfargument name="filter" type="any" required="no" default="">
        
        <cfset result = StructNew()>
        
        <cftry>
            <cfquery name="get_positions" datasource="#session.defaultDatabaseName#">
                SELECT 
                    EP.POSITION_CODE AS id,
                    (E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME + ' | ' + EP.POSITION_NAME) AS name
                FROM 
                    EMPLOYEE_POSITIONS EP,
                    EMPLOYEES E
                WHERE
                    EP.EMPLOYEE_ID = E.EMPLOYEE_ID
                    <cfif len(arguments.filter)> AND (E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME + ' | ' + EP.POSITION_NAME) LIKE '%#arguments.filter#%'</cfif>
                ORDER BY
                    name
            </cfquery>
        	<cfset result["list"] = get_positions>
            
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
    
    <!--- Get Position Groups --->
    <cffunction name="getPositionGroups" access="remote" returntype="any" output="no">
        <cfargument name="filter" type="any" required="no" default="">
        
        <cfset result = StructNew()>
        
        <cftry>
            <cfquery name="get_position_groups" datasource="#session.defaultDatabaseName#">
                SELECT 
                    POSITION_CAT_ID AS id,
                    POSITION_CAT AS name
                FROM 
                    SETUP_POSITION_CAT 
                WHERE 
                    POSITION_CAT_STATUS = 1
                    <cfif len(arguments.filter)> AND POSITION_CAT LIKE '%#arguments.filter#%'</cfif>
                ORDER BY
                    name
            </cfquery>
        	<cfset result["list"] = get_position_groups>
            
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