<cfquery name="UPDATE_REQ" datasource="#DSN#">
	UPDATE 
		SETUP_REQ_TYPE
	SET 
		REQ_NAME = '#attributes.req_name#',
		REQ_DETAIL = '#attributes.req_detail#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		REQ_ID = #attributes.req_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_req_type" addtoken="no">
