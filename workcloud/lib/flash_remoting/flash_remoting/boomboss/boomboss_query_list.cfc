<cfcomponent output="no">
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss - Query List component is accessible.">
	</cffunction>
    
    <!--- Get Query List --->
    <cffunction name="getList" access="remote" returntype="any" output="no">
        <cfargument name="filter" type="string" required="yes" default="">
        
        <cfset result = StructNew()>
        
        <cftry>
            <cfquery name="get_list" datasource="#session.databaseName#">
            	SELECT
                    REPORT_QUERY_ID,
                    REPORT_QUERY_NAME,
                    REPORT_QUERY_DETAIL,
                    (SELECT COUNT(COLUMN_TYPE) FROM REPORT_QUERY_COLUMNS WHERE REPORT_QUERY_ID = RQ.REPORT_QUERY_ID AND COLUMN_TYPE = 0) AS COLUMN_COUNT,
                    MAX_ROWS,
                    GRAPHIC_TYPE,
                    (E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME + ' | ' + EP.POSITION_NAME) AS savedBy
                FROM
                    REPORT_QUERY RQ,
                    #session.defaultDatabaseName#.dbo.EMPLOYEES E,
                    #session.defaultDatabaseName#.dbo.EMPLOYEE_POSITIONS EP
                WHERE
                    RQ.RECORD_EMP = E.EMPLOYEE_ID AND
                    EP.POSITION_CODE = #session.positionCode# AND
                	(
                        RQ.REPORT_QUERY_ID NOT IN (SELECT QUERY_ID FROM REPORT_PERMISSIONS WHERE QUERY_ID IS NOT NULL) OR
                        RQ.REPORT_QUERY_ID IN (SELECT QUERY_ID FROM REPORT_PERMISSIONS RP, #session.defaultDatabaseName#.dbo.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = #session.positionCode# AND (RP.POSITION_CODE = EP.POSITION_CODE OR RP.POSITION_CAT_ID = EP.POSITION_CAT_ID)) OR
                        RQ.RECORD_EMP = #session.userID# /*OR
                        (SELECT ADMIN_STATUS FROM #session.defaultDatabaseName#.dbo.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.userID#) = 1 --1 'den fazla pozisyonu olanlarda sıkıntılı, ayrıca admin olması raporu görebileceği anlamına gelmemeli */
                    )
                    <cfif len(arguments.filter)>AND REPORT_QUERY_NAME LIKE '%#arguments.filter#%'</cfif>
				ORDER BY
                	RQ.REPORT_QUERY_NAME 
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