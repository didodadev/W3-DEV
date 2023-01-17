<cfinclude template="get_comp_cons_cat.cfm">
<cfquery name="RESULTS" datasource="#DSN#">
	SELECT 
		FORUM_MAIN.FORUMID,
		FORUM_MAIN.FORUMNAME,
		FORUM_TOPIC.TOPICID,
		FORUM_TOPIC.TOPIC,
		FORUM_TOPIC.TITLE,
		FORUM_TOPIC.RECORD_DATE AS RECORD_DATE
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
		FORUM_MAIN.FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FORUMID#">
	    </cfif>	
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		FORUM_TOPIC.TITLE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	   <cfif not isDefined("attributes.TOPICHEAD")>	
		OR		
		FORUM_TOPIC.TOPIC LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		FORUM_REPLYS.REPLY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
   		OR
		FORUM_MAIN.DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		FORUM_MAIN.FORUMNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	   </cfif>
		)
	</cfif>
	UNION ALL
	
	SELECT 
		FORUM_MAIN.FORUMID,
		FORUM_MAIN.FORUMNAME,
		FORUM_TOPIC.TOPICID,
		FORUM_TOPIC.TOPIC,
		FORUM_TOPIC.TITLE,
		FORUM_TOPIC.RECORD_DATE AS RECORD_DATE
	FROM
		FORUM_MAIN,
		FORUM_TOPIC
	WHERE
		IS_INTERNET = 1 AND
		FORUM_TOPIC.FORUMID = FORUM_MAIN.FORUMID
	<cfif isDefined("attributes.FORUMID")>
		<cfif attributes.FORUMID NEQ 0>
		AND
		FORUM_MAIN.FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FORUMID#">
	    </cfif>	
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		FORUM_TOPIC.TITLE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	 	<cfif not isDefined("attributes.TOPICHEAD")>	
		OR		
		FORUM_TOPIC.TOPIC LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		FORUM_MAIN.DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		FORUM_MAIN.FORUMNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
   		</cfif>
		)
	</cfif>	
	ORDER BY
		RECORD_DATE DESC
</cfquery>
