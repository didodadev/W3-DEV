<cfquery name="DEL_APPROVAL_WARNING_ANSWER_TYPES" datasource="#dsn#">
	DELETE FROM
		SETUP_WARNING_RESULT
	WHERE
		SETUP_WARNING_RESULT_ID = #url.SETUP_WARNING_RESULT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_approval_warnings_answer_types" addtoken="no">
