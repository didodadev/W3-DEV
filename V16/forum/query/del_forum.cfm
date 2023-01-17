<cflock timeout="60">
	<cftransaction>
		<cfquery name="GET_FORUM_REPLY" datasource="#dsn#">
			SELECT TOPICID FROM FORUM_TOPIC WHERE FORUMID = #attributes.FORUMID#
		</cfquery>
		<cfif GET_FORUM_REPLY.recordcount>
			<cfquery name="DEL_FORUM_MESSAGES" datasource="#dsn#">
				DELETE 
				FROM
					FORUM_REPLYS 
				WHERE 
					TOPICID IN (#valuelist(GET_FORUM_REPLY.TOPICID,',')#)
			</cfquery>	
		</cfif>
		<cfquery name="TOPICS" datasource="#dsn#">
			DELETE
			FROM
				FORUM_TOPIC
			WHERE
				FORUMID = #attributes.FORUMID#
		</cfquery>		
		<cfquery name="DEL_FORUM" datasource="#dsn#">
			DELETE
			FROM
				FORUM_MAIN
			WHERE
				FORUMID = #attributes.FORUMID#
		</cfquery>	
		<cf_add_log  log_type="-1" action_id="#attributes.FORUMID#" action_name="#attributes.head#" datasource="#dsn#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=forum.list_forum" addtoken="No">
