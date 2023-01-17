<cfquery name="UPDATE_HOBBIES" datasource="#DSN#">
	UPDATE 
		SETUP_HOBBY
	SET 
		HOBBY_NAME = '#form.hobby_name#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		HOBBY_ID = #attributes.hobby_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_hobbies" addtoken="no">
