<cfquery name="GET_TOPICID" datasource="#dsn#">
	SELECT
		TOPICID
	FROM
		FORUM_REPLYS
	WHERE
		REPLYID = #REPLYID#
</cfquery>

<cfquery name="DEL_REPLY" datasource="#dsn#">
	DELETE
	FROM
		FORUM_REPLYS 
	WHERE
		REPLYID = #attributes.REPLYID#
</cfquery>

<cfquery name="FORUMID" datasource="#dsn#">
	SELECT
		FORUM_MAIN.FORUMID
	FROM
		FORUM_MAIN,
		FORUM_TOPIC
	WHERE
		FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID
		AND
		FORUM_TOPIC.TOPICID = #GET_TOPICID.TOPICID#
</cfquery>
	
<cfquery name="UPD_FORUM_MSG_COUNT" datasource="#dsn#">
	UPDATE
		FORUM_MAIN
	SET
		REPLY_COUNT = REPLY_COUNT-1
	WHERE
		FORUMID = #FORUMID.FORUMID#
</cfquery>
	
<cfquery name="UPD_TOPIC_REPLY_COUNT" datasource="#dsn#">
	UPDATE
		FORUM_TOPIC
	SET
		REPLY_COUNT = REPLY_COUNT-1
	WHERE
		TOPICID = #GET_TOPICID.TOPICID#
</cfquery>

	
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
