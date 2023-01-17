<cfcomponent>
	<cfinclude template="../../fbx_workcube_param.cfm">
	<!--- ADD TOPIC REPLY --->
	<cffunction name="addTopicReply" access="public" returntype="any">	
		<cfargument name="topicid" type="numeric" required="yes">
		<cfargument name="reply_area" type="string" required="yes">
	
		<cfquery name="ADD_TOPIC_REPLY" datasource="#DSN#" result="addtopicreply">
			INSERT INTO 
            	FORUM_REPLYS 
				(
					TOPICID, 
					USERKEY, 
					REPLY,
					VERIFIED,
					IS_ACTIVE,
					RECORD_DATE,
					RECORD_IP,
					<cfif isdefined('session.ep')>RECORD_EMP<cfelse>RECORD_PAR</cfif>,
					UPDATE_DATE,
					UPDATE_IP,
					<cfif isdefined('session.ep')>UPDATE_EMP<cfelse>UPDATE_PAR</cfif>
				)
			VALUES  
				(
					#arguments.topicid#,
					'#session.pp.userkey#',
					'#arguments.reply_area#',
					1,
					0,
					#now()#,
					'#cgi.remote_addr#',
					<cfif isdefined('session.ep')>#session.ep.userid#<cfelse>#session.pp.userid#</cfif>,
					#now()#,
					'#cgi.remote_addr#',
					<cfif isdefined('session.ep')>#session.ep.userid#<cfelse>#session.pp.userid#</cfif>
				)
		</cfquery>

		<cfquery name="UPD_HIERARCHY" datasource="#dsn#">
			UPDATE
				FORUM_REPLYS
			SET
				HIERARCHY = '#addtopicreply.identityCol#',
				MAIN_HIERARCHY = #addtopicreply.identityCol#
			WHERE
				REPLYID = #addtopicreply.identityCol#
		</cfquery>
	</cffunction>
	
	<!--- GET FORUMS --->
	<cffunction name="getForum" access="public" returntype="query">
		<cfargument name="keyword" type="string" default="">
		<cfargument name="status" type="any" default="">
		<cfargument name="forumid" type="numeric" default="0">

		<cfquery name="GET_FORUM" datasource="#DSN#">
			SELECT 
				FORUMID, 
				FORUMNAME,
				DESCRIPTION,
				TOPIC_COUNT
			FROM 
				FORUM_MAIN
			WHERE 
				1=1
				<cfif len(arguments.keyword)>
					AND (FORUMNAME LIKE '%#arguments.keyword#%' OR DESCRIPTION LIKE '%#arguments.keyword#%')
				</cfif>
				<cfif len(arguments.status)>
					AND STATUS=1
				</cfif>
				<cfif len('arguments.forumid') and arguments.forumid neq 0>
					AND FORUMID = #arguments.forumid#
				</cfif>
			ORDER BY
				FORUMNAME
		</cfquery>
		<cfreturn get_forum>
	</cffunction>
	
	<!--- GET FORUM TOPICS --->
	<cffunction name="getTopic" access="public" returntype="query">
		<cfargument name="forumid" type="any" default="">
		<cfargument name="topicid" type="any" default="">
		<cfargument name="topic_status" type="any" default="">
		<cfargument name="keyword" type="string" default="">
		
		<cfquery name="GET_TOPIC" datasource="#DSN#">
			SELECT 
				FORUM_TOPIC.TOPICID,
				FORUM_TOPIC.FORUMID,
				FORUM_TOPIC.TITLE,
				FORUM_TOPIC.TOPIC,
				FORUM_TOPIC.REPLY_COUNT,
				FORUM_TOPIC.RECORD_DATE,
				FORUM_TOPIC.RECORD_EMP,
				FORUM_MAIN.FORUMNAME
				,CASE 
					WHEN FORUM_TOPIC.RECORD_PAR IS NOT NULL THEN 
						(SELECT C2.NICKNAME+' - '+CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = FORUM_TOPIC.RECORD_PAR)
					WHEN FORUM_TOPIC.RECORD_EMP IS NOT NULL THEN 
						(SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = FORUM_TOPIC.RECORD_EMP)
					ELSE
						(SELECT C.CONSUMER_NAME +' ' + C.CONSUMER_SURNAME FROM CONSUMER C WHERE C.CONSUMER_ID = FORUM_TOPIC.RECORD_CON)
				END AS NAME
			FROM 
				FORUM_TOPIC
				<cfif isdefined('forumid')>
					LEFT JOIN FORUM_MAIN ON FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID
				</cfif>
			WHERE
				1=1  
				<cfif len(arguments.forumid)>
					AND FORUM_TOPIC.FORUMID = #arguments.forumid#
				</cfif>
				<cfif len(arguments.topicid)>
					AND FORUM_TOPIC.TOPICID = #arguments.topicid#
				</cfif>
				<cfif len(arguments.keyword)>
					AND (TOPIC LIKE '%#arguments.keyword#%' OR TITLE LIKE '%#arguments.keyword#%')
				</cfif>
				<cfif len(arguments.topic_status)>
					AND FORUM_TOPIC.TOPIC_STATUS = 1
				</cfif>
			ORDER BY 
				RECORD_DATE DESC
		</cfquery>
		<cfreturn get_topic>
	</cffunction>
	
	
	<!--- GET FORUMS REPLIES --->
	<cffunction name="getReply" access="public" returntype="query">
		<cfargument name="keyword" type="string" default="">
		<cfargument name="topicid" type="any" default="">
		<cfargument name="reply_status" type="any" default="">
		
		<cfquery name="GET_REPLY" datasource="#DSN#">
			SELECT 
				FORUM_REPLYS.REPLY,
				FORUM_REPLYS.MAIN_HIERARCHY,
				FORUM_REPLYS.HIERARCHY,
				FORUM_MAIN.FORUMNAME,
				FORUM_TOPIC.TITLE,
				FORUM_TOPIC.RECORD_DATE,
				FORUM_REPLYS.RECORD_DATE AS REPLY_DATE,
                FORUM_REPLYS.RECORD_PAR
				,CASE 
					WHEN FORUM_REPLYS.RECORD_PAR IS NOT NULL THEN 
						(SELECT CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER CP2 WHERE CP2.PARTNER_ID = FORUM_REPLYS.RECORD_PAR)
					ELSE
						(SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = FORUM_REPLYS.RECORD_EMP)
				END AS NAME
			FROM 
				FORUM_REPLYS
				<cfif len(arguments.topicid)>
					,FORUM_TOPIC  
					,FORUM_MAIN
				</cfif>
			WHERE
				1=1
				<cfif len(arguments.topicid)>
					AND FORUM_TOPIC.TOPICID = FORUM_REPLYS.TOPICID
					AND FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID
					AND FORUM_REPLYS.TOPICID = #arguments.topicid#
				</cfif>
				<cfif len(arguments.keyword)>
					AND (REPLY LIKE '%#arguments.keyword#%')
				</cfif>
				<cfif len(arguments.reply_status)>
					AND IS_ACTIVE = #arguments.reply_status#
				</cfif>
			ORDER BY 
				MAIN_HIERARCHY DESC,
				HIERARCHY ASC
		</cfquery>
		<cfreturn get_reply>
	</cffunction>
</cfcomponent>
