<cfquery name="UPDATE_UNIVERSITY" datasource="#DSN#">
	UPDATE 
		SETUP_UNIVERSITY
	SET 
		UNIVERSITY_NAME = '#attributes.university_name#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		UNIVERSITY_ID= #attributes.u_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_university" addtoken="no">

