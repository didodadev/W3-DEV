<cfquery name="FORUM_ID" datasource="#dsn#">
	SELECT 
		FORUMID
	FROM
		FORUM_TOPIC
	WHERE
		TOPICID = #attributes.TOPICID#
</cfquery>
<cfset forumid = forum_id.forumid>
<cfquery name="REPLY_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(REPLYID) AS TOTAL
	FROM
		FORUM_REPLYS
	WHERE
		TOPICID = #attributes.TOPICID#
</cfquery>
<cfquery name="DEL_REPLIES" datasource="#dsn#">
	DELETE 
	FROM
		FORUM_REPLYS
	WHERE
		TOPICID = #attributes.TOPICID#
</cfquery>
<cfquery name="DEL_TOPIC" datasource="#dsn#">
	DELETE 
	FROM
		FORUM_TOPIC 
	WHERE
		TOPICID = #attributes.TOPICID#
</cfquery>
<cfquery name="UPD_FORUM_LAST_MSG_DATE" datasource="#dsn#">
	UPDATE
		FORUM_MAIN
	SET
		TOPIC_COUNT = TOPIC_COUNT - 1
		<cfif REPLY_COUNT.RECORDCOUNT GT 0>
		, REPLY_COUNT = REPLY_COUNT - #REPLY_COUNT.TOTAL#
		</cfif>
	WHERE
		FORUMID = #FORUMID#
</cfquery>
<cflocation url="#request.self#?fuseaction=forum.view_topic&forumid=#forumid#" addtoken="No">
