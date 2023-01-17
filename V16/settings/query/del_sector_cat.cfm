<cfquery name="DEL_SECTOR_CAT" datasource="#dsn#">
	DELETE FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID=#SECTOR_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_sector_cat" addtoken="no">
