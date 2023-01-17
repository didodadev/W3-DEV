<cfquery name="DELTITLE" datasource="#dsn#">
	DELETE 
	FROM 
		SETUP_TITLE 
	WHERE 
		TITLE_ID=#TITLE_ID#
</cfquery>

<cfif listfirst(url.fuseaction,".") is "hr">
	<cflocation url="#request.self#?fuseaction=hr.add_title" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=settings.form_add_title" addtoken="no">
</cfif>
