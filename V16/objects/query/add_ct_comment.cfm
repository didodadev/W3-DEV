<cfsetting showdebugoutput="no">
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
        <cfquery name="ADD_COMMENT" datasource="#attributes.data_source#">
            INSERT INTO 
				#attributes.table_name#
			(
				#attributes.col_id#,
				#attributes.col_name#,
				NAME,
				SURNAME,
				MAIL_ADDRESS,
				<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'P'>
					PARTNER_ID,
				</cfif>
				<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'C'>
					CONSUMER_ID,
				</cfif>
				<cfif not isdefined("session.ww.userkey")>
					GUEST,
				</cfif>	
				RECORD_DATE,
				RECORD_IP,
				EMP_ID
			)
			VALUES
			(
				#attributes.action_id#,
				#sql_unicode()#'#attributes.ADD_COMMENT#',
				#sql_unicode()#'#attributes.NAME#',
				#sql_unicode()#'#attributes.SURNAME#',
				'#attributes.MAIL_ADDRESS#',
				<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'P'>
					#session.ww.userid#,
				</cfif>
				<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'C'>
					#session.ww.userid#,
				</cfif>
				<cfif not isdefined("session.ww.userkey")>
					1,
				</cfif>	
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
                INSERT INTO 
					MAILLIST 
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

