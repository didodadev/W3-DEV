<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    <cfset _index_folder = replacelist(expandPath("/"), "\", "/")>
    
    <!--- TEST --->
    <cffunction name="test" access="remote" returntype="string" output="no">
    	<cfreturn "test component is accessible">
    </cffunction>

	<!--- GET CONTACTS --->
	<cffunction name="getContacts" access="remote" returntype="any" output="no">
        <cfargument name="type_id" type="any" required="yes" hint="0: employee, 1: partner, 2: consumer">
        <cfargument name="user_id" type="any" required="no" default="">
        
        <cfquery name="get_user_id" datasource="#dsn#">
            SELECT USERID FROM WRK_SESSION WHERE WORKCUBE_ID = '#arguments.user_id#' AND USER_TYPE = #arguments.type_id#
        </cfquery>
        
        <cfif get_user_id.recordCount eq 0><cfreturn 0></cfif>
        
        <cfif arguments.type_id eq 0>
            <cfquery name="get_contacts" datasource="#dsn#">
                SELECT 
                	WORKCUBE_ID AS workcubeID,
                    POSITION_NAME AS info,
                	NAME AS name,
                	SURNAME AS surname
                FROM 
                	WRK_SESSION 
                WHERE 
                	USER_TYPE = 0 AND USERID <> #get_user_id.USERID#
                ORDER BY
                	NAME, SURNAME, POSITION_NAME
            </cfquery>
        <cfelseif arguments.type_id eq 1>
			<cfquery name="get_contacts" datasource="#dsn#">
            	SELECT 
                    WS.WORKCUBE_ID AS workcubeID,
                    C.NICKNAME AS info,
                    CP.COMPANY_PARTNER_NAME AS name,
                    CP.COMPANY_PARTNER_SURNAME AS surname,
                    0 AS type
                FROM 
                    COMPANY_PARTNER CP 
                    RIGHT JOIN COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID
                    RIGHT JOIN WRK_SESSION WS ON WS.USERID = CP.PARTNER_ID
                WHERE 
                    CP.COMPANY_PARTNER_STATUS = 1 AND
                    CP.COMPANY_ID = (SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_user_id.USERID#) AND
                    CP.PARTNER_ID <> #get_user_id.USERID#
                UNION
                SELECT 
                    WS.WORKCUBE_ID AS workcubeID,
                    C.NICKNAME AS info,
                    CP.COMPANY_PARTNER_NAME AS name,
                    CP.COMPANY_PARTNER_SURNAME AS surname,
                    1 AS type
                FROM 
                    MEMBER_FOLLOW MF
                    RIGHT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = MF.FOLLOW_MEMBER_ID
                    RIGHT JOIN COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID 
                    RIGHT JOIN WRK_SESSION WS ON WS.USERID = CP.PARTNER_ID
                WHERE
                    CP.COMPANY_PARTNER_STATUS = 1 AND
                    C.COMPANY_STATUS = 1 AND
                    MF.MY_MEMBER_ID = #get_user_id.USERID# AND
                    MF.FOLLOW_TYPE = 1
                ORDER BY
                    type, name, surname, info
            </cfquery>
        <cfelseif arguments.type_id eq 2>
        	<cfquery name="get_contacts" datasource="#dsn#">
                SELECT 
                    WS.WORKCUBE_ID AS workcubeID,
                    '' AS info,
                    C.CONSUMER_NAME AS name,
                    C.CONSUMER_SURNAME AS surname
                FROM 
                    MEMBER_FOLLOW MF
                    RIGHT JOIN CONSUMER C ON C.CONSUMER_ID = MF.FOLLOW_MEMBER_ID 
                    RIGHT JOIN WRK_SESSION WS ON WS.USERID = C.CONSUMER_ID
                WHERE
                    C.CONSUMER_STATUS = 1 AND
                    MF.MY_MEMBER_ID = #get_user_id.USERID# AND
                    MF.FOLLOW_TYPE = 1
                ORDER BY
                    C.CONSUMER_NAME, C.CONSUMER_SURNAME
            </cfquery>
        </cfif>
        
        <cfreturn get_contacts>
	</cffunction>
    
    <!--- INVITE --->
	<cffunction name="invite" access="remote" returntype="any" output="no">
        <cfargument name="type_id" type="any" required="yes" hint="0: employee, 1: partner, 2: consumer">
        <cfargument name="user_id" type="any" required="yes">
        <cfargument name="invited_id" type="any" required="yes">
        <cfargument name="message" type="any" required="yes">
        
        <cftry>
        	<cfquery name="get_user_id" datasource="#dsn#">
                SELECT USERID FROM WRK_SESSION WHERE WORKCUBE_ID = '#arguments.user_id#' AND USER_TYPE = #arguments.type_id#
            </cfquery>
            
            <cfif get_user_id.recordCount eq 0><cfreturn 0></cfif>
            
            <cfquery name="get_invited_id" datasource="#dsn#">
                SELECT USERID FROM WRK_SESSION WHERE WORKCUBE_ID = '#arguments.invited_id#' AND USER_TYPE = #arguments.type_id#
            </cfquery>
            
            <cfif get_invited_id.recordCount eq 0><cfreturn -1></cfif>
            
            <cfsavecontent variable="msg"><cfoutput>#arguments.message#</cfoutput></cfsavecontent>
            
            <cfquery name="add_message" datasource="#dsn#">
                INSERT INTO 
                    WRK_MESSAGE
                    (
                        RECEIVER_ID,
                        RECEIVER_TYPE,
                        SENDER_ID,
                        SENDER_TYPE,
                        MESSAGE,
                        IS_CHAT,
                        ROOM_ID,
                        SEND_DATE
                    )
                    VALUES
                    (
                        #get_invited_id.USERID#,
                        #arguments.type_id#,
                        #get_user_id.USERID#,
                        #arguments.type_id#,
                        '#msg#',
                        0,
                        NULL,
                        #now()#
                    )
            </cfquery>
        
        	<cfcatch type="any">
                <cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfthrow message="#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
            </cfcatch>
        </cftry>
        
        <cfreturn true>
    </cffunction>
    
    <!--- LOG SESSION --->
    <cffunction name="logSession" access="remote" returntype="any" output="no">
    	<cfargument name="type_id" type="any" required="yes" hint="0: employee, 1: partner, 2: consumer">
        <cfargument name="workcube_id" type="any" required="yes">
        <cfargument name="duration" type="any" required="yes">
        
        <cftry>
        	<cfquery name="get_user_id" datasource="#dsn#">
                SELECT USERID FROM WRK_SESSION WHERE WORKCUBE_ID = '#arguments.workcube_id#' AND USER_TYPE = #arguments.type_id#
            </cfquery>
            
            <cfif get_user_id.recordCount eq 0><cfreturn false></cfif>
                                    
            <cfquery name="add_session_log" datasource="#dsn#">
            	INSERT INTO
                    VIDEO_CONFERENCE_LOG
                    (
                        USER_ID,
                        USER_TYPE,
                        LOG_DATE,
                        LOG_DURATION,
                        REMOTE_IP
                    )
                    VALUES
                    (
                    	#get_user_id.USERID#,
                        #arguments.type_id#,
                        #now()#,
                        #arguments.duration#,
                        '#cgi.REMOTE_ADDR#'
                    )
            </cfquery>
        
        	<cfcatch type="any">
                <cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfthrow message="#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
            </cfcatch>
        </cftry>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>