<cfcomponent>
    <cfset _index_folder = replacelist(expandPath("/"), "\", "/")>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- Test --->
    <cffunction name="test" access="remote" returntype="string" output="no">
    	<cfreturn "Live Chat is accessible">
    </cffunction>	
    
    <!--- Get Available Employee --->
    <cffunction name="getAvailableEmployee" access="remote" returntype="any" output="no">
        <cfargument name="exception_list" type="array" required="yes">
        <cfargument name="target_employees" type="any" required="no" default="46,14,18,19">
        
        <cfloop from="1" to="#ArrayLen(arguments.exception_list)#" index="i">
        	<cfset arguments.exception_list[i] = "'#arguments.exception_list[i]#'">
        </cfloop>
        
        <!-- Get an employee as random according to the conditions -->
        <cfquery name="get_available_employees" datasource="#dsn#">
        	SELECT TOP(1)
                WS.WORKCUBE_ID AS id,
                (E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) AS info
            FROM 
                EMPLOYEES E,
                WRK_SESSION WS
            WHERE 
                E.EMPLOYEE_ID = WS.USERID AND WS.USER_TYPE = 0 AND
                EMPLOYEE_ID IN (#arguments.target_employees#) 
                <cfif ArrayLen(arguments.exception_list) gt 0> AND WS.WORKCUBE_ID NOT IN (#ArrayToList(arguments.exception_list)#)</cfif>
			ORDER BY 
            	NEWID()
        </cfquery>
        
        <!-- Get all if all employees are busy -->
        <cfif get_available_employees.recordCount eq 0>
        	<cfquery name="get_available_employees" datasource="#dsn#">
                SELECT TOP(1)
                    WS.WORKCUBE_ID AS id,
                    (E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) AS info
                FROM 
                    EMPLOYEES E,
                    WRK_SESSION WS
                WHERE 
                    E.EMPLOYEE_ID = WS.USERID AND WS.USER_TYPE = 0 AND
                    EMPLOYEE_ID IN (#arguments.target_employees#)
                ORDER BY 
                    NEWID()
            </cfquery>
        </cfif>
        
        <cfset emp = StructNew()>
        <cfset emp["id"] = get_available_employees.id>
        <cfset emp["info"] = get_available_employees.info>
        
        <cfreturn emp>
    </cffunction>    
    
    <!--- Send Request --->
	<cffunction name="sendRequest" access="remote" returntype="any" output="no">
        <cfargument name="message" type="string" required="yes">
        <cfargument name="related_id" type="any" required="yes" hint="write workcubeID of live support employee here">
        
        <cftry>
        	<cfquery name="get_related" datasource="#dsn#">
                SELECT USERID, USER_TYPE FROM WRK_SESSION WHERE WORKCUBE_ID = '#arguments.related_id#'
            </cfquery>
            
            <cfif get_related.recordCount eq 0><cfreturn 0></cfif>
            
            <cfsavecontent variable="msg"><cfoutput>#arguments.message#</cfoutput></cfsavecontent>
            
            <cfquery name="add_message" datasource="#dsn#">
            	INSERT INTO
                    WRK_MESSAGE
                    (
                        RECEIVER_ID,
                        RECEIVER_TYPE,
                        --SENDER_ID,
                        --SENDER_TYPE,
                        MESSAGE,
                        IS_CHAT,
                        SEND_DATE
                    )
                    VALUES
                    (
                        #get_related.USERID#,
                        #get_related.USER_TYPE#,
                        --1,
                        --0,
                        '#msg#',
                        0,
                        #now()#
                    )
            </cfquery>
        
        	<cfcatch type="any">
                <cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfthrow message="#cfcatch.Message#<br/><br/>Detail: #cfcatch.Detail#<br/><br/>Line: #cfcatchLine#">
            </cfcatch>
        </cftry>
        
        <cfreturn true>
    </cffunction>
    
    <!--- Save Interaction --->
    <cffunction name="saveInteraction" access="remote" returntype="any" output="no">
    	<cfargument name="emp_wid" type="any" required="yes">
        <cfargument name="app_name" type="any" required="yes">
        <cfargument name="app_email" type="any" required="yes">
        <cfargument name="title" type="any" required="yes">
        <cfargument name="transcript" type="any" required="yes">
        <cfargument name="interaction_category_id" type="any" required="no" default="17">
        
        <cftry>
        	<cfquery name="check_session" datasource="#dsn#">
                SELECT USERID FROM WRK_SESSION WHERE WORKCUBE_ID = '#arguments.emp_wid#'
            </cfquery>
            
            <cfif check_session.recordCount eq 0><cfreturn 0></cfif>
            
            <cfsavecontent variable="transcript"><cfoutput>#arguments.transcript#</cfoutput></cfsavecontent>
            <cfset currentDate = now()>
            
            <cfquery name="add_interaction" datasource="#dsn#">
            	INSERT INTO
                    CUSTOMER_HELP
                    (
	                    APP_CAT,
	                    INTERACTION_CAT,
                        INTERACTION_DATE,
                        SUBJECT, 
                        DETAIL,
                        APPLICANT_NAME, 
                        APPLICANT_MAIL, 
                        SOLUTION_DETAIL, 
                        RECORD_EMP, 
                        RECORD_DATE, 
                        RECORD_IP,
                        IS_REPLY,
                        IS_REPLY_MAIL,
                        PROCESS_STAGE
                    )
                    VALUES
                    (
                    	(SELECT COMMETHOD_ID FROM SETUP_COMMETHOD WHERE COMMETHOD LIKE '%nternet%'),
                        #arguments.interaction_category_id#,
                        #CreateDate(DatePart("yyyy", currentDate), DatePart("m", currentDate), DatePart("d", currentDate))#,
                        '#arguments.title#',
                        '#arguments.title#',
                        '#arguments.app_name#',
                        '#arguments.app_email#',
                        '#transcript#',
                        #check_session.USERID#,
                        #currentDate#,
                        '#cgi.REMOTE_ADDR#',
                        1,
                        1,
                        (SELECT TOP(1) PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = (SELECT TOP(1) PROCESS_ID FROM PROCESS_TYPE WHERE FACTION LIKE '%helpdesk%'))
                    )
            </cfquery>
        
        	<cfcatch type="any">
                <cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfthrow message="#cfcatch.Message#<br/><br/>Detail: #cfcatch.Detail#<br/><br/>Line: #cfcatchLine#">
            </cfcatch>
        </cftry>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>
