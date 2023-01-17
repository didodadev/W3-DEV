<cfquery name="ADD_INVOICE_CANCEL_TYPES" datasource="#DSN3#">
	INSERT INTO 
		SETUP_INVOICE_CANCEL_TYPE
	(
		INV_CANCEL_TYPE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		'#attributes.inv_cancel_type#',
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_inv_cancel_type" addtoken="no">
