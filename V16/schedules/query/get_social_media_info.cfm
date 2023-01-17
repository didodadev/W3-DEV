<cfquery name="get_process_types" datasource="#dsn#" maxrows="1">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID AS ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%worknet.list_social_media%">
	ORDER BY 
		ROW_ID ASC
</cfquery>
<cfif not get_process_types.recordcount>
	<cfabort>
</cfif>
<cftry>
	<cfinclude template="get_social_media_info_twitter.cfm">
		<cfcatch>
			<cf_add_log  log_type="-1" action_id="1" action_name="twitter hata">
		</cfcatch>
</cftry>
<cftry>
	<cfinclude template="get_social_media_info_googleplus.cfm">
		<cfcatch>
			<cf_add_log log_type="-1" action_id="1" action_name="google plus hata">
		</cfcatch>
</cftry>
<cftry>
	<cfinclude template="get_social_media_info_friendfeed.cfm">
		<cfcatch>
			<cf_add_log  log_type="-1" action_id="1" action_name="friendfeed hata">
		</cfcatch>
</cftry>
<cftry>
	<cfinclude template="get_social_media_info_facebook.cfm">
		<cfcatch>
			<cf_add_log  log_type="-1" action_id="1" action_name="facebook hata">
		</cfcatch>
</cftry>
<cftry>
	<cfinclude template="get_social_media_info_youtube.cfm">
		<cfcatch>
			<cf_add_log  log_type="-1" action_id="1" action_name="youtube hata">
		</cfcatch>
</cftry>
