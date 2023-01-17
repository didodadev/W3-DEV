<cfquery name="del_asset_care" datasource="#DSN#">
  DELETE FROM ASSET_CARE_CAT WHERE ASSET_CARE_ID = #URL.ASSET_CARE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_asset_care_cat" addtoken="no">
