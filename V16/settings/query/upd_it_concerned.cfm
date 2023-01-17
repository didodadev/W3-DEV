<cfquery name="UPD_IT_CONCERNED" datasource="#DSN#">
	UPDATE
		SETUP_IT_CONCERNED
		SET
			CONCERN_NAME = '#attributes.concern_name#',
			DETAIL = '#attributes.detail#',
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#	 
		WHERE
			CONCERN_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_it_concerned" addtoken="no">
