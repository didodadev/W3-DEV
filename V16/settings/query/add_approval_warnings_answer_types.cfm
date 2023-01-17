<cfquery name="ADD_SETUP_WARNING" datasource="#DSN#">
	INSERT INTO
		SETUP_WARNING_RESULT
	(
		SETUP_WARNING_RESULT,
		DETAIL,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		'#attributes.setup_warning#',
		<cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_approval_warnings_answer_types" addtoken="no">
