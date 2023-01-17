<cfquery name="REPLIES" datasource="#DSN#">
	SELECT 
		TOPICID,
        USERKEY,
        REPLY,
        HIERARCHY,
        UPDATE_DATE,
        REPLYID,
        FORUM_REPLY_FILE,
		RECORD_EMP  
	FROM 
		FORUM_REPLYS
	WHERE 
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND REPLY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif isdefined("attributes.special_definition") and len(attributes.special_definition)>
			AND SPECIAL_DEFINITION_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition#">
		</cfif>
		<cfif (isDefined("attributes.reply_status") and len(attributes.reply_status))>
			AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reply_status#">
		</cfif>
	ORDER BY 
		MAIN_HIERARCHY DESC,
		HIERARCHY ASC
</cfquery>
