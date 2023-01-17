<cfquery name="add_camp_stage" datasource="#dsn#">
	DELETE FROM
		SETUP_ACTION_STAGES
	WHERE
		STAGE_ID = #attributes.STAGE_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_action_stage" addtoken="no">
