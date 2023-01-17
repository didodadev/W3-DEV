<cfquery name="DELDRIVERLICENCE" datasource="#dsn#">
	DELETE FROM SETUP_DRIVERLICENCE WHERE LICENCECAT_ID=#LICENCECAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_driver_licence" addtoken="no">
