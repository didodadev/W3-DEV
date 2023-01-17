<cfquery name="DELCARD" datasource="#dsn#">
	DELETE FROM SETUP_CREDITCARD WHERE CARDCAT_ID=#CARDCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_card" addtoken="no">
