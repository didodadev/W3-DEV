<cfquery name="DELGUARANTYCAT" datasource="#dsn#">
	DELETE FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID=#GUARANTYCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_guaranty_cat" addtoken="no">
