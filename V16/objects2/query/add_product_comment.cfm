<cfsetting showdebugoutput="no">
<cfquery name="ADD_COMMENT" datasource="#dsn3#">
INSERT INTO 
	PRODUCT_COMMENT 
			(
			PRODUCT_ID,
			PRODUCT_COMMENT,
			PRODUCT_COMMENT_POINT,
			<cfif isdefined("session.pp.userid")>
				PARTNER_ID,
			</cfif>
			<cfif isdefined("session.ww.userid")>
				CONSUMER_ID,
			</cfif>
			<cfif not isdefined("session.ww.userid") and not isdefined("session.ww.userid")>
				GUEST,
			</cfif>							
			NAME,
			SURNAME,
			STAGE_ID,
			MAIL_ADDRESS,						
			RECORD_DATE,
			RECORD_IP
			)
	VALUES
		(
			#attributes.my_pid#,
			'#attributes.my_comment#',
			#attributes.my_comment_point#,
			<cfif isdefined("session.pp.userid")>
                #session.pp.userid#,
			</cfif>
			<cfif isdefined("session.ww.userid")>
                #session.ww.userid#,
			</cfif>
			<cfif not isdefined("session.ww.userid") and not isdefined("session.ww.userid")>
			1,
			</cfif>							
			'#attributes.my_name#',
			'#attributes.my_surname#',
			-1,
			'#attributes.my_email#',				
			#NOW()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
		
<!--- Mail list kayıt --->
<cfquery name="GET_MAIL" datasource="#dsn#">
    SELECT MAILLIST_EMAIL FROM MAILLIST WHERE MAILLIST_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.my_email#">
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
                '#attributes.my_name#',
                '#attributes.my_surname#',
                '#attributes.my_email#',				
                #NOW()#,
                -1
                )
</cfquery>		
</cfif>
<!--- Mail list kayıt --->
