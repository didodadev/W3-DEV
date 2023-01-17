<cfquery name="UPD_SETUP_COMPUTER_INFO" datasource="#dsn#">
	UPDATE 
		SETUP_PDKS_TYPES 
	SET 
		PDKS_TYPE = '#attributes.PDKS_type#',
		PDKS_TYPE_DETAIL = '#attributes.PDKS_type_detail#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		PDKS_TYPE_ID = #attributes.PDKS_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pdks_type" addtoken="no">
