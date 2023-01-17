<cfquery name="UPD_GRADUATE_LEVEL" datasource="#DSN#">
	UPDATE
		SETUP_GRADUATE_LEVEL
	SET
		GRADUATE_NAME = '#attributes.graduate_name#',
		DETAIL = '#attributes.detail#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE
		GRADUATE_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_graduate_level" addtoken="no">
