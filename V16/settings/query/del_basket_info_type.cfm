<cfif isdefined('url.info_type_id') and len(url.info_type_id)>
	<cfquery name="DEL_SHIP_CURR" datasource="#dsn3#">
		DELETE FROM SETUP_BASKET_INFO_TYPES WHERE BASKET_INFO_TYPE_ID = #url.info_type_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.add_basket_info_type" addtoken="no">
