<cfquery name="del_asset_state" datasource="#DSN#">
  DELETE 
  FROM 
  		ASSET_STATE 
  WHERE 
  		ASSET_STATE_ID = #URL.ASSET_STATE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_asset_state" addtoken="no">
