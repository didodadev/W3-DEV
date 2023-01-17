<cfquery name="DELOFFTIME" datasource="#DSN#">
	DELETE FROM SETUP_SOCIAL_SOCIETY WHERE SOCIETY_ID=#ATTRIBUTES.SOCIETY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_social_society" addtoken="no">
