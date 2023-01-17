<cfquery name="add_rec" datasource="#DSN#">
	UPDATE
		SETUP_PERFORM_CATS		
	SET
		PERFORM_CAT = '#attributes.PERFORM_CAT#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP ='#CGI.REMOTE_ADDR#'
	WHERE 
		PERFORM_CAT_ID=#attributes.PERFORM_CAT_ID#
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_perform_cat">
