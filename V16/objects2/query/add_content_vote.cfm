<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfif not IsDefined("Cookie.add_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset my_cookie_ = createUUID()>
	<cfcookie name="add_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#my_cookie_#" expires="1">
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>		
		<cfquery name="add_content_vote" datasource="#dsn#">
			INSERT INTO 
				CONTENT_COMMENT 
				(
					CONTENT_ID,
					CONTENT_COMMENT_POINT,
					<cfif isdefined("session.pp.userid")>
						NAME,
						SURNAME,
						PARTNER_ID,
					</cfif>
					<cfif isdefined("session.ww.userid")>
						NAME,
						SURNAME,
						CONSUMER_ID,
					</cfif>
					<cfif not isdefined("session.ww.userid")>
						GUEST,
					</cfif>							
					STAGE_ID,
					COOKIE_NAME,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#attributes.content_id#,
					#attributes.CONTENT_COMMENT_POINT#,
					<cfif isdefined("session.pp.userid")>
						#sql_unicode()#'#session.pp.name#',
						#sql_unicode()#'#session.pp.surname#',
						#session.pp.userid#,
					</cfif>
					<cfif isdefined("session.ww.userid")>
						#sql_unicode()#'#session.ww.name#',
						#sql_unicode()#'#session.ww.surname#',
						#session.ww.userid#,
					</cfif>
					<cfif not isdefined("session.ww.userid")>
						1,
					</cfif>							
					-1,
					<cfif isdefined("Cookie.add_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("Cookie.add_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
					#NOW()#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
