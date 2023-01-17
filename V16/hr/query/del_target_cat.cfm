<cfquery name="DEL_TARGET_CAT" datasource="#DSN#">
  	DELETE FROM TARGET_CAT WHERE TARGETCAT_ID = #attributes.target_cat_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=hr.list_target_cat" addtoken="no">
