<cfquery name="SETUP_ACTIVITY_STAGES" datasource="#dsn#">
	INSERT
	INTO
		SETUP_ACTIVITY_STAGES
	(
		ACTIVITY_STAGE,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		'#attributes.activity_stage#',
		 <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>null</cfif>,
		 #SESSION.EP.USERID#,
		 #NOW()#,
		 '#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_activity_stages" addtoken="no">
