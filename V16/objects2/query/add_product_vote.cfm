<cfif not IsDefined("Cookie.my_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset my_cookie_ = createUUID()>
	<cfcookie name="my_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#my_cookie_#" expires="1">
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>		
		<cfquery name="add_product_vote" datasource="#dsn3#">
			INSERT INTO 
				PRODUCT_COMMENT 
					(
						PRODUCT_ID,
						PRODUCT_COMMENT_POINT,
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
						#attributes.product_id#,
						#attributes.PRODUCT_COMMENT_POINT#,
						<cfif isdefined("session.pp.userid")>
							'#session.pp.name#',
							'#session.pp.surname#',
							#session.pp.userid#,
						</cfif>
						<cfif isdefined("session.ww.userid")>
							'#session.ww.name#',
							'#session.ww.surname#',
							#session.ww.userid#,
						</cfif>
						<cfif not isdefined("session.ww.userid")>
							1,
						</cfif>
						-1,
						<cfif isdefined("Cookie.my_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("Cookie.my_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
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
