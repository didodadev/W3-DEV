<cfquery name="del_asset_state" datasource="#DSN#">
  DELETE 
  FROM 
  		ASSET_TAKE_SUPPORT_CAT
  WHERE 
  		TAKE_SUP_CATID = #URL.TAKE_SUP_CATID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_asset_take_support_cat" addtoken="no">
