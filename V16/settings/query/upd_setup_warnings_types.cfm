<cfquery name="ADD_SETUP_WARNING" datasource="#DSN#">
	UPDATE
		SETUP_WARNINGS
	SET
		SETUP_WARNING = '#attributes.setup_warning#',
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #NOW()#
	WHERE
		SETUP_WARNING_ID = #attributes.SETUP_WARNING_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_warnings_approval_types" addtoken="no">
