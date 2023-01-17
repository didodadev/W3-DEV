<cfquery name="ADD_STAGE" datasource="#dsn#">
	INSERT
	INTO
		SETUP_ACTIVITY_TYPES
	(
		ACTIVITY_TYPE,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		'#attributes.activity_type#',
		<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>null</cfif>,
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_activity_type" addtoken="no">
