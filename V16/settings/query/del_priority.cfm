<cfquery name="DELPRIORITY" datasource="#dsn#">
	DELETE FROM SETUP_PRIORITY WHERE PRIORITY_ID=#PRIORITY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_priority" addtoken="no">
