<cfquery name="DELKNOWLEVEL" datasource="#dsn#">
	DELETE FROM SETUP_KNOWLEVEL WHERE KNOWLEVEL_ID=#KNOWLEVEL_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_know_level" addtoken="no">
