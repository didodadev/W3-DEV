<cfquery name="DELMOBILCAT" datasource="#dsn#">
	DELETE FROM SETUP_MOBILCAT WHERE MOBILCAT_ID=#MOBILCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_mobil_cat" addtoken="no">
