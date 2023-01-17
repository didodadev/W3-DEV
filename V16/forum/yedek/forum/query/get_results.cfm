<cfquery name="RESULTS" datasource="#DSN#">
	SELECT 
		FORUM_MAIN.FORUMID,
		FORUM_MAIN.FORUMNAME,
		FORUM_TOPIC.TOPICID,
		FORUM_TOPIC.TOPIC,
		FORUM_TOPIC.TITLE,
		FORUM_TOPIC.REPLY_COUNT,
		FORUM_TOPIC.VIEW_COUNT,
		FORUM_TOPIC.RECORD_DATE AS RECORD_DATE
	FROM
		FORUM_MAIN,
		FORUM_TOPIC,
		FORUM_REPLYS
	WHERE
		FORUM_REPLYS.TOPICID = FORUM_TOPIC.TOPICID
		AND
		FORUM_TOPIC.FORUMID = FORUM_MAIN.FORUMID
		<cfif len(attributes.topic_status)>
		 AND FORUM_TOPIC.TOPIC_STATUS=#attributes.topic_status#
		</cfif>
	<cfif isDefined("attributes.FORUMID")>
		<cfif attributes.FORUMID NEQ 0>
		AND FORUM_MAIN.FORUMID = #attributes.FORUMID#
	    </cfif>	
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		FORUM_TOPIC.TITLE LIKE '%#attributes.keyword#%'
	 <cfif not isDefined("attributes.TOPICHEAD")>	
		OR		
		FORUM_TOPIC.TOPIC LIKE '%#attributes.keyword#%'
		OR
		FORUM_REPLYS.REPLY LIKE '%#attributes.keyword#%'
   		OR
		FORUM_MAIN.DESCRIPTION LIKE '%#attributes.keyword#%'
		OR
		FORUM_MAIN.FORUMNAME LIKE '%#attributes.keyword#%'
   </cfif>
		)
	</cfif>
	UNION
	SELECT 
		FORUM_MAIN.FORUMID,
		FORUM_MAIN.FORUMNAME,
		FORUM_TOPIC.TOPICID,
		FORUM_TOPIC.TOPIC,
		FORUM_TOPIC.TITLE,
		FORUM_TOPIC.REPLY_COUNT,
		FORUM_TOPIC.VIEW_COUNT,
		FORUM_TOPIC.RECORD_DATE AS RECORD_DATE
	FROM
		FORUM_MAIN,
		FORUM_TOPIC
	WHERE
		
		FORUM_TOPIC.FORUMID = FORUM_MAIN.FORUMID
		<cfif len(attributes.topic_status)>
		 AND FORUM_TOPIC.TOPIC_STATUS=#attributes.topic_status#
		</cfif>
	<cfif isDefined("attributes.FORUMID")>
		<cfif attributes.FORUMID NEQ 0>
		AND FORUM_MAIN.FORUMID = #attributes.FORUMID#
	    </cfif>	
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		FORUM_TOPIC.TITLE LIKE '%#attributes.keyword#%'
			<cfif not isDefined("attributes.TOPICHEAD")>	
			OR		
			FORUM_TOPIC.TOPIC LIKE '%#attributes.keyword#%'
			OR
			FORUM_MAIN.DESCRIPTION LIKE '%#attributes.keyword#%'
			OR
			FORUM_MAIN.FORUMNAME LIKE '%#attributes.keyword#%'
			</cfif>
		) 
	</cfif>
    <cfif isdefined('attributes.tarih') and attributes.tarih eq 1>
		 ORDER BY RECORD_DATE
    <cfelseif isdefined('attributes.tarih') and attributes.tarih eq 2>
    	 ORDER BY RECORD_DATE DESC
	</cfif>
</cfquery>
