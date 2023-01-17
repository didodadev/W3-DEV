<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>			
	<cfquery name="ADD_COMMENT" datasource="#dsn#">
		INSERT INTO CONTENT_COMMENT 
						(
							CONTENT_ID,
							CONTENT_COMMENT,
							CONTENT_COMMENT_POINT,
							<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'P'>
							PARTNER_ID,
							</cfif>
							<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'C'>
							CONSUMER_ID,
							</cfif>
							<cfif not isdefined("session.ww.userkey")>
							GUEST,
							</cfif>							
							NAME,
							SURNAME,
							STAGE_ID,
							MAIL_ADDRESS,						
							RECORD_DATE,
							RECORD_IP,
							EMP_ID
						)
					VALUES
						(
							#attributes.CONTENT_ID#,
							#sql_unicode()#'#attributes.CONTENT_COMMENT#',
							#attributes.CONTENT_COMMENT_POINT#,
							<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'P'>
							#session.ww.userid#,
							</cfif>
							<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'C'>
							#session.ww.userid#,
							</cfif>
							<cfif not isdefined("session.ww.userkey")>
							1,
							</cfif>							
							#sql_unicode()#'#attributes.NAME#',
							#sql_unicode()#'#attributes.SURNAME#',
							-2,				
							'#attributes.MAIL_ADDRESS#',				
							#NOW()#,
							'#CGI.REMOTE_ADDR#',
							 #session.ep.userid#
						)
		</cfquery>
		<!--- Mail list kayıt --->
		<cfquery name="GET_MAIL" datasource="#dsn#">
			SELECT MAILLIST_EMAIL FROM MAILLIST WHERE MAILLIST_EMAIL = '#attributes.MAIL_ADDRESS#'
		</cfquery>
		<cfif NOT GET_MAIL.RECORDCOUNT>
		<cfquery name="ADD_MAIL" datasource="#dsn#">
			INSERT INTO MAILLIST 
					   (
							MAILLIST_NAME,
							MAILLIST_SURNAME,
							MAILLIST_EMAIL,
							RECORD_DATE,
							MAILLIST_CAT_ID
						)
					VALUES
						(
							'#attributes.NAME#',
							'#attributes.SURNAME#',
							'#attributes.MAIL_ADDRESS#',				
							#NOW()#,
							-1
						)
		</cfquery>		
		</cfif>
	</cftransaction>
</cflock>
<!--- Mail list kayıt --->
