<cfquery name="DEL_BASIC_INPUT" datasource="#DSN3#">
	DELETE
	FROM
		SETUP_BASIC_INPUT_COST
	WHERE
		BASIC_INPUT_ID=#URL.ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_basic_input" addtoken="no">
