<cfquery name="DELEVENTCAT" datasource="#dsn#">
	DELETE FROM EVENT_CAT WHERE EVENTCAT_ID=#EVENTCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_event_cat" addtoken="no">
