<cfsetting showdebugoutput="no">
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

<cfquery name="GET_EMAILS" datasource="#DSN#">
	SELECT 
		MAILLIST_ID
	FROM 
		MAILLIST
	WHERE
		MAILLIST_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#">
</cfquery>
<cfif get_emails.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1403.Girdiğiniz mail daha önceden sistemde kayıtlı Lütfen farklı bir mail adresi giriniz'>!");
		history.back();
    </script>	
<cfelse>
	<cfquery name="ADD_CAMPAIGN_MAIL" datasource="#DSN#">
		INSERT INTO
			MAILLIST
            (
                MAILLIST_EMAIL,
                MAILLIST_CONTENT,
                MAILLIST_NAME,
                MAILLIST_SURNAME,
                WANT_EMAIL,
                RECORD_DATE
            )
            VALUES
            (
                '#attributes.email#',
                <cfif isdefined('attributes.detail') and len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
                '#attributes.name#',
                '#attributes.surname#',
                1,
                #now()#
            )
	</cfquery>
</cfif>
<script type="text/javascript">
	alert("<cf_get_lang no ='1425.Mail Kaydiniz Basariyla Alinmistir'>!");
	window.location.href='<cfoutput>#request.self#?fuseaction=objects2.welcome</cfoutput>';
</script>
