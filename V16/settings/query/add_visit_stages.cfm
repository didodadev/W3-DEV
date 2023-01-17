<cfquery name="ADD_STAGE" datasource="#dsn#">
	INSERT
	INTO
		SETUP_VISIT_STAGES
	(
		VISIT_STAGE,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		'#attributes.visit_stage#',
		 <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>null</cfif>,
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_visit_stages" addtoken="no">
