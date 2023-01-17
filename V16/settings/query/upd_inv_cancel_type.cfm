<cfquery name="UPD_INVOICE_CANCEL_TYPE" datasource="#DSN3#">
	UPDATE 
		SETUP_INVOICE_CANCEL_TYPE
	SET 
		INV_CANCEL_TYPE = '#attributes.inv_cancel_type#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		INV_CANCEL_TYPE_ID = #attributes.inv_cancel_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_inv_cancel_type" addtoken="no">
