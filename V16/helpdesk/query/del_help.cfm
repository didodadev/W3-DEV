<cfquery name="DEL_HELP_DESK" datasource="#DSN#">
	DELETE FROM 
		HELP_DESK
	WHERE 
		HELP_ID = #attributes.help_id#
</cfquery>
<cfabort>
<cflocation addtoken="No" url="#request.self#?fuseaction=help.popup_list_helpdesk">
