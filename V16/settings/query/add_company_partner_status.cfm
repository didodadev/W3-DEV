<cfquery name="ADD_COMPANY_SIZE_CAT" datasource="#dsn#">
	INSERT 
	INTO 
		COMPANY_PARTNER_STATUS
		(
		STATUS_NAME,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
		) 
	VALUES 
		(
		'#STATUS_NAME#',
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_company_partner_status" addtoken="no">
