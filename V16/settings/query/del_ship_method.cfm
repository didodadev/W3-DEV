<cfquery name="DEL_SHIP_METHOD" datasource="#dsn#">
	DELETE FROM SHIP_METHOD	WHERE SHIP_METHOD_ID=#SHIP_METHOD_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_ship_method" addtoken="no">
