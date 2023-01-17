<cfquery name="GET_TOPICID" datasource="#dsn#">
	SELECT
		TOPICID
	FROM
		FORUM_REPLYS
	WHERE
		REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.replyid#">
</cfquery>

<cfquery name="DEL_REPLY" datasource="#dsn#">
	DELETE
		FORUM_REPLYS 
	WHERE
		REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.replyid#">
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
		FORUM_TOPIC.TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_topicid.topicid#">
</cfquery>
	
<cfquery name="UPD_FORUM_MSG_COUNT" datasource="#dsn#">
	UPDATE
		FORUM_MAIN
	SET
		REPLY_COUNT = REPLY_COUNT-1
	WHERE
		FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#forumid.forumid#">
</cfquery>
	
<cfquery name="UPD_TOPIC_REPLY_COUNT" datasource="#dsn#">
	UPDATE
		FORUM_TOPIC
	SET
		REPLY_COUNT = REPLY_COUNT-1
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_topicid.topicid#">
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
<cflocation url="#request.self#?fuseaction=objects2.view_reply&topicid=#topicid#" addtoken="No">
