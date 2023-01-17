<cfquery name="DEL_SECTOR_UPPER" datasource="#dsn#">
	DELETE FROM SETUP_SECTOR_CAT_UPPER WHERE SECTOR_UPPER_ID = #SECTOR_UPPER_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_sector_upper" addtoken="no">
