<cfcomponent output="no">
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss - Report List component is accessible.">
	</cffunction>
    
    <!--- Get Report List --->
    <cffunction name="getList" access="remote" returntype="any" output="no">
        <cfargument name="filter" type="string" required="yes" default="">
        
        <cfset result = StructNew()>
        
        <cftry>
            <cfquery name="get_list" datasource="#session.databaseName#">
                SELECT
                    REPORT_ID 		AS reportID,
                    REPORT_NAME		AS name,
                    REPORT_DETAIL	AS description,
                    (E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME + ' | ' + EP.POSITION_NAME) AS savedBy
                FROM
                    REPORT R,
                    #session.defaultDatabaseName#.dbo.EMPLOYEES E,
                    #session.defaultDatabaseName#.dbo.EMPLOYEE_POSITIONS EP
                WHERE
                    R.RECORD_EMP = E.EMPLOYEE_ID AND
                    EP.POSITION_CODE = #session.positionCode# AND
                	(
                        R.REPORT_ID NOT IN (SELECT REPORT_ID FROM REPORT_PERMISSIONS WHERE REPORT_ID IS NOT NULL) OR
                        R.REPORT_ID IN (SELECT REPORT_ID FROM REPORT_PERMISSIONS RP, #session.defaultDatabaseName#.dbo.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = #session.positionCode# AND (RP.POSITION_CODE = EP.POSITION_CODE OR RP.POSITION_CAT_ID = EP.POSITION_CAT_ID)) OR
                        R.RECORD_EMP = #session.userID# /*OR
                        (SELECT ADMIN_STATUS FROM #session.defaultDatabaseName#.dbo.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.userID#) = 1  --1 'den fazla pozisyonu olanlarda sıkıntılı, ayrıca admin olması raporu görebileceği anlamına gelmemeli */
                    )
                    <cfif len(arguments.filter)>AND REPORT_NAME LIKE '%#arguments.filter#%'</cfif>
				ORDER BY
					REPORT_NAME
            </cfquery>
            <cfset result["list"] = get_list>
            
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
    
    <!--- CROSS FUNCTIONS --->
</cfcomponent>