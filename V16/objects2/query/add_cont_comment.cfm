<cfsetting showdebugoutput="no">
<cfquery name="GET_CONTENT" datasource="#DSN#">
	SELECT 
		CONTENT_ID 
	FROM 
		CONTENT_COMMENT 
	WHERE 
		RECORD_IP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND 
		NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.name#"> AND
		SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.surname#"> AND
		<cfif isDefined('attributes.mail_address')>
        	MAIL_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_address#"> AND
		</cfif>
		<!---CONTENT_COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.content_comment#">--->
        CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
</cfquery>

<cfif not len(attributes.captcha_HashText)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1439.Güvenlik Kodunu Hatalı Girdiniz! Lütfen Düzenleyiniz'>!");
	</script>
	<cfabort>
<cfelse>
    <cfset captcha = structNew() />
    <cfset validationResult = application.captcha.validateCaptcha(attributes.captcha_HashReference,attributes.captcha_HashText)>
    <cfif validationResult eq false>
        <script type="text/javascript">
            alert("<cf_get_lang no ='1439.Güvenlik Kodunu Hatalı Girdiniz! Lütfen Düzenleyiniz'>!");
        </script>
        <cfabort>
    </cfif>
</cfif>

<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfif not get_content.recordcount>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>		
			<cfquery name="ADD_COMMENT" datasource="#DSN#">
				INSERT INTO CONTENT_COMMENT 
					(
						CONTENT_ID,
						CONTENT_COMMENT,
						CONTENT_COMMENT_POINT,
						PARTNER_ID,
						CONSUMER_ID,
						GUEST,
						NAME,
						SURNAME,
						STAGE_ID,
						MAIL_ADDRESS,		
						RECORD_DATE,
						RECORD_IP
					)
				VALUES
					(
						#attributes.content_id#,
						#sql_unicode()#'#attributes.content_comment#',
						<cfif isdefined('attributes.content_comment_point') and len(attributes.content_comment_point)>#attributes.content_comment_point#,<cfelse>5,</cfif>
						<cfif isdefined('attributes.member_type') and attributes.member_type eq 2>
							#attributes.member_id#,
						<cfelseif isdefined('session.pp.userid')>
							#session.pp.userid#,
						<cfelse>
							NULL,
						</cfif>
						<cfif isdefined('attributes.member_type') and attributes.member_type eq 1>
							#attributes.member_id#,
						<cfelseif isdefined('session.ww.userid')>
							#session.ww.userid#,
						<cfelse>
							NULL,
						</cfif>
						<cfif not isdefined('member_type') or not isdefined("session.ww.userid")>1,<cfelse>0,</cfif>					
						#sql_unicode()#'#attributes.name#',
						#sql_unicode()#'#attributes.surname#',
						-1,				
						<cfif isDefined('attributes.mail_address') and len(attributes.mail_address)>'#attributes.mail_address#'<cfelse>NULL</cfif>,				
						#NOW()#,
						'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<!--- Mail list kayit --->
            <cfif isDefined('attributes.mail_address') and len(attributes.mail_address)>
                <cfquery name="GET_MAIL" datasource="#DSN#">
                     SELECT MAILLIST_EMAIL FROM MAILLIST WHERE MAILLIST_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_address#">
                </cfquery>
                <cfif not get_mail.recordcount>
                    <cfquery name="ADD_MAIL" datasource="#DSN#">
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
                            '#attributes.name#',
                            '#attributes.surname#',
                            '#attributes.mail_address#',				
                            #now()#,
                            -1
                        )
                    </cfquery>		
                </cfif>
            </cfif>
            <!--- Mail list kayit --->
		</cftransaction>
	</cflock>
</cfif>
