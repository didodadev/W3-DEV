<cfquery name="UPDATE_OFFICE_STUFF" datasource="#dsn#">
	UPDATE 
		SETUP_OFFICE_STUFF
	SET 
		STUFF_NAME = '#attributes.stuff_name#',
		STUFF_DETAIL = <cfif len(attributes.stuff_detail)>'#attributes.stuff_detail#'<cfelse>NULL</cfif>,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		STUFF_ID =#attributes.stuff_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_office_stuff" addtoken="no">
