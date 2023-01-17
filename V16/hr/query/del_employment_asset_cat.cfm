<cfquery name="DELDRIVERLICENCE" datasource="#dsn#">
	DELETE FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID=#ATTRIBUTES.ASSET_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_employment_asset_cat" addtoken="no">
