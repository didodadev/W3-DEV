<cfcomponent output="no">
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss component is accessible.">
	</cffunction>
    
    <!--- Init Workcube Report System --->
    <cffunction name="initReportSystem" access="remote" returntype="any" output="no">
    	<cfargument name="data" type="struct" required="yes">
        
        <cfset session.databaseName = data.db_name>
        <cfset session.defaultDatabaseName = left(session.databaseName, len(session.databaseName) - len('_report'))>
       	<cfset session.userID = data.user_id>
        <cfset session.positionCode = data.position_code>
        <cfset session.workcubeReportSystem = true>
        <cfset session.isAdmin = isUserAdmin(data.position_code)>
        <cfset result = session>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Check User Is Admin Or Not --->
    <cffunction name="isUserAdmin" access="private" returntype="any" output="no">
    	<cfargument name="position_code" type="any" required="yes">
        
        <cfquery name="get_employee" datasource="#session.defaultDatabaseName#">
        	SELECT EP.ADMIN_STATUS AS isAdmin FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = #arguments.position_code#
        </cfquery>
        
        <cfreturn get_employee.isAdmin eq 1>
    </cffunction>
    
    <!--- Get Permissions --->
    <cffunction name="getPermissions" access="remote" returntype="any" output="no">
    	<cfargument name="report_id" type="any" required="no" default="">
        <cfargument name="query_id" type="any" required="no" default="">
        
        <cfset result = StructNew()>
        
        <cftry>
            <cfquery name="get_position_permissions" datasource="#session.databaseName#">
                SELECT 
                    RP.PERMISSION_ID AS id,
                    EP.POSITION_CODE AS code,
                    (E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME + ' | ' + EP.POSITION_NAME) AS name
                FROM 
                    REPORT_PERMISSIONS RP,
                    #session.defaultDatabaseName#.dbo.EMPLOYEE_POSITIONS EP,
                    #session.defaultDatabaseName#.dbo.EMPLOYEES E
                WHERE
                    RP.POSITION_CODE = EP.POSITION_CODE AND
                    EP.EMPLOYEE_ID = E.EMPLOYEE_ID
                    <cfif len(arguments.report_id)> AND RP.REPORT_ID = #arguments.report_id#</cfif>
                    <cfif len(arguments.query_id)> AND RP.QUERY_ID = #arguments.query_id#</cfif>
            </cfquery>
            <cfset result["positions"] = get_position_permissions>
            
            <cfquery name="get_position_cat_permissions" datasource="#session.databaseName#">
                SELECT 
                    RP.PERMISSION_ID AS id,
                    PC.POSITION_CAT_ID AS catID,
                    PC.POSITION_CAT AS name
                FROM 
                    REPORT_PERMISSIONS RP,
                    #session.defaultDatabaseName#.dbo.SETUP_POSITION_CAT PC
                WHERE
                    RP.POSITION_CAT_ID = PC.POSITION_CAT_ID
                    <cfif len(arguments.report_id)> AND RP.REPORT_ID = #arguments.report_id#</cfif>
                    <cfif len(arguments.query_id)> AND RP.QUERY_ID = #arguments.query_id#</cfif>
            </cfquery>
            <cfset result["positionGroups"] = get_position_cat_permissions>
        
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
    
    <!--- Save Permissions --->
    <cffunction name="savePermissions" access="remote" returntype="any" output="no">
    	<cfargument name="list" type="any" required="yes">
        <cfargument name="report_id" type="any" required="no" default="">
        <cfargument name="query_id" type="any" required="no" default="">
        
        <cfset result = StructNew()>
        
        <cftry>
			<cfset ids = "">
            <cfloop from="1" to="#ArrayLen(arguments.list)#" index="i">
                <cfset perm = arguments.list[i]>
                <cfif isDefined("perm.id") and len(perm.id)>
                    <cfquery name="update_permission" datasource="#session.databaseName#">
                        UPDATE 
                            REPORT_PERMISSIONS 
                        SET 
                            UPDATE_EMP = #session.userID#,
                            UPDATE_DATE = #now()#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
                            <cfif len(arguments.report_id)>,REPORT_ID = #arguments.report_id#</cfif>
                            <cfif len(arguments.query_id)>,QUERY_ID = #arguments.query_id#</cfif>
                            <cfif isDefined("perm.code") and len(perm.code)>,POSITION_CODE = #perm.code#</cfif>
                            <cfif isDefined("perm.catID") and len(perm.catID)>,POSITION_CAT_ID = #perm.catID#</cfif>
                        WHERE
                            PERMISSION_ID = #perm.id#
                    </cfquery>
                <cfelse>
                    <cfquery name="insert_permission" datasource="#session.databaseName#" result="queryResult">
                        INSERT INTO 
                            REPORT_PERMISSIONS 
                            ( 
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                                <cfif len(arguments.report_id)>,REPORT_ID</cfif>
                                <cfif len(arguments.query_id)>,QUERY_ID</cfif>
                                <cfif isDefined("perm.code") and len(perm.code)>,POSITION_CODE</cfif>
                                <cfif isDefined("perm.catID") and len(perm.catID)>,POSITION_CAT_ID</cfif>
                            )
                            VALUES
                            (
                                #session.userID#,
                                #now()#,
                                '#cgi.REMOTE_ADDR#'
                                <cfif len(arguments.report_id)>,#arguments.report_id#</cfif>
                                <cfif len(arguments.query_id)>,#arguments.query_id#</cfif>
                                <cfif isDefined("perm.code") and len(perm.code)>,#perm.code#</cfif>
                                <cfif isDefined("perm.catID") and len(perm.catID)>,#perm.catID#</cfif>
                            )
                    </cfquery>
                    <cfset arguments.list[i].id = queryResult.identityCol>
                </cfif>
                <cfset ids = listAppend(ids, arguments.list[i].id, ",")>
            </cfloop>
            
            <cfquery name="clear_deleted_permissions" datasource="#session.databaseName#">
                DELETE FROM 
                    REPORT_PERMISSIONS 
                WHERE 
                    1 = 1
                    <cfif len(ids)>AND PERMISSION_ID NOT IN (#ids#)</cfif>
                    <cfif len(arguments.report_id)>AND REPORT_ID = #arguments.report_id#</cfif>
                    <cfif len(arguments.query_id)>AND QUERY_ID = #arguments.query_id#</cfif>
            </cfquery>
            
            <cfset result["list"] = arguments.list>
        
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
    
    <!--- Get External Dictionary --->
    <cffunction name="getExternalDictionary" access="remote" returntype="array" output="no">
    	<cfargument name="db_name" type="string" required="yes">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="word_list" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "core.workcube")>
		<cfreturn lang_component.getExternalDictionary(db_name: arguments.db_name, lang: arguments.lang, word_list: arguments.word_list)>
    </cffunction>
</cfcomponent>