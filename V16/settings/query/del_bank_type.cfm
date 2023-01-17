<cfquery name="DEL_RELATION" datasource="#dsn#">
	DELETE FROM SETUP_BANK_TYPES WHERE BANK_ID=#bank_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_bank_type" addtoken="no">
