<cfquery name="UPDKNOWLEVEL" datasource="#dsn#">
	UPDATE 
		SETUP_KNOWLEVEL 
	SET 
		KNOWLEVEL = '#KNOWLEVEL#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
	WHERE 
		KNOWLEVEL_ID = #KNOWLEVEL_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_know_level" addtoken="no">
