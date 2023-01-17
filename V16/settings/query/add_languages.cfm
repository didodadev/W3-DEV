<cfset an='N'>
<cfquery name="add_lang" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_LANGUAGES
	(
		LANGUAGE_SET,
		LANGUAGE_SHORT,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		#an#'#attributes.title#',
		#an#'#attributes.short_title#',
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_languages" addtoken="no">
