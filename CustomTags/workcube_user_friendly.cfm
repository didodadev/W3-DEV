<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---<cf_workcube_user_friendly user_friendly_url='url_adi' action_type='content_id' action_id='1' action_page='objects2.detail_content&cnt_id=1'>--->

<cfif len(attributes.user_friendly_url)>
	<cfset user_friendly_ = replacelist(lcase(attributes.user_friendly_url),"/,*, ,',ğ,ü,ş,ö,ç,ı,İ,:,;,_,.,!,?","-,x,-,-,g,u,s,o,c,i,I,-,-,-,-,-,-")>
    <cfset user_friendly_ = replace(user_friendly_,",","-","all")>
	<cfset user_friendly_ = replace(user_friendly_,"--","-","all")>
	<cfset user_friendly_ = replace(user_friendly_,"--","-","all")>
	<cfquery name="GET_URL_FRIENDLY" datasource="#CALLER.DSN#">
		SELECT 
			USER_URL_ID 
		FROM 
			USER_FRIENDLY_URLS 
		WHERE 
			USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#"> AND
			(
            	(ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> AND ACTION_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">) OR 
                ACTION_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">
          	)
	</cfquery>
	<cfif isdefined("attributes.x_is_off_same_records")>
		<cfif get_url_friendly.recordcount and attributes.x_is_off_same_records eq 0>
			<script>
				alert("<cfoutput>#caller.getLang('main',312)#</cfoutput>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelseif get_url_friendly.recordcount>
			<script>
				alert("<cfoutput>#caller.getLang('main',312)#</cfoutput>");
				history.back();
			</script>
			<cfabort>
	</cfif>
<cfelse>
	<cfset user_friendly_ = "">
</cfif>

<cfquery name="DEL_" datasource="#CALLER.DSN#">
	DELETE FROM USER_FRIENDLY_URLS WHERE ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>

<cfquery name="ADD_" datasource="#CALLER.DSN#">
	INSERT INTO
		USER_FRIENDLY_URLS
	(
		ACTION_TYPE,
		ACTION_ID,
		USER_FRIENDLY_URL,
		FUSEACTION
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">,
		#attributes.action_id#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_page#">
	)
</cfquery>
<cfset caller.user_friendly_ = user_friendly_>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">