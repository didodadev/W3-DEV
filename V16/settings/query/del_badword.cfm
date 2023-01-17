<cfquery name="DEL_BADWORD" datasource="#dsn#">
	DELETE FROM 
		SETUP_FORUM_FILTER 
	WHERE 
		WORD_ID=#WORD_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_badword" addtoken="no">
