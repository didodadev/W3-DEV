<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>

    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BPM General Process Designer component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET MAIN PROCESS INFO --->
    <cffunction name="getMainProcessInfo" access="remote" returntype="struct" output="no">
    	<cfargument name="company_id" type="string" required="yes">
        <cfargument name="main_process_id" type="string" required="yes">
        
        <cfquery name="main_process_info" datasource="#dsn#">
        	SELECT
            	PROCESS_MAIN_HEADER AS processName
			FROM
            	PROCESS_MAIN
			WHERE
            	PROCESS_MAIN_ID = #arguments.main_process_id#
        </cfquery>
        
        <cfquery name="process_list" datasource="#dsn#">
        	SELECT
                PMR.PROCESS_MAIN_ROW_ID AS id,
                PMR.PROCESS_ID AS processID,
                PMR.PROCESS_CAT_ID AS transactionID,
                PMR.FUSEACTION_ID AS functionID,
                PMR.DESIGN_XY_COORD AS xyCoords,
                PMR.DESIGN_DISPLAY_REDIRECT_ID_LIST AS redirectInfoDF,
                PMR.DESIGN_ACTION_REDIRECT_ID_LIST AS redirectInfoAF,
                PMR.DISPLAY_HEADER AS displayHeader,
                PMR.DISPLAY_DETAIL AS displayDetail,
                PMR.ACTION_HEADER AS actionHeader,
                PMR.ACTION_DETAIL AS actionDetail,
                PMR.DESIGN_CONNECTED_ID AS connectedID,
                PMR.DESIGN_TITLE AS title,
                PMR.DESIGN_OBJECT_TYPE AS objectType,
                PMR.DESIGN_NOTE AS note
            FROM
                PROCESS_MAIN_ROWS PMR
            WHERE
                PMR.PROCESS_MAIN_ID = #arguments.main_process_id#
            ORDER BY
                PMR.RECORD_DATE
        </cfquery>
        
        <cfset result = StructNew()>
        <cfset result["mainProcessInfo"] = main_process_info>
        <cfset result["processList"] = process_list>
        
        <cfreturn result>
    </cffunction>
    
    <!--- SAVE --->
    <cffunction name="saveObject" access="remote" returntype="any" output="no">
    	<cfargument name="main_process_id" type="string" required="yes">
        <cfargument name="rec_emp_id" type="string" required="yes">
        <cfargument name="type" type="numeric" required="yes">
        <cfargument name="id" type="string" required="no">
        <cfargument name="process_id" type="string" required="no">
        <cfargument name="transaction_id" type="string" required="no">
        <cfargument name="function_id" type="string" required="no">
        <cfargument name="name" type="string" required="no">
        <cfargument name="xy_coord" type="string" required="no">
        <cfargument name="connected_id" type="string" required="no">
        <cfargument name="display_header" type="string" required="no">
        <cfargument name="display_detail" type="string" required="no">
        <cfargument name="display_redirect_info" type="string" required="no">
        <cfargument name="action_header" type="string" required="no">
        <cfargument name="action_detail" type="string" required="no">
        <cfargument name="action_redirect_info" type="string" required="no">
        <cfargument name="note" type="string" required="no">
        <cfargument name="random_id" type="string" required="no">
        
        <cftransaction>
            <cftry>
                <cfif isDefined('arguments.random_id') and len(arguments.random_id)>
                    <cfset result = StructNew()>
                    <cfif arguments.type is 0 and not isDefined('arguments.process_id')>
                        <cfquery name="save_process_type" datasource="#dsn#">
                            INSERT INTO PROCESS_TYPE
                                (
                                PROCESS_NAME,
                                IS_ACTIVE,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                                )
                            VALUES
                                (
                                '#arguments.name#',
                                1,
                                #now()#,
                                #arguments.rec_emp_id#,
                                '#cgi.REMOTE_ADDR#'
                                )
                        </cfquery>
                        <cfquery name="get_last_process_type" datasource="#dsn#">
                            SELECT MAX(PROCESS_ID) AS processID FROM PROCESS_TYPE
                        </cfquery>
                        <cfset result["processID"] = get_last_process_type.processID>
                        <cfset arguments.process_id = result["processID"]>
                    </cfif>
                    <cfquery name="save_object" datasource="#dsn#">	
                        INSERT INTO PROCESS_MAIN_ROWS
                            (
                            PROCESS_MAIN_ID,
                            DESIGN_OBJECT_TYPE,
                            DESIGN_TITLE,
                            <cfif arguments.type is 0>PROCESS_ID,</cfif>
                            <cfif arguments.type is 1>PROCESS_CAT_ID,</cfif>
                            <cfif arguments.type is 2 and isDefined('arguments.function_id') and len(arguments.function_id)>FUSEACTION_ID,</cfif>
                            DESIGN_XY_COORD,
                            DESIGN_DISPLAY_REDIRECT_ID_LIST,
                            DESIGN_ACTION_REDIRECT_ID_LIST,
                            DESIGN_CONNECTED_ID,
                            DISPLAY_HEADER,
                            DISPLAY_DETAIL,
                            ACTION_HEADER,
                            ACTION_DETAIL,
                            DESIGN_NOTE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                            )
                        VALUES
                            (
                            #arguments.main_process_id#,
                            #arguments.type#,
                            '#arguments.name#',
                            <cfif arguments.type is 0>#arguments.process_id#,</cfif>
                            <cfif arguments.type is 1>#arguments.transaction_id#,</cfif>
                            <cfif arguments.type is 2 and isDefined('arguments.function_id') and len(arguments.function_id)>#arguments.function_id#,</cfif>
                            '#arguments.xy_coord#',
							'#arguments.display_redirect_info#',
                            '#arguments.action_redirect_info#',
                            '#arguments.connected_id#',
                            '#arguments.display_header#',
                            '#arguments.display_detail#',
                            '#arguments.action_header#',
                            '#arguments.action_detail#',
                            '#arguments.note#',
                            #now()#,
                            #arguments.rec_emp_id#,
                            '#cgi.REMOTE_ADDR#'
                            )
                    </cfquery>
                    <cfquery name="get_last_object" datasource="#dsn#">
                        SELECT MAX(PROCESS_MAIN_ROW_ID) AS id FROM PROCESS_MAIN_ROWS
                    </cfquery>
                    <cfset result["newID"] = get_last_object.id>
                    <cfset result["randomID"] = arguments.random_id>
                <cfelse>
                    <cfif isDefined('arguments.name') and len(arguments.name) and arguments.type is 0>
                        <cfquery name="update_process_type" datasource="#dsn#">
                            UPDATE
                                PROCESS_TYPE
                            SET
                                PROCESS_NAME = '#arguments.name#',
                                UPDATE_DATE = #now()#,
                                UPDATE_EMP = #arguments.rec_emp_id#,
                                UPDATE_IP = '#cgi.REMOTE_ADDR#'
                            WHERE
                                PROCESS_ID = #arguments.process_id#
                        </cfquery>
                    </cfif> 
                    <cfquery name="update_object" datasource="#dsn#">
                        UPDATE
                            PROCESS_MAIN_ROWS
                        SET
                        	DESIGN_TITLE = '#arguments.name#',
                            <cfif isDefined('arguments.xy_coord') and len(arguments.xy_coord)>DESIGN_XY_COORD = '#arguments.xy_coord#',</cfif>
                            <cfif isDefined('arguments.display_redirect_info')>DESIGN_DISPLAY_REDIRECT_ID_LIST = '#arguments.display_redirect_info#',</cfif>
                            <cfif isDefined('arguments.action_redirect_info')>DESIGN_ACTION_REDIRECT_ID_LIST = '#arguments.action_redirect_info#',</cfif>
                            <cfif isDefined('arguments.connected_id')>DESIGN_CONNECTED_ID = '#arguments.connected_id#',</cfif>
                            <cfif isDefined('arguments.display_header')>DISPLAY_HEADER = '#arguments.display_header#',</cfif>
                            <cfif isDefined('arguments.display_detail')>DISPLAY_DETAIL = '#arguments.display_detail#',</cfif>
                            <cfif isDefined('arguments.action_header')>ACTION_HEADER = '#arguments.action_header#',</cfif>
                            <cfif isDefined('arguments.action_detail')>ACTION_DETAIL = '#arguments.action_detail#',</cfif>
                            <cfif isDefined('arguments.note')>DESIGN_NOTE = '#arguments.note#',</cfif>
                            UPDATE_DATE = #now()#,
                            UPDATE_EMP = #arguments.rec_emp_id#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
                        WHERE
                            PROCESS_MAIN_ID = #arguments.main_process_id# AND
                            PROCESS_MAIN_ROW_ID = #arguments.id#
                    </cfquery>
                    <cfset result = true>
                </cfif>
                <cfcatch type="any">
                    <cfreturn "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#">
                </cfcatch>
            </cftry>
		</cftransaction>
        
        <cfreturn result>
    </cffunction>
    
    <!--- DELETE --->
    <cffunction name="deleteObject" access="remote" returntype="boolean" output="no">
    	<cfargument name="main_process_id" type="numeric" required="yes">
        <cfargument name="type" type="numeric" required="yes">
        <cfargument name="id" type="numeric" required="no">
        
        <cfquery name="delete_object" datasource="#dsn#">
        	DELETE FROM PROCESS_MAIN_ROWS WHERE PROCESS_MAIN_ID = #arguments.main_process_id# AND PROCESS_MAIN_ROW_ID = #arguments.id#
        </cfquery>
        
        <cfreturn true>
    </cffunction>
    
    <!--- FIND --->
    <cffunction name="findFromDB" access="remote" returntype="query" output="no">
    	<cfargument name="company_id" type="string" required="yes">
        <cfargument name="type" type="numeric" required="yes">
        <cfargument name="filter" type="string" required="yes">
        
        <cfif arguments.type is 0>
            <cfquery name="get_result" datasource="#dsn#">
                SELECT DISTINCT
                    PROCESS_ID AS id,
                    PROCESS_NAME AS name
                FROM
                    PROCESS_TYPE
                WHERE
                    PROCESS_NAME LIKE '%#arguments.filter#%'
                ORDER BY
                    name
            </cfquery>
		<cfelseif arguments.type is 1>
			<cfquery name="get_result" datasource="#dsn#_#arguments.company_id#">
                SELECT DISTINCT
                    PROCESS_CAT_ID AS id,
                    PROCESS_CAT AS name
                FROM
                    SETUP_PROCESS_CAT
                WHERE
                    PROCESS_CAT LIKE '%#arguments.filter#%'
                ORDER BY
                    name
            </cfquery>
		<cfelseif arguments.type is 2>
			<cfquery name="get_result" datasource="#dsn#">
                SELECT
                    WRK_OBJECTS_ID AS id,
                    (MODUL + '.' + FUSEACTION) AS name
                FROM
                    WRK_OBJECTS
                WHERE
                    (MODUL + '.' + FUSEACTION) LIKE '%#arguments.filter#%'
                ORDER BY 
                    MODUL, FUSEACTION
            </cfquery>
        </cfif>
        
        <cfreturn get_result>
    </cffunction>
    
    <!--- CHANGE --->
    <cffunction name="changeObject" access="remote" returntype="boolean" output="no">
	    <cfargument name="rec_emp_id" type="string" required="yes">
	    <cfargument name="type" type="numeric" required="yes">
        <cfargument name="id" type="string" required="no">
        <cfargument name="new_id" type="numeric" required="yes">
        <cfargument name="new_title" type="string" required="yes">
        
        <cfquery name="change_object" datasource="#dsn#">
        	UPDATE
            	PROCESS_MAIN_ROWS
			SET
            	DESIGN_TITLE = '#arguments.new_title#',
                <cfif arguments.type is 0>
	            	PROCESS_ID = #arguments.new_id#,
				<cfelseif arguments.type is 1>
                	PROCESS_CAT_ID = #arguments.new_id#,
				<cfelseif arguments.type is 2>
                	FUSEACTION_ID = #arguments.new_id#,
                </cfif>
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #arguments.rec_emp_id#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
			WHERE
            	PROCESS_MAIN_ROW_ID = #arguments.id#
        </cfquery>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>