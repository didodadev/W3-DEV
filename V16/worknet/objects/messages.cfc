<cfcomponent>
	<cfinclude template="../../fbx_workcube_param.cfm">
	
	<!--- ADD MESSAGE --->
	<cffunction name="addMessage" access="public" returntype="string">	
		<cfargument name="message_type" type="numeric" required="yes">
		<cfargument name="sender_id" type="numeric" required="yes">
		<cfargument name="sender_type" type="string" required="yes">
		<cfargument name="receiver_id" type="numeric" required="yes">
		<cfargument name="receiver_type" type="string" required="yes">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="body" type="string" required="yes">
		<cfargument name="is_read" type="numeric" required="yes" default="0">
		<cfargument name="is_deleted" type="numeric" required="yes" default="0">
		<cfargument name="action_id" type="any" required="no" default="">
		<cfargument name="action_type" type="string" required="no" default="">
	
		<cfquery name="ADD_MESSAGE" datasource="#DSN#">
			INSERT INTO 
				MESSAGES
			(
				MESSAGE_TYPE,
				SENDER_ID,
				SENDER_TYPE,
				RECEIVER_ID,
				RECEIVER_TYPE,
				SUBJECT,
				BODY,
				SENT_DATE,
				IS_READ,
				IS_DELETED,
				ACTION_ID,
				ACTION_TYPE
			)
			VALUES
			(	
				#arguments.message_type#,
				#arguments.sender_id#,		
				'#arguments.sender_type#',
				#arguments.receiver_id#,
				'#arguments.receiver_type#',
				'#arguments.subject#',
				'#arguments.body#',
				#now()#,
				#arguments.is_read#,
				#arguments.is_deleted#,
				<cfif len(arguments.action_id)>#arguments.action_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.action_type)>'#arguments.action_type#'<cfelse>NULL</cfif>
			)
		</cfquery>
	</cffunction>
	
	<!--- UPD MESSAGE --->
	<cffunction name="updMessage" access="public" returntype="any">
		<cfargument name="msg_id" type="numeric" required="yes">
		<cfargument name="type" type="any" default="">
		<cfargument name="is_read" type="any" default="">
		<cfargument name="is_deleted" type="any" default="">
		
		<cfquery name="upd_message" datasource="#dsn#">
			UPDATE
				MESSAGES
			SET
				<cfif len(arguments.is_read)>
					IS_READ = #arguments.is_read#
				<cfelse>
					IS_DELETED = #arguments.is_deleted#		
				</cfif>
			WHERE
				MSG_ID = #arguments.msg_id#
		</cfquery>
	</cffunction>
	
	<!--- DELETE MESSAGE --->
	<cffunction name="delMessage" access="public" returntype="any">
		<cfargument name="msg_id" type="numeric" required="yes">
		
		<cfquery name="del_message" datasource="#dsn#">
			DELETE FROM MESSAGES WHERE MSG_ID = #arguments.msg_id#
		</cfquery>
	</cffunction>
	
	<!--- GET MESSAGE --->
	<cffunction name="getMessage" access="public" returntype="query">
		<cfargument name="msg_id" type="numeric" default="0">
		<cfargument name="type" type="any" default="">
		<cfargument name="keyword" type="string" default="">
		<cfargument name="is_read" type="any" default="">
		<cfargument name="is_deleted" type="any" default="">
		<cfargument name="sortdir" type="string" default="desc">
		<cfargument name="sortfield" type="string" default="SENT_DATE">
		
		<cfquery name="GET_MESSAGE" datasource="#DSN#">
			SELECT * FROM (
            SELECT 
				MSG_ID,
				MESSAGE_TYPE,
				SENDER_ID,
				SENDER_TYPE,
				RECEIVER_ID,
				RECEIVER_TYPE,
				SUBJECT,
				BODY,
				SENT_DATE,
				IS_READ,
				IS_DELETED
					,CASE 
						WHEN SENDER_TYPE ='PARTNER' THEN 
							(SELECT C2.NICKNAME+' - '+CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = MESSAGES.SENDER_ID)
						WHEN SENDER_TYPE = 'EMPLOYEE' THEN 
							(SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = MESSAGES.SENDER_ID)
						ELSE
							(SELECT C.CONSUMER_NAME +' ' + C.CONSUMER_SURNAME FROM CONSUMER C WHERE C.CONSUMER_ID = MESSAGES.SENDER_ID)
					END AS SENDER_NAME
					,CASE 
						WHEN RECEIVER_TYPE ='PARTNER' THEN 
							(SELECT C2.NICKNAME+' - '+CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = MESSAGES.RECEIVER_ID)
						WHEN RECEIVER_TYPE = 'EMPLOYEE' THEN 
							(SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = MESSAGES.RECEIVER_ID)
						ELSE
							(SELECT C.CONSUMER_NAME +' ' + C.CONSUMER_SURNAME FROM CONSUMER C WHERE C.CONSUMER_ID = MESSAGES.RECEIVER_ID)
					END AS RECEIVER_NAME
			FROM 
				MESSAGES
			WHERE 
				1 = 1
				<cfif arguments.msg_id neq 0>
					AND MSG_ID = #arguments.msg_id# 
					AND ((SENDER_ID = #session.pp.userid# AND MESSAGE_TYPE=1) OR (RECEIVER_ID = #session.pp.userid# AND MESSAGE_TYPE=0))
				</cfif>
				<cfif len(arguments.is_read)>
					AND IS_READ = #arguments.is_read# 
				</cfif>
				<cfif len(arguments.type) and arguments.type is 'inbox'>
					AND RECEIVER_ID = #session.pp.userid#
					AND MESSAGE_TYPE = 0
					AND IS_DELETED = 0
				<cfelseif len(arguments.type) and arguments.type is 'sentbox'>
					AND SENDER_ID = #session.pp.userid#
					AND MESSAGE_TYPE = 1
					AND IS_DELETED = 0
				<cfelseif len(arguments.type) and arguments.type eq 'trash'>
					AND ((SENDER_ID = #session.pp.userid# AND MESSAGE_TYPE=1) OR (RECEIVER_ID = #session.pp.userid# AND MESSAGE_TYPE=0))
					AND IS_DELETED = 1
				</cfif>
                )T1 
				<cfif len(arguments.keyword)>
                WHERE 
                		SUBJECT LIKE '%#arguments.keyword#%' OR
						BODY LIKE '%#arguments.keyword#%' OR
                        SENDER_NAME LIKE '%#arguments.keyword#%' OR
                        RECEIVER_NAME  LIKE '%#arguments.keyword#%'
                </cfif>
			ORDER BY
				#arguments.sortfield# #arguments.sortdir#
		</cfquery>

		<cfreturn get_message>
	</cffunction>
	
</cfcomponent>



