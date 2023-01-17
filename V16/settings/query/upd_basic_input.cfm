<cfquery name="ADD_BASIC_INPUT_COST" datasource="#DSN3#">
	UPDATE
		SETUP_BASIC_INPUT_COST
	SET 
		BASIC_INPUT='#attributes.BASIC_INPUT#',
		UPDATE_IP='#CGI.REMOTE_ADDR#',
		UPDATE_EMP=#SESSION.EP.USERID#,
		UPDATE_DATE=#NOW()#
	WHERE
		BASIC_INPUT_ID=#attributes.ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_basic_input" addtoken="no">
