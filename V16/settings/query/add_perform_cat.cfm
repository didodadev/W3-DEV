<cfquery name="add_rec" datasource="#DSN#">
	INSERT INTO SETUP_PERFORM_CATS
		(
		PERFORM_CAT,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
		) 
		VALUES 
		(
		'#attributes.perform_cat#',
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#
		)
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_perform_cat">
