<cfquery name="ADD_MAIL_CAT" datasource="#DSN#">
	INSERT INTO
		SETUP_MAIL_WARNING
	(
		MAIL_CAT,
		DETAIL,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	) 
	VALUES 
	(
		'#attributes.mail_cat#',
		<cfif len(attributes.detail)>'#trim(attributes.detail)#',<cfelse>NULL,</cfif>
		#session.ep.userid#,
		'#CGI.REMOTE_ADDR#',
		#now()#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_mail_cat" addtoken="no">

