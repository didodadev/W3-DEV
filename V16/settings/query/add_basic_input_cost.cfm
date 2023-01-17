<cfquery name="ADD_BASIC_INPUT_COST" datasource="#DSN3#">
	INSERT
	INTO
	SETUP_BASIC_INPUT_COST
	(
		BASIC_INPUT,
		RECORD_IP,
		RECORD_EMP,
		RECORD_DATE
	)
	VALUES
	(
		'#attributes.BASIC_INPUT#',
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#,
		#NOW()#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_basic_input" addtoken="no">
