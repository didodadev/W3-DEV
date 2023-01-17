<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Business Process Management component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET PROCESS INFO --->
    <cffunction name="getProcessInfo" access="remote" returntype="struct" output="no">
    	<cfargument name="process_id" type="string" required="yes">
        
        <cfquery name="process_info" datasource="#dsn#">
        	SELECT
            	PROCESS_NAME AS processName
			FROM
            	PROCESS_TYPE
			WHERE
            	PROCESS_ID = #arguments.process_id#
        </cfquery>
        
        <cfquery name="phase_list" datasource="#dsn#">
        	SELECT
            	PROCESS_ROW_ID AS id,
                STAGE AS title,
                DETAIL AS description,
                LINE_NUMBER AS lineNumber,
                DESIGN_XY_COORD AS xyCoords,
                DESIGN_DISPLAY_REDIRECT_ID_LIST AS redirectInfoDF,
                DESIGN_ACTION_REDIRECT_ID_LIST AS redirectInfoAF,
                DESIGN_CONNECTED_ID AS connectedPhaseID,
                IS_DISPLAY AS includeDF,
                IS_ACTION AS includeAF,
                DISPLAY_FILE_NAME AS displayFile,
                FILE_NAME AS actionFile,
                IS_SMS AS smsWarning,
                IS_EMAIL AS emailWarning,
                IS_ONLINE AS msgWarning,
                0 AS hasPerson,
                0 AS hasGroup
			FROM
            	PROCESS_TYPE_ROWS
			WHERE
            	PROCESS_ID = #arguments.process_id#
            ORDER BY
            	lineNumber
        </cfquery>
        
        <cfloop query="phase_list">
	        <cfset personCount = 0>
        	<cfquery name="person_list" datasource="#dsn#">
            	SELECT PRO_TYPE_ROWS_POS_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_ROW_ID = #phase_list.id#
            </cfquery>
            <cfset personCount += person_list.recordcount>
            <cfquery name="person_list" datasource="#dsn#">
            	SELECT PRO_TYPE_ROWS_CAUID FROM PROCESS_TYPE_ROWS_CAUID WHERE PROCESS_ROW_ID = #phase_list.id#
            </cfquery>
            <cfset personCount += person_list.recordcount>
            <cfquery name="person_list" datasource="#dsn#">
            	SELECT PRO_TYPE_ROWS_INF_ID FROM PROCESS_TYPE_ROWS_INFID WHERE PROCESS_ROW_ID = #phase_list.id#
            </cfquery>
            <cfset personCount += person_list.recordcount>
            <cfquery name="group_list" datasource="#dsn#">
            	SELECT WORKGROUP_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE PROCESS_ROW_ID = #phase_list.id# AND MAINWORKGROUP_ID IS NOT NULL
            </cfquery>
            
            <cfif personCount gt 0><cfset _update = QuerySetCell(phase_list, 'hasPerson', 1, currentrow)></cfif>
            <cfif group_list.recordcount gt 0><cfset _update = QuerySetCell(phase_list, 'hasGroup', 1, currentrow)></cfif>
        </cfloop>
        
        <cfquery name="note_list" datasource="#dsn#">
        	SELECT
                PROCESS_NOTE_ID AS id,
                PROCESS_ROW_ID AS phaseID,
                NOTE AS note,
                DESIGN_XY_COORD AS xyCoords
            FROM
                PROCESS_TYPE_NOTES
            WHERE
                PROCESS_ID = #arguments.process_id#
        </cfquery>
        
        <cfset result = StructNew()>
        <cfset result["processInfo"] = process_info>
        <cfset result["phaseList"] = phase_list>
        <cfset result["noteList"] = note_list>
        
        <cfreturn result>
    </cffunction>
    
    <!--- SAVE PHASE --->
    <cffunction name="savePhase" access="remote" returntype="any" output="no">
    	<cfargument name="process_id" type="string" required="yes">
        <cfargument name="rec_emp_id" type="string" required="yes">
        <cfargument name="phase_id" type="string" required="no">
        <cfargument name="line_number" type="string" required="no">
        <cfargument name="phase_name" type="string" required="no">
        <cfargument name="xy_coord" type="string" required="no">
        <cfargument name="sms_warning" type="numeric" required="no">
        <cfargument name="email_warning" type="numeric" required="no">
        <cfargument name="msg_warning" type="numeric" required="no">
        <cfargument name="df_redirect_info" type="string" required="no">
        <cfargument name="af_redirect_info" type="string" required="no">
        <cfargument name="connected_id" type="string" required="no">
        <cfargument name="random_id" type="string" required="no">
        
        <cfquery name="save_phase" datasource="#dsn#">
        	<cfif isDefined('arguments.phase_id') and len(arguments.phase_id)>
            	UPDATE
                	PROCESS_TYPE_ROWS
				SET
                	<cfif isDefined('arguments.phase_name') and len(arguments.phase_name)>STAGE = '#arguments.phase_name#',</cfif>
                    <cfif isDefined('arguments.xy_coord') and len(arguments.xy_coord)>DESIGN_XY_COORD = '#arguments.xy_coord#',</cfif>
                    <cfif isDefined('arguments.line_number') and len(arguments.line_number)>LINE_NUMBER = '#arguments.line_number#',</cfif>
                    <cfif isDefined('arguments.display_file')>DISPLAY_FILE_NAME = '#arguments.display_file#',</cfif>
                    <cfif isDefined('arguments.action_file')>FILE_NAME = '#arguments.action_file#',</cfif>
                    <cfif isDefined('arguments.sms_warning') and len(arguments.sms_warning)>IS_SMS = #arguments.sms_warning#,</cfif>
                    <cfif isDefined('arguments.email_warning') and len(arguments.email_warning)>IS_EMAIL = #arguments.email_warning#,</cfif>
                    <cfif isDefined('arguments.msg_warning') and len(arguments.msg_warning)>IS_ONLINE = #arguments.msg_warning#,</cfif>
                    <cfif isDefined('arguments.df_redirect_info')>DESIGN_DISPLAY_REDIRECT_ID_LIST = '#arguments.df_redirect_info#',</cfif>
                    <cfif isDefined('arguments.af_redirect_info')>DESIGN_ACTION_REDIRECT_ID_LIST = '#arguments.af_redirect_info#',</cfif>
                    <cfif isDefined('arguments.connected_id')>DESIGN_CONNECTED_ID = '#arguments.connected_id#',</cfif>
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #arguments.rec_emp_id#,
                    UPDATE_IP = '#cgi.REMOTE_ADDR#'
                WHERE
                	PROCESS_ID = #arguments.process_id# AND
                    PROCESS_ROW_ID = #arguments.phase_id#
           	<cfelse>
            	INSERT INTO PROCESS_TYPE_ROWS
                	(
                    PROCESS_ID,
                    STAGE,
                    DESIGN_XY_COORD,
                    LINE_NUMBER,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                    )
               	VALUES
                	(
                    #arguments.process_id#,
                    '#arguments.phase_name#',
                    '#arguments.xy_coord#',
                    #arguments.line_number#,
                    #now()#,
                    #arguments.rec_emp_id#,
                    '#cgi.REMOTE_ADDR#'
                    )
			</cfif>
        </cfquery>
        
        <cfif not isDefined('arguments.phase_id') or not len(arguments.phase_id)>
            <cfquery name="last_phase" datasource="#dsn#">
                SELECT 
                    MAX(PROCESS_ROW_ID) AS phaseID
                FROM
                    PROCESS_TYPE_ROWS
                WHERE
                    PROCESS_ID = #arguments.process_id#
            </cfquery>
            
            <cfset result = StructNew()>
            <cfset result["phaseID"] = last_phase.phaseID>
            <cfset result["randomID"] = arguments.random_id>
		<cfelse>
        	 <cfset result = true>
		</cfif>
        
        <cfreturn result>
    </cffunction>
    
    <!--- DELETE PHASE --->
    <cffunction name="deletePhase" access="remote" returntype="boolean" output="no">
    	<cfargument name="phase_id" type="numeric" required="yes">
        
        <cfquery name="delete_phase" datasource="#dsn#">
        	DELETE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #arguments.phase_id#
        </cfquery>
        
        <cfquery name="delete_related_notes" datasource="#dsn#">
        	DELETE FROM PROCESS_TYPE_NOTES WHERE PROCESS_ROW_ID = #arguments.phase_id#
        </cfquery>
        
        <cfreturn true>
    </cffunction>
    
    <!--- SAVE NOTE --->
    <cffunction name="saveNote" access="remote" returntype="any" output="no">
        <cfargument name="note" type="any" required="yes" default="">
        <cfargument name="note_id" type="any" required="no">
       	<cfargument name="process_id" type="any" required="no">        
        <cfargument name="phase_id" type="any" required="no" default="NULL">
        <cfargument name="xy_coord" type="any" required="no">
        <cfargument name="rec_emp_id" type="any" required="yes">
        <cfargument name="random_id" type="any" required="no">
        
        <cfset result = StructNew()>
        <cfif isDefined('arguments.note_id') and len(arguments.note_id)>
        	<cfquery name="update_note" datasource="#dsn#">
            	UPDATE
                    PROCESS_TYPE_NOTES
                SET
                    NOTE = '#arguments.note#',
                    PROCESS_ROW_ID = #arguments.phase_id#,
                    <cfif isDefined('arguments.xy_coord') and len(arguments.xy_coord)>DESIGN_XY_COORD = '#arguments.xy_coord#',</cfif>
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #arguments.rec_emp_id#,
                    UPDATE_IP = '#cgi.REMOTE_ADDR#'
                WHERE
                    PROCESS_NOTE_ID = #arguments.note_id#
            </cfquery>
            
            <cfset result["noteID"] = arguments.note_id>
            <cfset result["phaseID"] = arguments.phase_id>
		<cfelse>
        	<cfquery name="save_note" datasource="#dsn#">           
                INSERT INTO PROCESS_TYPE_NOTES
                    (
                    PROCESS_ID,
                    PROCESS_ROW_ID,
                    NOTE,
                    <cfif isDefined('arguments.xy_coord') and len(arguments.xy_coord)>DESIGN_XY_COORD,</cfif>
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                    )
                VALUES
                    (
                    #arguments.process_id#,
                    #arguments.phase_id#,
                    '#arguments.note#',
                    <cfif isDefined('arguments.xy_coord') and len(arguments.xy_coord)>'#arguments.xy_coord#',</cfif>
                    #now()#,
                    #arguments.rec_emp_id#,
                    '#cgi.REMOTE_ADDR#'
                    )
			</cfquery>
            
            <cfquery name="last_note" datasource="#dsn#">
                SELECT 
                    MAX(PROCESS_NOTE_ID) AS noteID
                FROM
                    PROCESS_TYPE_NOTES
                WHERE
                    PROCESS_ID = #arguments.process_id#
            </cfquery>
            
            <cfset result["noteID"] = last_note.noteID>
            <cfif isDefined('arguments.random_id') and len(arguments.random_id)>
	            <cfset result["randomID"] = arguments.random_id>
			<cfelse>
            	<cfset result["phaseID"] = arguments.phase_id>
            </cfif>
        </cfif>
        
        <cfreturn result>
    </cffunction>
    
    <!--- DELETE NOTE --->
    <cffunction name="deleteNote" access="remote" returntype="boolean" output="no">
    	<cfargument name="note_id" type="numeric" required="yes">
                
        <cfquery name="delete_note" datasource="#dsn#">
        	DELETE FROM PROCESS_TYPE_NOTES WHERE PROCESS_NOTE_ID = #arguments.note_id#
        </cfquery>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>