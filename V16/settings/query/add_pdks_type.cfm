<cfquery name="ADD_SETUP_COMPUTER_INFO" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_PDKS_TYPES
		(
			PDKS_TYPE,
			PDKS_TYPE_DETAIL,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
	VALUES 
		(
			'#attributes.PDKS_type#',
			'#attributes.PDKS_type_detail#',
			#SESSION.EP.USERID#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pdks_type" addtoken="no">
