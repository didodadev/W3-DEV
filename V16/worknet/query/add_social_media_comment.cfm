<cfquery name="ADD_NOTE" datasource="#dsn#">
	INSERT INTO 
			NOTES
			(
			ACTION_SECTION,
			<cfif attributes.action_type eq 0>ACTION_ID,<cfelse>ACTION_VALUE,</cfif>
			<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>ACTION_ID,</cfif>
			NOTE_HEAD,
			NOTE_BODY,
			IS_SPECIAL,
			IS_WARNING,
			COMPANY_ID,
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
			RECORD_EMP,
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
			RECORD_PAR,
		<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
			RECORD_CONS,
		</cfif>
			RECORD_DATE,
			RECORD_IP
			)
	VALUES
			(
			'#UCASE(attributes.action_section)#',
			<cfif attributes.action_type eq 0>#attributes.action_id#,<cfelse>'#attributes.action_id#',</cfif>
			<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>#attributes.action_id_2#,</cfif>
			#sql_unicode()#'#attributes.NOTE_HEAD#',
			#sql_unicode()#'#attributes.NOTE_BODY#',
			0,
			0,
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
			#session.ep.company_id#,
			#session.ep.userid#,
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
			#session.pp.our_company_id#,
			#session.pp.userid#,
		<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
			#session.ww.our_company_id#,
			#session.ww.userid#,
		</cfif>
			#now()#,
			'#CGI.REMOTE_ADDR#'
			)
</cfquery>
<cfquery name="get_social_media_info" datasource="#dsn#">
    SELECT
        SOCIAL_MEDIA_ID, 
        SOCIAL_MEDIA_CONTENT, 
        PUBLISH_DATE, 
        USER_NAME, 
        SITE, 
        PROCESS_ROW_ID, 
        COMMENT_URL, 
        USER_ID
    FROM 
    	SOCIAL_MEDIA_REPORT WHERE SID=#attributes.action_id#
</cfquery>
<cfif get_social_media_info.SITE eq 'TWITTER'>
	<script>
		window.open('https://twitter.com/intent/tweet?button_hashtag=TwitterStories&screen_name=<cfoutput>#get_social_media_info.USER_NAME#</cfoutput>&text=<cfoutput>#attributes.NOTE_BODY#</cfoutput>','');
		window.close();
    </script>
</cfif>

<cfif get_social_media_info.SITE eq 'GOOGLE PLUS'>
	<script>
		window.open('<cfoutput>#get_social_media_info.COMMENT_URL#</cfoutput>','');
		window.close();
    </script>
</cfif>

<cfif get_social_media_info.SITE eq 'FRIENDFEED'>
	<script>
		window.open('<cfoutput>#get_social_media_info.COMMENT_URL#</cfoutput>','');
		window.close();
    </script>
</cfif>

<cfif get_social_media_info.SITE eq 'facebook'>
	<script>
		window.open('<cfoutput>http://www.facebook.com/#listgetat(get_social_media_info.SOCIAL_MEDIA_ID,2,'_')#</cfoutput>','');
		window.close();
    </script>
</cfif>

<script type="text/javascript">
	window.opener.location.reload(true);
	window.close();
</script>				
