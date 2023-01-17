<cfquery name="upd_school_part" datasource="#dsn#">
	UPDATE 
		SETUP_LANGUAGES
	SET 
		LANGUAGE_SET='#title#',	
		LANGUAGE_SHORT='#title_short#',
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		LANGUAGE_ID=#language_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_languages" addtoken="no">
