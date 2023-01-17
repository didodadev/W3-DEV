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
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>		
		<cfquery name="ADD_COMMENT" datasource="#DSN#">
			INSERT INTO 
				CONTENT_COMMENT 
			(
				CONTENT_ID,
				CONTENT_COMMENT,
				CONTENT_COMMENT_POINT,
				<cfif isdefined("session.pp.userid")>
                    PARTNER_ID,
                </cfif>
                <cfif isdefined("session.ww.userid")>
                    CONSUMER_ID,
                </cfif>
                <cfif not isdefined("session.ww.userid")>
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
				#attributes.content_id#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.content_comment#">,
				<cfif isdefined('attributes.content_comment_point') and len(attributes.content_comment_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_comment_point#">,<cfelse>5,</cfif>
				<cfif isdefined("session.pp.userid")>
                    #session.pp.userid#,
                </cfif>
                <cfif isdefined("session.ww.userid")>
                    #session.ww.userid#,
                </cfif>
                <cfif not isdefined("session.ww.userid")>
                    1,
                </cfif>							
				#sql_unicode()#'#attributes.name#',
				#sql_unicode()#'#attributes.surname#',
				-1,				
				'#attributes.mail_address#',				
				#now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<!--- Mail list kayıt --->
		<cfquery name="GET_MAIL" datasource="#DSN#">
			 SELECT MAILLIST_EMAIL FROM MAILLIST WHERE MAILLIST_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_address#">
		</cfquery>
		<cfif not get_mail.recordcount>
			<cfquery name="ADD_MAIL" datasource="#DSN#">
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
					'#attributes.name#',
					'#attributes.surname#',
					'#attributes.mail_address#',				
					#now()#,
					-1
				)
			</cfquery>		
		</cfif>
		<!--- Mail list kayıt --->
	</cftransaction>
</cflock>
<cfif isdefined('attributes.backType') and attributes.backType eq 1>
	<script language="javascript">
		alert('Yorumunuz Kaydedilmiştir.');
		history.back();
	</script>
<cfelse>
	<script language="javascript">
		opener.location.reload();
		window.close();
	</script>
</cfif>
