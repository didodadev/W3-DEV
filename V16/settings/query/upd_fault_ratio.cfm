<cfquery name="UPD_FAULT_RATIO" datasource="#DSN#">
	UPDATE 
		SETUP_FAULT_RATIO
	SET 
		FAULT_RATIO_NAME = '#attributes.fault_ratio_name#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		FAULT_RATIO_ID = #attributes.fault_ratio_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_fault_ratio" addtoken="no">
