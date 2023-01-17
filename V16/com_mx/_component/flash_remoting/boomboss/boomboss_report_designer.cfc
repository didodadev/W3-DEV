<cfcomponent output="no">
	<cfset MODULE_NAME = "reportDesigner">

    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss - Report Designer component is accessible.">
	</cffunction>
    
    <!--- Get Queries --->
    <cffunction name="getQueries" access="remote" returntype="any" output="no">
        <cfargument name="filter" type="string" required="yes" default="">
        
        <cfset result = StructNew()>
        
        <cftry>
        	<cfquery name="get_gueries" datasource="#session.databaseName#">
            	SELECT
                    REPORT_QUERY_ID,
                    REPORT_QUERY_NAME,
                    REPORT_QUERY_DETAIL,
                    (SELECT COUNT(COLUMN_TYPE) FROM REPORT_QUERY_COLUMNS WHERE REPORT_QUERY_ID = RQ.REPORT_QUERY_ID AND COLUMN_TYPE = 0) AS COLUMN_COUNT,
                    MAX_ROWS,
                    GRAPHIC_TYPE,
                    LIST_VIEW
                FROM
                    REPORT_QUERY RQ
                WHERE
                	(
                        RQ.REPORT_QUERY_ID NOT IN (SELECT QUERY_ID FROM REPORT_PERMISSIONS WHERE QUERY_ID IS NOT NULL) OR
                        RQ.REPORT_QUERY_ID IN (SELECT QUERY_ID FROM REPORT_PERMISSIONS RP, #session.defaultDatabaseName#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = #session.positionCode# AND (RP.POSITION_CODE = EP.POSITION_CODE OR RP.POSITION_CAT_ID = EP.POSITION_CAT_ID)) OR
                        RQ.RECORD_EMP = #session.userID# /*OR
                        (SELECT ADMIN_STATUS FROM #session.defaultDatabaseName#.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.userID#) = 1*/
                    )
					<cfif len(arguments.filter)>AND REPORT_QUERY_NAME LIKE '%#arguments.filter#%'</cfif>
				ORDER BY
                	REPORT_QUERY_NAME
            </cfquery>
                        
            <cfset result["queries"] = get_gueries>
        
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
    
    <!--- Load Report --->
    <cffunction name="loadReport" access="remote" returntype="any" output="no">
        <cfargument name="report_id" type="numeric" required="yes">
        <cfargument name="skip_auth_checking" type="boolean" required="no" default="false">
        
        <cfset result = StructNew()>
        
        <cftry>
        	<cfquery name="report_info" datasource="#session.databaseName#">
            	SELECT
                    REPORT_NAME		AS name,
                    REPORT_DETAIL	AS description,
                    PAGE_WIDTH		AS width,
                    PAGE_HEIGHT		AS height,
                    PAGE_TYPE		AS pageType
                FROM
                    REPORT
                WHERE
                    REPORT_ID = #arguments.report_id#
            </cfquery>
            
           	<cfquery name="report_elements" datasource="#session.databaseName#">
            	SELECT
                    RE.REPORT_ELEMENT_ID	AS id,
                    RE.REPORT_QUERY_ID		AS queryID,
                    RQ.REPORT_QUERY_NAME	AS name,
                    RQ.REPORT_QUERY_DETAIL	AS description,
                    (SELECT COUNT(COLUMN_TYPE) FROM REPORT_QUERY_COLUMNS WHERE REPORT_QUERY_ID = RQ.REPORT_QUERY_ID AND COLUMN_TYPE = 0) AS columnCount,
                    RE.MAX_ROW				AS maxRows,
                    RE.GRAPHIC_TYPE			AS graphicType,
                    RE.WIDTH_HEIGHT			AS wh,
                    RE.X_Y					AS xy
                FROM
                    REPORT_ELEMENTS AS RE,
                    REPORT_QUERY AS RQ
                WHERE
                    REPORT_ID = #arguments.report_id# AND
                    RE.REPORT_QUERY_ID = RQ.REPORT_QUERY_ID
				ORDER BY
					RE.REPORT_ELEMENT_ID
            </cfquery>
            
            <cfset result["reportInfo"] = report_info>
            <cfset result["reportElements"] = report_elements>
            
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
    
    <!--- Save Report --->
    <cffunction name="saveReport" access="remote" returntype="any" output="no">
        <cfargument name="report_name" type="string" required="yes">
        <cfargument name="report_description" type="string" required="yes">
        <cfargument name="report_width" type="any" required="yes">
        <cfargument name="report_height" type="any" required="yes">
        <cfargument name="report_page_type" type="any" required="yes">
        <cfargument name="element_delete_list" type="array" required="yes">
        <cfargument name="element_list" type="array" required="yes">
        <cfargument name="report_id" type="any" required="no">
        
        <cftransaction>
			<cfset result = StructNew()>
            
            <cftry>
                <cfif isDefined('arguments.report_id') and len(arguments.report_id)>
                	<!-- Update report -->
                    <cfquery name="update_report" datasource="#session.databaseName#">
                    	UPDATE
                        	REPORT
						SET
                        	REPORT_NAME = '#arguments.report_name#',
                            REPORT_DETAIL = '#arguments.report_description#',
                            PAGE_WIDTH = #arguments.report_width#,
                            PAGE_HEIGHT = #arguments.report_height#,
                            PAGE_TYPE = #arguments.report_page_type#,
                            UPDATE_EMP = #session.userID#,
                            UPDATE_DATE = #now()#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
						WHERE
                        	REPORT_ID = #arguments.report_id#
                    </cfquery>
                <cfelse>
                	<!-- Save report -->
                    <cfquery name="insert_report" datasource="#session.databaseName#" result="queryResult">
                        INSERT INTO
                            REPORT
                            (
                                REPORT_NAME,
                                REPORT_DETAIL,
                                PAGE_WIDTH,
                                PAGE_HEIGHT,
                                PAGE_TYPE,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                '#arguments.report_name#',
                                '#arguments.report_description#',
                                #arguments.report_width#,
                                #arguments.report_height#,
                                #arguments.report_page_type#,
                                #session.userID#,
                                #now()#,
                                '#cgi.REMOTE_ADDR#'
                            )
                    </cfquery>
                    <!-- Get saved report id and assign it as report_id -->
                    <cfset arguments.report_id = queryResult.identityCol>
                </cfif>
                
                <!-- Clear deleted elements from database -->
                <cfloop from="1" to="#ArrayLen(arguments.element_delete_list)#" index="i">
                	<cfquery name="delete_element" datasource="#session.databaseName#">
	                    DELETE FROM REPORT_ELEMENTS WHERE REPORT_ELEMENT_ID = #arguments.element_delete_list[i]#
                    </cfquery>
                </cfloop>
                
                <!-- Insert/Update elements -->
                <cfloop from="1" to="#ArrayLen(arguments.element_list)#" index="i">
                    <cfset report_element = arguments.element_list[i]>

                    <cfif isDefined('report_element.id') and len(report_element.id)>
                        <cfquery name="update_report_element" datasource="#session.databaseName#">
                            UPDATE
                                REPORT_ELEMENTS
                            SET
                                REPORT_ID = #arguments.report_id#,
                                REPORT_QUERY_ID = #report_element.queryID#,
                                MAX_ROW = #report_element.maxRows#,
                                GRAPHIC_TYPE = #report_element.graphicType#,
                                WIDTH_HEIGHT = '#report_element.wh#',
                                X_Y = '#report_element.xy#'
                            WHERE
                                REPORT_ELEMENT_ID = #report_element.id#
                        </cfquery>
                    <cfelse>
                        <cfquery name="insert_report_element" datasource="#session.databaseName#" result="queryResult">
                        	INSERT
                            	REPORT_ELEMENTS
                                (
	                                REPORT_ID,
                                	REPORT_QUERY_ID,
                                    MAX_ROW,
                                	GRAPHIC_TYPE,
                                    WIDTH_HEIGHT,
                                    X_Y
                                )
                                VALUES
                                (
                                	#arguments.report_id#,
                                	#report_element.queryID#,
                                    #report_element.maxRows#,
                                    #report_element.graphicType#,
                                    '#report_element.wh#',
                                    '#report_element.xy#'
                                )
                        </cfquery>
                        <!-- Get saved element id and assign it to the list -->
                        <cfset report_element["id"] = queryResult.identityCol>
                        <cfset arguments.element_list[i]["id"] = queryResult.identityCol>
                    </cfif>
                </cfloop>

                <cfset result["reportID"] = arguments.report_id>
                <cfset result["savedElements"] = arguments.element_list>
                
                <cfcatch type="any">
					<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                    <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                    <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                    <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                    <cfreturn result>
                </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn result>
    </cffunction>
    
   	<!--- Clone Report --->
    <cffunction name="cloneReport" access="remote" returntype="any" output="no">
    	<cfargument name="report_id" type="any" required="yes" default="">
        <cfargument name="clone_word" type="string" required="yes">
        
        <cftransaction>
			<cfset result = StructNew()>
            
            <cftry>
                <cfquery name="get_report" datasource="#session.databaseName#">
                	SELECT * FROM REPORT WHERE REPORT_ID = #arguments.report_id#
                </cfquery>
                <cfquery name="get_report_rows" datasource="#session.databaseName#">
                	SELECT * FROM REPORT_ELEMENTS WHERE REPORT_ID = #arguments.report_id#
                </cfquery>
                
                <cfset recordDate = now()>
                <cfset reportTitle = "#get_report.REPORT_NAME# (#arguments.clone_word#)">
                
                <cfquery name="insert_report" datasource="#session.databaseName#" result="queryResult">
                	INSERT INTO
                   		REPORT
                        (
                            REPORT_NAME,
                            REPORT_DETAIL,
                            PAGE_WIDTH,
                            PAGE_HEIGHT,
                            PAGE_TYPE,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                        	'#reportTitle#',
                            '#get_report.REPORT_DETAIL#',
                            '#get_report.PAGE_WIDTH#',
                            '#get_report.PAGE_HEIGHT#',
                            '#get_report.PAGE_TYPE#',
                            #session.userID#,
                            #now()#,
                            '#cgi.REMOTE_ADDR#'
                        )
                </cfquery>
                
                <cfloop query="get_report_rows">                
                    <cfquery name="insert_report_row" datasource="#session.databaseName#" result="queryRowResult">
                        INSERT INTO
                            REPORT_ELEMENTS
                            (
                                REPORT_ID,
                                REPORT_QUERY_ID,
                                VIEW_TYPE,
                                MAX_ROW,
                                GRAPHIC_TYPE,
                                WIDTH_HEIGHT,
                                X_Y
                            )
                            VALUES
                            (
                                '#queryResult.identityCol#',
                                '#get_report_rows.REPORT_QUERY_ID#',
                                '#get_report_rows.VIEW_TYPE#',
                                '#get_report_rows.MAX_ROW#',
                                '#get_report_rows.GRAPHIC_TYPE#',
                                '#get_report_rows.WIDTH_HEIGHT#',
                                '#get_report_rows.X_Y#'
                            )
                    </cfquery>
                </cfloop>
                
                <cfset result["reportID"] = queryResult.identityCol>
                
                <cfcatch type="any">
					<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                    <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                    <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                    <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                    <cfreturn result>
                </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn result>
   	</cffunction>
    
    <!--- Delete Report --->
    <cffunction name="deleteReport" access="remote" returntype="any" output="no">
        <cfargument name="report_id" type="numeric" required="yes">
        <cfargument name="detail" type="any" required="no" default="">
        
        <cfset result = StructNew()>
        
        <cfquery name="delete_report_elements" datasource="#session.databaseName#">
        	DELETE FROM REPORT_ELEMENTS WHERE REPORT_ID = #arguments.report_id#
        </cfquery>
        
        <cfquery name="delete_report" datasource="#session.databaseName#">
        	DELETE FROM REPORT WHERE REPORT_ID = #arguments.report_id#
        </cfquery>
        
        <cfquery name="delete_report_permissions" datasource="#session.databaseName#">
        	DELETE FROM REPORT_PERMISSIONS WHERE REPORT_ID = #arguments.report_id#
        </cfquery>
        
        <cfreturn result>
    </cffunction>
    
    <!--- CROSS FUNCTIONS --->
        
    <!--- Test Query --->
    <cffunction name="testQuery" access="remote" returntype="any" output="no">
        <cfargument name="query_id" type="any" required="yes">
        <cfargument name="max_rows" type="numeric" required="yes" default="-1">
        
        <cfset result = StructNew()>
        
       	<cfset result = CreateObject("component", "boomboss_query_runner").runQuery(query_id: arguments.query_id, max_rows: arguments.max_rows)>
        <cfreturn result>
    </cffunction>
</cfcomponent>
