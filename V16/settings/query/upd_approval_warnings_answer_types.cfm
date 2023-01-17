<cfquery name="ADD_SETUP_WARNING" datasource="#DSN#">
	UPDATE
		SETUP_WARNING_RESULT
	SET
		SETUP_WARNING_RESULT = '#attributes.setup_warning#',
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #NOW()#
	WHERE
		SETUP_WARNING_RESULT_ID = #attributes.SETUP_WARNING_RESULT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_approval_warnings_answer_types" addtoken="no">
