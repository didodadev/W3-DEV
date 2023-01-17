<cfquery name="ADD_COMPANY_SIZE_CAT" datasource="#dsn#">
	INSERT INTO 
		SETUP_VISIT_TYPES
		(
			VISIT_TYPE,
			DETAIL,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
	VALUES 
		(
			'#attributes.visit_type#',
			'#attributes.detail#',
			#SESSION.EP.USERID#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_visit_types" addtoken="no">
