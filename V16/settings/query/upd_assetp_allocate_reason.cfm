<cfquery name="UPD_REASONS" datasource="#DSN#">
	UPDATE 
		SETUP_ALLOCATE_REASON
	SET 
		ALLOCATE_REASON = '#attributes.allocate_reason#',
		ALLOCATE_REASON_DETAIL = '#attributes.allocate_reason_detail#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		REASON_ID = #attributes.reason_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_assetp_allocate_reason" addtoken="no">
