<cfquery name="DELIDCARD" datasource="#dsn#">
	DELETE FROM SETUP_IDENTYCARD WHERE IDENTYCAT_ID=#IDENTYCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_id_card" addtoken="no">
