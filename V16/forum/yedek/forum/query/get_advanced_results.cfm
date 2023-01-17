<cfquery name="RESULTS" datasource="#DSN#">
	SELECT 
		FORUM_MAIN.FORUMID,
		FORUM_MAIN.FORUMNAME,
		FORUM_TOPIC.TOPICID,
		FORUM_TOPIC.TOPIC,
		FORUM_TOPIC.TITLE,
		FORUM_TOPIC.RECORD_DATE,
		FORUM_REPLYS.REPLY
	FROM
		FORUM_MAIN,
		FORUM_TOPIC,
		FORUM_REPLYS
	WHERE
		FORUM_REPLYS.TOPICID = FORUM_TOPIC.TOPICID
		AND
		FORUM_TOPIC.FORUMID = FORUM_MAIN.FORUMID
		
	<cfif isDefined("attributes.FORUMID")>
		<cfif attributes.FORUMID NEQ 0>
		AND
		FORUM_MAIN.FORUMID = #attributes.FORUMID#
		</cfif>	
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		FORUM_TOPIC.TOPIC LIKE '%#attributes.keyword#%'
		OR
		FORUM_TOPIC.TITLE LIKE '%#attributes.keyword#%'
		OR
		FORUM_REPLYS.REPLY LIKE '%#attributes.keyword#%'
		OR
		FORUM_MAIN.DESCRIPTION LIKE '%#attributes.keyword#%'
		OR
		FORUM_MAIN.FORUMNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
		
	ORDER BY
		FORUM_TOPIC.RECORD_DATE DESC
</cfquery>
